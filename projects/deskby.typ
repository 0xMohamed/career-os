// projects/deskby.typ
//
// Deskby — ambient widget dashboard.
//
// This file describes what Deskby IS, not how to present it on a resume.

#let deskby = (
  title:       "Deskby",
  role:        "Frontend Engineer",
  company:     "Deskby",
  type:        "Product",
  status:      "Completed",
  period:      "2022 — 2023",
  team_size:   "1–3",

  summary:    "Widget-based ambient dashboard.",

  technologies: (
    "Next.js", "React", "TypeScript", "Jotai",
    "React Grid Layout", "Tailwind CSS",
  ),

  achievements: (
    "Design and built the settings schema system: a declarative per-instance configuration layer that renders settings UI automatically from widget definitions, with no bespoke UI per widget.",
    "Implemented fullscreen reparenting — widgets transition into a fullscreen overlay while preserving all component state, avoiding remount and state loss.",
    "Established the Edit vs View mode architecture: Edit Mode exposes full chrome (ControlBar, Toolbar, Shelf, widget headers); View Mode keeps the canvas ambient and non-interactive.",
    "Built the ControlBar hover-reveal system: a thin top-edge bar activates on hover, sliding the ControlBar in from above the viewport with pointer-events constrained so widgets remain interactive underneath.",
    "Delivered 10+ production widgets with live data fetching, premium motion design, and instance-specific settings (Weather, Crypto, Prayer Times, News, Spotify, KPI, Recipe, Notes).",
  ),

  tags: ("ambient-computing", "product", "frontend", "ux-engineering"),

  links: (
    live: "dskby.vercel.app/",
  ),
)
