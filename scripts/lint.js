#!/usr/bin/env node
/**
 * lint.js — Career OS lint script
 *
 * Validates the structural integrity of the content layer without rendering.
 * Checks that required content files, project files, and layout templates exist,
 * and that Typst can parse the entry points and layouts without compilation errors.
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
  // Application layer (Content & positioning selection only)
  "applications/master.typ",
  // Template & Layout layer (Presentation concerns only)
  "templates/resume.typ",
  "templates/theme.typ",
  "templates/layouts/editorial.typ",
  "templates/layouts/standard.typ",
  "templates/layouts/classic.typ",
];

let errors = 0;

console.log("Career OS — linting content & layout structure...\n");

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

// 2. Try dry Typst compiles across applications and all presentation layouts
const testSuites = [
  { app: "master.typ", layout: "editorial" },
  { app: "master.typ", layout: "standard" },
  { app: "master.typ", layout: "classic" },
];

for (const { app, layout } of testSuites) {
  try {
    const entry = resolve(root, "applications", app);
    execSync(`typst compile --root "${root}" --input layout="${layout}" --format pdf "${entry}" /dev/null`, {
      stdio: "pipe",
      cwd: root,
    });
    console.log(`  ✓ Typst syntax check passed (${app} @ ${layout})`);
  } catch (err) {
    const output = err.stderr?.toString() || err.stdout?.toString() || String(err);
    console.error(`  ✗ Typst syntax error in ${app} with layout ${layout}:\n`);
    console.error(output.trim());
    errors++;
  }
}

console.log();

if (errors === 0) {
  console.log("✓ Lint passed — all content and layout templates are present and valid.");
} else {
  console.error(`✗ Lint failed — ${errors} error(s) found.`);
  process.exit(1);
}
