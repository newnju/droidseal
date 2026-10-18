// 活跃 hook 脚本(hook libc 的 read/openat 与 libart 的 GetStringUTFChars),
// 制造真实的函数级拦截(不是仅监听),验证密钥化防御在真实注入下的行为。
// 兼容 Frida 17(旧静态 Module.getExportByName 已移除;改用模块实例 API)。
// frida-inject -p <pid> -s hook.js
'use strict';
const calls = { openat: 0, read: 0, jstrings: 0 };
const errors = [];
const attached = [];

function tryHook(modName, fname, counter) {
  try {
    const m = Process.findModuleByName(modName);
    if (!m) throw new Error('module not found: ' + modName);
    const p = m.findExportByName(fname);
    if (!p) throw new Error('export not found: ' + fname);
    Interceptor.attach(p, { onEnter: function () { counter(); } });
    attached.push(modName + '/' + fname);
  } catch (e) {
    errors.push(modName + '/' + fname + ': ' + e);
  }
}

tryHook('libc.so', 'openat', function () { calls.openat += 1; });
tryHook('libc.so', 'read', function () { calls.read += 1; });
tryHook('libart.so', '_ZN3art7JNIEnv16GetStringUTFCharsEP8_jstringPh', function () { calls.jstrings += 1; });

send({ type: 'meta', attached: attached, errors: errors });

setInterval(function () {
  send({ type: 'heartbeat', calls: calls });
}, 2000);
