#!/usr/bin/env bash
# DroidSeal 真机验收套件(adb;需要一台已连接的设备/模拟器 + 已加固的 APK)
# 用法: bash scripts/device-test.sh <hardened.apk> <package.name> [--ks-relaunch]
#   --ks-relaunch  额外执行 Keystore 绑定二次启动判据(仅 --keystore-bind 产物需要)
# 判据(全部通过 exit 0,任一失败 exit 1):
#   D1 安装成功(adb install -r)
#   D2 启动后 5 秒进程存活——stub 引导 → loader 解密 → 壳启动闭环未中断
#   D3 logcat 无 DroidSeal 完整性失败标记(integrityFailed / GCM BadTag)
#   D4 卸载干净(为下一用例让路)
# 注意:
#   - 挑战模式产物需设备可达 --challenge-url 端点,否则按 fail-closed 设计解密静默失败,
#     D2 必失败——这不是缺陷,是预期行为;离线验收请用纯本地模式产物。
#   - 换证书重签必败判据请用 D5 手动流程(docs/device-testing.md §重签必败)。
set -u
APK="${1:?用法: device-test.sh <hardened.apk> <package.name> [--ks-relaunch]}"
PKG="${2:?缺少包名(如 com.example.app)}"
KS_RELAUNCH="${3:-}"
ADB=adb
command -v "$ADB" >/dev/null 2>&1 || { echo "FAIL: 找不到 adb——安装 Android Platform-Tools 并加入 PATH"; exit 2; }
"$ADB" get-state >/dev/null 2>&1 || { echo "FAIL: 无已连接设备(adb devices 为空)——连接设备或启动模拟器"; exit 2; }

pass=0; fail=0
check() { # check <id> <ok: 0|1> <detail>
  if [ "$2" -eq 0 ]; then echo "  ✓ $1 $3"; pass=$((pass+1)); else echo "  ✗ $1 $3"; fail=$((fail+1)); fi
}

echo "真机验收: $APK (包 $PKG, 设备 $("$ADB" shell getprop ro.build.version.sdk 2>/dev/null | tr -d '\r'))"

# D1 安装
if "$ADB" install -r "$APK" >/tmp/ds-install.log 2>&1; then
  check D1 0 "install -r 成功"
else
  check D1 1 "install 失败: $(tail -2 /tmp/ds-install.log | tr '\n' ' ')"
  echo "FAIL: $pass 通过 / $fail 失败"; exit 1
fi

# D2 启动 + 5 秒存活
"$ADB" logcat -c 2>/dev/null
"$ADB" shell am start -n "$PKG/$( "$ADB" shell cmd package resolve-activity --brief -c android.intent.category.LAUNCHER "$PKG" 2>/dev/null | tail -1 | tr -d '\r' )" >/dev/null 2>&1
sleep 5
PID=$("$ADB" shell pidof "$PKG" 2>/dev/null | tr -d '\r')
[ -n "$PID" ] && check D2 0 "进程存活 pid=$PID(解密+壳启动闭环完成)" || check D2 1 "启动 5s 后进程不存在——解密失败或壳被杀(见 D3 logcat)"

# D3 logcat 完整性/解密失败标记
LOG=$("$ADB" logcat -d 2>/dev/null)
echo "$LOG" | grep -qi "integrityFailed" && check D3 1 "logcat 出现 integrityFailed(证书/manifest 校验失败)" || true
echo "$LOG" | grep -qi "BadTag\|AEADBadTagException" && check D3 1 "logcat 出现 GCM BadTag(密钥错误)" || true
echo "$LOG" | grep -qi "integrityFailed\|BadTag" || check D3 0 "无完整性/GCM 失败标记"

# D4 Keystore 绑定二次启动(可选;仅 --keystore-bind 产物)
if [ "$KS_RELAUNCH" = "--ks-relaunch" ]; then
  "$ADB" shell am force-stop "$PKG" 2>/dev/null
  sleep 1
  "$ADB" shell am start -n "$PKG/$( "$ADB" shell cmd package resolve-activity --brief -c android.intent.category.LAUNCHER "$PKG" 2>/dev/null | tail -1 | tr -d '\r' )" >/dev/null 2>&1
  sleep 5
  PID2=$("$ADB" shell pidof "$PKG" 2>/dev/null | tr -d '\r')
  [ -n "$PID2" ] && check D4 0 "二次启动存活(unseal→XOR part3 路径正确)" || check D4 1 "二次启动失败——KS 封存/还原路径异常"
fi

# D5 卸载
"$ADB" uninstall "$PKG" >/dev/null 2>&1 && check D5 0 "卸载干净" || check D5 1 "卸载失败(手动: adb uninstall $PKG)"

echo "────"
if [ "$fail" -eq 0 ]; then echo "PASS: $pass 项判据全部通过"; exit 0
else echo "FAIL: $pass 通过 / $fail 失败——判据含义见 docs/device-testing.md"; exit 1; fi
