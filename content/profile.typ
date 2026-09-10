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
  phone: if "phone" in sys.inputs and sys.inputs.at("phone") != "" {
    sys.inputs.at("phone")
  } else {
    none
  },
  email:    "hello@seoudy.dev",
  website:  "seoudy.dev",
  github:   "github.com/0xMohamed",
  linkedin: "linkedin.com/in/0xmohamed",

  // A concise professional summary.
  // Applications may override this for specific job families.
  summary: "Frontend engineer with 4+ years of experience building complex interactive interfaces, visual canvas editors, and high-performance data visualizations with React, Next.js, and TypeScript. Strong foundation in frontend architecture, state management, and design systems, with hands-on experience integrating multimodal LLM workflows, structured outputs, and Node.js backend services while actively expanding into Python and AI-native application engineering.",
)
