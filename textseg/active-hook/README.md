# 活跃 Frida Hook 实测(2026-09-14)

目的:在加固应用进程内制造真实的函数级拦截(非仅监听),验证运行时检测器不误报、应用不崩溃。

方法:
- frida-inject 16.5.9 (android-x86_64),免 pip/Gadget,直接 push 到 /data/local/tmp/fj
- 脚本 scripts/frida-once-hook.js:hook libc.so 的 openat/read,25s 统计窗口,窗口内 UI tap/swipe 制造真实调用
- 附加到运行中的加固应用(com.textsplitter.app,PID 随机)

结果(once-out.txt):
- [hook] ok: libc.so:openat / read(2 个 hook 安装成功)
- [result] {"openat":0,"read":61,"hooked":2} —— 61 次真实 read 调用被拦截计数
- 注入期间应用存活(ALIVE-DURING-HOOK=1)
- 杀注入器后重启应用正常(RECOVERY alive=1)
- logcat 零失败标记(markers=0,无 integrityFailed/BadTag/frida 字样)

结论:加固应用在活跃函数级插桩下不误报、不崩溃;密钥化投票对"附加+libc hook"这种不触碰清单/签名的注入形态保持沉默(符合设计——投票锚定在清单哈希与反分析特征,而非进程内函数挂钩)。

已知环境坑(复现必读):
- 模拟器进程会随 bash 会话消亡 → PowerShell Start-Process 分离启动
- 后台 push 可能留 0 字节截断文件 → 必须核对 stat -c%s == 113402232
- userdata 跨重启持久 → fj/hook.js 只需推一次
- pidof 查不到包名进程(ps 名带后缀) → ps -A | grep 包名 | tail -1 取 PID
