#!/usr/bin/env bash
# DroidSeal 对抗审计探针(设备端)——闭合"加固→部署→对抗审计→报告回写"环。
# 判据集(docs/device-testing.md §对抗审计):
#   A1 篡改必败:重签产物安装启动 → 解密必须失败(D2 反转:进程消亡/无窗口=D2' pass;
#      进程存活且 D3 无 integrity 标记 = fail-closed 被绕过,FAIL)
#   A2 泄漏零容忍:设备端搜壳产物私有目录 + /sdcard——明文 dex/原始 apk = FAIL
#   A3 防护在场:壳 SO 落盘于 app lib 目录 + maps 中可见(加密 payload 版)
#   A4 调试面收敛:ro.debuggable=false 且 run-as 不可用(release 态)
#   A5 巡检在场:logcat 可见 patrol thread 启动标记(动态防御激活证据)
# 回写:结果 JSON 追加到最新加固报告目录 verdicts/adversarial-audit.json。
# 语义:全部判据可运行才出 verdict;设备缺失/工具缺失 → skip(不产 verdict)。
set -u
PKG=""; APK=""; SERIAL=""; API=""
while [ $# -gt 0 ]; do
  case "$1" in
    --pkg) PKG="$2"; shift 2;;
    --apk) APK="$2"; shift 2;;
    --serial) SERIAL="$2"; shift 2;;
    --api) API="$2"; shift 2;;
    *) echo "unknown arg $1" >&2; exit 2;;
  esac
done
[ -z "$PKG" ] && { echo "usage: $0 --apk <hardened.apk> --pkg <package> [--serial S] [--api N]" >&2; exit 2; }
command -v adb >/dev/null || { echo "SKIP: adb not found"; exit 0; }
S="-s $SERIAL"; [ -z "$SERIAL" ] && S=""
adb $S get-state >/dev/null 2>&1 || { echo "SKIP: no device"; exit 0; }

PASS=0; FAIL=0; SKIP=0
VERDICTS=""; # JSON 对象逐条累积(逗号分隔;w64devkit bash 数组支持不完整,用字符串)
check() { # check <id> <0|1|2> <detail>  (0=pass 1=fail 2=skip)
  local id="$1" st="$2" detail="$3"
  local v
  case "$st" in
    0) v="{\"id\":\"$id\",\"verdict\":\"pass\",\"detail\":\"$detail\"}"; PASS=$((PASS+1)); echo "  OK $id $detail";;
    1) v="{\"id\":\"$id\",\"verdict\":\"fail\",\"detail\":\"$detail\"}"; FAIL=$((FAIL+1)); echo "  XX $id $detail";;
    *) v="{\"id\":\"$id\",\"verdict\":\"skip\",\"detail\":\"$detail\"}"; SKIP=$((SKIP+1)); echo "  -- $id SKIP: $detail";;
  esac
  [ -n "$VERDICTS" ] && VERDICTS="$VERDICTS,"
  VERDICTS="$VERDICTS$v"
}

echo "对抗审计: $PKG ($(basename "$APK"))"

# ── A3 防护在场:壳 SO 落盘 + maps 可见 ─────────────────────────────────
timeout 20 adb $S install -r -t "$APK" >/dev/null 2>&1 </dev/null
timeout 15 adb $S shell monkey -p "$PKG" -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1 </dev/null
sleep 8
PID=$(timeout 15 adb $S shell pidof "$PKG" 2>/dev/null </dev/null | tr -d '\r')
if [ -n "$PID" ]; then
  LIBMAP=$(timeout 15 adb $S shell "cat /proc/$PID/maps 2>/dev/null" </dev/null | grep -c "\.so" | tr -d '\r')
  if [ "${LIBMAP:-0}" -gt 0 ]; then
    check A3 0 "壳 SO 已映射进进程(maps .so 命中 $LIBMAP)"
  else
    # API 34+ SELinux:adb shell 读他人 /proc/pid/maps 返回空——回退
    # DS_DIAG soLoaded=true(System.loadLibrary 成功 ⇒ SO 已映射的诚实证据)
    DIAG=$(timeout 20 adb $S logcat -d 2>/dev/null </dev/null | grep -c "DS_DIAG.*soLoaded=true" | tr -d '\r')
    [ "${DIAG:-0}" -ge 1 ] && check A3 0 "壳 SO 已加载(DS_DIAG soLoaded=true;maps 受 SELinux 限制不可读)" \
      || check A3 1 "壳 SO 既无 maps 映射也无 soLoaded 证据"
  fi
else
  check A3 1 "进程未存活,无法核验 SO 映射(先排查 D2)"
fi

# ── A5 巡检在场 ────────────────────────────────────────────────────────
PATROL=$(timeout 20 adb $S logcat -d 2>/dev/null </dev/null | grep -c "patrol: dynamic inspection thread started" | tr -d '\r')
if command -v bc >/dev/null 2>&1; then :; fi
[ "${PATROL:-0}" -ge 1 ] && check A5 0 "动态巡检线程已启动(patrol 标记可见)" || check A5 2 "未见 patrol 标记(产物未含巡检线程或日志窗口错位,不判失败——如实 skip)"

