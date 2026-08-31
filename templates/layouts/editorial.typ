// templates/layouts/editorial.typ
//
// Editorial Layout — Two-Column Presentation for Career OS.
//
// Modern, high-density editorial resume layout with parallel scanning:
//   - Left column (58%): Experience and Projects
//   - Right column (42%): Summary, Key Strengths, Education, Skills, Languages

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

#let render-editorial(app, p, section-heading, meta-text, dotted-divider, bullet) = {
  let left-col = [
    // ── EXPERIENCE ───────────────────────────────────────────────────
    #if "experience" in app and app.experience != none and app.experience.len() > 0 [
      #section-heading("Experience")
      #for entry in app.experience [
        #block(breakable: false)[
          #text(font: font-sans, size: size-title, weight: "bold", fill: color-ink)[#entry.role]
          #h(3pt)
          #if "link" in entry and entry.link != none and entry.link != "" [
            #let entry-url = normalize-url(entry.link)
            #text(font: font-sans, size: size-title, weight: "medium", fill: color-secondary)[· #link(entry-url)[#entry.company]]
          ] else [
            #text(font: font-sans, size: size-title, weight: "medium", fill: color-secondary)[· #entry.company]
          ]
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
          #if target-link != none [
            #let url = normalize-url(target-link)
            #link(url)[#text(font: font-sans, size: size-title, weight: "bold", fill: color-ink)[#proj.title]]
          ] else [
            #text(font: font-sans, size: size-title, weight: "bold", fill: color-ink)[#proj.title]
          ]
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

    // ── SKILLS ─────────────────────────────────────────────────────
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

    // ── LANGUAGES ──────────────────────────────────────────────────
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
