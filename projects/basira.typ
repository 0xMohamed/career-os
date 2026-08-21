// projects/basira.typ
//
// Basira (Prophet Graph) — interactive historical lineage visualization.
//
// This file describes what Basira IS, not how to present it on a resume.

#let basira = (
  title:       "Basira",
  role:        "Creator & Engineer",
  company:     "Basira",
  type:        "Open Source / Exploration",
  status:      "Completed",
  period:      "2026",
  team_size:   "Solo",

  summary:     "Interactive force-directed historical graph visualization.",

  technologies: (
    "React", "TypeScript", "TanStack Start", "TanStack Router",
    "D3.js", "D3 Force", "Canvas", "Tailwind CSS",
  ),

  achievements: (
    "Engineered force-directed graph simulations using D3.js, bypassing Virtual DOM bottlenecks to maintain strict 60 FPS rendering.",
    "Implemented mathematical viewport culling and WCAG-compliant keyboard navigation and focus management.",
    "Built immersive exploratory lineages with responsive zoom/pan canvas viewports.",
  ),

  tags: ("data-visualization", "performance", "accessibility", "open-source", "frontend"),

  links: (
    live: "basira-graph.vercel.app",
  ),
)
