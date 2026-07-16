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
  status:     "Active",
  period:     "2023 — Present",
  team_size:  "2–5",

  summary:    "Interactive storytelling and data visualization platform.",

  technologies: (
    "React", "TypeScript", "Redux Toolkit", "React Query",
    "React Hook Form", "Zod", "Tailwind CSS", "D3.js", "Visx",
    "Mapbox GL", "dnd-kit", "Lexical",
  ),

  achievements: (
    "Solely architected and developed the frontend application from the ground up.",
    "Built a reusable design system and custom drag-and-drop editing experience.",
    "Implemented normalized client-side state using Redux Toolkit Entity Adapter.",
    "Developed schema-driven content models with Zod and React Hook Form validation.",
    "Built advanced visualization and mapping experiences using D3, Visx, and Mapbox GL.",
  ),

  tags: ("data-visualization", "product", "frontend", "editor", "design-systems"),

  links: (
    live: "stories.lintu.io",
  ),
)
