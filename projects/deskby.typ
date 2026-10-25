// projects/deskby.typ
//
// Deskby — ambient widget dashboard.
//
// This file describes what Deskby IS, not how to present it on a resume.
// All achievements follow the Google X-Y-Z methodology backed by concrete codebase evidence.

#let deskby = (
  title:       "Deskby",
  role:        "Frontend Engineer",
  company:     "Deskby",
  type:        "Product",
  status:      "Completed",
  period:      "2025",
  team_size:   "1–3",

  summary:     "A StandBy-inspired dashboard that turns idle large displays into configurable widget workspaces.",

  technologies: (
    "Next.js", "React", "TypeScript", "Jotai",
    "React Grid Layout", "Tailwind CSS", "Jest",
  ),

  achievements: (
    (
      id: "widget-registry",
      statement: "Built a widget registry that lets users add, arrange, resize, and reorder widgets in a shared grid, with separate edit and display modes.",
      method: "Defined a typed WidgetDefinition contract with a declarative settingsSchema (text, number, toggle, select, color), automatically projecting form controls into Jotai state.",
      outcome: "Decoupled widget development from configuration UI authoring, allowing new modular widgets to be integrated solely through their schema contract.",
      metric: "Declarative widget registry with schema-driven configuration panels",
      evidence: "deskby/ARCHITECTURE.md & src/core/widgetRegistry.ts",
      skills: ("TypeScript", "Design Systems", "Component Architecture", "React"),
      tags: ("architecture", "frontend", "design-systems"),
    ),
    (
      id: "dom-reparenting",
      statement: "Used React portals to show widgets in a fullscreen layer without unmounting them, preserving running timers and widget state during transitions.",
      method: "Implemented targeted stage teleportation using React portals and Jotai atoms (maximizedWidgetIdAtom), preserving active timers and canvas elements.",
      outcome: "Preserved internal component state and timer execution across fullscreen modal transitions.",
      metric: "DOM portal reparenting without unmounting active widgets",
      evidence: "deskby/ARCHITECTURE.md & src/components/widget/WidgetShell.tsx",
      skills: ("React", "Jotai", "State Management", "Performance Optimization"),
      tags: ("frontend", "state-management", "ui"),
    ),
    (
      id: "safe-persistence",
      statement: "Implemented local-first state persistence with safe schema migration, ensuring reliable dashboard recovery across browser restarts.",
      method: "Wrapped localStorage synchronization in atomWithSafeStorage using Jotai with JSON parse guards and fallback defaults.",
      outcome: "Prevented corrupted state crashes and preserved user layout configurations across browser sessions.",
      metric: "Guarded JSON parse validation with fallback default state",
      evidence: "deskby/ARCHITECTURE.md & src/deskby/state/persistence.ts",
      skills: ("Jotai", "Next.js", "TypeScript", "State Management"),
      tags: ("state-management", "frontend", "architecture"),
    ),
  ),

  tags: ("ambient-computing", "product", "frontend", "ux-engineering"),

  links: (
    live: "dskby.vercel.app",
  ),
)
