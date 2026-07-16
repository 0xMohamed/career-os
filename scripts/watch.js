#!/usr/bin/env node
/**
 * watch.js — Career OS watch script
 *
 * Runs Typst in watch mode: recompiles output/resume.pdf automatically
 * whenever any .typ file changes. Ideal during active editing.
 *
 * Usage: pnpm watch
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

const entry = resolve(root, "applications", "oto.typ");
const out = resolve(outputDir, "resume.pdf");

console.log("Career OS — watching for changes...");
console.log(`  Entry : applications/oto.typ`);
console.log(`  Output: output/resume.pdf`);
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
