// projects/lintu.typ
//
// Lintu — data visualization dashboard platform.
//
// This file describes what Lintu IS, not how to present it on a resume.
// All achievements represent verified implementations from repository code and architecture.

#let lintu = (
  title:      "Lintu",
  role:       "Frontend Engineer",
  company:    "Lintu",
  type:       "Product",
  status:     "Completed",
  period:     "2023 — 2025",
  team_size:  "2–5",

  summary:    "Interactive storytelling and multi-layer data visualization platform.",

  technologies: (
    "React", "TypeScript", "Redux Toolkit", "React Query",
    "React Hook Form", "Zod", "Tailwind CSS", "D3.js", "Visx",
    "Mapbox GL", "Three.js", "Storybook", "dnd-kit", "Lexical", "Cypress", "Jest",
  ),

  achievements: (
    (
      id: "editor-arch",
      statement: "Engineered an interactive canvas layout engine utilizing @dnd-kit, implementing draggable and resizable Tiles organized into responsive section Rows.",
      method: "Constructed a nested Page-Section-Row-Tile hierarchy with pointer drag sensors, row/tile resizers, drop zones, and dynamic node registration supporting live resizing.",
      outcome: "Enabled flexible multi-column spatial composition of data visualization and content nodes within structured container boundaries.",
      metric: "Nested Page-Section-Row-Tile hierarchy with dynamic drag-and-drop",
      evidence: "lintu.io/frontend/src/features/views/section/Tiles.tsx & Section.tsx",
      skills: ("React", "TypeScript", "dnd-kit", "Server-Driven UI", "Component Architecture", "Tailwind CSS"),
      tags: ("frontend", "ui", "editor", "architecture"),
    ),
    (
      id: "composite-chart",
      statement: "Architected a multi-mark Composite Chart engine supporting lines, bars, areas, and scatter plots, preventing stale SVG marks from accumulating across scene transitions.",
      method: "Implemented Zod mark schemas with explicit replace and overlay rendering strategies, validating shared axis scale types (linear, log, categorical) and clearing previous SVG marks on transitions.",
      outcome: "Prevented stale mark accumulation and visual clipping artifacts across multi-scene narrative presentations, delivering predictable cross-layer comparisons.",
      metric: "Multi-mark visual engine (line, bar, area, scatter) with explicit scene lifecycle",
      evidence: "lintu.io/frontend/ARCHITECTURAL_DESIGN_COMPOSITE_CHART.md & composite-chart-visual-node.ts",
      skills: ("D3.js", "Visx", "SVG", "Zod", "Data Visualization", "TypeScript"),
      tags: ("data-visualization", "frontend", "architecture", "contracts"),
    ),
    (
      id: "extensible-nodes",
      statement: "Engineered an extensible node registry and dynamic runtime supporting 9+ visual and content types, powering server-driven document viewer execution alongside schema-driven settings panels.",
      method: "Combined a centralized node registry and recursive node renderer with automated settings form generation (AutoForm using React Hook Form) and Lexical rich-text plugins.",
      outcome: "Enabled the public viewer to execute server-defined component trees dynamically while auto-generating reactive property panels for editor authoring.",
      metric: "9+ registered node types with dynamic viewer runtime and schema panels",
      evidence: "lintu.io/frontend/src/features/editor/model/nodes/core/registry.ts, views/nodes/node-renderer.tsx & AutoForm.tsx",
      skills: ("React", "TypeScript", "React Hook Form", "Lexical", "Zod", "Server-Driven UI", "Component Architecture"),
      tags: ("frontend", "editor", "contracts", "architecture"),
    ),
  ),

  tags: ("data-visualization", "product", "frontend", "editor", "design-systems"),

  links: (
    live: "lintu.io",
  ),
)
