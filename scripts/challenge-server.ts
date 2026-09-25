// P2 服务端挑战参考实现(参考实现——生产部署请加限流/鉴权/HTTPS 终止)。
//
// 用法: bun scripts/challenge-server.ts <server-challenge.json 路径> [端口]
//
// 客户端(DroidSealLoader.fetchPart3)POST 表单字段 manifestSha256=<hex>;
// 服务器校验其与挑战文档中的 manifestSha256 一致后返回 {"part3":"<64 hex>"}。
// 校验失败/未知 APK 一律返回 403,不泄露任何信息。
import { readFileSync } from "node:fs"
import { createServer } from "node:http"

const docPath = process.argv[2]
const port = Number(process.argv[3] ?? 8080)
if (!docPath) {
  console.error("用法: bun scripts/challenge-server.ts <server-challenge.json> [端口]")
  process.exit(1)
}

const doc = JSON.parse(readFileSync(docPath, "utf8")) as {
  manifestSha256: string
  part3: string
  url?: string
}
if (!/^[0-9a-f]{64}$/.test(doc.manifestSha256) || !/^[0-9a-f]{64}$/.test(doc.part3)) {
  console.error("server-challenge.json 字段缺失或格式错误(需 64 位 hex 的 manifestSha256 与 part3)")
  process.exit(1)
}

createServer((req, res) => {
  if (req.method !== "POST") {
    res.writeHead(405).end()
    return
  }
  let body = ""
  req.on("data", (c: Buffer) => {
    body += c.toString("utf8")
    if (body.length > 4096) req.destroy() // 防滥用:请求体极小
  })
  req.on("end", () => {
    const m = /(?:^|&)manifestSha256=([0-9a-fA-F]{64})(?:&|$)/.exec(body)
    if (m && m[1]!.toLowerCase() === doc.manifestSha256.toLowerCase()) {
      res.writeHead(200, { "Content-Type": "application/json" })
      res.end(JSON.stringify({ part3: doc.part3 }))
    } else {
      res.writeHead(403).end()
    }
  })
}).listen(port, "127.0.0.1", () => {
  console.log(`DroidSeal 挑战服务器已启动: http://127.0.0.1:${port}(仅本机回环——part3 是密钥材料,绝不能暴露到局域网;公网部署请置于 HTTPS 反代之后,反代只转发本机回环)`)
  console.log(`校验锚 manifestSha256: ${doc.manifestSha256.slice(0, 16)}…`)
})
