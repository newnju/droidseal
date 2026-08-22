// POC 验证命令建议(QARK 差距①③④——poc-commands.ts)。
// 对高风险发现(导出组件/备份/可调试/深链)生成可执行的 adb/drozer 验证命令,
// 带可验证性标记与教育性说明(为什么/怎么验证)。失败关闭:未命中的发现不输出。
// 与 docs/dynamic-analysis-bridge.md 衔接(本地设备/模拟器上人工执行验证)。
import type { Finding } from "./types.ts"

export interface PocCommand {
  code: string
  title: string
  verifiable: boolean
  command: string
  explanation: string
}

// 发现 code 前缀 → 验证命令模板(adb/drozer——在本地设备/模拟器执行)。
interface CommandTemplate {
  prefix: string
  build: (packageName: string) => string
  explanation: string
}

const COMMAND_TEMPLATES: readonly CommandTemplate[] = [
  {
    prefix: "MANIFEST_EXPORTED_COMPONENT_UNPROTECTED",
    build: (packageName) => `adb shell dumpsys package ${packageName} | grep -A3 "Activity Resolver"`,
    explanation: "导出组件可能被任意应用拉起——先枚举组件，再用 am start 验证可达性。",
  },
  {
    prefix: "MANIFEST_BROWSABLE_EXPORTED_ACTIVITY",
    build: (packageName) => `adb shell am start -n ${packageName}/<activity> -a android.intent.action.VIEW -d "https://example.com/"`,
    explanation: "可浏览的导出 Activity 可被网页/外部意图拉起——用深链验证外部可达性。",
  },
  {
    prefix: "MANIFEST_BACKUP_ENABLED",
    build: (packageName) => `adb backup -f backup.ab -apk ${packageName}`,
    explanation: "allowBackup=true 允许 adb backup 提取应用数据——验证备份是否含敏感数据。",
  },
  {
    prefix: "MANIFEST_DEBUGGABLE",
    build: (packageName) => `adb shell run-as ${packageName} ls files/`,
    explanation: "可调试应用可用 run-as 进入私有目录——验证调试权限的数据访问面。",
  },
  {
    prefix: "MANIFEST_DEEPLINK_NO_AUTOVERIFY",
    build: () => `adb shell am start -a android.intent.action.VIEW -d "<deeplink-uri>"`,
    explanation: "深链未启用自动验证——验证深链是否可被其他应用伪造触发。",
  },
  {
    prefix: "MANIFEST_EXPORTED_SURFACE_OVERVIEW",
    build: (packageName) => `adb shell am start -n ${packageName}/<activity> --activity-task-on-home`,
    explanation: "导出到概览表面的 Activity 可见性——验证是否暴露敏感 UI。",
  },
  {
    prefix: "EXPORTED_",
    build: (packageName) => `drozer console connect; run app.activity.info -a ${packageName}`,
    explanation: "导出组件用 drozer 枚举并验证外部可达性(详见 dynamic-analysis-bridge)。",
  },
]

// 对发现的子集生成 POC 验证命令(失败关闭:未命中的发现跳过)。
export function buildPocCommands(findings: readonly Finding[], packageName?: string): PocCommand[] {
  const out: PocCommand[] = []
  for (const finding of findings) {
    if (finding.severity !== "high" && finding.severity !== "medium" && finding.severity !== "critical") continue
    for (const template of COMMAND_TEMPLATES) {
      if (finding.code.startsWith(template.prefix)) {
        out.push({
          code: finding.code,
          title: finding.title,
          verifiable: true,
          command: template.build(packageName ?? "<package>"),
          explanation: template.explanation,
        })
        break
      }
    }
  }
  return out
}
