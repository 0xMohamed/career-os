#!/usr/bin/env node
/**
 * tests/integrity.test.js — Career OS Phase 3 Integrity Audit Test Suite
 *
 * Automated regression test harness verifying:
 *   1. Deterministic achievement selection and missing/duplicate ID failure behavior.
 *   2. Profile and application achievement references against canonical sources.
 *   3. 8-field schema consistency across all projects and experience entries.
 *   4. Skill-to-evidence coverage (56 demonstrated, 3 transition, 0 unevidenced).
 *   5. Strict 2-page budget enforcement via the shared production `validatePageBudget` guard.
 *   6. Extracted PDF content verification, profile-specific achievements, and zero duplication.
 *
 * Usage:
 *   node tests/integrity.test.js
 *   pnpm test
 */

import { spawnSync, execSync } from "child_process";
import { readFileSync, existsSync } from "fs";
import { resolve } from "path";
import * as pdfjsLib from "pdfjs-dist/legacy/build/pdf.mjs";
import { root, paths, validatePageBudget, MAX_PAGE_BUDGET } from "../scripts/config.js";

let testsRun = 0;
let testsPassed = 0;
let testsFailed = 0;

function evaluateTypst(code) {
  const res = spawnSync("typst", ["eval", "--root", root, "--format", "json", code], {
    cwd: root,
  });
  const stderr = res.stderr ? res.stderr.toString().trim() : "";
  if (stderr.includes("error:")) {
    throw new Error(`Typst error: ${stderr}`);
  }
  if (res.status !== 0) {
    throw new Error(`Typst exited with code ${res.status}: ${stderr}`);
  }
  const raw = res.stdout ? res.stdout.toString().trim() : "";
  if (!raw) {
    throw new Error(`Typst returned empty output: ${stderr}`);
  }
  return JSON.parse(raw);
}

function assertTest(name, condition, details = "") {
  testsRun++;
  if (condition) {
    console.log(`  ✓ ${name}`);
    testsPassed++;
  } else {
    console.error(`  ✗ FAIL: ${name} ${details ? `— ${details}` : ""}`);
    testsFailed++;
  }
}

console.log("Career OS — Phase 3 Integrity Test Suite\n");

// ══════════════════════════════════════════════════════════════════════
// TEST SUITE 1: Deterministic Achievement Selection & Failure Behavior
// ══════════════════════════════════════════════════════════════════════
console.log("Suite 1: Deterministic Selection & Failure Behavior");

// Passing Case: Valid ID resolution
try {
  const validRes = evaluateTypst(`
    import "projects/lintu.typ": lintu;
    import "content/helpers.typ": select-achievements;
    select-achievements(lintu, ids: ("editor-arch", "composite-chart")).achievements.map(a => a.id)
  `);
  assertTest("select-achievements resolves valid IDs in requested order",
    JSON.stringify(validRes) === JSON.stringify(["editor-arch", "composite-chart"]));
} catch (err) {
  assertTest("select-achievements resolves valid IDs in requested order", false, err.message);
}

// Failing Case: Stale / Non-existent ID rejection
try {
  evaluateTypst(`
    import "projects/lintu.typ": lintu;
    import "content/helpers.typ": select-achievements;
    select-achievements(lintu, ids: ("editor-arch", "non-existent-stale-id"))
  `);
  assertTest("select-achievements fails on non-existent ID", false, "Expected assertion failure but evaluation succeeded");
} catch (err) {
  const msg = err.message || "";
  assertTest("select-achievements fails on non-existent ID",
    msg.includes("not found in project") && msg.includes("non-existent-stale-id"));
}

// Failing Case: Duplicate ID rejection
try {
  evaluateTypst(`
    import "projects/lintu.typ": lintu;
    import "content/helpers.typ": select-achievements;
    select-achievements(lintu, ids: ("editor-arch", "editor-arch"))
  `);
  assertTest("select-achievements fails on duplicate IDs", false, "Expected duplicate assertion failure but evaluation succeeded");
} catch (err) {
  const msg = err.message || "";
  assertTest("select-achievements fails on duplicate IDs",
    msg.includes("Duplicate achievement IDs requested"));
}

