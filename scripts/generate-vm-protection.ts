#!/usr/bin/env bun
// 轻量 VMP（层面1——generate-vm-protection.ts）。
// 生成 VM 解释器类 + 指令化样例（源码接入——用户把敏感逻辑编码为自定义指令数组——
// 运行期解释执行——静态分析只见解释器与指令数组，不见真实逻辑——最硬的盾的源码接入形态）。
// 自定义指令集：CONST/LOAD/STORE/ADD/SUB/RETURN（含 opaque 指令——静态难以还原语义）。失败关闭。
//
// 用法：
//   bun scripts/generate-vm-protection.ts <输出目录> [--class 类名]
import { mkdir, writeFile } from "node:fs/promises"
import path from "node:path"

function parseArgs(argv: string[]): { outputDir: string; className: string } {
  let outputDir = argv[0]
  if (!outputDir) throw new Error("用法: generate-vm-protection <输出目录> [--class 类名]")
  let className = "VmProtectedLogic"
  for (let i = 1; i < argv.length; i += 1) {
    if (argv[i] === "--class") className = argv[++i] ?? "VmProtectedLogic"
  }
  return { outputDir, className }
}

async function generate(outputDir: string, className: string): Promise<string> {
  await mkdir(outputDir, { recursive: true })
  const content = `// 自动生成的轻量 VMP 框架（DroidSeal 轻量 VMP——源码接入——不改变应用行为）。
// 把敏感逻辑编码为指令数组（自定义指令集）→ 运行期由解释器执行——静态分析只见解释器与指令，
// 不见真实逻辑（最硬盾的源码接入形态）。指令集可扩展（LOAD/STORE/ADD/SUB/CONST/RETURN/OPAQUE）。
package com.example.vm;

/** 轻量 VM 解释器（源码接入——敏感逻辑指令化后运行期解释执行） */
public final class ${className} {

    // 自定义指令集（可扩展——静态无法直接还原语义）
    private static final int OP_CONST = 1;
    private static final int OP_LOAD = 2;
    private static final int OP_STORE = 3;
    private static final int OP_ADD = 4;
    private static final int OP_SUB = 5;
    private static final int OP_OPAQUE = 6; // 伪指令（不改变状态——静态噪声）
    private static final int OP_RETURN = 7;

    private static final int[] REG = new int[8];

    /** 敏感逻辑指令样例（用户把真实逻辑按指令集编码——替换此数组） */
    public static final int[][] VM_PROGRAM = {
        // { op, a, b }：CONST 加载 / LOAD 取参 / STORE 存结果 / ADD·SUB 运算 / OPAQUE 噪声 / RETURN 结束
        { OP_OPAQUE, 0, 0 },
        { OP_CONST, 0, 42 },
        { OP_CONST, 1, 7 },
        { OP_ADD, 0, 1 },
        { OP_STORE, 2, 0 },
        { OP_OPAQUE, 0, 0 },
        { OP_RETURN, 0, 2 },
    };

    /** 解释执行（源码接入——把真实逻辑编码进 VM_PROGRAM） */
    public static int run(int input) {
        int pc = 0;
        REG[0] = input;
        int result = 0;
        while (pc < VM_PROGRAM.length) {
            int[] ins = VM_PROGRAM[pc];
            int op = ins[0], a = ins[1], b = ins[2];
            switch (op) {
                case OP_CONST: REG[a] = b; break;
                case OP_LOAD: REG[a] = input; break;
                case OP_STORE: REG[b] = REG[a]; break;
                case OP_ADD: REG[a] = REG[a] + REG[b]; break;
                case OP_SUB: REG[a] = REG[a] - REG[b]; break;
                case OP_OPAQUE: /* 伪指令——不改变状态 */ break;
                case OP_RETURN: return REG[b];
                default: return result;
            }
            pc += 1;
        }
        return result;
    }
}
`
  const file = path.join(outputDir, `${className}.java`)
  await writeFile(file, content, "utf8")
  return file
}

function main(): void {
  const { outputDir, className } = parseArgs(process.argv.slice(2))
  generate(outputDir, className)
    .then((file) => console.log(`已生成轻量 VMP 框架：${file}（VM 解释器 + 指令化样例——把敏感逻辑编码进 VM_PROGRAM——运行期解释执行）`))
    .catch((error) => {
      console.error(`轻量 VMP 生成失败：${error instanceof Error ? error.message : String(error)}`)
      process.exitCode = 1
    })
}

main()
