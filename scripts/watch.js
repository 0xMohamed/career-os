#!/usr/bin/env node
/**
 * watch.js — Career OS watch script
 *
 * Runs Typst in watch mode for a specific application (default: master.typ).
 *
 * Usage:
 *   pnpm watch             # watches applications/master.typ → output/resume.pdf
 *   pnpm watch -- <app>    # watches applications/<app>.typ → output/resume-<app>.pdf
 */

import { spawn } from "child_process";
import { mkdirSync, existsSync } from "fs";
import { resolve } from "path";
import { root, paths, getApplication, getPhoneInput } from "./config.js";

if (!existsSync(paths.output)) {
  mkdirSync(paths.output, { recursive: true });
}

// Determine target application and output file (filter out '--' prefix passed by package managers)
const args = process.argv.slice(2).filter(arg => arg !== "--");
const targetQuery = args[0] || "master";
const app = getApplication(targetQuery);

if (!app) {
  console.error(`\n✗ Error: Application file not found: applications/${targetQuery}.typ`);
  process.exit(1);
}

const entry = app.path;
const outName = app.defaultOutName;
const out = resolve(paths.output, outName);
const phone = getPhoneInput();

console.log("Career OS — watching for changes...");
console.log(`  Entry : ${app.file}`);
console.log(`  Layout: ${app.detectedLayout}`);
if (phone) {
  console.log(`  Phone : Configured via CAREER_PHONE/private.json`);
}
console.log(`  Output: output/${outName}`);
console.log(`  Press Ctrl+C to stop.\n`);

const typstArgs = ["watch", "--root", root, "--input", `layout=${app.detectedLayout}`];
if (phone) {
  typstArgs.push("--input", `phone=${phone}`);
}
typstArgs.push(entry, out);

const child = spawn("typst", typstArgs, {
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
