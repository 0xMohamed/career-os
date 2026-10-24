// applications/software-engineer.typ
//
// Software Engineer — Canonical Production Resume for Full-Stack / Software Roles.
//
// Composes the reusable Software Engineer job-family profile using the
// canonical classic monochrome single-column layout.

#import "../profiles/software-engineer.typ": compose-software-engineer
#import "../templates/resume.typ": resume-template

#let app = compose-software-engineer(
  layout: "classic",
)

// Pass to the Resume Template
#resume-template(app, layout: "classic")
