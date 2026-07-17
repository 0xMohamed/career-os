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

  summary:    "AI-powered presentation platform.",

  technologies: (
    "React", "TypeScript", "TanStack Router", "Zustand",
    "TipTap", "Zod", "Express", "Prisma",
  ),

  achievements: (
    "Built a modular visual editor with customizable presentation blocks.",
    "Designed shared contracts and AI-assisted creation workflows.",
    "Implemented reusable presentation templates and optimized rendering performance.",
    "Designed a shared contracts package (@modra/ai-contracts) enforcing type safety between modules.",
    "Implemented a reactive AI image hydration system utilizing transient pending states.",
  ),

  tags: ("ai", "data-visualization", "product", "frontend", "monorepo"),

  links: (
    live: "usemodra.xyz",
  ),
)
