#!/usr/bin/env node
/**
 * build.js — Career OS build script
 *
 * Compiles applications through specific presentation layouts into output PDFs.
 *
 * Usage:
 *   pnpm build                     # compiles master.typ @ editorial → output/resume.pdf
 *   pnpm build -- master standard  # compiles master.typ @ standard  → output/single.pdf
 *   pnpm build -- master classic   # compiles master.typ @ classic   → output/classic.pdf
 *   pnpm build:all                 # compiles master across all 3 layouts (editorial, standard, classic)
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

// Parse arguments (filtering package manager '--')
const args = process.argv.slice(2).filter(arg => arg !== "--");
const firstArg = args[0] || "master";
const secondArg = args[1] || "editorial";

let buildJobs = [];

if (firstArg === "all") {
  buildJobs = [
    { app: "master", layout: "editorial", outName: "resume.pdf" },
    { app: "master", layout: "standard",  outName: "single.pdf" },
    { app: "master", layout: "classic",   outName: "classic.pdf" },
  ];
} else {
  const app = firstArg;
  const layout = secondArg;
  let outName = `${app}.pdf`;
  if (app === "master" && layout === "editorial") {
    outName = "resume.pdf";
  } else if (app === "master" && (layout === "standard" || layout === "single-column" || layout === "one-column")) {
    outName = "single.pdf";
  } else if (app === "master" && (layout === "classic" || layout === "traditional")) {
    outName = "classic.pdf";
  } else if (layout !== "editorial") {
    outName = `${app}-${layout}.pdf`;
  }
  buildJobs = [{ app, layout, outName }];
}

console.log("Career OS — building resume artifacts...\n");

let successCount = 0;

for (const { app, layout, outName } of buildJobs) {
  const entry = resolve(root, "applications", `${app}.typ`);
  const out = resolve(outputDir, outName);

  if (!existsSync(entry)) {
    console.error(`✗ Error: Application file not found: applications/${app}.typ`);
    process.exit(1);
  }

  console.log(`  Application : applications/${app}.typ`);
  console.log(`  Layout      : ${layout}`);
  console.log(`  Output      : output/${outName}`);

  try {
    execSync(`typst compile --root "${root}" --input layout="${layout}" "${entry}" "${out}"`, {
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