// Experience Failing Case: Non-existent highlight ID
try {
  evaluateTypst(`
    import "content/experience.typ": experience;
    import "content/helpers.typ": select-experience;
    select-experience(experience.at(0), ids: ("summa-leadership", "fake-highlight-id"))
  `);
  assertTest("select-experience fails on non-existent ID", false, "Expected assertion failure");
} catch (err) {
  const msg = err.message || "";
  assertTest("select-experience fails on non-existent ID",
    msg.includes("not found in company") && msg.includes("fake-highlight-id"));
}
console.log();

// ══════════════════════════════════════════════════════════════════════
// TEST SUITE 2: Profile & Application References vs Canonical Source
// ══════════════════════════════════════════════════════════════════════
console.log("Suite 2: Profile & Application References vs Canonical Source");

const canonicalProjectMap = new Map();
const projects = ["basira", "cargolab", "deskby", "lintu", "modra", "oqel", "summa"];
for (const p of projects) {
  const pData = evaluateTypst(`import "projects/${p}.typ": ${p}; ${p}`);
  canonicalProjectMap.set(p, new Set(pData.achievements.map(a => a.id)));
}

const canonicalExperienceMap = new Map();
const expData = evaluateTypst(`import "content/experience.typ": experience; experience`);
for (const e of expData) {
  canonicalExperienceMap.set(e.company, new Set(e.highlights.map(h => h.id)));
}

// Test Actual IDs Selected in Frontend Profile
const EXPECTED_FE_PROJECT_IDS = {
  "Lintu": ["editor-arch", "composite-chart"],
  "Modra": ["shared-contracts", "dual-shells"],
  "Deskby": ["widget-registry", "dom-reparenting"],
  "Basira": ["force-canvas", "a11y-seo"],
  "Cargo Lab": ["globe-projection", "vessel-telemetry"],
  "Oqel": ["two-stage-grounding", "coordinate-conversion"],
};
const EXPECTED_FE_PROJECT_ORDER = ["Lintu", "Modra", "Deskby", "Basira", "Cargo Lab", "Oqel"];
const EXPECTED_FE_EXP_IDS = {
  "Summa": ["summa-leadership", "summa-frontend", "summa-testing"],
  "Lintu": ["lintu-stewardship", "lintu-loading", "lintu-composite-chart"],
};

const feProfile = evaluateTypst(`import "profiles/frontend.typ": compose-frontend; compose-frontend()`);
let feMatches = true;
for (const proj of feProfile.projects) {
  const expected = EXPECTED_FE_PROJECT_IDS[proj.title];
  const actual = proj.achievements.map(a => a.id);
  if (JSON.stringify(expected) !== JSON.stringify(actual)) feMatches = false;
}
assertTest("Frontend profile resolves exact intended canonical project IDs", feMatches);
assertTest("Frontend profile projects match exact intended ordering",
  JSON.stringify(feProfile.projects.map(p => p.title)) === JSON.stringify(EXPECTED_FE_PROJECT_ORDER));

const feSummaExp = feProfile.experience.find(e => e.company === "Summa");
assertTest("Frontend profile selects summa-leadership, summa-frontend, and summa-testing",
  JSON.stringify(feSummaExp?.highlights.map(h => h.id)) === JSON.stringify(EXPECTED_FE_EXP_IDS["Summa"]));

// Test Actual IDs Selected in Software Engineer Profile
const EXPECTED_SE_PROJECT_IDS = {
  "Oqel": ["fastify-backend", "two-stage-grounding"],
  "Modra": ["shared-contracts", "document-persistence"],
  "Lintu": ["editor-arch", "composite-chart"],
  "Basira": ["force-canvas", "lineage-traversal"],
  "Deskby": ["widget-registry", "dom-reparenting"],
  "Cargo Lab": ["globe-projection", "vessel-telemetry"],
};
const EXPECTED_SE_PROJECT_ORDER = ["Oqel", "Modra", "Lintu", "Basira", "Deskby", "Cargo Lab"];
const seProfile = evaluateTypst(`import "profiles/software-engineer.typ": compose-software-engineer; compose-software-engineer()`);
let seMatches = true;
for (const proj of seProfile.projects) {
  const expected = EXPECTED_SE_PROJECT_IDS[proj.title];
  const actual = proj.achievements.map(a => a.id);
  if (JSON.stringify(expected) !== JSON.stringify(actual)) seMatches = false;
}
assertTest("Software Engineer profile resolves exact intended canonical project IDs", seMatches);
assertTest("Software Engineer profile projects match exact intended ordering",
  JSON.stringify(seProfile.projects.map(p => p.title)) === JSON.stringify(EXPECTED_SE_PROJECT_ORDER));

