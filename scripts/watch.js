#!/usr/bin/env node
/**
 * watch.js — Career OS watch script
 *
 * Runs Typst in watch mode for a specific application (default: master.typ).
 *
 * Usage:
 *   pnpm watch          # watches applications/master.typ → output/resume.pdf
 *   pnpm watch -- oto   # watches applications/oto.typ → output/oto.pdf
 */

import { spawn } from "child_process";
import { mkdirSync, existsSync } from "fs";
import { resolve, dirname } from "path";
import { fileURLToPath } from "url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const root = resolve(__dirname, "..");

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

console.log("Career OS — watching for changes...");
console.log(`  Entry : applications/${target}.typ`);
console.log(`  Output: output/${outName}`);
console.log(`  Press Ctrl+C to stop.\n`);

const child = spawn("typst", ["watch", "--root", root, entry, out], {
  stdio: "inherit",
  cwd: root,
});

child.on("error", () => {
  console.error("✗ Could not start Typst. Is it installed? Run: brew install typst");
  process.exit(1);
});

child.on("exit", (code) => {
  process.exit(code ?? 0);
});
