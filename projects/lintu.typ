// projects/lintu.typ
//
// Lintu — data visualization dashboard platform.
//
// This file describes what Lintu IS, not how to present it on a resume.
// Any renderer or future output (portfolio, website, cover letter) can
// consume this structured data and render it appropriately.

#let lintu = (
  title:      "Lintu",
  role:       "Co-Founder & Frontend Engineer",
  company:    "Lintu",
  type:       "Product",
  status:     "Completed",
  period:     "2022 — 2025",
  team_size:  "2–5",

  summary:    "Interactive storytelling and multi-layer data visualization platform.",

  technologies: (
    "React", "TypeScript", "Redux Toolkit", "React Query",
    "React Hook Form", "Zod", "Tailwind CSS", "D3.js", "Visx",
    "Mapbox GL", "dnd-kit", "Lexical",
  ),

  achievements: (
    "Designed and engineered the frontend application, building a custom drag-and-drop block editor and modular design system.",
    "Implemented normalized state management using Redux Toolkit Entity Adapter and schema-validated forms with Zod.",
    "Built multi-layered interactive mapping and charting components with D3.js, Visx, and Mapbox GL.",
  ),

  tags: ("data-visualization", "product", "frontend", "editor", "design-systems"),

  links: (
    live: "stories.lintu.io",
  ),
)