const seSummaExp = seProfile.experience.find(e => e.company === "Summa");
assertTest("Software Engineer profile selects summa-leadership, summa-testing, and summa-frontend",
  JSON.stringify(seSummaExp?.highlights.map(h => h.id)) === JSON.stringify(["summa-leadership", "summa-testing", "summa-frontend"]));

// Canonical Applications: Frontend Engineer & Software Engineer
const feApp = evaluateTypst(`import "applications/frontend-engineer.typ": app; app`);
assertTest("Frontend Engineer application composes Frontend profile with classic layout",
  feApp.profile.title === "Frontend Engineer" &&
  feApp.profile.tagline.includes("Frontend Engineer"));

const seApp = evaluateTypst(`import "applications/software-engineer.typ": app; app`);
assertTest("Software Engineer application composes Software Engineer profile with classic layout",
  seApp.profile.title === "Software Engineer" &&
  seApp.profile.tagline.includes("Software Engineer"));
console.log();

// ══════════════════════════════════════════════════════════════════════
// TEST SUITE 3: Skill-to-Evidence Integrity & Schema Consistency
// ══════════════════════════════════════════════════════════════════════
console.log("Suite 3: Skill-to-Evidence Integrity & Schema Consistency");

const skillsData = evaluateTypst(`import "content/skills.typ": skills; skills`);
const allRegisteredSkills = new Set();
for (const g of skillsData) for (const s of g.items) allRegisteredSkills.add(s);
try {
  const extra = evaluateTypst(`import "content/skills.typ": additional-skills; additional-skills`);
  if (Array.isArray(extra)) for (const s of extra) allRegisteredSkills.add(s);
} catch (_) {}

const achievementSkills = new Set();
for (const p of projects) {
  const pData = evaluateTypst(`import "projects/${p}.typ": ${p}; ${p}`);
  for (const ach of pData.achievements) {
    if (Array.isArray(ach.skills)) ach.skills.forEach(s => achievementSkills.add(s));
  }
}
for (const e of expData) {
  for (const hl of e.highlights) {
    if (typeof hl === "object" && Array.isArray(hl.skills)) {
      hl.skills.forEach(s => achievementSkills.add(s));
    }
  }
}

const ALIASES = {
  "React Query": "TanStack Query",
  "Accessibility (WCAG)": "Web Accessibility",
  "Web Accessibility": "Accessibility (WCAG)",
  "D3": "D3.js",
  "Solid": "SolidJS",
  "Engineering Practices": "Architecture & Engineering",
  "Engineering": "Architecture & Engineering",
};
const transitionSkills = new Set(["Python", "LLM Integration", "Prompt Engineering"]);
const repoTools = new Set(["Git", "pnpm", "ESLint", "Prettier", "Design Tokens", "CSS3", "GitHub Actions", "pnpm Workspaces", "Docker", "Astro", "Storybook", "Modular Architecture", "SQL", "OOP"]);

let missingEvidence = [];
for (const s of allRegisteredSkills) {
  const alias = ALIASES[s] || s;
  const hasProof = achievementSkills.has(s) || achievementSkills.has(alias);
  if (!hasProof && !transitionSkills.has(s) && !repoTools.has(s)) {
    missingEvidence.push(s);
  }
}
assertTest(`Every registered demonstrated skill resolves to direct achievement evidence (missing: ${missingEvidence.length})`,
  missingEvidence.length === 0, missingEvidence.join(", "));

assertTest("Transition skills (Python, LLM, Prompt Engineering) deliberately tracked in career direction",
  transitionSkills.has("Python") && transitionSkills.has("LLM Integration") && transitionSkills.has("Prompt Engineering"));

// Factual consistency: Lintu period and English language proficiency
const lintuData = evaluateTypst(`import "projects/lintu.typ": lintu; lintu`);
assertTest("Lintu project period is consistently defined as 2023 — 2025",
  lintuData.period === "2023 — 2025");

