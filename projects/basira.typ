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

  summary:     "Interactive historical lineage visualization.",

  technologies: (
    "React", "TypeScript", "TanStack Start", "TanStack Router",
    "D3.js", "D3 Force", "Canvas", "Tailwind CSS",
  ),

  achievements: (
    "Built force-directed visualizations and immersive exploration lineages.",
    "Bypassed Virtual DOM bottlenecks to maintain strict 60 FPS viewport rendering using D3 simulation loops.",
    "Implemented viewport culling to mathematically skip rendering off-screen elements.",
    "Integrated semantic Landmarking and focus traps to ensure WCAG compliant accessibility.",
  ),

  tags: ("data-visualization", "performance", "accessibility", "open-source", "frontend"),

  links: (
    live: "basira-graph.vercel.app",
  ),
)
