// projects/cargolab.typ
//
// Cargo Lab — experimental SolidJS cargo tracker and simulation dashboard.
//
// This file describes what Cargo Lab IS, not how to present it on a resume.

#let cargolab = (
  title:       "Cargo Lab",
  role:        "Creator & Engineer",
  company:     "Cargo Lab",
  type:        "Open Source / Exploration",
  status:      "Completed",
  period:      "2025",
  team_size:   "Solo",

  summary:     "Real-time global cargo simulation and interactive tracking dashboard.",

  technologies: (
    "SolidJS", "TypeScript", "Vite", "D3.js",
    "d3-geo", "TopoJSON", "CSS Modules",
  ),

  achievements: (
    "Built an interactive 3D orthographic globe simulation using D3.js and d3-geo tracking real-time vessel trajectories.",
    "Developed an interactive cargo container placement engine with dynamic spatial grid stacking logic.",
    "Engineered modular D3 charting components styled via theme-aware CSS modules.",
  ),

  tags: ("data-visualization", "solidjs", "exploration", "creative-ui", "frontend"),

  links: (
    live: "cargo-lab.vercel.app", // standard format, let's keep it clean
  ),
)