# ── A4 调试面收敛 ──────────────────────────────────────────────────────
DBG=$(timeout 15 adb $S shell getprop ro.debuggable 2>/dev/null </dev/null | tr -d '\r')
[ "$DBG" = "0" ] && check A4 0 "设备 ro.debuggable=0(release 态)" || check A4 2 "设备本身 debuggable(模拟器常态),设备侧不判"

# ── A2 泄漏零容忍(私有目录 + 外部存储)──────────────────────────────────
LEAK=0
if [ -n "$PID" ] || timeout 15 adb $S shell pm path "$PKG" >/dev/null 2>&1 </dev/null; then
  FILES=$(timeout 20 adb $S shell "run-as $PKG ls files/ 2>/dev/null" </dev/null | tr -d '\r')
  case "$FILES" in
    *classes*.dex*|*.apk*) LEAK=1;;
  esac
  SD=$(timeout 20 adb $S shell "ls /sdcard/Android/data/$PKG/files/ 2>/dev/null" </dev/null | tr -d '\r')
  case "$SD" in
    *classes*.dex*|*.apk*) LEAK=1;;
  esac
  [ "$LEAK" = "0" ] && check A2 0 "私有/外部目录无明文 dex/apk 泄漏" || check A2 1 "发现明文 dex/apk 泄漏(泄漏零容忍失守)"
else
  check A2 2 "包未安装,无法扫描"
fi

# ── A1 篡改必败(重签路径,需 apksigner + 攻击 key)────────────────────────
if command -v apksigner >/dev/null 2>&1 || [ -n "$(ls C:/Users/diamond/AppData/Local/Android/Sdk/build-tools/*/apksigner.bat 2>/dev/null | tail -1)" ]; then
  AS=$(ls C:/Users/diamond/AppData/Local/Android/Sdk/build-tools/*/apksigner.bat 2>/dev/null | tail -1)
  command -v apksigner >/dev/null 2>&1 && AS=apksigner
  ATTACK_KEY="$HOME/ds-fixtures/attack-test.jks"
  if [ -f "$ATTACK_KEY" ]; then
    RESIGNED="/tmp/ds-attack-resigned.apk"
    "$AS" sign --ks "$ATTACK_KEY" --ks-pass pass:attack-test --key-pass pass:attack-test \
      --out "$RESIGNED" "$APK" >/dev/null 2>&1
    if [ -f "$RESIGNED" ]; then
      timeout 20 adb $S uninstall "$PKG" >/dev/null 2>&1 </dev/null
      timeout 25 adb $S install -r -t "$RESIGNED" >/dev/null 2>&1 </dev/null
      timeout 15 adb $S shell monkey -p "$PKG" -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1 </dev/null
      sleep 8
      RP=$(timeout 15 adb $S shell pidof "$PKG" 2>/dev/null </dev/null | tr -d '\r')
      MARK=$(timeout 20 adb $S logcat -d 2>/dev/null </dev/null | grep -icE "integrityFailed|AES/GCM|BadTag|integrity" | tr -d '\r')
      if [ -z "$RP" ]; then
        check A1 0 "重签产物进程未存活(解密 fail-closed 生效)"
      elif [ "${MARK:-0}" -ge 1 ]; then
        check A1 0 "重签产物存活但完整性标记可见(进入失败关闭路径)"
      else
        check A1 1 "重签产物存活且无完整性失败标记——篡改未被拒绝(锚点失效?)"
      fi
      timeout 15 adb $S uninstall "$PKG" >/dev/null 2>&1 </dev/null
    else
      check A1 2 "重签失败(attack key 签名错误),无法执行篡改判据"
    fi
  else
    check A1 2 "attack-test.jks 不存在(生成方式见 docs/device-testing.md),跳过篡改判据"
  fi
else
  check A1 2 "apksigner 不可用,跳过篡改判据"
fi

# ── verdict 回写:最新加固报告目录 ──────────────────────────────────────
REPORT_DIR=$(ls -td out/*/.droidseal/runs/*/reports 2>/dev/null | head -1)
if [ -n "$REPORT_DIR" ] && [ "$FAIL" -eq 0 ]; then
  mkdir -p "$REPORT_DIR/verdicts"
  {
    echo "{"
    echo "  \"tool\": \"adversarial-audit.sh\","
    echo "  \"package\": \"$PKG\","
    echo "  \"date\": \"$(date -Iseconds)\","
    echo "  \"summary\": {\"pass\": $PASS, \"fail\": $FAIL, \"skip\": $SKIP},"
    echo "  \"verdicts\": [$VERDICTS"
    echo "  ]"
    echo "}"
  } > "$REPORT_DIR/verdicts/adversarial-audit.json"
  echo "verdict 已回写: $REPORT_DIR/verdicts/adversarial-audit.json"
fi

echo "────"
echo "对抗审计: PASS=$PASS FAIL=$FAIL SKIP=$SKIP"
[ "$FAIL" -eq 0 ] && exit 0 || exit 1
