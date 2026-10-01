#!/usr/bin/env bash
# DroidSeal 真机验收套件(adb;需要一台已连接的设备/模拟器 + 已加固的 APK)
# 用法: bash scripts/device-test.sh <hardened.apk> <package.name> [flags]
#   --ks-relaunch         额外执行 Keystore 绑定二次启动判据(仅 --keystore-bind 产物需要)
#   --api <N>             设备 API 版本判据:设备 SDK != N 时判 FAIL(矩阵参数化——
#                         逐 API 跑一遍并断言版本,防"拿错设备跑对场景")
#   --challenge-offline   挑战模式产物**离线**验收(端点不可达):D2 预期失败——
#                         进程 5s 内消亡 = fail-closed 语义正确,判据方向反转。
#                         不加此 flag 时挑战模式产物直接跑会误报 D2 失败。
#   --auto-emulator       无已连接设备时,自动启动首个可用 AVD 再继续(需本机
#                         已装 Android 模拟器 + 至少一个 system image)。Windows 下
#                         经 PowerShell Start-Process 分离启动,避免模拟器随脚本
#                         会话结束而消亡;启动后轮询 adb 等待 boot 完成(上限 180s)。
#                         不加此 flag 时维持原行为:无设备直接 FAIL 并给出指引。
# 判据(全部通过 exit 0,任一失败 exit 1):
#   D1 安装成功(adb install -r)
#   D2 启动后 5 秒进程存活——stub 引导 → loader 解密 → 壳启动闭环未中断
#      (--challenge-offline 时反转为"5s 内不存活 = 预期")
#   D3 logcat 无 DroidSeal 完整性失败标记(integrityFailed / GCM BadTag)
#   D4 API 版本断言(仅 --api)
#   D5 卸载干净(为下一用例让路)
#   D6 Keystore 绑定二次启动(仅 --ks-relaunch)
# 注意:
#   - 挑战模式产物需设备可达 --challenge-url 端点,否则按 fail-closed 设计解密静默失败;
#     在线验收用正常模式(端点可达),离线验收用 --challenge-offline 断言 fail-closed。
#   - 换证书重签必败判据请用 D5 手动流程(docs/device-testing.md §重签必败)。
set -u
APK="${1:?用法: device-test.sh <hardened.apk> <package.name> [flags]}"
shift
PKG="${1:?缺少包名(如 com.example.app)}"
shift || true
KS_RELAUNCH=""; WANT_API=""; CHALLENGE_OFFLINE=""; AUTO_EMU=""
while [ $# -gt 0 ]; do
  case "$1" in
    --ks-relaunch) KS_RELAUNCH=1 ;;
    --api) WANT_API="${2:?--api 需要版本号}"; shift ;;
    --challenge-offline) CHALLENGE_OFFLINE=1 ;;
    --auto-emulator) AUTO_EMU=1 ;;
    *) echo "FAIL: 未知参数 $1"; exit 2 ;;
  esac
  shift
done
ADB=${ADB:-adb}
"$ADB" version >/dev/null 2>&1 || { echo "FAIL: adb 不可用($ADB)——安装 Android Platform-Tools 并加入 PATH"; exit 2; }

