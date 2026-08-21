#!/usr/bin/env node
/**
 * lint.js — Career OS lint script
 *
 * Validates the structural integrity of the content layer without rendering.
 * Checks that required content files and project files all exist and that
 * Typst can parse the entry point without compilation errors.
 *
 * Usage: pnpm lint
 */

import { existsSync } from "fs";
import { execSync } from "child_process";
import { resolve, dirname } from "path";
import { fileURLToPath } from "url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const root = resolve(__dirname, "..");

const REQUIRED_FILES = [
  // Content layer
  "content/profile.typ",
  "content/experience.typ",
  "content/education.typ",
  "content/languages.typ",
  "content/skills.typ",
  "content/strengths.typ",
  "content/career-direction.typ",
  // Project layer
  "projects/lintu.typ",
  "projects/modra.typ",
  "projects/oqel.typ",
  "projects/basira.typ",
  "projects/deskby.typ",
  "projects/cargolab.typ",
  // Application layer
  "applications/master.typ",
  "applications/oto.typ",
  // Template layer
  "templates/resume.typ",
  "templates/theme.typ",
];

let errors = 0;

console.log("Career OS — linting content structure...\n");

// 1. Check all required files exist
for (const file of REQUIRED_FILES) {
  const full = resolve(root, file);
  if (existsSync(full)) {
    console.log(`  ✓ ${file}`);
  } else {
    console.error(`  ✗ MISSING: ${file}`);
    errors++;
  }
}

console.log();

// 2. Try a dry Typst compile to catch syntax errors
try {
  const entry = resolve(root, "applications", "master.typ");
  execSync(`typst compile --root "${root}" --format pdf "${entry}" /dev/null`, {
    stdio: "pipe",
    cwd: root,
  });
  console.log("  ✓ Typst syntax check passed");
} catch (err) {
  const output = err.stderr?.toString() || err.stdout?.toString() || String(err);
  console.error("  ✗ Typst syntax error:\n");
  console.error(output.trim());
  errors++;
}

console.log();

if (errors === 0) {
  console.log("✓ Lint passed — all content files present and valid.");
} else {
  console.error(`✗ Lint failed — ${errors} error(s) found.`);
  process.exit(1);
}
