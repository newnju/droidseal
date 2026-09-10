// Node bundle 组合入口:先安装 Node 兼容 shim,再执行 CLI 主程序。
// 由 scripts/build-node.ts 作为 entrypoint 使用——bundler 负责合并作用域,
// 避免 shim 与主程序顶层变量名冲突(Terser toplevel mangle 已知冲突 bug)。
// @ts-nocheck
import "./node-shim.js"
import "../src/index.tsx"
