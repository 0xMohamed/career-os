// templates/resume.typ
//
// The resume renderer for Career OS.
//
// This template receives a fully prepared `app` dictionary from the
// application layer and renders a modern two-column editorial resume.
//
// It knows nothing about:
//   - companies or job applications
//   - project selection logic
//   - business rules or prioritization
//
// It renders what it receives:
//   - app.profile
//   - app.experience
//   - app.projects
//   - app.strengths
//   - app.education
//   - app.skills
//   - app.languages

#import "theme.typ": *

// ── Main resume template ─────────────────────────────────────────────

#let resume-template(app) = {
  let p = app.profile

  set document(
    title: p.name + " — Resume",
    author: p.name,
    keywords: ("Frontend", "React", "TypeScript", "TanStack", "Data Visualization", "AI", "Design Systems"),
  )

  set page(
    paper: "a4",
    margin: (x: 1.4cm, top: 1.15cm, bottom: 1.15cm),
  )

  set text(
    font: font-sans,
    size: size-body,
    fill: color-ink,
    hyphenate: false,
  )

  set par(
    justify: false,
    leading: 0.48em,
  )

  // ── Helper: section heading ─────────────────────────────────────────
  let section-heading(label) = {
    v(space-section)
    text(
      font: font-sans,
      size: size-section,
      weight: "bold",
      fill: color-ink,
      upper(label),
    )
    v(1.5pt)
    line(length: 100%, stroke: 0.9pt + color-rule-dark)
    v(space-inner)
  }

  // ── Helper: meta text row ───────────────────────────────────────────
  let meta-text(content) = text(
    font: font-sans,
    size: size-meta,
    fill: color-muted,
    content,
  )

  // ── Helper: subtle dotted divider between items ─────────────────────
  let dotted-divider() = {
    v(space-tight)
    line(length: 100%, stroke: (paint: color-rule, dash: "dotted", thickness: 0.5pt))
    v(space-tight)
  }

  // ── Helper: bullet item ─────────────────────────────────────────────
  let bullet(content) = {
    grid(
      columns: (5.5pt, 1fr),
      gutter: 2pt,
      text(fill: color-muted, size: size-body)[•],
      text(size: size-body, fill: color-ink)[#content],
    )
    v(space-tight)
  }

  // ════════════════════════════════════════════════════════════════════
  // HEADER
  // ════════════════════════════════════════════════════════════════════
  let display-tagline = if "tagline" in p and p.tagline != none and p.tagline != "" {
    p.tagline
  } else {
    p.title
  }

  // Monogram initials derivation (e.g. Mohamed Seoudy → MS)
  let name-parts = p.name.split(" ")
  let initials = if name-parts.len() >= 2 {
    name-parts.at(0).slice(0, 1) + name-parts.at(-1).slice(0, 1)
  } else {
    p.name.slice(0, 1)
  }

  grid(
    columns: (1fr, auto),
    gutter: 14pt,
    align: (left + horizon, right + horizon),
    [
      #text(
        font: font-sans,
        size: size-name,
        weight: "bold",
        fill: color-ink,
        upper(p.name),
      )
      #v(2.5pt)
      #text(
        font: font-sans,
        size: size-tagline,
        weight: "bold",
        fill: color-accent,
        display-tagline,
      )
      #v(4pt)
      #set text(font: font-sans, size: size-meta, fill: color-secondary)
      #link("mailto:" + p.email)[#icon-mail #h(2pt) #p.email]
      #h(6.5pt)
      #link("https://" + p.website)[#icon-link #h(2pt) #p.website]
      #h(6.5pt)
      #link("https://" + p.github)[#icon-github #h(2pt) #p.github]
      #h(6.5pt)
      #if "linkedin" in p and p.linkedin != none and p.linkedin != "" [
        #link("https://" + p.linkedin)[#icon-linkedin #h(2pt) #p.linkedin]
        #h(6.5pt)
      ]
      #icon-location #h(2pt) #p.location
    ],
    [
      #circle(radius: 20pt, fill: color-accent)[
        #align(center + horizon)[
          #text(fill: white, weight: "bold", size: 13.5pt)[#initials]
        ]
      ]
    ]
  )

  v(3pt)

  // ════════════════════════════════════════════════════════════════════
  // TWO COLUMN CONTENT LAYOUT
  // ════════════════════════════════════════════════════════════════════

  let left-col = [
    // ── EXPERIENCE ───────────────────────────────────────────────────
    #if "experience" in app and app.experience != none and app.experience.len() > 0 [
      #section-heading("Experience")
      #for entry in app.experience [
        #block(breakable: false)[
          #text(font: font-sans, size: size-title, weight: "bold", fill: color-ink)[#entry.role]
          #h(3pt)
          #text(font: font-sans, size: size-title, weight: "medium", fill: color-secondary)[· #entry.company]
          #v(1.5pt)
          #meta-text[#icon-calendar #h(2pt) #entry.period #h(6pt) #icon-location #h(2pt) #entry.location]
          #v(space-tight)
          #for hl in entry.highlights [
            #bullet(hl)
          ]
          #v(space-entry)
        ]
      ]
    ]

    // ── PROJECTS ─────────────────────────────────────────────────────
    #if "projects" in app and app.projects != none and app.projects.len() > 0 [
      #section-heading("Projects")
      #for (i, proj) in app.projects.enumerate() [
        #block(breakable: false)[
          #let target-link = none
          #if "links" in proj and proj.links != none {
            if "live" in proj.links and proj.links.live != none and proj.links.live != "" {
              target-link = proj.links.live
            } else if "github" in proj.links and proj.links.github != none and proj.links.github != "" {
              target-link = proj.links.github
            }
          }
          #if target-link != none {
            let url = target-link
            if not url.starts-with("http://") and not url.starts-with("https://") {
              url = "https://" + url
            }
            link(url)[#text(font: font-sans, size: size-title, weight: "bold", fill: color-ink)[#proj.title]]
          } else {
            text(font: font-sans, size: size-title, weight: "bold", fill: color-ink)[#proj.title]
          }
          #v(1pt)
          #meta-text[#icon-calendar #h(2pt) #proj.period]
          #v(1.5pt)
          #text(size: size-body, fill: color-secondary)[#proj.summary]
          #v(space-tight)
          #let top-achievements = proj.achievements.slice(0, calc.min(2, proj.achievements.len()))
          #for bullet-item in top-achievements [
            #bullet(bullet-item)
          ]
          #if i < app.projects.len() - 1 [
            #dotted-divider()
          ]
        ]
      ]
    ]
  ]

  let right-col = [
    // ── SUMMARY ──────────────────────────────────────────────────────
    #if "summary" in p and p.summary != none and p.summary != "" [
      #section-heading("Summary")
      #text(
        size: size-body,
        fill: color-secondary,
        p.summary,
      )
    ]

    // ── KEY STRENGTHS ────────────────────────────────────────────────
    #if "strengths" in app and app.strengths != none and app.strengths.len() > 0 [
      #section-heading("Key Strengths")
      #for (i, s) in app.strengths.enumerate() [
        #block(breakable: false)[
          #grid(
            columns: (10pt, 1fr),
            gutter: 2pt,
            align: (top + left, top + left),
            icon-gem,
            [
              #text(font: font-sans, size: size-body, weight: "bold", fill: color-ink)[#s.title] \
              #v(0.5pt)
              #text(size: size-small, fill: color-secondary)[#s.description]
            ]
          )
          #if i < app.strengths.len() - 1 [
            #dotted-divider()
          ]
        ]
      ]
    ]

    // ── EDUCATION ────────────────────────────────────────────────────
    #if "education" in app and app.education != none and app.education.len() > 0 [
      #section-heading("Education")
      #for entry in app.education [
        #block(breakable: false)[
          #text(font: font-sans, size: size-title, weight: "bold", fill: color-ink)[#entry.degree] \
          #v(1pt)
          #text(font: font-sans, size: size-body, weight: "semibold", fill: color-accent)[#entry.institution] \
          #v(1pt)
          #meta-text[#icon-calendar #h(2pt) #entry.period]
          #v(space-entry)
        ]
      ]
    ]

    // ── SKILLS ───────────────────────────────────────────────────────
    #if "skills" in app and app.skills != none and app.skills.len() > 0 [
      #section-heading("Skills")
      #for (i, group) in app.skills.enumerate() [
        #block(breakable: false)[
          #text(font: font-sans, size: size-body, weight: "bold", fill: color-accent)[#group.category]
          #v(1.5pt)
          #par(leading: 0.6em)[
            #for skill in group.items [
              #box(
                inset: (x: 3pt, top: 0.5pt, bottom: 1.5pt),
                stroke: (bottom: 0.6pt + color-underline),
                text(font: font-sans, size: size-small, weight: "medium", fill: color-ink)[#skill]
              )
              #h(2.5pt)
            ]
          ]
          #if i < app.skills.len() - 1 [
            #dotted-divider()
          ]
        ]
      ]
    ]

    // ── LANGUAGES ────────────────────────────────────────────────────
    #if "languages" in app and app.languages != none and app.languages.len() > 0 [
      #section-heading("Languages")
      #for (i, lang) in app.languages.enumerate() [
        #block(breakable: false)[
          #text(font: font-sans, size: size-body, weight: "bold", fill: color-ink)[#lang.name] \
          #text(font: font-sans, size: size-small, fill: color-muted)[#lang.level]
          #if i < app.languages.len() - 1 [
            #dotted-divider()
          ]
        ]
      ]
    ]
  ]

  grid(
    columns: (58%, 1fr),
    gutter: 15pt,
    left-col,
    right-col,
  )
}
