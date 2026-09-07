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
  if (!raw) return "editorial";
  return LAYOUT_ALIASES[raw.toLowerCase()] || raw;
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
    const detectedLayout = layoutMatch ? normalizeLayout(layoutMatch[1]) : "editorial";

    // Convention-driven output name:
    // master defaults to resume.pdf (plus multi-layout variants)
    // custom apps: resume-<id>.pdf (or <id>.pdf if already prefixed with resume-)
    let defaultOutName = `${id}.pdf`;
    if (id === "master") {
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
  if (!query) return apps.find(a => a.id === "master") || null;

  const clean = query.replace(/\.typ$/, "").replace(/\.pdf$/, "");
  const normalized = clean.startsWith("resume-") && clean !== "resume" ? clean.replace(/^resume-/, "") : clean;

  return apps.find(a => a.id === clean || a.id === normalized || a.defaultOutName === `${clean}.pdf`) || null;
}

/**
 * Generate build jobs dynamically based on targets and layout arguments.
 * No application names are hardcoded.
 */
export function getBuildJobs(firstArg, secondArg) {
  const apps = discoverApplications();

  if (firstArg === "all") {
    const jobs = [];
    for (const app of apps) {
      if (app.id === "master") {
        jobs.push({ app: "master", layout: "editorial", outName: "resume.pdf" });
        jobs.push({ app: "master", layout: "standard",  outName: "single.pdf" });
        jobs.push({ app: "master", layout: "classic",   outName: "classic.pdf" });
      } else {
        jobs.push({
          app: app.id,
          layout: app.detectedLayout,
          outName: app.defaultOutName,
        });
      }
    }
    return jobs;
  }

  const targetApp = getApplication(firstArg || "master");
  if (!targetApp) {
    const requested = firstArg || "master";
    throw new Error(`Application file not found: applications/${requested}.typ`);
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
