// profiles/frontend.typ
//
// Frontend Engineer Job-Family Profile
//
// Reusable profile defining composition rules, project ordering, skill emphasis,
// and achievement filtering for Frontend Engineer roles.
// Does NOT duplicate career data; composes canonical content and project layers.

#import "../content/profile.typ": profile
#import "../content/experience.typ": experience
#import "../content/education.typ": education
#import "../content/languages.typ": languages
#import "../content/skills.typ": skills, get-skill-category
#import "../content/career-direction.typ": career-direction
#import "../content/helpers.typ": select-achievements, select-experience

// Import all projects
#import "../projects/summa.typ": summa
#import "../projects/lintu.typ": lintu
#import "../projects/basira.typ": basira
#import "../projects/modra.typ": modra
#import "../projects/cargolab.typ": cargolab
#import "../projects/deskby.typ": deskby
#import "../projects/oqel.typ": oqel

// Base Frontend Profile Definition
#let frontend-profile-info = (
  title: "Frontend Engineer",
  tagline: "Frontend Engineer | React • TypeScript • JavaScript | Interactive Web Applications",
  summary: career-direction.targeted_summaries.frontend_engineer,
)

// Default Frontend Experience Selection (explicit canonical IDs)
#let default-frontend-experience = (
  select-experience(experience.at(0), ids: ("summa-leadership", "summa-frontend", "summa-testing"), limit: 3),
  select-experience(experience.at(1), ids: ("lintu-stewardship", "lintu-loading", "lintu-composite-chart"), limit: 3),
  select-experience(experience.at(2), ids: ("mvp-prototyping", "csv-parsing"), limit: 2),
)

// Default Frontend Project Priority Ordering & Explicit ID Selection
// Ordering: 1. Lintu, 2. Modra, 3. Deskby, 4. Basira, 5. Cargo Lab, 6. Oqel
#let default-frontend-projects = (
  select-achievements(lintu, ids: ("editor-arch", "composite-chart"), limit: 2),
  select-achievements(modra, ids: ("shared-contracts", "dual-shells"), limit: 2),
  select-achievements(deskby, ids: ("widget-registry", "dom-reparenting"), limit: 2),
  select-achievements(basira, ids: ("force-canvas", "a11y-seo"), limit: 2),
  select-achievements(cargolab, ids: ("globe-projection", "vessel-telemetry"), limit: 2),
  select-achievements(oqel, ids: ("two-stage-grounding", "coordinate-conversion"), limit: 2),
)

#let default-frontend-skills(label-overrides: (:)) = (
  get-skill-category("Languages"),
  get-skill-category("Frontend"),
  get-skill-category("State, Data Fetching & Validation", label: label-overrides.at("State, Data Fetching & Validation", default: "State, Data & Validation")),
  get-skill-category("Styling & UI", items: ("Tailwind CSS", "shadcn/ui", "CSS Modules", "Design Systems", "Responsive Design")),
  get-skill-category("Data Visualization"),
  get-skill-category("Engineering Practices", label: label-overrides.at("Engineering Practices", default: "Architecture & Engineering"), items: ("Component Architecture", "Server-Driven UI", "Performance Optimization", "Web Accessibility", "Monorepos")),
  get-skill-category("Testing & Tooling", label: label-overrides.at("Testing & Tooling", default: "Tooling & Testing")),
  get-skill-category("Backend & Data", label: label-overrides.at("Backend & Data", default: "Backend")),
  get-skill-category("AI & LLM Integration", label: label-overrides.at("AI & LLM Integration", default: "AI")),
)

// Profile Composer
#let compose-frontend(
  layout: "classic",
  profile-overrides: (:),
  experience-overrides: none,
  projects-overrides: none,
  skills-overrides: none,
  skills-label-overrides: (:),
  max-project-achievements: 2,
) = {
  (
    layout: layout,
    profile: (:
      ..profile,
      ..frontend-profile-info,
      ..profile-overrides,
    ),
    experience: if experience-overrides != none { experience-overrides } else { default-frontend-experience },
    projects: if projects-overrides != none { projects-overrides } else { default-frontend-projects },
    skills: if skills-overrides != none { skills-overrides } else { default-frontend-skills(label-overrides: skills-label-overrides) },
    education: education,
    languages: languages,
    max_project_achievements: max-project-achievements,
  )
}
