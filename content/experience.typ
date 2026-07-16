// content/experience.typ
//
// Professional experience — the single source of truth for work history.
// No layout, no rendering. Only structured data.
//
// Each entry exposes:
//   company     — employer name
//   role        — job title
//   period      — employment dates
//   location    — office or remote
//   summary     — optional short description of the position
//   highlights  — array of accomplishment bullets (written as outcomes, not tasks)

#let experience = (
  (
    company:   "Lintu",
    role:      "Lead Frontend Engineer",
    period:    "2023 — Present",
    location:  "Remote",
    summary:   "Building the core product — a data visualization dashboard platform used by analysts and non-technical teams.",
    highlights: (
      "Architected and shipped the full WYSIWYG editor from zero: drag-and-drop layout, undo/redo, dataset ingestion, and a block registry supporting charts, maps, text, and images.",
      "Designed a dual-layer theme system (ThemeDefinition + ThemePreset) adopted across all product surfaces.",
      "Implemented dataset-linked blocks with live preview, CSV/XLSX parsing, and schema-aware column inference.",
      "Built the public viewer and share link infrastructure, enabling read-only document distribution.",
    ),
  ),
  (
    company:   "Deskby",
    role:      "Frontend Engineer",
    period:    "2022 — 2023",
    location:  "Remote",
    summary:   "Contributed to a widget-based ambient dashboard product focused on glanceable, calm information display.",
    highlights: (
      "Built the settings schema system: a declarative, instance-specific configuration layer that renders settings UI automatically from widget definitions.",
      "Implemented fullscreen reparenting — preserving component state while transitioning widgets into a fullscreen overlay.",
      "Delivered Weather, Crypto, Prayer Times, and KPI widgets with live data fetching and premium motion design.",
      "Established the Edit vs View mode architecture separating interactive chrome from ambient display.",
    ),
  ),
)
