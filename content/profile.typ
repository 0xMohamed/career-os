// content/profile.typ
//
// Personal profile — the single source of truth for identity information.
// No layout, no rendering. Only structured data.
//
// Used by: applications, templates

#let profile = (
  name:     "Mohamed Sayed Seoudy",
  title:    "Frontend Engineer",
  location: "Cairo, Egypt",
  email:    "hello@seoudy.dev",
  website:  "seoudy.dev",
  github:   "github.com/0xMohamed",
  linkedin: "linkedin.com/in/0xmohamed",

  // A concise professional summary.
  // Applications may override this for specific job families.
  summary: "Frontend Engineer with 4+ years of experience building complex React applications, interactive editors, design systems, AI-powered products, and data visualization platforms. Specialized in scalable frontend architecture, Redux Toolkit state management, schema-driven development with Zod, and high-performance user interfaces. Passionate about building maintainable SaaS products with exceptional user experiences.",
)
