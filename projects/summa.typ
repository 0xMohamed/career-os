// projects/summa.typ
//
// Summa — headless document engine and multi-application visual storytelling platform.
//
// Current status: Under active development (pre-launch).
// All achievements represent verified engineering architecture and test implementations.

#let summa = (
  title:      "Summa",
  role:       "Founder & Product Engineer",
  company:    "Summa",
  type:       "Product / Platform",
  status:     "In Development",
  period:     "2026 — Present",
  team_size:  "Solo",

  summary:    "Modular headless document engine and visual storytelling platform (in active development).",

  technologies: (
    "TypeScript", "React", "TanStack Start", "Turborepo",
    "Node.js", "Hono", "PostgreSQL", "Drizzle ORM",
    "Docker", "Vitest", "Playwright", "Tailwind CSS", "Zod", "shadcn/ui",
  ),

  achievements: (
    (
      id: "document-engine",
      statement: "Architected a headless Document Engine across an 11-package Turborepo monorepo, enforcing deterministic mutations via command-driven domain aggregates and shared TypeScript contracts.",
      method: "Implemented Domain-Driven Design bounded contexts decoupling administrative Project metadata from Document composition, validated by Zod contracts.",
      outcome: "Established clean package separation between authoring Studio editor workflows, headless API services, and a Server-Driven UI document runtime for public SSR Viewer presentation.",
      metric: "11 monorepo packages across apps/ and packages/",
      evidence: "packages/domain/DOMAIN_MODEL.md, docs/architecture/platform-architecture.md & packages/render/src/node-renderer.tsx",
      skills: ("TypeScript", "Server-Driven UI", "Component Architecture", "Monorepos", "Turborepo", "Zod", "React", "Hono"),
      tags: ("architecture", "contracts", "backend", "monorepo"),
    ),
    (
      id: "testing-automation",
      statement: "Implemented a multi-tier test architecture comprising 81 Vitest test suites and 3 Playwright end-to-end Critical User Journeys (CUJs) across Studio and Viewer applications.",
      method: "Authored isolated unit test suites for layout math and schema validators alongside browser-level integration tests covering canvas hydration and sticky storytelling.",
      outcome: "Established automated regression coverage across document engine commands, layout recalculations, and server-side rendering pipelines.",
      metric: "81 Vitest test suites, 3 Playwright CUJs",
      evidence: "summa/docs/architecture/TESTING_CONVENTIONS.md & e2e/*.spec.ts",
      skills: ("Vitest", "Playwright", "TypeScript", "Engineering Practices"),
      tags: ("testing", "engineering-practices", "quality", "fullstack"),
    ),
    (
      id: "layout-engine",
      statement: "Engineered a Track-and-Band layout engine and modular UI workspace utilizing React, TypeScript, CSS Container Queries, and shadcn/ui accessible primitives.",
      method: "Implemented layout calculations using CSS Container Queries (cqi), an event-driven Trigger-to-Reaction pipeline, and composed shadcn/ui dock panels.",
      outcome: "Enabled responsive multi-column canvas reflow and unified spatial interaction models across authoring and viewer runtimes.",
      metric: "Container-query based geometry reflow with shadcn/ui primitives",
      evidence: "summa/docs/architecture/layout-engine.md & runtime-graph.md",
      skills: ("React", "TypeScript", "Tailwind CSS", "shadcn/ui", "Design Systems", "Component Architecture"),
      tags: ("frontend", "ui", "editor"),
    ),
  ),

  tags: ("editor", "monorepo", "architecture", "data-visualization", "fullstack"),

  links: (
    live: "summa.cyou",
  ),
)
