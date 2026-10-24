/**
 * config.js — Career OS Tooling Configuration & Generic Discovery
 *
 * Single source of truth for paths, conventions, and dynamic filesystem
 * discovery of applications, projects, and templates.
 *
 * Adding a new application or project requires ZERO changes to this file.
 */

import { existsSync, readdirSync, readFileSync } from "fs";
import { resolve, dirname, basename } from "path";
import { fileURLToPath } from "url";

const __dirname = dirname(fileURLToPath(import.meta.url));
export const root = resolve(__dirname, "..");

export const paths = {
  root,
  content: resolve(root, "content"),
  projects: resolve(root, "projects"),
  applications: resolve(root, "applications"),
  templates: resolve(root, "templates"),
  profiles: resolve(root, "profiles"),
  output: resolve(root, "output"),
};

// Core candidate single source of truth files (universal)
export const CORE_CONTENT_FILES = [
  "content/profile.typ",
  "content/experience.typ",
  "content/education.typ",
  "content/languages.typ",
  "content/skills.typ",
  "content/strengths.typ",
  "content/career-direction.typ",
  "content/helpers.typ",
];

// Core reusable job-family profiles
export const CORE_PROFILE_FILES = [
  "profiles/frontend.typ",
  "profiles/software-engineer.typ",
];

// Core presentation templates & layouts
export const CORE_TEMPLATE_FILES = [
  "templates/resume.typ",
  "templates/theme.typ",
  "templates/layouts/editorial.typ",
  "templates/layouts/standard.typ",
  "templates/layouts/classic.typ",
];

export const LAYOUT_ALIASES = {
  "editorial": "editorial",
  "two-column": "editorial",
  "standard": "standard",
  "single-column": "standard",
  "one-column": "standard",
  "single": "standard",
  "classic": "classic",
  "traditional": "classic",
  "conservative": "classic",
  "minimal": "classic",
};

export function normalizeLayout(raw) {
  if (!raw) return "classic";
  return LAYOUT_ALIASES[raw.toLowerCase()] || raw;
}

export const MAX_PAGE_BUDGET = 2;

/**
 * Deterministic page-budget validation guard.
 * Validates that an artifact's page count does not exceed the allowed budget.
 *
 * @param {number} pageCount - The actual number of pages extracted from the PDF.
 * @param {string} [artifactName="Artifact"] - Name of the artifact for diagnostic reporting.
 * @param {number} [maxBudget=MAX_PAGE_BUDGET] - Maximum allowed pages (default: 2).
 * @returns {{ valid: boolean, pageCount: number, maxBudget: number, error: string | null }}
 */
export function validatePageBudget(pageCount, artifactName = "Artifact", maxBudget = MAX_PAGE_BUDGET) {
  if (typeof pageCount !== "number" || isNaN(pageCount) || pageCount < 1 || !Number.isInteger(pageCount)) {
    return {
      valid: false,
      pageCount,
      maxBudget,
      error: `Invalid page count for ${artifactName}: received ${pageCount} (must be a positive integer)`,
    };
  }

  if (pageCount > maxBudget) {
    return {
      valid: false,
      pageCount,
      maxBudget,
      error: `Page budget exceeded for ${artifactName}: got ${pageCount} pages (maximum allowed: ${maxBudget})`,
    };
  }

  return {
    valid: true,
    pageCount,
    maxBudget,
    error: null,
  };
}

/**
 * Retrieve phone number override if configured.
 * 1. Environment variable CAREER_PHONE or PHONE (primary)
 * 2. Optional local untracked private.json (secondary)
 */
export function getPhoneInput() {
  if (process.env.CAREER_PHONE) return process.env.CAREER_PHONE;
  if (process.env.PHONE) return process.env.PHONE;

  const privateJsonPath = resolve(root, "private.json");
  if (existsSync(privateJsonPath)) {
    try {
      const data = JSON.parse(readFileSync(privateJsonPath, "utf8"));
      if (data.phone) return data.phone;
    } catch {}
  }

  return null;
}

/**
 * Dynamically discover all projects in projects/*.typ
 */
export function discoverProjects() {
  if (!existsSync(paths.projects)) return [];
  return readdirSync(paths.projects)
    .filter(file => file.endsWith(".typ"))
    .map(file => ({
      id: basename(file, ".typ"),
      file: `projects/${file}`,
      path: resolve(paths.projects, file),
    }));
}

/**
 * Dynamically discover all job-family profiles in profiles/*.typ
 */
export function discoverProfiles() {
  if (!existsSync(paths.profiles)) return [];
  return readdirSync(paths.profiles)
    .filter(file => file.endsWith(".typ"))
    .map(file => ({
      id: basename(file, ".typ"),
      file: `profiles/${file}`,
      path: resolve(paths.profiles, file),
    }));
}

