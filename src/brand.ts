export const DROIDSEAL_LOGO = [
  "██████╗ ██████╗  ██████╗ ██╗██████╗ ███████╗███████╗ █████╗ ██╗",
  "██╔══██╗██╔══██╗██╔═══██╗██║██╔══██╗██╔════╝██╔════╝██╔══██╗██║",
  "██║  ██║██████╔╝██║   ██║██║██║  ██║███████╗█████╗  ███████║██║",
  "██║  ██║██╔══██╗██║   ██║██║██║  ██║╚════██║██╔══╝  ██╔══██║██║",
  "██████╔╝██║  ██║╚██████╔╝██║██████╔╝███████║███████╗██║  ██║███████╗",
  "╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝╚══════╝",
] as const
export const DROIDSEAL_LOGO_WIDTH = Math.max(...DROIDSEAL_LOGO.map((line) => line.length))
export const DROIDSEAL_LOGO_HEIGHT = DROIDSEAL_LOGO.length

export const VERSION = "1.0.0"
// 产品版本(Edition):当前开源 Community 版;Pro/Enterprise 为独立私有模块(见（工具）)
export const EDITION = "community" as const
