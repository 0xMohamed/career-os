// projects/cargolab.typ
//
// Cargo Lab — experimental SolidJS cargo tracker and simulation dashboard.
//
// This file describes what Cargo Lab IS, not how to present it on a resume.
// All achievements follow the Google X-Y-Z methodology backed by concrete codebase evidence.

#let cargolab = (
  title:       "Cargo Lab",
  role:        "Creator & Engineer",
  company:     "Cargo Lab",
  type:        "Open Source / Exploration",
  status:      "Completed",
  period:      "2025",
  team_size:   "Solo",

  summary:     "An interactive logistics prototype visualizing vessel routes and cargo placement.",

  technologies: (
    "SolidJS", "TypeScript", "Vite", "D3.js",
    "d3-geo", "TopoJSON", "CSS Modules",
  ),

  achievements: (
    (
      id: "globe-projection",
      statement: "Built an interactive logistics visualization with a D3 orthographic globe rendered through SVG and Canvas, displaying simulated vessel movement between six ports.",
      method: "Rendered base landmass polygons and graticule lines via D3 geoOrthographic SVG paths while overlaying an HTML5 Canvas for vessel markers, applying geodesic distance calculations (geoDistance > 1.57) to clip markers on the far hemisphere.",
      outcome: "Delivered responsive drag-to-rotate and zoom navigation across 2D spherical projections with pointer-tracked cargo inspections.",
      metric: "Layered SVG/Canvas rendering with far-hemisphere visibility clipping",
      evidence: "cargo-lab/src/components/charts/GlobalMap.tsx & assets/world-110m.json",
      skills: ("SolidJS", "D3.js", "Canvas API", "SVG", "Data Visualization"),
      tags: ("data-visualization", "solidjs", "performance", "frontend"),
    ),
    (
      id: "vessel-telemetry",
      statement: "Added a container-bay interface with a 40-slot layout and three-tier stacking rules, allowing users to place and inspect simulated cargo.",
      method: "Engineered periodic coordinate progression using haversine distance and step vectors between six major ports, broadcasting state updates to SolidJS reactive stores at 3-second intervals.",
      outcome: "Simulated transit progress, estimated arrival times, and status transitions without external API dependencies or backend polling overhead.",
      metric: "Client-side geodesic simulation across 6 international shipping ports",
      evidence: "cargo-lab/src/services/cargoService.ts & utils/geoUtils.ts",
      skills: ("SolidJS", "TypeScript", "Algorithms", "State Management"),
      tags: ("algorithms", "frontend", "solidjs"),
    ),
    (
      id: "bay-manager",
      statement: "Developed an interactive cargo bay configuration engine in SolidJS, modeling a 40-slot vessel blueprint with multi-tier container stacking constraints.",
      method: "Constructed an interactive SVG ship blueprint with programmatic slot filtering (2 rows x 20 columns), three-tier capacity limits, dynamic fill styling, and cursor-following inspection tooltips.",
      outcome: "Provided real-time visual feedback on container tier distribution, bay capacity limits, and container metadata assignment.",
      metric: "40-slot vessel layout with 3-tier stacking constraints",
      evidence: "cargo-lab/src/pages/Cargo.tsx & styles/Cargo.module.css",
      skills: ("SolidJS", "SVG", "TypeScript", "CSS Modules", "Component Architecture"),
      tags: ("frontend", "ui", "solidjs", "architecture"),
    ),
  ),

  tags: ("data-visualization", "solidjs", "exploration", "creative-ui", "frontend"),

  links: (
    live: "cargo-lab.vercel.app",
  ),
)
