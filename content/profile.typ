// content/profile.typ
//
// Personal profile — the single source of truth for identity information.
// No layout, no rendering. Only structured data.
//
// Used by: applications, templates

#let profile = (
  name:     "Seoudy",
  title:    "Senior Frontend Engineer",
  location: "Remote",
  email:    "hello@seoudy.com",
  website:  "seoudy.com",
  github:   "github.com/seoudy",

  // A concise professional summary.
  // Applications may override this for specific job families.
  summary: "Frontend engineer specializing in data visualization, interactive UI systems, and AI-integrated products. Proven track record building performant, accessible, and beautifully crafted interfaces — from real-time graph engines to collaborative slide editors and AI reasoning surfaces.",
)
