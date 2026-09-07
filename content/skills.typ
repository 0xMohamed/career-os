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
      "HTML5",
      "CSS3",
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
    category: "Styling & UI",
    items: (
      "Tailwind CSS",
      "CSS Modules",
      "Design Systems",
      "Design Tokens",
      "Responsive Design",
    ),
  ),

  (
    category: "Data Visualization",
    items: (
      "D3.js",
      "Visx",
      "Canvas API",
      "SVG",
      "Mapbox GL",
      "Three.js",
    ),
  ),

  (
    category: "Backend",
    items: (
      "Node.js",
      "Fastify",
      "Express",
      "PostgreSQL",
      "Prisma",
      "REST APIs",
    ),
  ),

  (
    category: "AI & LLM Integration",
    items: (
      "LLM Integration",
      "Prompt Engineering",
      "Structured Outputs",
      "AI Workflows",
      "Multimodal AI",
    ),
  ),

  (
    category: "Engineering Practices",
    items: (
      "Component Architecture",
      "Performance Optimization",
      "Accessibility (WCAG)",
      "Monorepos",
      "Cross-Browser Compatibility",
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

// Helper function to extract, reorder, or customize skill categories in applications
#let get-skill-category(name, items: none, label: none) = {
  let found = skills.find(s => s.category == name)
  if found == none {
    (category: if label != none { label } else { name }, items: if items != none { items } else { () })
  } else {
    (
      category: if label != none { label } else { found.category },
      items: if items != none { items } else { found.items },
    )
  }
}