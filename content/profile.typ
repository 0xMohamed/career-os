// content/profile.typ
//
// Personal profile — the single source of truth for identity information.
// No layout, no rendering. Only structured data.
//
// Used by: applications, templates

#let profile = (
  name:     "Mohamed Seoudy",
  title:    "Frontend Engineer",
  location: "Cairo, Egypt",
  email:    "hello@seoudy.dev",
  website:  "seoudy.dev",
  github:   "github.com/0xMohamed",
  linkedin: "linkedin.com/in/0xmohamed",

  // A concise professional summary.
  // Applications may override this for specific job families.
  summary: "Frontend engineer specializing in building complex, interaction-rich product interfaces with React and TypeScript. Experienced in frontend architecture, design systems, data visualization, and AI-enabled user experiences, with a strong focus on performance, scalability, and crafting products that are intuitive, maintainable, and enjoyable to use.",
)
