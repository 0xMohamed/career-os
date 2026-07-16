#!/usr/bin/env node
/**
 * build.js — Career OS build script
 *
 * Compiles the active application (applications/oto.typ) into output/resume.pdf
 * via Typst. Typst is treated as a detachable rendering engine; swapping it for
 * another renderer requires only changing this file.
 *
 * Usage: pnpm build
 */

import { execSync } from "child_process";
import { mkdirSync, existsSync } from "fs";
import { resolve, dirname } from "path";
import { fileURLToPath } from "url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const root = resolve(__dirname, "..");

// Ensure output directory exists
const outputDir = resolve(root, "output");
if (!existsSync(outputDir)) {
  mkdirSync(outputDir, { recursive: true });
}

const entry = resolve(root, "applications", "oto.typ");
const out = resolve(outputDir, "resume.pdf");

console.log("Career OS — building resume...");
console.log(`  Entry : applications/oto.typ`);
console.log(`  Output: output/resume.pdf`);
console.log();

try {
  // --root tells Typst the project boundary, allowing imports across
  // subdirectories (content/, projects/, templates/) without escaping the sandbox.
  execSync(`typst compile --root "${root}" "${entry}" "${out}"`, {
    stdio: "inherit",
    cwd: root,
  });
  console.log("\n✓ Build complete → output/resume.pdf");
} catch {
  console.error("\n✗ Build failed. Is Typst installed? Run: brew install typst");
  process.exit(1);
}
