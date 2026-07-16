// applications/oto.typ
//
// Oto — the first Career OS application.
//
// An application is a lightweight composition layer.
// It assembles content and projects into a prepared data structure
// that the template receives and renders.
//
// An application never duplicates content.
// An application never contains rendering logic.
// An application defines WHAT to include, not HOW to display it.
//
// Think of it as a configuration file that composes the source of truth
// into a specific, intentional view of the professional identity.

// ── Import content layer ────────────────────────────────────────────
#import "../content/profile.typ":    profile
#import "../content/experience.typ": experience
#import "../content/education.typ":  education
#import "../content/languages.typ":  languages
#import "../content/skills.typ":     skills

// ── Import project layer ────────────────────────────────────────────
#import "../projects/lintu.typ":   lintu
#import "../projects/modra.typ":   modra
#import "../projects/oqel.typ":    oqel
#import "../projects/basira.typ":  basira
#import "../projects/deskby.typ":  deskby

// ── Application composition ─────────────────────────────────────────
//
// This is where editorial decisions are made:
//   - Which projects appear, and in what order
//   - Which skills are surfaced
//   - Whether the default profile summary is used or overridden
//
// No rendering here. Only selection and ordering.

#let app = (
  profile: profile,

  // Projects ordered by relevance for this application.
  // The template renders them in this order.
  projects: (lintu, modra, oqel, basira, deskby),

  experience: experience,
  education:  education,
  languages:  languages,

  // Skills loaded from content/skills.typ
  skills: skills,
)

// ── Pass to the resume template ─────────────────────────────────────
#import "../templates/resume.typ": resume-template
#resume-template(app)
