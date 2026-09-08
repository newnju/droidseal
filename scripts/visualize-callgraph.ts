#!/usr/bin/env bun
// 调用图可视化（Phase 3 扩充——D3.js 交互式 + Mermaid 静态）。
// 从 APK/DEX 提取调用图（含接口分派）→ 输出:
//   - Mermaid flowchart（.mmd）——供 GitHub/Markdown 渲染
//   - HTML 交互式力导向图（.html）——供浏览器浏览/缩放/搜索/过滤
//   - DOT 格式（.dot）——供 Graphviz 渲染
// 失败关闭。
//
// 用法：
//   bun scripts/visualize-callgraph.ts <app.apk|classes.dex> [--format mermaid|html|dot|all] [--output prefix] [--max-edges 500]
import { readFileSync } from "node:fs"
import { writeFile, mkdir } from "node:fs/promises"
import { spawnSync } from "node:child_process"
import path from "node:path"
import { extractCallGraph, expandInterfaceDispatch } from "../src/core/dex-callgraph.ts"

// Mermaid 节点 ID 转义（去特殊字符——保持可渲染）。
function nodeId(name: string): string {
  return `n${[...name].map((c) => (c.match(/[A-Za-z0-9_]/) ? c : "")).join("").slice(0, 40) || "x"}`
}

// ── 参数解析 ──────────────────────────────────────────────────────────────

function parseArgs(argv: string[]): { input: string; format: string; output: string; maxEdges: number } {
  let input = ""
  let format = "all"
  let output = "callgraph"
  let maxEdges = 500
  for (let i = 0; i < argv.length; i += 1) {
    if (argv[i] === "--format" && argv[i + 1]) { format = argv[++i]!; continue }
    if (argv[i] === "--output" && argv[i + 1]) { output = argv[++i]!; continue }
    if (argv[i] === "--max-edges" && argv[i + 1]) { maxEdges = parseInt(argv[++i]!, 10) || 500; continue }
    if (!argv[i]!.startsWith("-")) { input = argv[i]!; continue }
  }
  return { input, format, output, maxEdges }
}

interface GraphEdge { caller: string; callee: string }

function extractEdges(graph: Map<string, Set<string>>, maxEdges: number): GraphEdge[] {
  const edges: GraphEdge[] = []
  for (const [caller, callees] of graph) {
    if (edges.length >= maxEdges) break
    for (const callee of callees) {
      if (edges.length >= maxEdges) break
      edges.push({ caller, callee })
    }
  }
  return edges
}

// ── Mermaid 输出 ──────────────────────────────────────────────────────────

function generateMermaid(edges: GraphEdge[]): string {
  const lines: string[] = ["flowchart TD"]
  for (const edge of edges) {
    lines.push(`  ${nodeId(edge.caller)}["${edge.caller.replace(/"/g, "&quot;")}"] --> ${nodeId(edge.callee)}["${edge.callee.replace(/"/g, "&quot;")}"]`)
  }
  return lines.join("\n") + "\n"
}

// ── DOT (Graphviz) 输出 ──────────────────────────────────────────────────

function generateDot(edges: GraphEdge[]): string {
  const lines: string[] = ["digraph callgraph {", '  rankdir=LR;', '  node [shape=box, fontsize=10, fontname="Consolas"];', '  edge [arrowsize=0.7];']
  const nodes = new Set<string>()
  for (const edge of edges) {
    nodes.add(edge.caller)
    nodes.add(edge.callee)
  }
  // 类名着色:同一类的方法用相同颜色
  const classColors = new Map<string, string>()
  const palette = ["#4E79A7", "#F28E2B", "#E15759", "#76B7B2", "#59A14F", "#EDC948", "#B07AA1", "#FF9DA7", "#9C755F", "#BAB0AC"]
  let colorIdx = 0
  for (const node of nodes) {
    const cls = node.split(".")[0] ?? node
    if (!classColors.has(cls)) {
      classColors.set(cls, palette[colorIdx % palette.length]!)
      colorIdx += 1
    }
  }
  for (const node of nodes) {
    const cls = node.split(".")[0] ?? node
    const color = classColors.get(cls) ?? "#999"
    lines.push(`  "${node}" [fillcolor="${color}", style=filled, fontcolor=white];`)
  }
  for (const edge of edges) {
    lines.push(`  "${edge.caller}" -> "${edge.callee}";`)
  }
  lines.push("}")
  return lines.join("\n") + "\n"
}

