// templates/layouts/classic.typ
//
// Classic Layout — Traditional / Conservative Resume Presentation for Career OS.
//
// Designed for traditional enterprise recruiters and conservative hiring pipelines:
//   - Single-column, linear typographic hierarchy
//   - Narrative flow: Summary → Experience → Projects → Key Strengths → Skills → Education/Languages
//   - Monochrome / neutral aesthetic with zero decorative color treatment
//   - Centered classic header with standard contact delimiters
//   - Clean horizontal section rules
//   - Traditional inline category: skills matrix
//   - Real selectable text, full ATS compatibility, and interactive hyperlink annotations

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

#let render-classic(app, p, section-heading, meta-text, dotted-divider, bullet) = {
  // ── Traditional Section Heading ──────────────────────────────────────
  let classic-heading(label) = [
    #v(space-section)
    #text(
      font: font-sans,
      size: size-section,
      weight: "bold",
      fill: color-ink,
      upper(label),
    )
    #v(1.5pt)
    #line(length: 100%, stroke: 0.8pt + color-ink)
    #v(space-inner)
  ]

  // ── Traditional Bullet Item ──────────────────────────────────────────
  let classic-bullet(content) = [
    #grid(
      columns: (6pt, 1fr),
      gutter: 2pt,
      text(fill: color-ink, size: size-body)[•],
      text(size: size-body, fill: color-ink)[#content],
    )
    #v(space-tight)
  ]

  let display-tagline = if "tagline" in p and p.tagline != none and p.tagline != "" {
    p.tagline
  } else {
    p.title
  }

  // ════════════════════════════════════════════════════════════════════
  // CLASSIC HEADER (LEFT-ALIGNED)
  // ════════════════════════════════════════════════════════════════════
  let classic-header = [
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
      fill: color-secondary,
      display-tagline,
    )
    #v(3.5pt)
    #set text(font: font-sans, size: size-meta, fill: color-secondary)
    #if "phone" in p and p.phone != none and p.phone != "" [
      #let clean-phone = p.phone.replace(" ", "")
      #link("tel:" + clean-phone)[#p.phone]
      #h(4pt) | #h(4pt)
    ]
    #link("mailto:" + p.email)[#p.email]
    #h(4pt) | #h(4pt)
    #link("https://" + p.website)[#p.website]
    #h(4pt) | #h(4pt)
    #if "github" in p and p.github != none and p.github != "" [
      #link("https://" + p.github)[GitHub · 0xMohamed]
      #h(4pt) | #h(4pt)
    ]
    #if "linkedin" in p and p.linkedin != none and p.linkedin != "" [
      #link("https://" + p.linkedin)[LinkedIn · 0xMohamed]
      #h(4pt) | #h(4pt)
    ]
    #p.location
  ]

  let body = [
    #classic-header
    #v(4pt)

    // ── SUMMARY ──────────────────────────────────────────────────────
    #if "summary" in p and p.summary != none and p.summary != "" [
      #classic-heading("Summary")
      #text(
        size: size-body,
        fill: color-ink,
        p.summary,
      )
    ]

    // ── EXPERIENCE ───────────────────────────────────────────────────
    #if "experience" in app and app.experience != none and app.experience.len() > 0 [
      #classic-heading("Experience")
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
          #let entry-meta-block = text(font: font-sans, size: size-meta, fill: color-muted)[#entry.period #h(6pt) · #h(6pt) #entry.location]

          #grid(
            columns: (1fr, auto),
            gutter: 8pt,
            align: (left + horizon, right + horizon),
            entry-title-block,
            entry-meta-block,
          )
          #v(space-tight)
          #for hl in entry.highlights [
            #classic-bullet(hl)
          ]
          #if i < app.experience.len() - 1 [
            #v(space-tight)
          ]
        ]
      ]
    ]

    // ── PROJECTS ─────────────────────────────────────────────────────
    #if "projects" in app and app.projects != none and app.projects.len() > 0 [
      #classic-heading("Projects")
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
          #let proj-meta-block = text(font: font-sans, size: size-meta, fill: color-muted)[#proj.period]

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
            #classic-bullet(bullet-item)
          ]
          #if i < app.projects.len() - 1 [
            #dotted-divider()
          ]
        ]
      ]
    ]

    // ── SKILLS ───────────────────────────────────────────────────────
    #if "skills" in app and app.skills != none and app.skills.len() > 0 [
      #classic-heading("Skills")
      #for (i, group) in app.skills.enumerate() [
        #block(breakable: false)[
          #let cat-cell = text(font: font-sans, size: size-body, weight: "bold", fill: color-ink)[#group.category:]
          #let tags-cell = text(font: font-sans, size: size-small, fill: color-secondary)[#group.items.join(", ")]
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

    // ── EDUCATION & LANGUAGES ────────────────────────────────────────
    #grid(
      columns: (1fr, 1fr),
      gutter: 20pt,
      [
        #if "education" in app and app.education != none and app.education.len() > 0 [
          #classic-heading("Education")
          #for entry in app.education [
            #block(breakable: false)[
              #text(font: font-sans, size: size-title, weight: "bold", fill: color-ink)[#entry.degree] \
              #v(1pt)
              #text(font: font-sans, size: size-body, weight: "semibold", fill: color-secondary)[#entry.institution] \
              #v(1pt)
              #text(font: font-sans, size: size-meta, fill: color-muted)[#entry.period]
              #v(space-entry)
            ]
          ]
        ]
      ],
      [
        #if "languages" in app and app.languages != none and app.languages.len() > 0 [
          #classic-heading("Languages")
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
  ]

  body
}
