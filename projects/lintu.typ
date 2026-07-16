// projects/lintu.typ
//
// Lintu — data visualization dashboard platform.
//
// This file describes what Lintu IS, not how to present it on a resume.
// Any renderer or future output (portfolio, website, cover letter) can
// consume this structured data and render it appropriately.

#let lintu = (
  title:      "Lintu",
  role:       "Lead Frontend Engineer",
  company:    "Lintu",
  type:       "Product",
  status:     "Active",
  period:     "2023 — Present",
  team_size:  "2–5",

  summary: "A collaborative data visualization platform where users create multi-slide presentations composed of charts, maps, tables, and AI-generated insights — all driven by uploaded datasets. Designed for analysts and non-technical teams who need to communicate data without writing code.",

  technologies: (
    "React", "TypeScript", "Zustand", "Vite",
    "D3.js", "Custom Design System",
  ),

  achievements: (
    "Designed and implemented the full WYSIWYG editor from zero — drag-and-drop layout engine, undo/redo history, and a block registry powering charts, maps, text, and images.",
    "Built a dual-layer theme system (ThemeDefinition + ThemePreset) that controls visual DNA across all product surfaces from a single token source.",
    "Implemented dataset-linked blocks with live preview, CSV/XLSX parsing, and schema-aware column type inference.",
    "Architected the public viewer and share link system enabling read-only document distribution with no authentication required.",
    "Designed the editor state model — centralized Zustand snapshots with 200ms autosave debounce and structural undo/redo stability.",
  ),

  tags: ("data-visualization", "product", "frontend", "editor", "design-systems"),

  links: (
    live: "lintu.io",
  ),
)
