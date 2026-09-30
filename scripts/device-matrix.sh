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
    --api) APIS="${2:?--api 需要逗号分隔版本号}"; shift ;;
    --output) OUTDIR="${2:?--output 需要目录}"; shift ;;
    --cert-sha256) CERT="${2:?--cert-sha256 需要指纹}"; shift ;;
    *) echo "FAIL: 未知参数 $1"; exit 2 ;;
  esac
done

# 设备预检:无设备 → SKIP(给指引,不判失败)
if ! command -v adb >/dev/null 2>&1; then
  echo "SKIP: adb 不在 PATH——请安装 Android platform-tools 后重跑(矩阵未执行,非失败)"; exit 0
fi
DEV_COUNT=$(adb devices 2>/dev/null | grep -c "device$" || true)
if [ "$DEV_COUNT" -eq 0 ]; then
  echo "SKIP: 无已连接设备(adb devices 为空)。需要: ①USB 调试真机,或 ②模拟器(见 docs/device-testing.md 最小设备矩阵);连接后重跑。"
  exit 0
fi

BUN=${BUN:-bun}
PKG_BASE=$(basename "$INPUT" .apk)
mkdir -p "$OUTDIR"
FAILED=0; RAN=0

run_case() { # $1=标签 $2=api $3=构建flags $4=验收flags
  local label="$1" api="$2" build_flags="$3" test_flags="$4"
  local apk="$OUTDIR/${PKG_BASE}.${label}.hardened.apk"
  echo "=== [$label API $api] build ==="
  if [ -n "$CERT" ]; then
    $BUN run src/index.tsx harden "$INPUT" --output "$OUTDIR/$label" --cert-sha256 "$CERT" $build_flags || { echo "FAIL: $label 构建失败"; FAILED=$((FAILED+1)); return; }
  else
    $BUN run src/index.tsx harden "$INPUT" --output "$OUTDIR/$label" $build_flags || { echo "FAIL: $label 构建失败"; FAILED=$((FAILED+1)); return; }
  fi
  # 产物名与包名从构建输出目录取(包名 = 原包名;device-test 需要)
  local hardened
  hardened=$(ls "$OUTDIR/$label"/*.hardened.apk 2>/dev/null | head -1)
  if [ -z "$hardened" ]; then echo "FAIL: $label 未产出 hardened.apk"; FAILED=$((FAILED+1)); return; fi
  local pkg
  pkg=$($BUN -e "const z=require('child_process').execSync(\"aapt dump badging '$hardened' 2>/dev/null || aapt2 dump badging '$hardened'\").toString(); console.log(/package: name='([^']+)'/.exec(z)?.[1] ?? '')" 2>/dev/null)
  if [ -z "$pkg" ]; then echo "FAIL: $label 包名解析失败(aapt 不可用或产物损坏)"; FAILED=$((FAILED+1)); return; fi
  echo "=== [$label API $api] device-test (pkg=$pkg) ==="
  RAN=$((RAN+1))
  if ! bash scripts/device-test.sh "$hardened" "$pkg" --api "$api" $test_flags; then
    echo "FAIL: [$label API $api]"; FAILED=$((FAILED+1))
  fi
}

for api in $(echo "$APIS" | tr ',' ' '); do
  # V1 标准加固
  run_case standard "$api" "" ""
  # V2 Keystore 绑定(首启封装 + 二次启动判据)
  run_case keystore "$api" "--keystore-bind" "--ks-relaunch"
  # V3/V4 挑战模式:构建一次,在线+离线各验一轮
  build_flags_challenge="--challenge-url http://127.0.0.1:8080"
  if [ -n "$CERT" ]; then build_flags_challenge="$build_flags_challenge --cert-sha256 $CERT"; fi
  echo "=== [challenge API $api] build ==="
  if $BUN run src/index.tsx harden "$INPUT" --output "$OUTDIR/challenge-$api" $build_flags_challenge; then
    challenge_doc=$(ls "$OUTDIR/challenge-$api"/*/server-challenge.json 2>/dev/null | head -1)
    [ -z "$challenge_doc" ] && challenge_doc=$(ls "$OUTDIR/challenge-$api"/server-challenge.json 2>/dev/null | head -1)
    if [ -n "$challenge_doc" ]; then
      $BUN scripts/challenge-server.ts "$challenge_doc" 8080 &
      SRV_PID=$!
      sleep 2
      hardened=$(ls "$OUTDIR/challenge-$api"/*.hardened.apk 2>/dev/null | head -1)
      pkg=$($BUN -e "const z=require('child_process').execSync(\"aapt dump badging '$hardened' 2>/dev/null\").toString(); console.log(/package: name='([^']+)'/.exec(z)?.[1] ?? '')" 2>/dev/null)
      if [ -n "$hardened" ] && [ -n "$pkg" ]; then
        RAN=$((RAN+1))
        bash scripts/device-test.sh "$hardened" "$pkg" --api "$api" || { echo "FAIL: [challenge-online API $api]"; FAILED=$((FAILED+1)); }
        RAN=$((RAN+1))
        bash scripts/device-test.sh "$hardened" "$pkg" --api "$api" --challenge-offline || { echo "FAIL: [challenge-offline API $api]"; FAILED=$((FAILED+1)); }
      fi
      kill $SRV_PID 2>/dev/null || true
    else
      echo "FAIL: server-challenge.json 未产出"; FAILED=$((FAILED+1))
    fi
  else
    echo "FAIL: challenge 构建(API $api)"; FAILED=$((FAILED+1))
  fi
done

echo "=============================================="
if [ "$FAILED" -eq 0 ]; then
  echo "MATRIX PASS: $RAN 用例全绿(API=$APIS)——vmProtected 验收前提满足"
else
  echo "MATRIX FAIL: $FAILED / $RAN 用例失败——失败格位即真机缺陷定位(vmProtected 保持 false)"
  exit 1
fi