// ── HTML 交互式力导向图 (D3.js CDN) ──────────────────────────────────────

function generateHtml(edges: GraphEdge[]): string {
  const nodes = new Map<string, { id: string; group: string }>()
  for (const edge of edges) {
    if (!nodes.has(edge.caller)) nodes.set(edge.caller, { id: edge.caller, group: edge.caller.split(".")[0] ?? "" })
    if (!nodes.has(edge.callee)) nodes.set(edge.callee, { id: edge.callee, group: edge.callee.split(".")[0] ?? "" })
  }
  const nodesJson = JSON.stringify([...nodes.values()])
  const linksJson = JSON.stringify(edges.map((e) => ({ source: e.caller, target: e.callee })))

  return `<!DOCTYPE html>
<html lang="en"><head><meta charset="utf-8"><title>DroidSeal Call Graph</title>
<style>
body{margin:0;background:#FDF6E3;font:13px "Segoe UI",sans-serif;color:#586E75}
#toolbar{position:fixed;top:0;left:0;right:0;height:44px;background:#EEF4F9;border-bottom:1px solid #CFE0E4;display:flex;align-items:center;padding:0 16px;gap:12px;z-index:9}
#toolbar input{padding:6px 10px;border:1px solid #CFE0E4;border-radius:6px;width:220px}
#toolbar span{color:#93A1A1;font-size:12px}
#info{position:fixed;bottom:16px;right:16px;background:#fff;border:1px solid #CFE0E4;border-radius:8px;padding:12px;max-width:340px;font-size:12px;box-shadow:0 2px 8px #0001;display:none;z-index:9}
svg{position:fixed;top:44px;left:0}
.link{stroke:#93A1A1;stroke-opacity:.6;stroke-width:1}
.node circle{stroke:#fff;stroke-width:1.5;cursor:pointer}
.node text{font-size:10px;pointer-events:none}
</style></head><body>
<div id="toolbar">
  <b style="color:#586E75">DroidSeal Call Graph</b>
  <input id="search" type="text" placeholder="搜索类/方法名...">
  <span id="stats">${nodes.size} 节点 · ${edges.length} 边</span>
</div>
<div id="info"></div>
<script src="https://d3js.org/d3.v7.min.js"><\/script>
<script>
const nodes=${nodesJson};
const links=${linksJson};
const width=window.innerWidth,height=window.innerHeight-44;
const color=d3.scaleOrdinal(d3.schemeTableau10);
const svg=d3.select("body").append("svg").attr("width",width).attr("height",height);
const g=svg.append("g");
svg.call(d3.zoom().on("zoom",(e)=>g.attr("transform",e.transform)));
const sim=d3.forceSimulation(nodes)
  .force("link",d3.forceLink(links).id(d=>d.id).distance(80))
  .force("charge",d3.forceManyBody().strength(-120))
  .force("center",d3.forceCenter(width/2,height/2))
  .force("collision",d3.forceCollide().radius(20));
const link=g.append("g").selectAll("line").data(links).join("line").attr("class","link");
const node=g.append("g").selectAll("g").data(nodes).join("g").attr("class","node")
  .call(d3.drag().on("start",(e,d)=>{if(!e.active)sim.alphaTarget(.3).restart();d.fx=d.x;d.fy=d.y})
    .on("drag",(e,d)=>{d.fx=e.x;d.fy=e.y}).on("end",(e,d)=>{if(!e.active)sim.alphaTarget(0);d.fx=null;d.fy=null}));
node.append("circle").attr("r",8).attr("fill",d=>color(d.group));
node.append("text").attr("dx",12).attr("dy",4).text(d=>d.id.split(".").pop());
node.on("mouseover",(e,d)=>{
  const inL=links.filter(l=>l.source.id===d.id||l.target.id===d.id);
  document.getElementById("info").style.display="block";
  document.getElementById("info").innerHTML="<b>"+d.id+"</b><br>调用 "+inL.filter(l=>l.source.id===d.id).length+" 个方法<br>被 "+inL.filter(l=>l.target.id===d.id).length+" 个方法调用";
}).on("mouseout",()=>{document.getElementById("info").style.display="none"});
sim.on("tick",()=>{link.attr("x1",d=>d.source.x).attr("y1",d=>d.source.y).attr("x2",d=>d.target.x).attr("y2",d=>d.target.y);node.attr("transform",d=>"translate("+d.x+","+d.y+")")});
document.getElementById("search").addEventListener("input",function(){
  const q=this.value.toLowerCase();
  node.select("circle").attr("opacity",d=>!q||d.id.toLowerCase().includes(q)?1:.15);
  node.select("text").attr("opacity",d=>!q||d.id.toLowerCase().includes(q)?1:.15);
  link.attr("stroke-opacity",d=>!q||d.source.id.toLowerCase().includes(q)||d.target.id.toLowerCase().includes(q)?.6:.05);
});
<\/script></body></html>`
}

