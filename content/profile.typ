// content/profile.typ
//
// Personal profile — the single source of truth for identity information.
// No layout, no rendering. Only structured data.
//
// Used by: applications, templates

#let profile = (
  name:     "Mohamed Seoudy",
  title:    "Frontend Engineer",
  tagline:  "Frontend Engineer | Interactive Systems | Data Visualization | AI-Powered Experiences",
  location: "Cairo, Egypt",
  email:    "hello@seoudy.dev",
  website:  "seoudy.dev",
  github:   "github.com/0xMohamed",
  linkedin: "linkedin.com/in/0xmohamed",

  // A concise professional summary.
  // Applications may override this for specific job families.
  summary: "Frontend engineer with 4+ years of experience architecting complex interactive interfaces, visual canvas editors, and high-performance data visualizations with React, Next.js, and TypeScript. Deep expertise in frontend architecture, state management, and design systems, currently expanding into AI-native application engineering with multimodal LLM workflows, structured outputs, and Python backend services.",
)
