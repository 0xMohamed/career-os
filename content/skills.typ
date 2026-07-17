// content/skills.typ
//
// Skills — the single source of truth for technical skills.
// No layout, no rendering. Only structured data.
//
// Every skill listed here is backed by real project experience.
// Applications may choose which categories or skills to surface,
// while templates remain completely presentation-agnostic.

#let skills = (
  (
    category: "Languages",
    items: (
      "TypeScript",
      "JavaScript",
      "HTML",
      "CSS",
      "Python",
    ),
  ),

  (
    category: "Frontend",
    items: (
      "React",
      "Next.js",
      "TanStack Start",
      "TanStack Router",
      "React Router",
      "React Hook Form",
      "Vite",
    ),
  ),

  (
    category: "State Management",
    items: (
      "Redux Toolkit",
      "Zustand",
      "Jotai",
      "TanStack Query",
      "Zod",
    ),
  ),

  (
    category: "Styling",
    items: (
      "Tailwind CSS",
      "Design Systems",
      "Design Tokens",
      "Responsive UI",
    ),
  ),

  (
    category: "Data Visualization",
    items: (
      "Canvas",
      "SVG",
      "D3.js",
      "VISX",
      "Mapbox GL",
      "Three.js",
    ),
  ),

  (
    category: "Backend",
    items: (
      "Node.js",
      "Express",
      "Fastify",
      "Prisma",
      "PostgreSQL",
      "REST APIs",
    ),
  ),

  (
    category: "AI",
    items: (
      "LLM Integration",
      "Prompt Engineering",
      "Structured Outputs",
      "AI Workflows",
      "Multi-modal AI",
    ),
  ),

  (
    category: "Engineering",
    items: (
      "Component Architecture",
      "Design Systems",
      "State Management",
      "Performance Optimization",
      "Accessibility",
    ),
  ),

  (
    category: "Tooling",
    items: (
      "Git",
      "pnpm",
      "ESLint",
      "Prettier",
      "Vitest",
      "Storybook",
      "Turborepo",
    ),
  ),
)