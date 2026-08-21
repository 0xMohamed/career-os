// projects/oqel.typ
//
// Oqel — AI-powered personal presence analyzer.
//
// This file describes what Oqel IS, not how to present it on a resume.

#let oqel = (
  title:      "Oqel",
  role:       "Founding Engineer",
  company:    "Oqel",
  type:       "Product",
  status:     "Completed",
  period:     "2026",
  team_size:  "Solo",

  summary:    "AI-driven personal presence and visual style analyzer.",

  technologies: (
    "React", "TypeScript", "TanStack Start", "React Query",
    "Fastify", "Neon PostgreSQL", "Cloudflare R2", "Google Gemini",
    "Zod",
  ),

  achievements: (
    "Built multimodal AI pipelines leveraging Google Gemini 2.5 Flash and Zod schemas for deterministic structured outputs.",
    "Developed an interactive canvas dashboard with real-time feedback and structured report generation.",
    "Designed the validation reasoning engine and narrative adapter compilers connecting frontend to Fastify backend.",
  ),

  tags: ("ai", "computer-vision", "reasoning", "product", "fullstack"),

  links: (
    live: "oqel.vercel.app/",
  ),
)
