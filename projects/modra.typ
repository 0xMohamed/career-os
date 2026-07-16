// projects/modra.typ
//
// Modra — AI-powered collaborative slide-deck builder.
//
// This file describes what Modra IS, not how to present it on a resume.

#let modra = (
  title:      "Modra",
  role:       "Founding Engineer",
  company:    "Modra",
  type:       "Product",
  status:     "Active",
  period:     "2024 — Present",
  team_size:  "2–4",

  summary: "A collaborative slide-deck builder focused on data visualization. Users create multi-slide presentations containing rich visual blocks — charts, maps, tables, text, images, and AI-generated insights — all driven by uploaded datasets. Documents can be shared publicly, presented in full-screen mode, or exported for review.",

  technologies: (
    "React", "TypeScript", "Next.js", "Zustand",
    "D3.js", "Fastify", "PostgreSQL", "Prisma", "pnpm Monorepo",
  ),

  achievements: (
    "Designed the AI generation pipeline using a shared contracts package (@modra/ai-contracts) that enforces strict type safety between the frontend and backend AI modules.",
    "Built a reactive AI image hydration system — asynchronous image generation with transient pending states so slides render without blocking the user.",
    "Implemented the Modular Typography System eliminating slide content scaling as an ADR-documented architectural decision.",
    "Designed the overlay interaction system: a LIFO stack controlling all open panels (inspectors, command palette, popovers) with ESC behavior and outside-click dismissal.",
    "Built the LIFO overlay stack and command palette (Cmd+K) from zero, with full keyboard navigation and live action search.",
    "Architected the 4-layer slide rendering model (Shell, Base, Renderer, Atomic) that standardizes how every block type is composed and isolated.",
  ),

  tags: ("ai", "data-visualization", "product", "frontend", "monorepo"),

  links: (),
)
