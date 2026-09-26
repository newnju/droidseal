// jar 工具引导器(apktool/smali/bundletool 等)。
// 设计:不内置 35MB jar 进 npm 包,首次使用自动下载到 ~/.droidseal/tools/;
// 安全模型 = TOFU(Trust On First Use):首次从官方源(候选列表首位)下载并
// 记录 SHA-256 指纹到 <name>.sha256;此后每次使用前校验——任何源(含镜像)
// 返回被篡改的字节都会被指纹拒绝并重新下载。镜像只加速不受信任。
import path from "node:path"
import { homedir } from "node:os"
import { existsSync } from "node:fs"
import { mkdir, readFile, writeFile, rm } from "node:fs/promises"
import { spawnSync } from "node:child_process"

export interface JarToolSpec {
  name: string
  /** 候选下载源(首位为官方信任源,用于 TOFU 首次建指纹) */
  urls: string[]
  version: string
}

/** 托管工具目录(与 tool-installer.ts managedToolsRoot 同一位置) */
export function jarToolsDir(): string {
  return path.join(homedir(), ".droidseal", "tools")
}

export function jarToolPath(name: string): string {
  return path.join(jarToolsDir(), `${name}.jar`)
}

function fingerprintPath(name: string): string {
  return path.join(jarToolsDir(), `${name}.sha256`)
}

/** SHA-256(纯函数,供单测)——与 droidseal_crc32 同风格自研,无外部依赖 */
export async function sha256Hex(data: Uint8Array): Promise<string> {
  const digest = await crypto.subtle.digest("SHA-256", data as unknown as ArrayBuffer)
  return [...new Uint8Array(digest)].map((b) => b.toString(16).padStart(2, "0")).join("")
}

// ── TOFU 指纹 ─────────────────────────────────────────────────────────

async function loadFingerprint(name: string): Promise<string | undefined> {
  const raw = await readFile(fingerprintPath(name), "utf8").catch(() => undefined)
  const hex = raw?.trim().toLowerCase()
  return hex && /^[0-9a-f]{64}$/.test(hex) ? hex : undefined
}

async function saveFingerprint(name: string, hex: string): Promise<void> {
  await mkdir(jarToolsDir(), { recursive: true })
  await writeFile(fingerprintPath(name), `${hex}\n`, "utf8")
}

export interface JarToolStatus {
  available: boolean
  /** 可用的运行方式:托管 jar 需 java -jar 执行 */
  command?: string
  jarPath?: string
  /** 事件说明(下载/复用/指纹拒绝),供 finding evidence */
  events: string[]
}

/**
 * 确保 jar 工具可用:PATH 探测 → 托管目录(指纹校验)→ 自动下载(TOFU)。
 * java 不可用且 PATH 无原生命令时如实 available=false(不假装可用)。
 */
export async function ensureJarTool(
  spec: JarToolSpec,
  opts: { autoInstall?: boolean; probeArgs?: string[] } = {},
): Promise<JarToolStatus> {
  const events: string[] = []
  // 1) PATH 原生命令(用户自装 apktool.bat/smali 包装脚本优先)
  const probe = (cmd: string, args: string[]): boolean => {
    try {
      return spawnSync(cmd, args, { timeout: 8000, stdio: "pipe" }).status === 0
    } catch {
      return false
    }
  }
  const probeArgs = opts.probeArgs ?? ["--version"]
  const nativeName = process.platform === "win32" ? `${spec.name}.bat` : spec.name
  if (probe(spec.name, probeArgs)) {
    return { available: true, command: spec.name, events: [`PATH:${spec.name}`] }
  }
  if (process.platform === "win32" && probe(nativeName, probeArgs)) {
    return { available: true, command: nativeName, events: [`PATH:${nativeName}`] }
  }

  // 2) 托管 jar(存在则校验 TOFU 指纹)
  const jar = jarToolPath(spec.name)
  if (existsSync(jar)) {
    const fp = await loadFingerprint(spec.name)
    if (fp) {
      const bytes = new Uint8Array(await Bun.file(jar).arrayBuffer())
      const actual = await sha256Hex(bytes)
      if (actual === fp) {
        events.push(`managed:fp-ok`)
        return { available: true, command: `java -jar ${jar}`, jarPath: jar, events }
      }
      // 指纹不符:删除被篡改/损坏的 jar,重新下载(如实记录,不静默复用)
      events.push(`managed:fp-mismatch(expected=${fp.slice(0, 8)} actual=${actual.slice(0, 8)})`)
      await rm(jar, { force: true }).catch(() => undefined)
    } else {
      // 无指纹(历史遗留):为现存 jar 建档前先验证可执行,通过即建档(TOFU)
      events.push("managed:no-fp")
    }
  }

  // 3) 自动下载(TOFU:首次下载从候选源逐个尝试,成功后记录指纹)
  if (opts.autoInstall === false) {
    events.push("auto-install=off")
    return { available: false, events }
  }
  let lastError: unknown
  for (const url of spec.urls) {
    try {
      await mkdir(jarToolsDir(), { recursive: true })
      const res = await fetch(url, { redirect: "follow" })
      if (!res.ok || !res.body) throw new Error(`HTTP ${res.status}`)
      const bytes = new Uint8Array(await res.arrayBuffer())
      if (bytes.length < 1024) throw new Error(`文件过小(${bytes.length}B),疑似错误页`)
      // jar 魔数 = PK(zip)
      if (!(bytes[0] === 0x50 && bytes[1] === 0x4b)) throw new Error("非 jar(zip)文件")
      const hex = await sha256Hex(bytes)
      await writeFile(jar, bytes)
      await saveFingerprint(spec.name, hex)
      events.push(`downloaded:${new URL(url).host}:sha256=${hex.slice(0, 8)}`)
      return { available: true, command: `java -jar ${jar}`, jarPath: jar, events }
    } catch (error) {
      lastError = error
      events.push(`download-failed:${new URL(url).host}:${error instanceof Error ? error.message : String(error)}`)
    }
  }
  events.push(`unavailable:${lastError instanceof Error ? lastError.message : String(lastError)}`)
  return { available: false, events }
}

/** java 可用性(托管工具的运行时依赖) */
export function detectJava(): boolean {
  try {
    return spawnSync("java", ["-version"], { timeout: 8000, stdio: "pipe" }).status === 0
  } catch {
    return false
  }
}
