// projects/oqel.typ
//
// Oqel — AI-powered personal presence analyzer.
//
// This file describes what Oqel IS, not how to present it on a resume.
// All achievements represent verified implementations from repository code and architecture.

#let oqel = (
  title:      "Oqel",
  role:       "Founding Engineer",
  company:    "Oqel",
  type:       "Product",
  status:     "Completed",
  period:     "2026",
  team_size:  "Solo",

  summary:    "An image-based styling tool that identifies and highlights clothing items in outfit photos.",

  technologies: (
    "React", "TypeScript", "TanStack Start", "React Query",
    "Fastify", "Prisma", "Neon PostgreSQL", "Cloudflare R2", "Google Gemini",
    "Zod",
  ),

  achievements: (
    (
      id: "two-stage-grounding",
      statement: "Built a two-stage image-analysis flow using Google Gemini: identify clothing items in an uploaded photo, then map their coordinates back to the image so the UI can highlight relevant regions.",
      method: "Structured reasoning calls into an initial observation phase generating semantic queries (e.g. 'navy blazer'), followed by a dedicated visual grounding call predicting detection boxes.",
      outcome: "Separated high-level stylistic reasoning from spatial coordinate extraction, avoiding fragile heuristic string matching across visual elements.",
      metric: "Two-stage prompt pipeline (Reasoning -> Visual Grounding)",
      evidence: "oqel/apps/server/src/engine/grounding/geminiProvider.ts & reasoningPipeline.ts",
      skills: ("Multimodal AI", "Structured Outputs", "Fastify", "TypeScript"),
      tags: ("ai", "backend", "contracts", "fullstack"),
    ),
    (
      id: "fastify-backend",
      statement: "Built a Fastify backend handling multipart image uploads, AI orchestration, Cloudflare R2 storage, and daily scan quotas, with Prisma and PostgreSQL for transactional persistence.",
      method: "Structured multipart stream uploads with Sharp WebP image processing, persisting perception reports and audit events in Prisma transactions alongside rate-limiting middleware.",
      outcome: "Decoupled compute-intensive image processing and AI orchestration from client state while guaranteeing transactional data integrity in PostgreSQL.",
      metric: "Fastify REST service with Prisma PostgreSQL transactions and R2 storage",
      evidence: "oqel/apps/server/src/routes/analyze.ts, scans.ts & prisma/schema.prisma",
      skills: ("Fastify", "Prisma", "PostgreSQL", "Node.js", "TypeScript", "REST APIs"),
      tags: ("backend", "contracts", "fullstack", "ai"),
    ),
    (
      id: "coordinate-conversion",
      statement: "Developed coordinate conversion utilities translating normalized [0–1000] detection bounds into percentage-based overlay coordinates, with non-fatal fallbacks to region anchors.",
      method: "Authored conversion algorithms clamping and rounding Gemini integer boxes to client percentage coordinates [x, y, w, h], with error-handling falling back to coarse region anchors.",
      outcome: "Enabled client-side interactive overlays to render reliably even when fine-grained visual localization calls fail or encounter API limits.",
      metric: "Percentage-based spatial coordinates with non-fatal fallback handling",
      evidence: "oqel/apps/server/src/engine/grounding/grounding.ts & geminiProvider.ts",
      skills: ("TypeScript", "Node.js", "Fastify", "Algorithms"),
      tags: ("backend", "algorithms", "ai"),
    ),
    (
      id: "zod-narrative",
      statement: "Enforced runtime payload validation using strict Zod schemas and built a narrative adapter compiler translating graph tuples into structured styling feedback reports.",
      method: "Parsed and validated LLM JSON responses with ReasoningGraphSchema.parse() before compiling evidence, constraints, and recommendations into readable English paragraphs.",
      outcome: "Prevented malformed API payloads from reaching client views and produced structured narrative reports rendered on an interactive TanStack Start canvas.",
      metric: "Runtime schema validation (ReasoningGraphSchema) and narrative report compiler",
      evidence: "oqel/apps/server/src/engine/validator.ts & narrative/buildNarrativeReport.ts",
      skills: ("Zod", "TypeScript", "Fastify", "REST APIs", "React", "TanStack Start", "TanStack Query"),
      tags: ("backend", "contracts", "ai", "fullstack", "frontend"),
    ),
  ),

  tags: ("ai", "computer-vision", "reasoning", "product", "fullstack"),

  links: (
    live: "oqel.vercel.app",
  ),
)