# 自动模拟器(--auto-emulator):仅当当前无已连接设备时才触发;有设备则零影响。
if ! "$ADB" get-state >/dev/null 2>&1; then
  if [ -z "$AUTO_EMU" ]; then
    echo "FAIL: 无已连接设备(adb devices 为空)——连接设备、启动模拟器,或加 --auto-emulator 自动启动 AVD"
    exit 2
  fi
  EMU=$(command -v emulator || true)
  [ -n "$EMU" ] || { echo "FAIL: --auto-emulator 需要模拟器(emulator 不在 PATH)"; exit 2; }
  AVD_LIST=$("$EMU" -list-avds 2>/dev/null | head -1)
  [ -n "$AVD_LIST" ] || { echo "FAIL: --auto-emulator 未找到任何 AVD(avdmanager create avd 先建一个)"; exit 2; }
  echo ">> 无已连接设备,自动启动 AVD: $AVD_LIST"
  case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*)
      # Windows:分离启动(模拟器进程必须脱离本脚本会话,否则脚本退出时被杀)
      powershell -NoProfile -Command "Start-Process -WindowStyle Hidden -FilePath '$EMU' -ArgumentList '@$AVD_LIST'" ;;
    *)
      nohup "$EMU" "@$AVD_LIST" >/dev/null 2>&1 & ;;
  esac
  echo ">> 等待设备 boot(上限 180s)"
  boot_ok=1
  for _ in $(seq 1 60); do
    sleep 3
    "$ADB" wait-for-device >/dev/null 2>&1 || continue
    BOOT=$("$ADB" shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')
    if [ "$BOOT" = "1" ]; then boot_ok=0; break; fi
  done
  [ "$boot_ok" -eq 0 ] || { echo "FAIL: 模拟器 180s 内未完成 boot"; exit 2; }
  echo ">> 模拟器已就绪"
fi
"$ADB" get-state >/dev/null 2>&1 || { echo "FAIL: 设备仍未连接"; exit 2; }

pass=0; fail=0
check() { # check <id> <ok: 0|1> <detail>
  if [ "$2" -eq 0 ]; then echo "  ✓ $1 $3"; pass=$((pass+1)); else echo "  ✗ $1 $3"; fail=$((fail+1)); fi
}

DEV_API=$("$ADB" shell getprop ro.build.version.sdk 2>/dev/null | tr -d '\r')
echo "真机验收: $APK (包 $PKG, 设备 API $DEV_API, 场景: ${CHALLENGE_OFFLINE:+挑战离线/}${KS_RELAUNCH:+KS重启动/}${WANT_API:+期望API=$WANT_API})"

# D1 API 版本断言(矩阵参数化:先断言拿对了设备再跑场景)
if [ -n "$WANT_API" ]; then
  [ "$DEV_API" = "$WANT_API" ] && check D1a 0 "设备 API $DEV_API = 期望 $WANT_API" || check D1a 1 "设备 API $DEV_API ≠ 期望 $WANT_API——矩阵用例拿错设备"
fi

# D2 安装
if "$ADB" install -r "$APK" >/tmp/ds-install.log 2>&1; then
  check D1 0 "install -r 成功"
else
  check D1 1 "install 失败: $(tail -2 /tmp/ds-install.log | tr '\n' ' ')"
  echo "FAIL: $pass 通过 / $fail 失败"; exit 1
fi

# D3 启动 + 5 秒存活(挑战离线场景方向反转:不存活 = fail-closed 正确)
# 启动用 monkey——不依赖 resolve-activity(adbd 抖动时该子命令会挂空,am start
# 拿到空 activity 名 → 启动指令无效 → D2 假失败);pidof 为空时重试一次
"$ADB" logcat -c 2>/dev/null
"$ADB" shell monkey -p "$PKG" -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1
sleep 5
PID=$("$ADB" shell pidof "$PKG" 2>/dev/null | tr -d '\r')
if [ -z "$PID" ] && [ -z "$CHALLENGE_OFFLINE" ]; then
  sleep 2
  "$ADB" shell monkey -p "$PKG" -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1
  sleep 5
  PID=$("$ADB" shell pidof "$PKG" 2>/dev/null | tr -d '\r')
fi
if [ -n "$CHALLENGE_OFFLINE" ]; then
  [ -z "$PID" ] && check D2 0 "进程 5s 内不存活(挑战离线,fail-closed 语义正确)" || check D2 1 "进程仍存活 pid=$PID——离线挑战模式下解密应失败(fail-closed 被绕过?核实 challengeUrl 是否被端点外供给)"
else
  [ -n "$PID" ] && check D2 0 "进程存活 pid=$PID(解密+壳启动闭环完成)" || check D2 1 "启动 5s 后进程不存在——解密失败或壳被杀(见 D3 logcat)"
fi

# D4 logcat 完整性/解密失败标记
LOG=$("$ADB" logcat -d 2>/dev/null)
echo "$LOG" | grep -qi "integrityFailed" && check D3 1 "logcat 出现 integrityFailed(证书/manifest 校验失败)" || true
echo "$LOG" | grep -qi "BadTag\|AEADBadTagException" && check D3 1 "logcat 出现 GCM BadTag(密钥错误)" || true
echo "$LOG" | grep -qi "integrityFailed\|BadTag" || check D3 0 "无完整性/GCM 失败标记"

# D5 Keystore 绑定二次启动(可选;仅 --keystore-bind 产物)
if [ -n "$KS_RELAUNCH" ]; then
  "$ADB" shell am force-stop "$PKG" 2>/dev/null
  sleep 1
  "$ADB" shell monkey -p "$PKG" -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1
  sleep 5
  PID2=$("$ADB" shell pidof "$PKG" 2>/dev/null | tr -d '\r')
  [ -n "$PID2" ] && check D5 0 "二次启动存活(unseal→XOR part3 路径正确)" || check D5 1 "二次启动失败——KS 封存/还原路径异常"
fi

# D6 卸载
"$ADB" uninstall "$PKG" >/dev/null 2>&1 && check D6 0 "卸载干净" || check D6 1 "卸载失败(手动: adb uninstall $PKG)"

echo "────"
if [ "$fail" -eq 0 ]; then echo "PASS: $pass 项判据全部通过"; exit 0
else echo "FAIL: $pass 通过 / $fail 失败——判据含义见 docs/device-testing.md"; exit 1; fi
