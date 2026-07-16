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
      "Architected and delivered production-grade frontend products focused on interactive systems, visual editors, dashboards, and AI-powered experiences.",
      "Designed scalable frontend architectures, reusable UI components, and complex state management solutions.",
      "Collaborated with founders and product teams to transform ideas into production-ready products.",
      "Focused on performance, maintainability, accessibility, and engineering quality.",
    ),
  ),
)
