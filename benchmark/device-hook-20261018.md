# 设备活跃 hook 实验证据(2026-10-18)

- 目标: `out/a6/pass1/hardened/ds-hello.signed.hardened.apk`(包 com.droidseal.fixtures.hello,API 26 (x86_64),emulator emulator-5554)
- 进程内 hook 计数(25s 类窗口,device 侧 28s timeout,UI 交互驱动 I/O):
  - libc `read`: **18**
  - libc `openat`: **0**
  - libart `GetStringUTFChars`: **0**
- 挂载成功: ["libc.so/openat","libc.so/read"]
- 应用整个窗口存活: true(pid 3676)
- 注入后重启: 成功(pid 3843)
- logcat 失败标记(integrityFailed/BadTag/FATAL): none (integral scan empty)
- 心跳消息: 13 条(原文归档:`device-hook-20261018-heartbeats.txt`,同目录)
- 运行器: `scripts/run-hook-experiment.ts`(2026-10-18);hook 脚本: `scripts/frida-active-hook.js`

> 复现:启动 ds-a26 模拟器(ANDROID_AVD_HOME=E:\env\avd)→ bun scripts/run-hook-experiment.ts <frida-inject> --serial emulator-5554
> 注:密钥化投票对函数级 libc hooking 按设计保持沉默;载荷篡改则错钥解密 fail-closed。历史口径"61 read calls"与本轮数字不同属 I/O 量差异,以本轮提交证据为准。
