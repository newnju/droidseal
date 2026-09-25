// 一次性活跃 hook 验证 v2:挂钩 libc read/openat,25 秒统计窗口
// (由外部 input tap 制造真实调用),输出计数后自然退出。
'use strict';
var calls = { openat: 0, read: 0, hooked: 0 };
function tryHook(lib, name) {
  try {
    var addr = Module.getExportByName(lib, name);
    Interceptor.attach(addr, function () { calls[name]++; });
    calls.hooked++;
    console.log('[hook] ok: ' + lib + ':' + name);
  } catch (e) {
    console.log('[hook] fail: ' + lib + ':' + name + ' -> ' + e.message);
  }
}
console.log('[frida] attached pid, hooking...');
tryHook('libc.so', 'openat');
tryHook('libc.so', 'read');
setTimeout(function () {
  console.log('[result] ' + JSON.stringify(calls));
}, 25000);