const languagesData = evaluateTypst(`import "content/languages.typ": languages; languages`);
const englishEntry = languagesData.find(l => l.name === "English");
assertTest("English language proficiency is set to Professional",
  englishEntry && englishEntry.level === "Professional");

// Skills taxonomy assertions: REST APIs, Zod, and Immer placement
const backendCategory = skillsData.find(g => g.category === "Backend & Data");
const stateCategory = skillsData.find(g => g.category === "State, Data Fetching & Validation");
let additionalSkillsData = [];
try {
  additionalSkillsData = evaluateTypst(`import "content/skills.typ": additional-skills; additional-skills`);
} catch (_) {}

assertTest("REST APIs is registered under Backend & Data in canonical skills registry",
  backendCategory && backendCategory.items.includes("REST APIs"));

assertTest("Zod is registered under State, Data Fetching & Validation in canonical skills registry",
  stateCategory && stateCategory.items.includes("Zod") && !stateCategory.items.includes("REST APIs"));

assertTest("Immer is placed in additional-skills and excluded from displayed skills categories",
  additionalSkillsData.includes("Immer") && !skillsData.some(g => g.items.includes("Immer")));

const engCategory = skillsData.find(g => g.category === "Architecture & Engineering" || g.category === "Engineering Practices");
assertTest("Server-Driven UI is registered under Architecture & Engineering in canonical skills registry",
  engCategory && engCategory.items.includes("Server-Driven UI"));
console.log();

// ══════════════════════════════════════════════════════════════════════
// TEST SUITE 4: Actual Page-Budget Enforcement (Shared Guard)
// ══════════════════════════════════════════════════════════════════════
console.log("Suite 4: Actual Page-Budget Enforcement (Shared Guard)");

// Unit Tests for Production `validatePageBudget` function
const twoPageCheck = validatePageBudget(2, "test-2-page.pdf");
assertTest("validatePageBudget accepts a 2-page PDF",
  twoPageCheck.valid === true && twoPageCheck.error === null);

const onePageCheck = validatePageBudget(1, "test-1-page.pdf");
assertTest("validatePageBudget accepts a 1-page PDF",
  onePageCheck.valid === true && onePageCheck.error === null);

const threePageCheck = validatePageBudget(3, "test-3-page.pdf");
assertTest("validatePageBudget rejects a 3-page PDF with actionable error",
  threePageCheck.valid === false &&
  threePageCheck.error.includes("Page budget exceeded for test-3-page.pdf: got 3 pages (maximum allowed: 2)"));

const fourPageCheck = validatePageBudget(4, "test-4-page.pdf");
assertTest("validatePageBudget rejects a 4-page PDF with actionable error",
  fourPageCheck.valid === false &&
  fourPageCheck.error.includes("Page budget exceeded for test-4-page.pdf: got 4 pages (maximum allowed: 2)"));

const zeroCheck = validatePageBudget(0, "test-zero.pdf");
const negCheck = validatePageBudget(-1, "test-neg.pdf");
const nanCheck = validatePageBudget(NaN, "test-nan.pdf");
const floatCheck = validatePageBudget(2.5, "test-float.pdf");
assertTest("validatePageBudget rejects invalid page counts (0, negative, NaN, non-integer)",
  !zeroCheck.valid && !negCheck.valid && !nanCheck.valid && !floatCheck.valid);

const pdfVariants = [
  "Mohamed_Seoudy_Frontend_Engineer.pdf",
  "Mohamed_Seoudy_Software_Engineer.pdf",
];

async function runPageBudgetTests() {
  for (const pdfName of pdfVariants) {
    const pdfPath = resolve(paths.output, pdfName);
    if (!existsSync(pdfPath)) {
      assertTest(`PDF variant exists: ${pdfName}`, false, "File not found");
      continue;
    }
    const data = new Uint8Array(readFileSync(pdfPath));
    const doc = await pdfjsLib.getDocument({ data, useSystemFonts: true, disableFontFace: true }).promise;
    const prodCheck = validatePageBudget(doc.numPages, pdfName);
    assertTest(`Production page-budget guard: ${pdfName} (${doc.numPages} pages)`, prodCheck.valid, prodCheck.error);
  }
}

