#!/usr/bin/env bash
# IIA 真机验收矩阵:变体 × API 级参数化执行 device-test.sh(逐用例构建 → 安装 → 判据)。
# 用法: bash scripts/device-matrix.sh <input.apk> [--api "26,24"] [--output out] [--cert-sha256 <hex>]
# 变体(每格 = 构建 flags + 验收 flags):
#   V1 standard   标准加固              → device-test.sh --api N
#   V2 keystore   +--keystore-bind      → device-test.sh --api N --ks-relaunch(首启+二次启动)
#   V3 challenge  +--challenge-url      → 先启动 challenge-server(本机回环)再跑在线验收
#   V4 offline    同 V3 产物            → device-test.sh --challenge-offline(fail-closed 反转判据)
# 无已连接设备时如实 SKIP(exit 0)并给指引——skip 不是失败;矩阵全绿才允许 vmProtected 置 true。
set -u
INPUT="${1:?用法: device-matrix.sh <input.apk> [--api 26,24] [--output out] [--cert-sha256 <hex>]}"
shift || true
APIS="26,24"; OUTDIR="out-matrix"; CERT=""
while [ $# -gt 0 ]; do
  case "$1" in
    --api) APIS="${2:?--api 需要逗号分隔版本号}"; shift; shift ;;
    --output) OUTDIR="${2:?--output 需要目录}"; shift; shift ;;
    --cert-sha256) CERT="${2:?--cert-sha256 需要指纹}"; shift; shift ;;
    *) echo "FAIL: 未知参数 $1"; exit 2 ;;
  esac
done

# 设备预检:无设备 → SKIP(给指引,不判失败)
# ADB 可用环境变量覆盖(WMI/CI 等继承环境 PATH 不可靠的场景):ADB=<adb.exe 绝对路径>
ADB=${ADB:-adb}
if ! "$ADB" version >/dev/null 2>&1; then
  echo "SKIP: adb 不可用($ADB)——请安装 Android platform-tools 后重跑(矩阵未执行,非失败)"; exit 0
fi
DEV_COUNT=$("$ADB" devices 2>/dev/null | grep -c "device$" || true)
if [ "$DEV_COUNT" -eq 0 ]; then
  echo "SKIP: 无已连接设备(adb devices 为空)。需要: ①USB 调试真机,或 ②模拟器(见 docs/device-testing.md 最小设备矩阵);连接后重跑。"
  exit 0
fi

BUN=${BUN:-bun}
# 签名参数经环境变量注入(密钥材料留仓库外,不进命令行/仓库):
#   DS_KS_FLAGS="--keystore <jks> --ks-alias <a> --ks-pass <p> --key-pass <p>"
# 三变体产物都必须签名,否则安装判据必然 INSTALL_PARSE_FAILED_NO_CERTIFICATES
KS_FLAGS="${DS_KS_FLAGS:-}"
PKG_BASE=$(basename "$INPUT" .apk)
mkdir -p "$OUTDIR"
FAILED=0; RAN=0

# 多设备并存:按 API 级自动选格——一台设备一个串号,device-test.sh 经 --serial 定向。
# 单设备时退化为原行为(serial 为空,设备检查沿用 get-state)。
# 注意:不能用管道 while 循环——循环体内 adb shell 会吞掉管道剩余 stdin,
# 导致检查完第一台设备后循环提前结束,第二台永远匹配不到。
DEV_SERIAL() { # $1=api → echo 串号(无匹配设备输出空)
  local api="$1" serial s_api
  for serial in $("$ADB" devices 2>/dev/null | tail -n +2 | awk '$2=="device"{print $1}'); do
    s_api=$("$ADB" -s "$serial" shell getprop ro.build.version.sdk 2>/dev/null </dev/null | tr -d '\r')
    [ "$s_api" = "$api" ] && { echo "$serial"; return 0; }
  done
  return 1
}

run_case() { # $1=标签 $2=api $3=构建flags $4=验收flags
  local label="$1" api="$2" build_flags="$3" test_flags="$4"
  local apk="$OUTDIR/${PKG_BASE}.${label}.hardened.apk"
  echo "=== [$label API $api] build ==="
  if [ -n "$CERT" ]; then
    $BUN run src/index.tsx "$INPUT" --output "$OUTDIR/$label" --cert-sha256 "$CERT" $build_flags || { echo "FAIL: $label 构建失败"; FAILED=$((FAILED+1)); return; }
  else
    $BUN run src/index.tsx "$INPUT" --output "$OUTDIR/$label" $build_flags || { echo "FAIL: $label 构建失败"; FAILED=$((FAILED+1)); return; }
  fi
  # 产物名与包名从构建输出目录取(包名 = 原包名;device-test 需要)
  local hardened
  hardened=$(ls "$OUTDIR/$label"/hardened/*.hardened.apk 2>/dev/null | head -1)
  if [ -z "$hardened" ]; then echo "FAIL: $label 未产出 hardened.apk"; FAILED=$((FAILED+1)); return; fi
  local pkg
  # 包名解析:bash 直调 aapt(不经 bun execSync/cmd shell——PATH 跨层转换不可靠)
  AAPT_BIN="${AAPT:-$(ls /c/Users/diamond/AppData/Local/Android/Sdk/build-tools/*/aapt.exe 2>/dev/null | sort | tail -1)}"
  pkg=$("$AAPT_BIN" dump badging "$hardened" 2>/dev/null | sed -n "s/^package: name='\([^']*\)'.*/\1/p" | head -1)
  if [ -z "$pkg" ]; then echo "FAIL: $label 包名解析失败(aapt 不可用或产物损坏)"; FAILED=$((FAILED+1)); return; fi
  echo "=== [$label API $api] device-test (pkg=$pkg) ==="
  RAN=$((RAN+1))
  local serial_for_api
  serial_for_api=$(DEV_SERIAL "$api")
  local serial_args=""
  [ -n "$serial_for_api" ] && serial_args="--serial $serial_for_api"
  if ! bash scripts/device-test.sh "$hardened" "$pkg" --api "$api" $serial_args $test_flags; then
    echo "FAIL: [$label API $api]"; FAILED=$((FAILED+1))
  fi
}

