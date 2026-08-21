// projects/modra.typ
//
// Modra — AI-powered presentation platform.
//
// This file describes what Modra IS, not how to present it on a resume.

#let modra = (
  title:      "Modra",
  role:       "Founding Engineer",
  company:    "Modra",
  type:       "Product",
  status:     "Completed",
  period:     "2026",
  team_size:  "Solo",

  summary:    "AI-powered presentation platform with modular canvas editing.",

  technologies: (
    "React", "TypeScript", "TanStack Router", "Zustand",
    "TipTap", "Zod", "Express", "Prisma",
  ),

  achievements: (
    "Engineered a modular visual slide editor with customizable block layouts and shared TypeScript contracts (@modra/ai-contracts).",
    "Implemented reactive AI image hydration workflows utilizing transient pending states for asynchronous generation.",
    "Built reusable presentation templates and optimized canvas rendering performance.",
  ),

  tags: ("ai", "data-visualization", "product", "frontend", "monorepo"),

  links: (
    live: "usemodra.xyz",
  ),
)
