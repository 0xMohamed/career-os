#!/usr/bin/env node
/**
 * build.js — Career OS build script
 *
 * Compiles a specific application (default: master.typ) into the output folder via Typst.
 *
 * Usage:
 *   pnpm build          # compiles applications/master.typ → output/resume.pdf
 *   pnpm build -- oto   # compiles applications/oto.typ → output/oto.pdf
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

// Determine target application and output file (filter out '--' prefix passed by package managers)
const args = process.argv.slice(2).filter(arg => arg !== "--");
const target = args[0] || "master";
const entry = resolve(root, "applications", `${target}.typ`);
const outName = target === "master" ? "resume.pdf" : `${target}.pdf`;
const out = resolve(outputDir, outName);

if (!existsSync(entry)) {
  console.error(`\n✗ Error: Application file not found: applications/${target}.typ`);
  process.exit(1);
}

console.log("Career OS — building resume...");
console.log(`  Entry : applications/${target}.typ`);
console.log(`  Output: output/${outName}`);
console.log();

try {
  // --root tells Typst the project boundary, allowing imports across
  // subdirectories (content/, projects/, templates/) without escaping the sandbox.
  execSync(`typst compile --root "${root}" "${entry}" "${out}"`, {
    stdio: "inherit",
    cwd: root,
  });
  console.log(`\n✓ Build complete → output/${outName}`);
} catch {
  console.error("\n✗ Build failed. Is Typst installed? Run: brew install typst");
  process.exit(1);
}
