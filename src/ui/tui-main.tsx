// TUI 启动模块(仅 TUI 分支动态加载)。
// 独立成文件的缘故:本文件含 JSX,会被编译出对 @opentui/solid/jsx-dev-runtime
// 的静态 import——若留在 index.tsx,CLI bundle 的入口 chunk 会带上该依赖,
// 用户未安装 OpenTUI 时连 --version 都无法运行。
import { createCliRenderer } from "@opentui/core"
import { render } from "@opentui/solid"
import { theme } from "./theme.ts"
import { App } from "./app.tsx"

const renderer = await createCliRenderer({
  exitOnCtrlC: true,
  useMouse: true,
  enableMouseMovement: true,
  targetFps: 60,
  maxFps: 60,
  gatherStats: false,
  autoFocus: false,
  screenMode: "alternate-screen",
  backgroundColor: theme.background,
  openConsoleOnError: false,
  useKittyKeyboard: {
    disambiguate: true,
    alternateKeys: true,
  },
})

await render(() => <App />, renderer)