// ── 主入口 ────────────────────────────────────────────────────────────────

async function main(): Promise<void> {
  const args = parseArgs(process.argv.slice(2))
  if (!args.input) throw new Error("用法: visualize-callgraph <app.apk|classes.dex> [--format mermaid|html|dot|all] [--output prefix] [--max-edges 500]")

  let bytes: Uint8Array
  if (args.input.toLowerCase().endsWith(".apk")) {
    const result = spawnSync("unzip", ["-p", args.input, "classes.dex"], { maxBuffer: 256 * 1024 * 1024 })
    if (result.status !== 0) throw new Error("提取 classes.dex 失败（需 unzip）")
    bytes = new Uint8Array(result.stdout)
  } else {
    bytes = new Uint8Array(readFileSync(args.input))
  }
  if (bytes.length === 0 || bytes[0] !== 0x64) throw new Error("不是有效的 DEX 文件")

  const graph = expandInterfaceDispatch(extractCallGraph(bytes), bytes)
  const edges = extractEdges(graph, args.maxEdges)
  // 统计节点数
  const allNodes = new Set<string>()
  for (const edge of edges) { allNodes.add(edge.caller); allNodes.add(edge.callee) }
  const doAll = args.format === "all"
  const outDir = path.dirname(args.output) || "."
  await mkdir(outDir, { recursive: true }).catch(() => undefined)
  const baseName = path.basename(args.output)
  const nodeCount = allNodes.size

  if (doAll || args.format === "mermaid") {
    const file = path.join(outDir, `${baseName}.mmd`)
    await writeFile(file, generateMermaid(edges), "utf8")
    console.log(`Mermaid: ${file}（${edges.length} 条边）`)
  }
  if (doAll || args.format === "html") {
    const file = path.join(outDir, `${baseName}.html`)
    await writeFile(file, generateHtml(edges), "utf8")
    console.log(`HTML: ${file}（${nodeCount} 节点,${edges.length} 边——浏览器交互）`)
  }
  if (doAll || args.format === "dot") {
    const file = path.join(outDir, `${baseName}.dot`)
    await writeFile(file, generateDot(edges), "utf8")
    console.log(`DOT: ${file}（Graphviz 渲染）`)
  }

  console.log(`调用图: ${graph.size} 个调用方方法,${edges.length} 条调用边（最大 ${args.maxEdges}）`)
}

main().catch((error) => {
  console.error(`调用图可视化失败：${error instanceof Error ? error.message : String(error)}`)
  process.exitCode = 1
})
