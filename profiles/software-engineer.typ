// profiles/software-engineer.typ
//
// Software Engineer Job-Family Profile
//
// Reusable profile defining composition rules, project ordering, skill emphasis,
// and achievement filtering for Software Engineer (TypeScript / Node.js / Full-Stack) roles.
// Does NOT duplicate career data; composes canonical content and project layers.

#import "../content/profile.typ": profile
#import "../content/experience.typ": experience
#import "../content/education.typ": education
#import "../content/languages.typ": languages
#import "../content/skills.typ": skills, get-skill-category
#import "../content/strengths.typ": strengths
#import "../content/career-direction.typ": career-direction
#import "../content/helpers.typ": select-achievements, select-experience

// Import all projects
#import "../projects/summa.typ": summa
#import "../projects/oqel.typ": oqel
#import "../projects/modra.typ": modra
#import "../projects/lintu.typ": lintu
#import "../projects/deskby.typ": deskby
#import "../projects/basira.typ": basira
#import "../projects/cargolab.typ": cargolab

// Base Software Engineer Profile Definition
#let software-engineer-profile-info = (
  title: "Software Engineer",
  tagline: "Software Engineer | TypeScript • Node.js • React | APIs & Application Architecture",
  summary: career-direction.targeted_summaries.software_engineer,
)

// Default Software Engineer Experience Selection (explicit canonical IDs emphasizing architecture, contracts, testing)
#let default-se-experience = (
  select-experience(
    experience.at(0),
    role: "Founder & Software Engineer",
    ids: ("summa-leadership", "summa-testing", "summa-frontend"),
    limit: 3,
  ),
  select-experience(
    experience.at(1),
    ids: ("lintu-stewardship", "lintu-loading", "lintu-standards"),
    limit: 3,
  ),
  select-experience(
    experience.at(2),
    ids: ("mvp-prototyping", "csv-parsing"),
    limit: 2,
  ),
)

// Default Software Engineer Project Priority Ordering & Explicit ID Selection:
// 1. Oqel, 2. Modra, 3. Lintu, 4. Basira, 5. Deskby, 6. Cargo Lab
#let default-se-projects = (
  select-achievements(oqel, ids: ("fastify-backend", "two-stage-grounding"), limit: 2),
  select-achievements(modra, ids: ("shared-contracts", "document-persistence"), limit: 2),
  select-achievements(lintu, ids: ("editor-arch", "composite-chart"), limit: 2),
  select-achievements(basira, ids: ("force-canvas", "lineage-traversal"), limit: 2),
  select-achievements(deskby, ids: ("widget-registry", "dom-reparenting"), limit: 2),
  select-achievements(cargolab, ids: ("globe-projection", "vessel-telemetry"), limit: 2),
)

// Default Software Engineer Skills Reorganization: Languages, Backend, Contracts, Server State, Frontend, Client State, Engineering
#let default-se-skills(label-overrides: (:)) = (
  get-skill-category("Languages"),
  get-skill-category("Backend & Data", label: label-overrides.at("Backend & Data", default: "Backend & Data")),
  get-skill-category("State, Data Fetching & Validation", label: label-overrides.at("State, Data Fetching & Validation", default: "State, Data & Validation")),
  get-skill-category("Frontend", items: ("React", "Next.js", "SolidJS", "TanStack Start", "TanStack Router")),
  get-skill-category("Testing & Tooling", label: label-overrides.at("Testing & Tooling", default: "Testing & Tooling")),
  get-skill-category("Engineering Practices", label: label-overrides.at("Engineering Practices", default: "Engineering Practices"), items: ("Component Architecture", "Server-Driven UI", "Performance Optimization", "Monorepos", "Algorithms", "Web Accessibility")),
  get-skill-category("AI & LLM Integration", label: label-overrides.at("AI & LLM Integration", default: "AI Integration")),
  get-skill-category("Data Visualization"),
  get-skill-category("Styling & UI", items: ("Design Systems", "Tailwind CSS", "shadcn/ui", "CSS Modules", "Responsive Design")),
)

// Profile Composer
#let compose-software-engineer(
  layout: "classic",
  profile-overrides: (:),
  experience-overrides: none,
  projects-overrides: none,
  skills-overrides: none,
  skills-label-overrides: (:),
  include-strengths: false,
  max-project-achievements: 2,
) = {
  (
    layout: layout,
    profile: (:
      ..profile,
      ..software-engineer-profile-info,
      ..profile-overrides,
    ),
    experience: if experience-overrides != none { experience-overrides } else { default-se-experience },
    projects: if projects-overrides != none { projects-overrides } else { default-se-projects },
    skills: if skills-overrides != none { skills-overrides } else { default-se-skills(label-overrides: skills-label-overrides) },
    strengths: if include-strengths { strengths } else { () },
    education: education,
    languages: languages,
    max_project_achievements: max-project-achievements,
  )
}
