import { test, expect } from "bun:test"
import { mkdtemp, mkdir, writeFile, rm } from "node:fs/promises"
import { tmpdir } from "node:os"
import path from "node:path"
import { scanSourceDetectors } from "../src/core/source-detectors.ts"

// 配置/加固类「缺失检测」的精度用例（正：无防护风险源码→检出；负：有防护→不检出）。
async function scanSource(files: Record<string, string>): Promise<string[]> {
  const dir = await mkdtemp(path.join(tmpdir(), "det-config-"))
  await mkdir(path.join(dir, "src"), { recursive: true })
  for (const [name, content] of Object.entries(files)) {
    await writeFile(path.join(dir, "src", name), content, "utf8")
  }
  const findings = await scanSourceDetectors(path.join(dir, "src"))
  await rm(dir, { recursive: true, force: true })
  return findings.map((f) => f.code)
}

test("SOURCE_CERTIFICATE_PINNING_ABSENT: positive (network without pinning)", async () => {
  const codes = await scanSource({ "A.java": "class A { void x() { OkHttpClient c = new OkHttpClient(); } }" })
  expect(codes).toContain("SOURCE_CERTIFICATE_PINNING_ABSENT")
})

test("SOURCE_CERTIFICATE_PINNING_ABSENT: negative (pinning present)", async () => {
  const codes = await scanSource({ "A.java": "class A { void x() { CertificatePinner p = new CertificatePinner.Builder().build(); } }" })
  expect(codes).not.toContain("SOURCE_CERTIFICATE_PINNING_ABSENT")
})

test("SOURCE_TAPJACKING_UNPROTECTED: positive (UI without touch filter)", async () => {
  const codes = await scanSource({ "A.java": "class A { void x() { setContentView(layout); } }" })
  expect(codes).toContain("SOURCE_TAPJACKING_UNPROTECTED")
})

test("SOURCE_TAPJACKING_UNPROTECTED: negative (touch filter present)", async () => {
  const codes = await scanSource({ "A.java": "class A { void x() { setFilterTouchesWhenObscured(true); } }" })
  expect(codes).not.toContain("SOURCE_TAPJACKING_UNPROTECTED")
})

test("SOURCE_SCREENSHOT_NOT_BLOCKED: positive (UI without FLAG_SECURE)", async () => {
  const codes = await scanSource({ "A.java": "class A { void x() { setContentView(layout); } }" })
  expect(codes).toContain("SOURCE_SCREENSHOT_NOT_BLOCKED")
})

test("SOURCE_SCREENSHOT_NOT_BLOCKED: negative (FLAG_SECURE present)", async () => {
  const codes = await scanSource({ "A.java": "class A { void x() { getWindow().setFlags(FLAG_SECURE, FLAG_SECURE); } }" })
  expect(codes).not.toContain("SOURCE_SCREENSHOT_NOT_BLOCKED")
})

test("SOURCE_ROOT_DETECTION_ABSENT: positive (system calls without root check)", async () => {
  const codes = await scanSource({ "A.java": "class A { void x() { getSystemService(TELEPHONY_SERVICE); } }" })
  expect(codes).toContain("SOURCE_ROOT_DETECTION_ABSENT")
})

test("SOURCE_ROOT_DETECTION_ABSENT: negative (root check present)", async () => {
  const codes = await scanSource({ "A.java": "class A { boolean x() { return RootBeer.isRooted(); } }" })
  expect(codes).not.toContain("SOURCE_ROOT_DETECTION_ABSENT")
})

test("SOURCE_INTEGRITY_API_ABSENT: positive (purchase without integrity check)", async () => {
  const codes = await scanSource({ "A.java": "class A { void x() { startPurchase(\"sku\"); } }" })
  expect(codes).toContain("SOURCE_INTEGRITY_API_ABSENT")
})

test("SOURCE_INTEGRITY_API_ABSENT: negative (Play Integrity present)", async () => {
  const codes = await scanSource({ "A.java": "class A { void x() { IntegrityManager im = getIntegrityManager(); } }" })
  expect(codes).not.toContain("SOURCE_INTEGRITY_API_ABSENT")
})

test("SOURCE_CERTIFICATE_TRANSPARENCY_ABSENT: positive (HTTP client without transparency config)", async () => {
  const codes = await scanSource({ "A.java": "class A { void x() { OkHttpClient c = new OkHttpClient(); } }" })
  expect(codes).toContain("SOURCE_CERTIFICATE_TRANSPARENCY_ABSENT")
})

test("SOURCE_CERTIFICATE_TRANSPARENCY_ABSENT: negative (network security config present)", async () => {
  const codes = await scanSource({ "A.java": "class A { void x() { NetworkSecurityConfig c = getNetworkSecurityConfig(); } }" })
  expect(codes).not.toContain("SOURCE_CERTIFICATE_TRANSPARENCY_ABSENT")
})
