#!/usr/bin/env node
/**
 * build.js — Career OS build script
 *
 * Compiles applications through specific presentation layouts into output PDFs.
 *
 * Usage:
 *   pnpm build                     # compiles default (master @ editorial) → output/resume.pdf
 *   pnpm build -- <app>            # compiles applications/<app>.typ using its default layout
 *   pnpm build -- <app> <layout>   # compiles applications/<app>.typ with specific layout override
 *   pnpm build:all                 # compiles master across all layouts + all custom applications
 */

import { execSync } from "child_process";
import { mkdirSync, existsSync } from "fs";
import { resolve } from "path";
import { root, paths, getBuildJobs, getPhoneInput } from "./config.js";

// Ensure output directory exists
if (!existsSync(paths.output)) {
  mkdirSync(paths.output, { recursive: true });
}

// Parse arguments (filtering package manager '--')
const args = process.argv.slice(2).filter(arg => arg !== "--");
const firstArg = args[0];
const secondArg = args[1];

let buildJobs = [];
try {
  buildJobs = getBuildJobs(firstArg, secondArg);
} catch (err) {
  console.error(`\n✗ ${err.message}`);
  process.exit(1);
}

const phone = getPhoneInput();

console.log("Career OS — building resume artifacts...\n");
if (phone) {
  console.log("  [Privacy] Custom phone number detected via CAREER_PHONE/private.json\n");
}

let successCount = 0;

for (const { app, layout, outName } of buildJobs) {
  const entry = resolve(paths.applications, `${app}.typ`);
  const out = resolve(paths.output, outName);

  if (!existsSync(entry)) {
    console.error(`✗ Error: Application file not found: applications/${app}.typ`);
    process.exit(1);
  }

  console.log(`  Application : applications/${app}.typ`);
  console.log(`  Layout      : ${layout}`);
  console.log(`  Output      : output/${outName}`);

  try {
    const inputArgs = [`layout=${layout}`];
    if (phone) {
      inputArgs.push(`phone=${phone}`);
    }
    const inputFlags = inputArgs.map(arg => `--input "${arg}"`).join(" ");

    execSync(`typst compile --root "${root}" ${inputFlags} "${entry}" "${out}"`, {
      stdio: "pipe",
      cwd: root,
    });
    console.log(`  ✓ Build complete → output/${outName}\n`);
    successCount++;
  } catch (err) {
    const output = err.stderr?.toString() || err.stdout?.toString() || String(err);
    console.error(`\n✗ Build failed for ${app} with layout ${layout}:\n${output.trim()}`);
    process.exit(1);
  }
}

console.log(`✓ ${successCount} resume artifact(s) generated successfully.`);