// Canonical production targets and their output filenames
export const PRODUCTION_TARGETS = [
  {
    id: "frontend-engineer",
    aliases: ["frontend", "fe", "frontend-engineer", "Mohamed_Seoudy_Frontend_Engineer"],
    file: "applications/frontend-engineer.typ",
    outName: "Mohamed_Seoudy_Frontend_Engineer.pdf",
    layout: "classic",
    title: "Frontend Engineer",
  },
  {
    id: "software-engineer",
    aliases: ["software", "se", "swe", "software-engineer", "Mohamed_Seoudy_Software_Engineer"],
    file: "applications/software-engineer.typ",
    outName: "Mohamed_Seoudy_Software_Engineer.pdf",
    layout: "classic",
    title: "Software Engineer",
  },
];

/**
 * Dynamically discover all applications in applications/*.typ
 * Inspects each application file to extract declared layout and conventions.
 */
export function discoverApplications() {
  if (!existsSync(paths.applications)) return [];

  const files = readdirSync(paths.applications).filter(file => file.endsWith(".typ"));

  return files.map(file => {
    const id = basename(file, ".typ");
    const filePath = resolve(paths.applications, file);
    const content = readFileSync(filePath, "utf8");

    // Detect declared layout in file: e.g. layout: "classic" or resume-template(app, layout: "classic")
    const layoutMatch = content.match(/layout:\s*"([a-zA-Z0-9_-]+)"/);
    const detectedLayout = layoutMatch ? normalizeLayout(layoutMatch[1]) : "classic";

    // Convention-driven output name:
    let defaultOutName = `${id}.pdf`;
    const prodTarget = PRODUCTION_TARGETS.find(t => t.id === id);
    if (prodTarget) {
      defaultOutName = prodTarget.outName;
    } else if (id === "master") {
      defaultOutName = "resume.pdf";
    } else if (id.startsWith("resume-")) {
      defaultOutName = `${id}.pdf`;
    } else {
      defaultOutName = `resume-${id}.pdf`;
    }

    return {
      id,
      file: `applications/${file}`,
      path: filePath,
      detectedLayout,
      defaultOutName,
    };
  });
}

/**
 * Resolve a specific application by name or alias
 */
export function getApplication(query) {
  const apps = discoverApplications();
  if (!query) {
    return apps.find(a => a.id === "frontend-engineer") || apps[0] || null;
  }

  const clean = query.replace(/\.typ$/, "").replace(/\.pdf$/, "");
  const normalized = clean.startsWith("resume-") && clean !== "resume" ? clean.replace(/^resume-/, "") : clean;

  const prodMatch = PRODUCTION_TARGETS.find(
    t => t.id === clean || t.aliases.includes(clean) || t.aliases.includes(normalized) || t.outName === `${clean}.pdf`
  );
  if (prodMatch) {
    const found = apps.find(a => a.id === prodMatch.id);
    if (found) return found;
  }

  return apps.find(a => a.id === clean || a.id === normalized || a.defaultOutName === `${clean}.pdf`) || null;
}

/**
 * Generate build jobs dynamically based on targets and layout arguments.
 * Default build or 'all' generates the primary canonical role-based resumes.
 */
export function getBuildJobs(firstArg, secondArg) {
  const apps = discoverApplications();

  // Default build or 'all' generates canonical production role-based resumes
  if (!firstArg || firstArg === "all") {
    const jobs = [];
    for (const target of PRODUCTION_TARGETS) {
      const app = apps.find(a => a.id === target.id);
      if (app) {
        jobs.push({
          app: app.id,
          layout: app.detectedLayout || target.layout,
          outName: target.outName,
        });
      }
    }
    if (jobs.length > 0) return jobs;
  }

  const targetApp = getApplication(firstArg);
  if (!targetApp) {
    throw new Error(`Application file not found: applications/${firstArg}.typ`);
  }

  const requestedLayout = secondArg ? normalizeLayout(secondArg) : null;
  const layout = requestedLayout || targetApp.detectedLayout;

  let outName = targetApp.defaultOutName;
  if (targetApp.id === "master") {
    if (layout === "editorial") outName = "resume.pdf";
    else if (layout === "standard") outName = "single.pdf";
    else if (layout === "classic") outName = "classic.pdf";
    else outName = `resume-${layout}.pdf`;
  } else if (requestedLayout && requestedLayout !== targetApp.detectedLayout) {
    outName = `${targetApp.defaultOutName.replace(/\.pdf$/, "")}-${layout}.pdf`;
  }

  return [{
    app: targetApp.id,
    layout,
    outName,
  }];
}
