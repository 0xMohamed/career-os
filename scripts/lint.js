#!/usr/bin/env node
/**
 * lint.js — Career OS lint script
 *
 * Validates the structural integrity of the content layer without rendering.
 * Checks that required content files, project files, layout templates, and
 * applications exist, and verifies Typst syntax via dry compilation.
 *
 * Fully dynamic: automatically discovers all projects and applications.
 *
 * Usage: pnpm lint
 */

import { existsSync } from "fs";
import { execSync } from "child_process";
import { resolve } from "path";
import {
  root,
  CORE_CONTENT_FILES,
  CORE_TEMPLATE_FILES,
  discoverProjects,
  discoverApplications,
} from "./config.js";

let errors = 0;

console.log("Career OS — linting content & layout structure...\n");

// 1. Check core content files
console.log("  [Content Layer]");
for (const file of CORE_CONTENT_FILES) {
  const full = resolve(root, file);
  if (existsSync(full)) {
    console.log(`    ✓ ${file}`);
  } else {
    console.error(`    ✗ MISSING: ${file}`);
    errors++;
  }
}
console.log();

// 2. Check template & layout files
console.log("  [Template Layer]");
for (const file of CORE_TEMPLATE_FILES) {
  const full = resolve(root, file);
  if (existsSync(full)) {
    console.log(`    ✓ ${file}`);
  } else {
    console.error(`    ✗ MISSING: ${file}`);
    errors++;
  }
}
console.log();

// 3. Dynamically check all projects in projects/
console.log("  [Project Layer]");
const projects = discoverProjects();
if (projects.length === 0) {
  console.error("    ✗ No project files found in projects/");
  errors++;
} else {
  for (const proj of projects) {
    if (existsSync(proj.path)) {
      console.log(`    ✓ ${proj.file}`);
    } else {
      console.error(`    ✗ MISSING: ${proj.file}`);
      errors++;
    }
  }
}
console.log();

// 4. Dynamically check all applications in applications/
console.log("  [Application Layer]");
const applications = discoverApplications();
if (applications.length === 0) {
  console.error("    ✗ No application files found in applications/");
  errors++;
} else {
  for (const app of applications) {
    if (existsSync(app.path)) {
      console.log(`    ✓ ${app.file}`);
    } else {
      console.error(`    ✗ MISSING: ${app.file}`);
      errors++;
    }
  }
}
console.log();

// 5. Dry Typst compiles across discovered applications
console.log("  [Typst Syntax & Template Integrity]");
const testSuites = [];

for (const app of applications) {
  if (app.id === "master") {
    testSuites.push({ app: "master.typ", layout: "editorial", path: app.path });
    testSuites.push({ app: "master.typ", layout: "standard",  path: app.path });
    testSuites.push({ app: "master.typ", layout: "classic",   path: app.path });
  } else {
    testSuites.push({ app: `${app.id}.typ`, layout: app.detectedLayout, path: app.path });
  }
}

for (const { app, layout, path } of testSuites) {
  try {
    execSync(`typst compile --root "${root}" --input layout="${layout}" --format pdf "${path}" /dev/null`, {
      stdio: "pipe",
      cwd: root,
    });
    console.log(`    ✓ Typst syntax check passed (${app} @ ${layout})`);
  } catch (err) {
    const output = err.stderr?.toString() || err.stdout?.toString() || String(err);
    console.error(`    ✗ Typst syntax error in ${app} with layout ${layout}:\n`);
    console.error(output.trim());
    errors++;
  }
}

console.log();

if (errors === 0) {
  console.log("✓ Lint passed — all content, projects, applications, and layout templates are present and valid.");
} else {
  console.error(`✗ Lint failed — ${errors} error(s) found.`);
  process.exit(1);
}
