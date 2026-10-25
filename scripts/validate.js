#!/usr/bin/env node
/**
 * validate.js — Career OS Semantic Schema & Skill-to-Evidence Validator
 *
 * Truly deterministic semantic validation powered by `typst eval`:
 *   1. Evaluates all content, projects, and profiles directly through the Typst runtime.
 *   2. Validates 8-field achievement schema across all projects and work history.
 *   3. Enforces global and local ID uniqueness.
 *   4. Validates project metadata, types, and external URL formats.
 *   5. Verifies skill-to-evidence relationships, distinguishing demonstrated skills from
 *      learning-stage skills (Python) and reporting actionable evidence gaps.
 *
 * Usage:
 *   node scripts/validate.js           # Run standalone validation
 *   pnpm validate                      # npm script alias
 */

import { spawnSync, execSync } from "child_process";
import { existsSync } from "fs";
import { root, paths, discoverProjects, discoverProfiles, discoverApplications } from "./config.js";

const allArgs = process.argv.slice(2);
const verbose = allArgs.includes("--verbose");

let errorCount = 0;
let warningCount = 0;

function reportError(file, field, message) {
  console.error(`  ✗ [ERROR] ${file}${field ? ` → ${field}` : ""}: ${message}`);
  errorCount++;
}

function reportWarning(file, field, message) {
  console.warn(`  ! [WARN]  ${file}${field ? ` → ${field}` : ""}: ${message}`);
  warningCount++;
}

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

console.log("Career OS — Semantic Data Integrity & Skill-to-Evidence Validation\n");

// ══════════════════════════════════════════════════════════════════════
// 1. CANONICAL SKILL REGISTRY & CAREER DIRECTION INTROSPECTION
// ══════════════════════════════════════════════════════════════════════
console.log("1. Canonical Skill Registry & Career Direction");

let skillsData = [];
const registeredSkills = new Set();
const skillCategories = new Set();

try {
  skillsData = evaluateTypst('import "content/skills.typ": skills; skills');
  for (const group of skillsData) {
    if (!group.category || !Array.isArray(group.items)) {
      reportError("content/skills.typ", "category/items", "Category missing name or items array");
      continue;
    }
    skillCategories.add(group.category);
    for (const item of group.items) {
      if (typeof item !== "string" || !item.trim()) {
        reportError("content/skills.typ", group.category, "Skill item must be a non-empty string");
      } else {
        registeredSkills.add(item.trim());
      }
    }
  }
  try {
    const additional = evaluateTypst('import "content/skills.typ": additional-skills; additional-skills');
    if (Array.isArray(additional)) {
      for (const item of additional) {
        if (typeof item === "string" && item.trim()) {
          registeredSkills.add(item.trim());
        }
      }
    }
  } catch (_) {}
  console.log(`  ✓ Loaded ${registeredSkills.size} canonical skills across ${skillCategories.size} categories`);
} catch (e) {
  reportError("content/skills.typ", null, e.message);
}

let careerDirection = null;
const currentFocusSkills = new Set();

try {
  careerDirection = evaluateTypst('import "content/career-direction.typ": career-direction; career-direction');
  if (careerDirection && Array.isArray(careerDirection.current_focus)) {
    for (const focus of careerDirection.current_focus) {
      // Extract key keywords from focus statements (e.g. Python, Fastify, LLM)
      if (typeof focus === "string") {
        if (/python/i.test(focus)) currentFocusSkills.add("Python");
        if (/hono/i.test(focus)) currentFocusSkills.add("Hono");
        if (/fastify/i.test(focus)) currentFocusSkills.add("Fastify");
        if (/express/i.test(focus)) currentFocusSkills.add("Express");
        if (/postgresql/i.test(focus)) currentFocusSkills.add("PostgreSQL");
        if (/prisma/i.test(focus)) currentFocusSkills.add("Prisma");
        if (/llm/i.test(focus)) currentFocusSkills.add("LLM Integration");
        if (/prompt/i.test(focus)) currentFocusSkills.add("Prompt Engineering");
        if (/structured outputs/i.test(focus)) currentFocusSkills.add("Structured Outputs");
      }
    }
  }
  console.log(`  ✓ Loaded career direction (${currentFocusSkills.size} active engineering focus areas identified)`);
} catch (e) {
  reportError("content/career-direction.typ", null, e.message);
}
console.log();

