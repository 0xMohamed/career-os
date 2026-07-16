// projects/oqel.typ
//
// Oqel — AI-powered visual perception analysis system.
//
// This file describes what Oqel IS, not how to present it on a resume.

#let oqel = (
  title:      "Oqel",
  role:       "Founding Engineer",
  company:    "Oqel",
  type:       "Product",
  status:     "Active",
  period:     "2024 — Present",
  team_size:  "Solo",

  summary: "An AI-powered visual perception analysis system that evaluates outfit images and generates structured styling reports. Oqel does not score beauty — it analyzes presence: posture, grooming, clothing coordination, silhouette structure, and color relationships that form first impressions in specific social contexts.",

  technologies: (
    "React", "TypeScript", "TanStack Start", "Fastify",
    "Prisma", "Google Gemini", "Zod", "pnpm Monorepo",
  ),

  achievements: (
    "Designed the full reasoning pipeline: image input → structured LLM output (Gemini 2.5 Flash) → Zod schema validation → narrative adapter → interactive client canvas (MirrorCanvas).",
    "Built the ReasoningGraphSchema in Zod — a strict, self-validating contract between the AI model and the client that prevents malformed outputs from reaching the UI.",
    "Implemented percentage-positioned bounding boxes for grounded evidence: every AI observation is anchored to a physical coordinate on the user's photo.",
    "Built SVG connector paths that visually link related garments (e.g. torso fit to footwear balance) directly on the image — making reasoning relationships visible.",
    "Designed the prose-as-UI pattern: AI writes natural English, the interface layers interactivity via subtle underlines instead of boxy token fragments.",
    "Wrote comprehensive test suites for Zod schemas, narrative compilers, validator logic, and the full reasoning pipeline.",
  ),

  tags: ("ai", "computer-vision", "reasoning", "product", "fullstack"),

  links: (),
)
