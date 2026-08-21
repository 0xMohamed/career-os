// applications/master.typ
//
// Master — the canonical, default profile application of Career OS.
//
// It represents the single source of truth for the primary resume view.
// All specific job applications (e.g., oto.typ) are lightweight variants
// that import the same underlying content and customize selection or emphasis.

// ── Import content layer ────────────────────────────────────────────
#import "../content/profile.typ":    profile
#import "../content/experience.typ": experience
#import "../content/education.typ":  education
#import "../content/languages.typ":  languages
#import "../content/skills.typ":     skills
#import "../content/strengths.typ":  strengths

// ── Import project layer ────────────────────────────────────────────
#import "../projects/lintu.typ":   lintu
#import "../projects/modra.typ":   modra
#import "../projects/oqel.typ":    oqel
#import "../projects/basira.typ":  basira
#import "../projects/deskby.typ":  deskby
#import "../projects/cargolab.typ": cargolab

// ── Master composition ──────────────────────────────────────────────
#let app = (
  profile: profile,

  // All projects included in canonical order.
  projects: (lintu, modra, oqel, basira, deskby, cargolab),

  experience: experience,
  strengths:  strengths,
  education:  education,
  languages:  languages,

  // All skills categories from the source of truth.
  skills: skills,
)

// ── Pass to the resume template ─────────────────────────────────────
#import "../templates/resume.typ": resume-template
#resume-template(app)
