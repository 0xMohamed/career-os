// content/skills.typ
//
// Skills — the single source of truth for technical skills.
// No layout, no rendering. Only structured data.
//
// Every skill listed in the active categories below is backed by verified
// implementation artifacts across local repositories (Summa, Lintu, Modra,
// Oqel, Basira, Deskby, Cargo Lab).
//
// Emerging and transition skills are explicitly designated as such and
// tracked in content/career-direction.typ.
//
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
      "Python", // Emerging / active engineering transition (see career-direction.typ)
    ),
  ),

  (
    category: "Frontend",
    items: (
      "React",
      "Next.js",
      "Astro",
      "SolidJS",
      "TanStack Start",
      "TanStack Router",
      "React Router",
      "React Hook Form",
      "dnd-kit",
      "Lexical",
    ),
  ),

  (
    category: "State, Data Fetching & Validation",
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
      "shadcn/ui",
      "CSS Modules",
      "Design Systems",
      "Responsive Design",
    ),
  ),

  (
    category: "Data Visualization",
    items: (
      "D3.js",
      "Visx",
      "p5.js",
      "Canvas API",
      "SVG",
      "Mapbox GL",
      "Three.js",
    ),
  ),

  (
    category: "Backend & Data",
    items: (
      "Node.js",
      "Hono",
      "Fastify",
      "Express",
      "REST APIs",
      "SQL",
      "PostgreSQL",
      "Prisma",
    ),
  ),

  (
    category: "AI & LLM Integration",
    items: (
      "Structured Outputs",
      "Multimodal AI",
      "AI Workflows",
      "LLM Integration", // Emerging transition focus (see career-direction.typ)
      "Prompt Engineering", // Emerging transition focus (see career-direction.typ)
    ),
  ),

  (
    category: "Architecture & Engineering",
    items: (
      "Component Architecture",
      "Server-Driven UI",
      "Performance Optimization",
      "Web Accessibility",
      "Monorepos",
      "Algorithms",
      "Cross-Browser Compatibility",
    ),
  ),

  (
    category: "Testing & Tooling",
    items: (
      "Vitest",
      "Playwright",
      "Storybook",
      "Vite",
      "Turborepo",
      "pnpm Workspaces",
      "GitHub Actions",
      "Docker",
    ),
  ),
)

// Helper function to extract, reorder, or customize skill categories in applications
#let get-skill-category(name, items: none, label: none) = {
  let aliases = (
    "Backend": "Backend & Data",
    "Tooling": "Testing & Tooling",
    "Testing": "Testing & Tooling",
    "Engineering": "Architecture & Engineering",
    "Engineering Practices": "Architecture & Engineering",
    "Architecture": "Architecture & Engineering",
    "State Management": "State, Data Fetching & Validation",
    "Server State & Data Fetching": "State, Data Fetching & Validation",
    "State & Data Architecture": "State, Data Fetching & Validation",
  )
  let target = aliases.at(name, default: name)
  let found = skills.find(s => s.category == target or s.category == name)
  if found == none {
    (category: if label != none { label } else { name }, items: if items != none { items } else { () })
  } else {
    (
      category: if label != none { label } else { found.category },
      items: if items != none { items } else { found.items },
    )
  }
}

// Canonical verified skills referenced in achievement evidence and architecture,
// but not surfaced as standalone category chips on resumes.
#let additional-skills = (
  "Immer",
)