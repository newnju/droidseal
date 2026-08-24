// DroidSeal opt-in anti-debug stub — self-developed, MIT.
//
// Detection ONLY. This unit reports signals; it never decides to crash, exit,
// or alter app behaviour. The host app owns the response policy (prefer using
// these as risk inputs alongside server-side checks, not as sole access control).
//
// Build-time linked via CMake/NDK. It is NOT injected post-hoc into a finished
// APK, matching DroidSeal's boundary of never synthesising executable code into
// unknown artifacts.

#include <jni.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Reads TracerPid from /proc/self/status.
// Returns: 0 = no tracer, >0 = tracer pid, -1 = unavailable.
static int droidseal_tracer_pid(void) {
    FILE *fp = fopen("/proc/self/status", "r");
    if (!fp) {
        return -1;
    }
    char line[512];
    int tracer = 0;
    while (fgets(line, sizeof(line), fp)) {
        if (strncmp(line, "TracerPid:", 10) == 0) {
            tracer = (int) strtol(line + 10, NULL, 10);
            break;
        }
    }
    fclose(fp);
    return tracer;
}

// Well-known dynamic-instrumentation artifacts. Defensive detection only.
static const char *DROIDSEAL_TOKENS[] = {
    "frida",
    "gum-js-loop",
    "libgadget",
    "gadget",
    "xposed",
    "substrate",
    "libriru",
    "magisk",
    "zygisk",
    "lspd",
    "riru",
    "Sui",
    NULL,
};

// Scans the process' own memory maps for injection framework signatures.
// Returns 1 on the first match, 0 otherwise.
static int droidseal_scan_maps(void) {
    FILE *fp = fopen("/proc/self/maps", "r");
    if (!fp) {
        return 0;
    }
    char line[1024];
    int hit = 0;
    while (!hit && fgets(line, sizeof(line), fp)) {
        for (int i = 0; DROIDSEAL_TOKENS[i] != NULL; i++) {
            if (strstr(line, DROIDSEAL_TOKENS[i]) != NULL) {
                hit = 1;
                break;
            }
        }
    }
    fclose(fp);
    return hit;
}

JNIEXPORT jint JNICALL
Java_com_droidseal_antidebug_DroidSealAntiDebug_nativeTracerPid(JNIEnv *env, jobject thiz) {
    (void) env;
    (void) thiz;
    return (jint) droidseal_tracer_pid();
}

JNIEXPORT jboolean JNICALL
Java_com_droidseal_antidebug_DroidSealAntiDebug_nativeHasInjectionArtifacts(JNIEnv *env, jobject thiz) {
    (void) env;
    (void) thiz;
    return droidseal_scan_maps() ? JNI_TRUE : JNI_FALSE;
}

// 方向⑤（原生层反调试——ptrace 自跟踪检测）：尝试 PTRACE_TRACEME——
// 失败（EPERM/EACCES）说明本进程已被 ptrace（调试器/注入框架跟踪）——native 侧主动防御，与 Java 层互补。
static int droidseal_ptrace_traced(void) {
#if defined(__ANDROID__)
    if (ptrace(PTRACE_TRACEME, 0, NULL, NULL) == -1) {
        return 1; // 已被跟踪
    }
    ptrace(PTRACE_DETACH, 0, NULL, NULL);
#endif
    return 0;
}

JNIEXPORT jboolean JNICALL
Java_com_droidseal_antidebug_DroidSealAntiDebug_nativePtraceTraced(JNIEnv *env, jobject thiz) {
    (void) env;
    (void) thiz;
    return droidseal_ptrace_traced() ? JNI_TRUE : JNI_FALSE;
}