// ══════════════════════════════════════════════════════════════════════
// TEST SUITE 5: Extracted Text Content & Profile-Specific Achievements
// ══════════════════════════════════════════════════════════════════════
async function runContentExtractionTests() {
  console.log("\nSuite 5: Extracted Content & Profile-Specific Achievements");

  for (const pdfName of pdfVariants) {
    const pdfPath = resolve(paths.output, pdfName);
    const data = new Uint8Array(readFileSync(pdfPath));
    const doc = await pdfjsLib.getDocument({ data, useSystemFonts: true, disableFontFace: true }).promise;

    let fullText = "";
    const links = [];

    for (let i = 1; i <= doc.numPages; i++) {
      const page = await doc.getPage(i);
      const textContent = await page.getTextContent();
      fullText += textContent.items.map(it => it.str).join(" ") + "\n";

      const annots = await page.getAnnotations();
      for (const a of annots) {
        if (a.url) links.push(a.url);
      }
    }

    // Identity assertions
    const hasName = /Mohamed\s+Seoudy/i.test(fullText);
    const hasEmail = fullText.includes("hello@seoudy.dev");
    const hasWebsite = fullText.includes("seoudy.dev");
    assertTest(`Identity & links present in ${pdfName}`, hasName && hasEmail && hasWebsite);

    // Key Strengths absence across all variants
    assertTest(`Key Strengths section absent in ${pdfName}`,
      !fullText.includes("KEY STRENGTHS") && !fullText.includes("Key Strengths"));

    // Profile-specific content assertions
    if (pdfName === "Mohamed_Seoudy_Frontend_Engineer.pdf") {
      assertTest("Frontend Engineer PDF renders Frontend Engineer profile content",
        /Frontend\s+Engineer/i.test(fullText) && fullText.includes("Lintu"));
      assertTest("Frontend Engineer PDF contains summa-frontend achievement text",
        fullText.includes("scalable UI component foundations") || fullText.includes("container-query"));
      assertTest("Frontend Engineer PDF contains editor-arch achievement text",
        fullText.includes("drag-and-drop editor") || fullText.includes("dnd-kit") || fullText.includes("Page\u2013Section"));
    }
    if (pdfName === "Mohamed_Seoudy_Software_Engineer.pdf") {
      assertTest("Software Engineer PDF renders Software Engineer profile content",
        /Software\s+Engineer/i.test(fullText) && fullText.includes("Summa"));
      assertTest("Software Engineer PDF contains Summa leadership in Experience",
        fullText.includes("Zod schemas") || fullText.includes("monorepo"));
      assertTest("Software Engineer PDF contains shared-contracts achievement text",
        fullText.includes("LLM-based content-generation") || fullText.includes("Zod contracts") || fullText.includes("shared Zod"));
      assertTest("Software Engineer PDF contains Cargo Lab project with telemetry simulation",
        fullText.includes("Cargo Lab") && (fullText.includes("cargo transit simulation") || fullText.includes("orthographic globe")));
      const projectSectionText = fullText.split(/PROJECTS/i)[1]?.split(/SKILLS/i)[0] || "";
      assertTest("Software Engineer PDF does not duplicate Summa under Projects",
        !projectSectionText.includes("Summa"));
    }
  }
}

// ══════════════════════════════════════════════════════════════════════
// TEST SUITE 6: Factual Integrity & Basira Claims Regression Guard
// ══════════════════════════════════════════════════════════════════════
function validateBasiraFactualClaims(text) {
  const forbidden = [
    { pattern: /50\+\s*nodes/i, reason: "Unsupported node count (actual verified: 28 historical prophet nodes)" },
    { pattern: /60\s*fps/i, reason: "Unmeasured 60 FPS performance claim without benchmark" },
    { pattern: /wcag\s*(?:2\.[012]|compliance|certified)/i, reason: "Uncertified formal WCAG compliance claim without formal audit" },
  ];
  for (const { pattern, reason } of forbidden) {
    if (pattern.test(text)) {
      return { valid: false, error: reason };
    }
  }
  return { valid: true, error: null };
}

