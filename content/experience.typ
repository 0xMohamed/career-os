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
//   link        — optional website/live product link
//   summary     — optional short description of the position
//   highlights  — array of accomplishment bullets (written as outcomes, not tasks)

#let experience = (
  (
    company:   "Summa",
    role:      "Founder & Product Engineer",
    link:      "https://summa.vercel.app/",
    period:    "Aug 2026 — Present",
    location:  "Remote",
    summary:   "Building an independent product from the ground up across the full stack, unifying frontend architecture, backend services, and AI-assisted workflows.",
    highlights: (
      "Designing product architecture and building the full-stack web application with React, TypeScript, and Node.js backend services.",
      "Developing reusable component foundations and AI-assisted workflows with a focus on simplicity, maintainability, and real-world usability.",
    ),
  ),
  (
    company:   "Self-employed",
    role:      "Frontend Developer",
    period:    "Jan 2023 — Dec 2025",
    location:  "Remote",
    summary:   "Led frontend engineering for an interactive storytelling and data visualization product (Lintu), scaling from initial concepts to a modular web application.",
    highlights: (
      "Engineered core frontend architecture, drag-and-drop block editor, and design system using React, TypeScript, and Redux Toolkit.",
      "Built multi-layer data visualization and interactive mapping interfaces with D3.js, Visx, and Mapbox GL, optimizing canvas and DOM rendering.",
    ),
  ),
  (
    company:   "Self-employed",
    role:      "Frontend Developer",
    period:    "Feb 2022 — Dec 2022",
    location:  "Remote",
    summary:   "Collaborated on early-stage product exploration, prototyping data-driven web experiences, interactive charting demos, and command-center interfaces.",
    highlights: (
      "Built interactive MVPs, command-center prototypes, and data visualization interfaces using React, JavaScript, Redux, and D3.js.",
      "Collaborated on frontend/backend prototypes, translating early product concepts into functional, responsive web experiences.",
    ),
  ),
)
