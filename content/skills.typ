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
    category: "Frontend",
    items: ("React", "TypeScript", "JavaScript", "TanStack Start", "TanStack Router", "Redux Toolkit", "React Query", "Jotai", "React Hook Form"),
  ),
  (
    category: "UI Engineering",
    items: ("Design Systems", "Component Libraries", "Tailwind CSS", "dnd-kit", "Lexical", "Performance Optimization", "Accessibility"),
  ),
  (
    category: "Validation & Data",
    items: ("Zod", "Redux Entity Adapter", "D3.js", "Visx", "Canvas API", "SVG", "Mapbox GL"),
  ),
  (
    category: "Backend & AI",
    items: ("Node.js", "Fastify", "Express", "Prisma", "Neon PostgreSQL", "Cloudflare R2", "OpenRouter", "LLM Integration"),
  ),
)
