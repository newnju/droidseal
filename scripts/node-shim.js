// DroidSeal Node 运行时兼容层(build:node 时注入 bundle 顶部)。
// 仅在非 Bun 运行时安装 globalThis.Bun 的最小子集:
//   file / write / which / spawn / spawnSync / CryptoHasher
// Bun 环境下此层不生效(真实 Bun 已存在)。
import { createHash } from "node:crypto"
import { createReadStream, createWriteStream, existsSync, statSync, mkdirSync } from "node:fs"
import { mkdir, open, readFile, writeFile } from "node:fs/promises"
import { spawn, spawnSync as nodeSpawnSync } from "node:child_process"
import path from "node:path"
import { Readable } from "node:stream"

if (typeof globalThis.Bun === "undefined") {
  const isWin = process.platform === "win32"

  const which = (name) => {
    if (typeof name !== "string" || name.length === 0) return undefined
    const exts = isWin ? ["", ...(process.env.PATHEXT ?? ".EXE;.CMD;.BAT;.COM").split(";")] : [""]
    const searchPaths = name.includes("/") || name.includes("\\")
      ? [""]
      : (process.env.PATH ?? "").split(path.delimiter)
    for (const dir of searchPaths) {
      if (!dir && !name.includes("/") && !name.includes("\\")) continue
      for (const ext of exts) {
        const candidate = dir ? path.join(dir, name + ext) : name + ext
        try {
          if (existsSync(candidate) && statSync(candidate).isFile()) return candidate
        } catch { /* 继续搜索 */ }
      }
    }
    return undefined
  }

  const bunFile = (p) => {
    const filePath = path.resolve(String(p))
    let cachedSize
    const getSize = () => {
      if (cachedSize === undefined) {
        try { cachedSize = statSync(filePath).size } catch { cachedSize = 0 }
      }
      return cachedSize
    }
    return {
      get size() { return getSize() },
      slice(start, end) {
        return {
          arrayBuffer: async () => {
            const fh = await open(filePath, "r")
            try {
              const s = Math.max(0, start)
              const e = Math.min(getSize(), end)
              const len = Math.max(0, e - s)
              const buf = Buffer.alloc(len)
              if (len > 0) await fh.read(buf, 0, len, s)
              return buf.buffer.slice(buf.byteOffset, buf.byteOffset + len)
            } finally {
              await fh.close()
            }
          },
        }
      },
      arrayBuffer: async () => {
        const b = await readFile(filePath)
        return b.buffer.slice(b.byteOffset, b.byteOffset + b.byteLength)
      },
      stream: () => Readable.toWeb(createReadStream(filePath)),
      writer() {
        mkdirSync(path.dirname(filePath), { recursive: true })
        const ws = createWriteStream(filePath)
        return {
          write(chunk) {
            return new Promise((resolve, reject) => {
              ws.write(chunk, (err) => (err ? reject(err) : resolve()))
            })
          },
          end: () => new Promise((resolve) => ws.end(() => resolve())),
        }
      },
    }
  }

  const bunWrite = async (p, data) => {
    const fp = path.resolve(String(p))
    await mkdir(path.dirname(fp), { recursive: true })
    await writeFile(fp, data)
    return data?.byteLength ?? data?.length ?? 0
  }

  class CryptoHasher {
    constructor(algorithm) {
      this._hash = createHash(algorithm)
    }
    update(data) {
      this._hash.update(data)
      return this
    }
    digest(encoding) {
      return encoding ? this._hash.digest(encoding) : this._hash.digest()
    }
  }

  const bunSpawn = (cmd, opts = {}) => {
    const stdio = [opts.stdin === "pipe" ? "pipe" : "ignore", "pipe", "pipe"]
    const child = spawn(cmd[0], cmd.slice(1), {
      cwd: opts.cwd,
      env: opts.env,
      stdio,
      windowsHide: Boolean(opts.windowsHide),
    })
    const exited = new Promise((resolve) => {
      child.on("exit", (code, signal) =>
        resolve(code ?? (signal === "SIGINT" ? 130 : signal ? 1 : 0)))
      child.on("error", () => resolve(1))
    })
    return {
      stdin: child.stdin,
      stdout: child.stdout ? Readable.toWeb(child.stdout) : null,
      stderr: child.stderr ? Readable.toWeb(child.stderr) : null,
      exited,
      kill: (signal) => child.kill(signal),
    }
  }

  const bunSpawnSync = (cmd, opts = {}) => {
    const r = nodeSpawnSync(cmd[0], cmd.slice(1), {
      cwd: opts.cwd,
      env: opts.env,
      stdio: ["ignore", "pipe", "pipe"],
      windowsHide: true,
      timeout: opts.timeout,
    })
    return { stdout: r.stdout, stderr: r.stderr, exitCode: r.status ?? 1 }
  }

  globalThis.Bun = {
    file: bunFile,
    write: bunWrite,
    which,
    spawn: bunSpawn,
    spawnSync: bunSpawnSync,
    CryptoHasher,
  }
}
