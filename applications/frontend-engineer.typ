// applications/frontend-engineer.typ
//
// Frontend Engineer — Canonical Production Resume for Frontend Roles.
//
// Composes the reusable Frontend Engineer job-family profile using the
// canonical classic monochrome single-column layout.

#import "../profiles/frontend.typ": compose-frontend
#import "../templates/resume.typ": resume-template

#let app = compose-frontend(
  layout: "classic",
)

// Pass to the Resume Template
#resume-template(app, layout: "classic")
