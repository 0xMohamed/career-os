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
    company:   "Independent Frontend Engineer",
    role:      "Frontend Engineer",
    period:    "Jan 2022 — Present",
    location:  "Remote",
    summary:   "Architected and delivered production-grade frontend products and collaborated directly with founders to build interactive SaaS experiences, visual editors, dashboards, and AI-powered products.",
    highlights: (
      "Architected and shipped full-featured interactive SaaS platforms, drag-and-drop visual editors, and ambient canvas dashboards using React, Next.js, and TypeScript.",
      "Engineered scalable client-side architectures with normalized state (Redux Toolkit, Jotai, Zustand) and declarative schema validation (Zod, React Hook Form).",
      "Built real-time data visualization systems with D3, Visx, and Mapbox GL, optimizing canvas and DOM loops to sustain 60 FPS under high event frequency.",
      "Integrated production AI workflows leveraging Google Gemini, multimodal processing, structured JSON schemas, and resilient client-side hydration.",
    ),
  ),
)