for api in $(echo "$APIS" | tr ',' ' '); do
  # V1 标准加固
  run_case standard "$api" "$KS_FLAGS" ""
  # V2 Keystore 绑定(首启封装 + 二次启动判据)
  run_case keystore "$api" "--keystore-bind $KS_FLAGS" "--ks-relaunch"
  # V3/V4 挑战模式:构建一次,在线+离线各验一轮
  # 构建期校验门强制 challenge URL 为 https://(loader-key-patch.ts),模拟器经
  # 10.0.2.2 直达本机回环;TLS 材料留在仓库外(含私钥),路径可用环境变量覆盖
  TLS_CERT="${DS_TLS_CERT:-$HOME/ds-fixtures/tls/srv-fullchain.pem}"
  TLS_KEY="${DS_TLS_KEY:-$HOME/ds-fixtures/tls/srv.key}"
  CH_URL="https://10.0.2.2:8443"
  build_flags_challenge="--challenge-url $CH_URL $KS_FLAGS"
  if [ -n "$CERT" ]; then build_flags_challenge="$build_flags_challenge --cert-sha256 $CERT"; fi
  if [ ! -f "$TLS_CERT" ] || [ ! -f "$TLS_KEY" ]; then
    echo "SKIP: [challenge API $api] TLS 材料缺失($TLS_CERT / $TLS_KEY)——构建期 https 门不允许降级为 http;设置 DS_TLS_CERT/DS_TLS_KEY 后重跑"
  else
  echo "=== [challenge API $api] build ==="
  if $BUN run src/index.tsx "$INPUT" --output "$OUTDIR/challenge-$api" $build_flags_challenge; then
    challenge_doc=$(ls "$OUTDIR/challenge-$api"/*/server-challenge.json 2>/dev/null | head -1)
    [ -z "$challenge_doc" ] && challenge_doc=$(ls "$OUTDIR/challenge-$api"/server-challenge.json 2>/dev/null | head -1)
    if [ -n "$challenge_doc" ]; then
      $BUN scripts/challenge-server.ts "$challenge_doc" 8443 --tls "$TLS_CERT" "$TLS_KEY" &
      SRV_PID=$!
      sleep 2
      hardened=$(ls "$OUTDIR/challenge-$api"/hardened/*.hardened.apk 2>/dev/null | head -1)
      pkg=$("$AAPT_BIN" dump badging "$hardened" 2>/dev/null | sed -n "s/^package: name='\([^']*\)'.*/\1/p" | head -1)
      if [ -n "$hardened" ] && [ -n "$pkg" ]; then
        RAN=$((RAN+1))
        serial_args=""
        serial_for_api=$(DEV_SERIAL "$api")
        [ -n "$serial_for_api" ] && serial_args="--serial $serial_for_api"
        bash scripts/device-test.sh "$hardened" "$pkg" --api "$api" $serial_args || { echo "FAIL: [challenge-online API $api]"; FAILED=$((FAILED+1)); }
        # 离线格前必须真正杀掉端点:MSYS kill 对 Windows 侧 bun 可能无效,
        # 用 netstat 拿监听 PID 后经 cmd taskkill 兜底,并断言端口已释放
        kill $SRV_PID 2>/dev/null || true
        sleep 1
        WPID=$(netstat -ano 2>/dev/null | grep ":8443" | grep -i LISTEN | head -1 | awk '{print $NF}' | tr -d '\r')
        if [ -n "$WPID" ]; then
          # 不经 cmd //c——w64devkit bash 不转换 //c,cmd 会掉进交互模式挂死
          powershell -NoProfile -Command "Stop-Process -Id $WPID -Force" >/dev/null 2>&1 || true
          sleep 1
        fi
        netstat -ano 2>/dev/null | grep ":8443" | grep -qi LISTEN && echo "WARN: 8443 仍监听——离线格判据可能失真" || true
        RAN=$((RAN+1))
        bash scripts/device-test.sh "$hardened" "$pkg" --api "$api" $serial_args --challenge-offline || { echo "FAIL: [challenge-offline API $api]"; FAILED=$((FAILED+1)); }
      fi
      kill $SRV_PID 2>/dev/null || true
    else
      echo "FAIL: server-challenge.json 未产出"; FAILED=$((FAILED+1))
    fi
  else
    echo "FAIL: challenge 构建(API $api)"; FAILED=$((FAILED+1))
  fi
  fi
done

echo "=============================================="
if [ "$FAILED" -eq 0 ]; then
  echo "MATRIX PASS: $RAN 用例全绿(API=$APIS)——壳加载链验收通过(vmProtected 绑定 VMP 注入链,与此矩阵无关,维持 false)"
else
  echo "MATRIX FAIL: $FAILED / $RAN 用例失败——失败格位即真机缺陷定位"
  exit 1
fi
