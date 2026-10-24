// projects/basira.typ
//
// Basira (Prophet Graph) — interactive historical lineage visualization.
//
// This file describes what Basira IS, not how to present it on a resume.
// All achievements represent verified implementations from repository code and architecture.

#let basira = (
  title:       "Basira",
  role:        "Creator & Engineer",
  company:     "Basira",
  type:       "Open Source / Educational",
  status:      "Completed",
  period:      "2026",
  team_size:   "Solo",

  summary:     "Interactive lineage graph visualization of historical prophet genealogy.",

  technologies: (
    "React", "TypeScript", "TanStack Start", "TanStack Router",
    "D3.js", "D3 Force", "Canvas API", "Tailwind CSS",
  ),

  achievements: (
    (
      id: "force-canvas",
      statement: "Engineered an interactive educational graph visualizing historical prophet lineages (28 nodes) using D3 force simulation on an HTML5 canvas viewport.",
      method: "Combined D3 force physics directly with an HTML5 canvas rendering loop, maintaining smooth camera zoom, pan, and real-time hovered ancestor/descendant lineage tracing.",
      outcome: "Delivered responsive educational graph exploration with interactive node selection, timeline era filtering, and bilingual Arabic/English naming.",
      metric: "Interactive 28-node genealogical graph with ancestor/descendant path tracing",
      evidence: "basira/src/data/prophets.json & src/components/GraphCanvas.tsx",
      skills: ("D3.js", "Canvas API", "TypeScript", "React", "Data Visualization"),
      tags: ("data-visualization", "frontend", "algorithms"),
    ),
    (
      id: "lineage-traversal",
      statement: "Engineered bidirectional graph traversal algorithms (BFS) and cycle validation, enabling interactive ancestor/descendant lineage path discovery and hierarchy depth computation.",
      method: "Implemented forward and backward link traversal algorithms with depth calculation for generational layout stratification and cycle detection to guarantee tree validity.",
      outcome: "Provided real-time visual path highlighting across historical prophet lineages with verified referential integrity.",
      metric: "Bidirectional BFS graph traversal with cycle and referential validation",
      evidence: "basira/src/utils/graphUtils.ts & src/components/GraphCanvas.tsx",
      skills: ("Algorithms", "TypeScript", "Data Visualization", "Component Architecture"),
      tags: ("algorithms", "data-visualization", "frontend"),
    ),
    (
      id: "a11y-seo",
      statement: "Implemented keyboard focus management (useFocusTrap hook, landmark elements) and programmatic JSON-LD metadata schemas for historical graph entities.",
      method: "Structured modal panels with focus trap hooks and landmark HTML elements, and dynamically generated Schema.org Person schemas for search engine crawlability.",
      outcome: "Ensured keyboard-accessible navigation across modal inspection panels and standard entity relationship modeling for Google Rich Results.",
      metric: "Focus trapping with landmark elements and Schema.org Person schemas",
      evidence: "basira/src/hooks/useFocusTrap.ts & README.md",
      skills: ("Web Accessibility", "HTML5", "Component Architecture", "TanStack Router"),
      tags: ("accessibility", "frontend", "ui", "seo"),
    ),
  ),

  tags: ("data-visualization", "performance", "accessibility", "open-source", "frontend"),

  links: (
    live: "basira-graph.vercel.app",
  ),
)