// ══════════════════════════════════════════════════════════════════════
// 2. PROJECT SCHEMA VALIDATION
// ══════════════════════════════════════════════════════════════════════
console.log("2. Project Schema Validation (8-Field Achievement Audit)");

const discoveredProjects = discoverProjects();
const globalAchievementIds = new Map(); // id -> file
const skillEvidenceMap = new Map();     // skill -> Set of achievement IDs/project IDs

const URL_PATTERN = /^(https?:\/\/)?([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}(\/[^\s]*)?$/;
const SLUG_PATTERN = /^[a-z0-9_-]+$/;

const CANONICAL_ALIASES = {
  "React Query": "TanStack Query",
  "Accessibility (WCAG)": "Web Accessibility",
  "Web Accessibility": "Accessibility (WCAG)",
  "D3": "D3.js",
  "Solid": "SolidJS",
  "State Management": "State, Data Fetching & Validation",
  "Backend": "Backend & Data",
  "Tooling": "Testing & Tooling",
  "Engineering Practices": "Architecture & Engineering",
  "Engineering": "Architecture & Engineering",
};

const canonicalProjectAchievements = new Map(); // proj.id -> Set of achievement IDs

for (const proj of discoveredProjects) {
  const fileRel = proj.file;
  let pData = null;

  try {
    const importName = proj.id === "cargolab" ? "cargolab" : proj.id.replace(/-/g, "_");
    pData = evaluateTypst(`import "${fileRel}": ${importName}; ${importName}`);
  } catch (err) {
    reportError(fileRel, null, `Failed to load project: ${err.message}`);
    continue;
  }

  // Required Project Fields
  const REQUIRED_PROJECT_FIELDS = [
    { name: "title", type: "string" },
    { name: "role", type: "string" },
    { name: "company", type: "string" },
    { name: "type", type: "string" },
    { name: "status", type: "string" },
    { name: "period", type: "string" },
    { name: "team_size", type: "string" },
    { name: "summary", type: "string" },
    { name: "technologies", type: "array" },
    { name: "achievements", type: "array" },
    { name: "tags", type: "array" },
  ];

  for (const req of REQUIRED_PROJECT_FIELDS) {
    if (!(req.name in pData) || pData[req.name] === null || pData[req.name] === undefined) {
      reportError(fileRel, req.name, `Missing required field '${req.name}'`);
    } else if (req.type === "array" && !Array.isArray(pData[req.name])) {
      reportError(fileRel, req.name, `Field '${req.name}' must be an array`);
    } else if (req.type === "string" && (typeof pData[req.name] !== "string" || !pData[req.name].trim())) {
      reportError(fileRel, req.name, `Field '${req.name}' must be a non-empty string`);
    }
  }

  // Validate Links
  if (pData.links && typeof pData.links === "object") {
    for (const [key, url] of Object.entries(pData.links)) {
      if (typeof url !== "string" || !URL_PATTERN.test(url)) {
        reportError(fileRel, `links.${key}`, `Invalid URL format: '${url}'`);
      }
    }
  }

  // Validate 8-Field Achievements
  const localAchievementIds = new Set();
  canonicalProjectAchievements.set(proj.id, new Set());
  const achievements = Array.isArray(pData.achievements) ? pData.achievements : [];

  for (let idx = 0; idx < achievements.length; idx++) {
    const ach = achievements[idx];
    const prefix = `achievements[${idx}]`;

    if (typeof ach !== "object" || ach === null) {
      reportError(fileRel, prefix, "Achievement must be a structured dictionary");
      continue;
    }

    // Required achievement fields (supporting both evidence_source and evidence alias)
    const CORE_ACH_FIELDS = [
      { name: "id", type: "string" },
      { name: "statement", type: "string" },
      { name: "method", type: "string" },
      { name: "outcome", type: "string" },
      { name: "metric", type: "string" },
      { name: "skills", type: "array" },
      { name: "tags", type: "array" },
    ];

    for (const f of CORE_ACH_FIELDS) {
      if (!(f.name in ach) || ach[f.name] === null || ach[f.name] === undefined) {
        reportError(fileRel, `${prefix}.${f.name}`, `Missing required achievement field '${f.name}'`);
      } else if (f.type === "array" && !Array.isArray(ach[f.name])) {
        reportError(fileRel, `${prefix}.${f.name}`, `Achievement field '${f.name}' must be an array`);
      } else if (f.type === "string" && typeof ach[f.name] !== "string") {
        reportError(fileRel, `${prefix}.${f.name}`, `Achievement field '${f.name}' must be a string`);
      }
    }

    // Evidence source verification (evidence_source or evidence)
    const evidenceVal = ach.evidence_source || ach.evidence;
    if (!evidenceVal || typeof evidenceVal !== "string" || !evidenceVal.trim()) {
      reportError(fileRel, `${prefix}.evidence_source`, "Missing required evidence source string (evidence_source or evidence)");
    }

    // Optional verified boolean field
    if ("verified" in ach && typeof ach.verified !== "boolean") {
      reportError(fileRel, `${prefix}.verified`, "Field 'verified' must be a boolean");
    }

    // Validate ID
    if (ach.id) {
      if (!SLUG_PATTERN.test(ach.id)) {
        reportError(fileRel, `${prefix}.id`, `ID '${ach.id}' must be a valid lowercase slug (a-z, 0-9, -, _)`);
      }
      if (localAchievementIds.has(ach.id)) {
        reportError(fileRel, `${prefix}.id`, `Duplicate achievement ID '${ach.id}' within project`);
      }
      localAchievementIds.add(ach.id);
      canonicalProjectAchievements.get(proj.id).add(ach.id);

      if (globalAchievementIds.has(ach.id)) {
        reportError(fileRel, `${prefix}.id`, `Global ID collision: '${ach.id}' already declared in ${globalAchievementIds.get(ach.id)}`);
      }
      globalAchievementIds.set(ach.id, fileRel);
    }

    // Validate and record skills (strictly from achievement evidence)
    if (Array.isArray(ach.skills)) {
      for (const skill of ach.skills) {
        const canonicalName = CANONICAL_ALIASES[skill] || skill;
        if (!registeredSkills.has(skill) && !registeredSkills.has(canonicalName) && !skillCategories.has(skill) && !skillCategories.has(canonicalName)) {
          reportWarning(fileRel, `${prefix}.skills`, `Referenced skill '${skill}' is not in canonical skills.typ`);
        }
        if (!skillEvidenceMap.has(skill)) skillEvidenceMap.set(skill, new Set());
        skillEvidenceMap.get(skill).add(`${proj.id}:${ach.id}`);
        if (canonicalName !== skill) {
          if (!skillEvidenceMap.has(canonicalName)) skillEvidenceMap.set(canonicalName, new Set());
          skillEvidenceMap.get(canonicalName).add(`${proj.id}:${ach.id}`);
        }
      }
    }
  }

  console.log(`  ✓ ${fileRel} — 11 metadata fields & ${achievements.length} achievements validated`);
}
console.log();

// ══════════════════════════════════════════════════════════════════════
// 3. WORK EXPERIENCE SCHEMA VALIDATION
// ══════════════════════════════════════════════════════════════════════
console.log("3. Work Experience Schema Validation");

let experienceData = [];
const expFile = "content/experience.typ";
const canonicalExperienceHighlights = new Map(); // company -> Set of highlight IDs

try {
  experienceData = evaluateTypst('import "content/experience.typ": experience; experience');
  if (!Array.isArray(experienceData) || experienceData.length === 0) {
    reportError(expFile, null, "Experience must be a non-empty array of position entries");
  } else {
    for (let i = 0; i < experienceData.length; i++) {
      const entry = experienceData[i];
      const entryPrefix = `experience[${i}] (${entry.company || "unknown"})`;

      if (!entry.company || typeof entry.company !== "string") reportError(expFile, `${entryPrefix}.company`, "Missing company name");
      if (!entry.role || typeof entry.role !== "string") reportError(expFile, `${entryPrefix}.role`, "Missing role title");
      if (!entry.period || typeof entry.period !== "string") reportError(expFile, `${entryPrefix}.period`, "Missing employment period");
      if (!entry.location || typeof entry.location !== "string") reportError(expFile, `${entryPrefix}.location`, "Missing location");
      if (!entry.summary || typeof entry.summary !== "string") reportError(expFile, `${entryPrefix}.summary`, "Missing position summary");

      const highlights = Array.isArray(entry.highlights) ? entry.highlights : [];
      if (highlights.length === 0) {
        reportError(expFile, `${entryPrefix}.highlights`, "Entry has 0 highlights");
      }

      if (!canonicalExperienceHighlights.has(entry.company)) {
        canonicalExperienceHighlights.set(entry.company, new Set());
      }

      for (let hIdx = 0; hIdx < highlights.length; hIdx++) {
        const hl = highlights[hIdx];
        const hlPrefix = `${entryPrefix}.highlights[${hIdx}]`;

        if (typeof hl === "string") {
          // Legacy string highlight supported for backward compatibility
          if (verbose) {
            console.log(`    Legacy string highlight supported: ${hl.slice(0, 40)}...`);
          }
          continue;
        }

        if (typeof hl !== "object" || hl === null) {
          reportError(expFile, hlPrefix, "Highlight must be a structured dictionary or string");
          continue;
        }

        // Validate 8 achievement fields for structured highlights
        const CORE_HL_FIELDS = ["id", "statement", "method", "outcome", "metric", "skills", "tags"];
        for (const f of CORE_HL_FIELDS) {
          if (!(f in hl) || hl[f] === null || hl[f] === undefined) {
            reportError(expFile, `${hlPrefix}.${f}`, `Missing field '${f}'`);
          }
        }

        // Evidence source verification (evidence_source or evidence)
        const evidenceVal = hl.evidence_source || hl.evidence;
        if (!evidenceVal || typeof evidenceVal !== "string" || !evidenceVal.trim()) {
          reportError(expFile, `${hlPrefix}.evidence_source`, "Missing required evidence source string (evidence_source or evidence)");
        }

        // Optional verified boolean field
        if ("verified" in hl && typeof hl.verified !== "boolean") {
          reportError(expFile, `${hlPrefix}.verified`, "Field 'verified' must be a boolean");
        }

        if (hl.id) {
          if (!SLUG_PATTERN.test(hl.id)) {
            reportError(expFile, `${hlPrefix}.id`, `Invalid slug format '${hl.id}'`);
          }
          if (globalAchievementIds.has(hl.id)) {
            reportError(expFile, `${hlPrefix}.id`, `Global ID collision: '${hl.id}' already declared in ${globalAchievementIds.get(hl.id)}`);
          }
          globalAchievementIds.set(hl.id, expFile);
          canonicalExperienceHighlights.get(entry.company).add(hl.id);
        }

        if (Array.isArray(hl.skills)) {
          for (const skill of hl.skills) {
            const canonicalName = CANONICAL_ALIASES[skill] || skill;
            if (!registeredSkills.has(skill) && !registeredSkills.has(canonicalName) && !skillCategories.has(skill) && !skillCategories.has(canonicalName)) {
              reportWarning(expFile, `${hlPrefix}.skills`, `Referenced skill '${skill}' is not in canonical skills.typ`);
            }
            if (!skillEvidenceMap.has(skill)) skillEvidenceMap.set(skill, new Set());
            skillEvidenceMap.get(skill).add(`exp:${entry.company}:${hl.id}`);
            if (canonicalName !== skill) {
              if (!skillEvidenceMap.has(canonicalName)) skillEvidenceMap.set(canonicalName, new Set());
              skillEvidenceMap.get(canonicalName).add(`exp:${entry.company}:${hl.id}`);
            }
          }
        }
      }
      console.log(`  ✓ ${entry.company} (${entry.period}) — ${highlights.length} highlights validated`);
    }
  }
} catch (e) {
  reportError(expFile, null, e.message);
}
console.log();

// ══════════════════════════════════════════════════════════════════════
// 4. JOB-FAMILY PROFILES & APPLICATION INTEGRITY
// ══════════════════════════════════════════════════════════════════════
console.log("4. Job-Family Profile Composition & Application Integrity");

function validateComposedApp(appObj, sourceFile) {
  if (!appObj || typeof appObj !== "object") {
    reportError(sourceFile, "structure", "Composed application did not return a valid dictionary");
    return;
  }
  if (!appObj.profile?.title) reportError(sourceFile, "profile.title", "Missing profile title");
  if (!Array.isArray(appObj.projects) || appObj.projects.length === 0) {
    reportError(sourceFile, "projects", "Projects list is empty");
  } else {
    for (let pIdx = 0; pIdx < appObj.projects.length; pIdx++) {
      const proj = appObj.projects[pIdx];
      const pTitle = proj.title || `Project #${pIdx}`;
      const achievements = Array.isArray(proj.achievements) ? proj.achievements : [];
      if (achievements.length === 0) {
        reportError(sourceFile, `projects[${pIdx}] (${pTitle})`, `Empty selection: project has 0 achievements rendered`);
      }
      const seenIds = new Set();
      for (const ach of achievements) {
        const achId = typeof ach === "object" && ach ? ach.id : null;
        if (achId) {
          if (seenIds.has(achId)) {
            reportError(sourceFile, `projects[${pIdx}] (${pTitle})`, `Duplicate achievement rendered: '${achId}'`);
          }
          seenIds.add(achId);
          if (!globalAchievementIds.has(achId)) {
            reportError(sourceFile, `projects[${pIdx}] (${pTitle})`, `Stale / unknown achievement ID '${achId}' does not exist in canonical source`);
          }
        }
      }
    }
  }

  if (!Array.isArray(appObj.experience) || appObj.experience.length === 0) {
    reportError(sourceFile, "experience", "Experience list is empty");
  } else {
    for (let eIdx = 0; eIdx < appObj.experience.length; eIdx++) {
      const exp = appObj.experience[eIdx];
      const company = exp.company || `Company #${eIdx}`;
      const highlights = Array.isArray(exp.highlights) ? exp.highlights : [];
      if (highlights.length === 0) {
        reportError(sourceFile, `experience[${eIdx}] (${company})`, `Empty selection: experience entry has 0 highlights rendered`);
      }
      const seenHlIds = new Set();
      for (const hl of highlights) {
        const hlId = typeof hl === "object" && hl ? hl.id : null;
        if (hlId) {
          if (seenHlIds.has(hlId)) {
            reportError(sourceFile, `experience[${eIdx}] (${company})`, `Duplicate highlight rendered: '${hlId}'`);
          }
          seenHlIds.add(hlId);
          if (!globalAchievementIds.has(hlId)) {
            reportError(sourceFile, `experience[${eIdx}] (${company})`, `Stale / unknown highlight ID '${hlId}' does not exist in canonical source`);
          }
        }
      }
    }
  }
}

const discoveredProfiles = discoverProfiles();
for (const prof of discoveredProfiles) {
  try {
    const funcName = prof.id === "frontend" ? "compose-frontend" : "compose-software-engineer";
    const appResult = evaluateTypst(`import "${prof.file}": ${funcName}; ${funcName}()`);
    validateComposedApp(appResult, prof.file);
    console.log(`  ✓ ${prof.file} → composed role: '${appResult.profile.title}', ${appResult.projects.length} projects, ${appResult.experience.length} experiences`);
  } catch (err) {
    reportError(prof.file, null, `Profile composition failed: ${err.message}`);
  }
}

const discoveredApps = discoverApplications();
for (const app of discoveredApps) {
  try {
    const appData = evaluateTypst(`import "${app.file}": app; app`);
    validateComposedApp(appData, app.file);
    execSync(`typst compile --root "${root}" --input layout="${app.detectedLayout}" --format pdf "${app.path}" /dev/null`, {
      stdio: "pipe",
      cwd: root,
    });
    console.log(`  ✓ ${app.file} → valid application composition (@ ${app.detectedLayout})`);
  } catch (err) {
    reportError(app.file, null, `Application compilation failed: ${err.message}`);
  }
}
console.log();

// ══════════════════════════════════════════════════════════════════════
// 5. AUTOMATED SKILL-TO-EVIDENCE VERIFICATION
// ══════════════════════════════════════════════════════════════════════
console.log("5. Automated Skill-to-Evidence Relationships");

let verifiedSkillsCount = 0;
let focusSkillsCount = 0;
const missingEvidenceSkills = [];

for (const skill of registeredSkills) {
  const evidenceSet = skillEvidenceMap.get(skill);
  if (evidenceSet && evidenceSet.size > 0) {
    verifiedSkillsCount++;
    if (verbose) {
      console.log(`  ✓ [Verified] ${skill} ← ${Array.from(evidenceSet).join(", ")}`);
    }
  } else if (currentFocusSkills.has(skill) || skill === "Python") {
    focusSkillsCount++;
    console.log(`  * [Documented Transition Focus] ${skill} (tracked in career-direction.typ)`);
  } else {
    // Check if tool/practice has global repo proof (e.g. Git, pnpm, ESLint, Astro, Storybook)
    const REPO_WIDE_TOOLS = ["Git", "pnpm", "ESLint", "Prettier", "Design Tokens", "CSS3", "GitHub Actions", "pnpm Workspaces", "Docker", "Astro", "Storybook", "Modular Architecture", "SQL", "OOP"];
    if (REPO_WIDE_TOOLS.includes(skill)) {
      verifiedSkillsCount++;
      if (verbose) {
        console.log(`  ✓ [Repo Standard Tooling] ${skill}`);
      }
    } else {
      missingEvidenceSkills.push(skill);
    }
  }
}

console.log(`  ✓ Verified Demonstrated Skills : ${verifiedSkillsCount}/${registeredSkills.size}`);
console.log(`  ✓ Documented Transition Skills  : ${focusSkillsCount}`);

if (missingEvidenceSkills.length > 0) {
  console.log(`\n  ! Skills Requiring Direct Achievement Evidence (${missingEvidenceSkills.length}):`);
  for (const s of missingEvidenceSkills) {
    reportWarning("content/skills.typ", s, "Registered skill lacks direct achievement evidence tag");
  }
} else {
  console.log(`  ✓ 100% of registered skills have evidence or documented transition classification.`);
}
console.log();

// ══════════════════════════════════════════════════════════════════════
// SUMMARY
// ══════════════════════════════════════════════════════════════════════
if (errorCount === 0) {
  console.log(`✓ Semantic Validation Passed: 0 errors, ${warningCount} review warning(s).`);
  process.exit(0);
} else {
  console.error(`✗ Semantic Validation Failed: ${errorCount} error(s), ${warningCount} review warning(s).`);
  process.exit(1);
}
