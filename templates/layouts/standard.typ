// templates/layouts/standard.typ
//
// Standard Layout — One-Column Presentation for Career OS.
//
// Modern, conservative single-column resume layout with linear narrative flow:
//   - Full-width Header and Summary
//   - Full-width chronological Experience timeline
//   - Full-width Projects with top achievements
//   - High-density 2-column balanced Key Strengths grid
//   - Structured 2-column tabular Skills matrix
//   - Side-by-side balanced Education & Languages footer

#import "../theme.typ": *

#let normalize-url(url) = {
  if url == none or url == "" {
    none
  } else if url.starts-with("http://") or url.starts-with("https://") {
    url
  } else {
    "https://" + url
  }
}

#let render-standard(app, p, section-heading, meta-text, dotted-divider, bullet) = {
  // ── SUMMARY ────────────────────────────────────────────────────────
  if "summary" in p and p.summary != none and p.summary != "" [
    #section-heading("Summary")
    #text(
      size: size-body,
      fill: color-secondary,
      p.summary,
    )
  ]

  // ── EXPERIENCE ─────────────────────────────────────────────────────
  if "experience" in app and app.experience != none and app.experience.len() > 0 [
    #section-heading("Experience")
    #for (i, entry) in app.experience.enumerate() [
      #block(breakable: false)[
        #let entry-title-block = [
          #text(font: font-sans, size: size-title, weight: "bold", fill: color-ink)[#entry.role]
          #h(3pt)
          #if "link" in entry and entry.link != none and entry.link != "" [
            #let entry-url = normalize-url(entry.link)
            #text(font: font-sans, size: size-title, weight: "medium", fill: color-secondary)[· #link(entry-url)[#entry.company]]
          ] else [
            #text(font: font-sans, size: size-title, weight: "medium", fill: color-secondary)[· #entry.company]
          ]
        ]
        #let entry-meta-block = meta-text[#icon-calendar #h(2pt) #entry.period #h(6pt) #icon-location #h(2pt) #entry.location]

        #grid(
          columns: (1fr, auto),
          gutter: 8pt,
          align: (left + horizon, right + horizon),
          entry-title-block,
          entry-meta-block,
        )
        #v(space-tight)
        #for hl in entry.highlights [
          #bullet(hl)
        ]
        #if i < app.experience.len() - 1 [
          #v(space-tight)
        ]
      ]
    ]
  ]

  // ── PROJECTS ───────────────────────────────────────────────────────
  if "projects" in app and app.projects != none and app.projects.len() > 0 [
    #section-heading("Projects")
    #for (i, proj) in app.projects.enumerate() [
      #block(breakable: false)[
        #let target-link = if "links" in proj and proj.links != none {
          if "live" in proj.links and proj.links.live != none and proj.links.live != "" {
            proj.links.live
          } else if "github" in proj.links and proj.links.github != none and proj.links.github != "" {
            proj.links.github
          } else {
            none
          }
        } else {
          none
        }

        #let proj-title-block = [
          #if target-link != none [
            #let url = normalize-url(target-link)
            #link(url)[#text(font: font-sans, size: size-title, weight: "bold", fill: color-ink)[#proj.title]]
          ] else [
            #text(font: font-sans, size: size-title, weight: "bold", fill: color-ink)[#proj.title]
          ]
          #h(4pt)
          #text(size: size-body, fill: color-secondary)[· #proj.summary]
        ]
        #let proj-meta-block = meta-text[#icon-calendar #h(2pt) #proj.period]

        #grid(
          columns: (1fr, auto),
          gutter: 8pt,
          align: (left + horizon, right + horizon),
          proj-title-block,
          proj-meta-block,
        )
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

  // ── KEY STRENGTHS ──────────────────────────────────────────────────
  if "strengths" in app and app.strengths != none and app.strengths.len() > 0 [
    #section-heading("Key Strengths")
    #grid(
      columns: (1fr, 1fr),
      gutter: 12pt,
      ..app.strengths.map(s => [
        #block(breakable: false)[
          #grid(
            columns: (10pt, 1fr),
            gutter: 3pt,
            align: (top + left, top + left),
            icon-gem,
            [
              #text(font: font-sans, size: size-body, weight: "bold", fill: color-ink)[#s.title] \
              #v(0.5pt)
              #text(size: size-small, fill: color-secondary)[#s.description]
            ]
          )
        ]
      ])
    )
  ]

  // ── SKILLS ─────────────────────────────────────────────────────────
  if "skills" in app and app.skills != none and app.skills.len() > 0 [
    #section-heading("Skills")
    #for (i, group) in app.skills.enumerate() [
      #block(breakable: false)[
        #let cat-cell = text(font: font-sans, size: size-body, weight: "bold", fill: color-accent)[#group.category]
        #let tags-cell = par(leading: 0.6em)[
          #for skill in group.items [
            #box(
              inset: (x: 3pt, top: 0.5pt, bottom: 1.5pt),
              stroke: (bottom: 0.6pt + color-underline),
              text(font: font-sans, size: size-small, weight: "medium", fill: color-ink)[#skill]
            )
            #h(2.5pt)
          ]
        ]
        #grid(
          columns: (112pt, 1fr),
          gutter: 8pt,
          align: (top + left, top + left),
          cat-cell,
          tags-cell,
        )
        #if i < app.skills.len() - 1 [
          #v(space-tight)
        ]
      ]
    ]
  ]

  // ── EDUCATION & LANGUAGES ──────────────────────────────────────────
  grid(
    columns: (1fr, 1fr),
    gutter: 20pt,
    [
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
    ],
    [
      #if "languages" in app and app.languages != none and app.languages.len() > 0 [
        #section-heading("Languages")
        #for (i, lang) in app.languages.enumerate() [
          #block(breakable: false)[
            #text(font: font-sans, size: size-body, weight: "bold", fill: color-ink)[#lang.name]
            #h(4pt)
            #text(font: font-sans, size: size-small, fill: color-muted)[· #lang.level]
            #if i < app.languages.len() - 1 [
              #v(space-tight)
            ]
          ]
        ]
      ]
    ]
  )
}
