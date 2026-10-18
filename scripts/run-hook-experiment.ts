#!/usr/bin/env bun
// 活跃 hook 重跑实验一次成型的执行器(2026-10-18):
// 1) 强停 → 冷启 → 取 PID
// 2) frida-inject 挂 hook.js,device 侧 timeout 28s 自动收束,输出回传落盘
// 3) 窗口内 UI 交互驱动 I/O(swipe/tap)
// 4) 判定:最后心跳计数 / 应用存活(同 PID) / 重启成功 / logcat 零失败标记
// 用法: bun scripts/run-hook-experiment.ts <frida-inject-binary> [--serial emulator-5554]
import { readFileSync, writeFileSync } from "node:fs"
import { execFileSync } from "node:child_process"

const adb = "C:/Users/diamond/AppData/Local/Android/Sdk/platform-tools/adb.exe"
const pkg = "com.droidseal.fixtures.hello"
const serialIdx = process.argv.indexOf("--serial")
const serial = serialIdx >= 0 ? process.argv[serialIdx + 1]! : "emulator-5554"
const bin = process.argv[2]
if (!bin) { console.error("usage: bun scripts/run-hook-experiment.ts <frida-inject> [--serial s]"); process.exit(2) }
const sh = (cmd: string, timeout = 60_000) =>
  execFileSync(adb, ["-s", serial, "shell", cmd], { encoding: "utf8", timeout }).trim()
const log: string[] = []
const emit = (x: string) => { log.push(x); console.log(x) }

const boot = sh("getprop sys.boot_completed")
emit(`boot_completed: ${boot}`)

// 1) 冷启
sh(`am force-stop ${pkg}`)
let pid = sh(`pidof ${pkg}`)
emit(`after force-stop pid: ${pid || "(none)"}`)
sh(`monkey -p ${pkg} -c android.intent.category.LAUNCHER 1`)
await Bun.sleep(4000)
pid = sh(`pidof ${pkg}`)
emit(`launched pid: ${pid}`)
if (!pid || !/^\d+$/.test(pid)) { emit("FAIL: no pid after launch"); process.exit(1) }

// 2) 推送二进制(若参数为本地文件则 push)
execFileSync(adb, ["-s", serial, "push", bin, "/data/local/tmp/frida-inject.probe"], { encoding: "utf8", timeout: 120_000 })
sh("chmod 755 /data/local/tmp/frida-inject.probe")
execFileSync(adb, ["-s", serial, "push", "E:/DroidSeal-GitHub/scripts/frida-active-hook.js", "/data/local/tmp/hook.js"], { encoding: "utf8", timeout: 60_000 })
emit("pushed frida-inject + hook.js")

// 3) 开 28s 窗口(设备侧 timeout 保证收束),同进程 UI 交互驱动 I/O
const capture = Bun.spawn(["powershell", "-NoProfile", "-Command",
  `& '${adb}' -s ${serial} shell 'timeout 28 /data/local/tmp/frida-inject.probe -p ${pid} -s /data/local/tmp/hook.js' 2>&1 | Out-File -Encoding utf8 E:/env/frida/hook-window.log`],
  { stdout: "pipe" })
const strokes = [
  ["tap", "540", "900"], ["swipe", "300", "1200", "300", "400"], ["swipe", "300", "400", "300", "1200"],
  ["tap", "540", "600"], ["swipe", "300", "1200", "300", "800"], ["swipe", "300", "900", "300", "300"],
]
for (const s of strokes) {
  sh(`input ${s.join(" ")}`, 20_000)
  await Bun.sleep(2500)
}
emit("window: strokes injected, waiting for 28s timeout to close")
const t0 = performance.now()
while (performance.now() - t0 < 34_000) {
  await Bun.sleep(1500)
  const alive = sh(`pidof ${pkg}`)
  if (alive !== pid) { emit(`pid drifted: ${alive} (was ${pid}) at t+${Math.round(performance.now() - t0)}ms`); break }
}
await capture.exited
emit("capture process exited")

// 4) 证据落盘
const windowOut = readFileSync("E:/env/frida/hook-window.log", "utf8")
writeFileSync("E:/env/frida/hook-window.log.bak", windowOut)
const heartbeats = [...windowOut.matchAll(/\{[^\n]*?heartbeat[^\n]*?\}/g)].map(m => m[0])
const last = heartbeats.at(-1) ?? ""
emit(`heartbeats: ${heartbeats.length}; last: ${last.slice(0, 200)}`)

const pidAfter = sh(`pidof ${pkg}`)
emit(`pid after window: ${pidAfter} (expected ${pid})`)

// 重启判据
sh(`am force-stop ${pkg}`)
sh(`monkey -p ${pkg} -c android.intent.category.LAUNCHER 1`)
await Bun.sleep(4000)
const pidRelaunch = sh(`pidof ${pkg}`)
emit(`relaunch pid: ${pidRelaunch}`)

// logcat 失败标记(围绕本轮)
const logcat = sh(`logcat -d -t 400 | grep -Ei "integrityFailed|BadTag|FATAL EXCEPTION" | grep -v "grep" || echo MARKER_SCAN_EMPTY`)
emit(`logcat scan: ${logcat.split("\n").slice(0, 12).join(" | ")}`)

const counts = last.match(/"openat"\s*:\s*(\d+)[^}]*?"read"\s*:\s*(\d+)/) ?? last.match(/openat[^0-9]*(\d+)[^a-z]*read[^0-9]*(\d+)/)
emit(`parsed calls: ${counts ? `openat=${counts[1]}, read=${counts[2]}` : "(parse failed)"}`)

writeFileSync("E:/env/frida/hook-experiment-20261018.log", log.join("\n") + "\n")
console.log("evidence written: E:/env/frida/hook-experiment-20261018.log")
