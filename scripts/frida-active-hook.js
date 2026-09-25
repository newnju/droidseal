// 活跃 hook 脚本:hook libc 的 read/openat 与 libart 的 GetStringUTFChars,
// 制造真实的函数级拦截(不是仅监听),验证密钥化防御在真实注入下的 fail-closed。
// frida-inject -p <pid> -s hook.js
'use strict';
const calls = { openat: 0, read: 0, jstrings: 0 };
try {
  const openat = Module.getExportByName('libc.so', 'openat');
  Interceptor.attach(openat, {
    onEnter: function (args) { calls.openat++; },
  });
} catch (e) { }
try {
  const read = Module.getExportByName('libc.so', 'read');
  Interceptor.attach(read, {
    onEnter: function (args) { calls.read++; },
  });
} catch (e) { }
try {
  const gstr = Module.getExportByName('libart.so', '_ZN3art7JNIEnv16GetStringUTFCharsEP8_jstringPh');
  Interceptor.attach(gstr, {
    onEnter: function (args) { calls.jstrings++; },
  });
} catch (e) { }
setInterval(function () {
  send({ type: 'heartbeat', calls: calls });
}, 2000);
