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
  period:      "2025",
  team_size:   "1–3",

  summary:    "Modular ambient desktop dashboard and widget engine.",

  technologies: (
    "Next.js", "React", "TypeScript", "Jotai",
    "React Grid Layout", "Tailwind CSS",
  ),

  achievements: (
    "Architected a declarative per-instance settings schema system that auto-generates configuration UI from widget definitions.",
    "Engineered seamless DOM reparenting enabling widgets to transition into fullscreen overlays without unmounting or state loss.",
    "Built a modular widget runtime supporting 10+ live widgets with instance-specific settings and responsive layouts.",
  ),

  tags: ("ambient-computing", "product", "frontend", "ux-engineering"),

  links: (
    live: "dskby.vercel.app/",
  ),
)
