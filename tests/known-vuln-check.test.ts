import { describe, expect, test } from "bun:test"
import { KNOWN_VULNERABILITIES } from "../src/core/known-vulnerabilities.ts"
import { KNOWN_PACKERS } from "../src/core/packers.ts"

const SEVERITIES = ["critical", "high", "medium", "low", "info"]

describe("data tables consistency", () => {
  test("vulnerability snapshot has unique CVEs and packages with required fields", () => {
    const cves = KNOWN_VULNERABILITIES.map((entry) => entry.cve)
    expect(new Set(cves).size).toBe(cves.length)
    const packages = KNOWN_VULNERABILITIES.map((entry) => entry.package)
    expect(new Set(packages).size).toBe(packages.length)
    for (const entry of KNOWN_VULNERABILITIES) {
      expect(entry.package.length).toBeGreaterThan(0)
      expect(entry.cve).toMatch(/^CVE-\d{4}-\d+$/)
      expect(SEVERITIES).toContain(entry.severity)
      expect(entry.note.length).toBeGreaterThan(0)
    }
  })

  test("packer fingerprints have unique markers and names with required fields", () => {
    const markers = KNOWN_PACKERS.map((packer) => packer.marker)
    expect(new Set(markers).size).toBe(markers.length)
    const names = KNOWN_PACKERS.map((packer) => packer.name)
    expect(new Set(names).size).toBe(names.length)
    for (const packer of KNOWN_PACKERS) {
      expect(packer.name.length).toBeGreaterThan(0)
      expect(packer.marker.length).toBeGreaterThan(0)
      expect(packer.note.length).toBeGreaterThan(0)
    }
  })
})
