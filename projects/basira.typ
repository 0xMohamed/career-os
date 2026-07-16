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
  status:      "Active",
  period:      "2024 — Present",
  team_size:   "Solo",

  summary: "A high-performance React application that visualizes massive interactive historical lineages on the web. Integrates D3 force layouts directly against React lifecycles to maintain 60 FPS with large graphs, featuring bilingual layouts (Arabic/English), semantic accessibility, and a premium motion design system.",

  technologies: (
    "React 19", "TypeScript", "D3.js", "TanStack Router",
    "Vite 7", "Tailwind CSS",
  ),

  achievements: (
    "Achieved 60 FPS with large force-directed graphs by integrating D3 physics directly against React lifecycles — bypassing Virtual DOM re-renders for simulation ticks.",
    "Built a viewport culling system that uses mathematical spatial awareness to instantly skip rendering for nodes beyond the camera bounds, maintaining performance at scale.",
    "Implemented the BiographyPanel with adaptive layouts: desktop modal and mobile bottom sheet driven by velocity-based gesture mapping.",
    "Achieved WCAG accessibility using semantic landmarks (main, nav, aside, header) with strict useFocusTrap for keyboard navigation through graph nodes.",
    "Implemented programmatic JSON-LD SEO schemas mapped to Google Rich Results criteria — enabling structured person data for each historical figure.",
    "Designed a custom D3 collision matrix with fluid edge curvature and real-time hovered lineage highlighting.",
  ),

  tags: ("data-visualization", "performance", "accessibility", "open-source", "frontend"),

  links: (
    github: "github.com/0xMohamed/basira",
  ),
)