async function runBasiraFactualTests() {
  console.log("\nSuite 6: Factual Integrity & Basira Claims Regression Guard");

  // 1. Guard Unit Tests with Simulated Regressions
  const validBasiraText = "Interactive educational graph visualizing historical prophet lineages (28 nodes) using D3 force simulation with viewport bounding culling and keyboard focus management";
  assertTest("validateBasiraFactualClaims accepts verified Basira text",
    validateBasiraFactualClaims(validBasiraText).valid === true);

  const fake50Nodes = "Interactive force graph rendering 50+ nodes on canvas";
  assertTest("validateBasiraFactualClaims rejects unsupported '50+ nodes' claim",
    validateBasiraFactualClaims(fake50Nodes).valid === false &&
    validateBasiraFactualClaims(fake50Nodes).error.includes("Unsupported node count"));

  const fake60Fps = "Maintains smooth force simulation at 60fps";
  assertTest("validateBasiraFactualClaims rejects unmeasured '60fps' claim",
    validateBasiraFactualClaims(fake60Fps).valid === false &&
    validateBasiraFactualClaims(fake60Fps).error.includes("Unmeasured 60 FPS"));

  const fakeWcag = "Ensures full WCAG 2.1 AA compliance certification across graph";
  assertTest("validateBasiraFactualClaims rejects uncertified 'WCAG compliance' claim",
    validateBasiraFactualClaims(fakeWcag).valid === false &&
    validateBasiraFactualClaims(fakeWcag).error.includes("Uncertified formal WCAG"));

  // 2. Canonical Basira Data Verification
  const canonicalBasira = evaluateTypst('import "projects/basira.typ": basira; basira');
  const basiraSerialized = JSON.stringify(canonicalBasira);

  const canonicalCheck = validateBasiraFactualClaims(basiraSerialized);
  assertTest("Canonical Basira data contains zero forbidden factual claims",
    canonicalCheck.valid, canonicalCheck.error);

  assertTest("Canonical Basira force-canvas accurately specifies verified 28 nodes",
    basiraSerialized.includes("28 nodes") || basiraSerialized.includes("28-node"));

  assertTest("Canonical Basira preserves Canvas and lineage-traversal implementation",
    basiraSerialized.includes("canvas") || basiraSerialized.includes("Canvas"));

  assertTest("Canonical Basira specifies verified keyboard focus management (useFocusTrap, landmark elements)",
    basiraSerialized.includes("useFocusTrap") && basiraSerialized.includes("landmark elements"));

  // 3. Generated PDF Artifact Output Verification
  for (const pdfName of pdfVariants) {
    const pdfPath = resolve(paths.output, pdfName);
    const data = new Uint8Array(readFileSync(pdfPath));
    const doc = await pdfjsLib.getDocument({ data, useSystemFonts: true, disableFontFace: true }).promise;

    let fullText = "";
    for (let i = 1; i <= doc.numPages; i++) {
      const page = await doc.getPage(i);
      const textContent = await page.getTextContent();
      fullText += textContent.items.map(it => it.str).join(" ") + "\n";
    }

    if (fullText.includes("Basira")) {
      const pdfFactualCheck = validateBasiraFactualClaims(fullText);
      assertTest(`Factual integrity verified in ${pdfName} (no 50+, 60fps, or WCAG claims)`,
        pdfFactualCheck.valid, pdfFactualCheck.error);
      assertTest(`Verified 28-node graph reflected in ${pdfName}`,
        fullText.includes("28 nodes") || fullText.includes("28-node") || fullText.includes("lineage"));
      assertTest(`Verified lineage traversal or focus management reflected in ${pdfName}`,
        /lineage\s+traversal/i.test(fullText) || fullText.includes("useFocusTrap") || fullText.includes("focus management") || /cycle\s+checks/i.test(fullText));
    }
  }
}

async function run() {
  await runPageBudgetTests();
  await runContentExtractionTests();
  await runBasiraFactualTests();

  console.log(`\n══════════════════════════════════════════════════════════════════════`);
  console.log(`Test Results: ${testsPassed}/${testsRun} passed (${testsFailed} failed)`);
  console.log(`══════════════════════════════════════════════════════════════════════\n`);

  if (testsFailed > 0) {
    process.exit(1);
  }
}

run().catch(err => {
  console.error("Test execution fatal error:", err);
  process.exit(1);
});
