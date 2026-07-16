// content/skills.typ
//
// Skills — the single source of truth for technical skills.
// No layout, no rendering. Only structured data.
//
// Organized into logical categories. Every skill here is backed by
// real project work — nothing is listed speculatively.
//
// Applications consume this file and may subset or reorder categories.
// Templates render whatever the application passes in.

#let skills = (
  (
    category: "Languages",
    items: ("TypeScript", "JavaScript", "HTML", "CSS", "Rust"),
  ),
  (
    category: "Frontend",
    items: ("React", "Next.js", "TanStack Router", "TanStack Start", "Vite"),
  ),
  (
    category: "Data Visualization",
    items: ("D3.js", "WebGL", "Three.js", "Custom GLSL Shaders", "Force Layouts"),
  ),
  (
    category: "State & Data",
    items: ("Zustand", "Jotai", "TanStack Query", "Zod", "Prisma"),
  ),
  (
    category: "Styling",
    items: ("Tailwind CSS", "CSS Modules", "Design Tokens", "Custom Design Systems"),
  ),
  (
    category: "Backend",
    items: ("Fastify", "Node.js", "PostgreSQL", "REST", "pnpm Monorepo"),
  ),
  (
    category: "AI",
    items: ("Google Gemini", "Structured LLM Output", "Reasoning Pipelines", "AI Contracts"),
  ),
  (
    category: "Tooling",
    items: ("Git", "pnpm", "ESLint", "Prettier", "Vitest"),
  ),
)
