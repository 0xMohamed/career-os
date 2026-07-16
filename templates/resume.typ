// templates/resume.typ
//
// The resume renderer for Career OS.
//
// This template receives a fully prepared `app` dictionary from the
// application layer and renders it. It knows nothing about:
//   - companies or job applications
//   - project selection logic
//   - business rules or prioritization
//
// It only renders what it receives.
//
// Changing visual layout: edit this file.
// Changing content: edit content/, projects/, or applications/.
// Changing visual design: edit theme.typ.

#import "theme.typ": *

// ── Page setup ───────────────────────────────────────────────────────

#let resume-template(app) = {
  set document(
    title: app.profile.name + " — Resume",
    author: app.profile.name,
  )

  set page(
    paper: "a4",
    margin: (x: 1.6cm, y: 1.4cm),
  )

  set text(
    font: font-body,
    size: size-body,
    fill: color-ink,
    hyphenate: false,
  )

  set par(
    justify: true,
    leading: 0.55em,
  )

  // ── Helper: section heading ─────────────────────────────────────────
  let section-heading(label) = {
    v(space-section)
    text(
      font: font-sans,
      size: size-section,
      weight: "semibold",
      fill: color-accent,
      upper(label),
    )
    v(1.5pt)
    line(length: 100%, stroke: 0.5pt + color-rule)
    v(space-inner)
  }

  // ── Helper: meta line (dates, location) ────────────────────────────
  let meta-text(content) = text(
    font: font-sans,
    size: size-meta,
    fill: color-muted,
    content,
  )

  // ── Helper: skill tag ──────────────────────────────────────────────
  let skill-tag(label) = box(
    fill: color-tag-bg,
    inset: (x: 5pt, y: 2.5pt),
    radius: 2pt,
    text(
      font: font-mono,
      size: size-small - 0.5pt,
      fill: color-tag-fg,
      label,
    ),
  )

  // ════════════════════════════════════════════════════════════════════
  // HEADER
  // ════════════════════════════════════════════════════════════════════
  let p = app.profile
  grid(
    columns: (1fr, auto),
    gutter: 8pt,
    // Left: name + title
    align(left)[
      #text(
        font: font-sans,
        size: size-name,
        weight: "bold",
        fill: color-ink,
        p.name,
      )
      #v(2pt)
      #text(
        font: font-sans,
        size: size-title,
        fill: color-secondary,
        p.title,
      )
    ],
    // Right: contact info
    align(right + horizon)[
      #set text(font: font-sans, size: size-meta, fill: color-muted)
      #p.email \
      #link("https://" + p.website)[#text(fill: color-accent)[#p.website]] \
      #link("https://" + p.github)[#text(fill: color-accent)[#p.github]] \
      #p.location
    ],
  )

  // Summary
  v(8pt)
  text(
    font: font-sans,
    size: size-body,
    fill: color-secondary,
    style: "italic",
    p.summary,
  )

  // ════════════════════════════════════════════════════════════════════
  // EXPERIENCE
  // ════════════════════════════════════════════════════════════════════
  section-heading("Experience")

  for entry in app.experience {
    // Entry header row
    grid(
      columns: (1fr, auto),
      grid.cell(align: left)[
        #text(font: font-sans, size: size-body, weight: "semibold")[#entry.company]
        #h(6pt)
        #text(font: font-sans, size: size-body, fill: color-secondary)[#entry.role]
      ],
      grid.cell(align: right)[
        #meta-text[#entry.period · #entry.location]
      ],
    )
    v(space-tight)

    // Highlights
    for bullet in entry.highlights {
      grid(
        columns: (8pt, 1fr),
        gutter: 3pt,
        text(fill: color-accent)[–],
        text(size: size-body)[#bullet],
      )
      v(space-tight)
    }
    v(space-entry)
  }

  // ════════════════════════════════════════════════════════════════════
  // PROJECTS
  // ════════════════════════════════════════════════════════════════════
  section-heading("Projects")

  for proj in app.projects {
    // Project header
    grid(
      columns: (1fr, auto),
      grid.cell(align: left)[
        #text(font: font-sans, size: size-body, weight: "semibold")[#proj.title]
        #h(5pt)
        #text(font: font-sans, size: size-small, fill: color-muted)[#proj.role]
      ],
      grid.cell(align: right)[
        #meta-text[#proj.period]
      ],
    )
    v(space-tight)

    // Technologies (compact, monospace row)
    text(
      font: font-mono,
      size: size-small,
      fill: color-muted,
      proj.technologies.join(" · "),
    )
    v(space-tight)

    // Summary sentence
    text(size: size-body, style: "italic", fill: color-secondary)[#proj.summary]
    v(space-tight)

    // Top 2 achievements to keep resume tight
    let top-achievements = proj.achievements.slice(0, calc.min(2, proj.achievements.len()))
    for bullet in top-achievements {
      grid(
        columns: (8pt, 1fr),
        gutter: 3pt,
        text(fill: color-accent)[–],
        text(size: size-body)[#bullet],
      )
      v(space-tight)
    }
    v(space-entry)
  }

  // ════════════════════════════════════════════════════════════════════
  // SKILLS
  // ════════════════════════════════════════════════════════════════════
  section-heading("Skills")

  for group in app.skills {
    grid(
      columns: (70pt, 1fr),
      gutter: 4pt,
      grid.cell(align: left + top)[
        #text(font: font-sans, size: size-small, weight: "medium", fill: color-secondary)[#group.category]
      ],
      grid.cell[
        // Skill tags are inline boxes — they wrap naturally in paragraph flow.
        #for skill in group.items {
          skill-tag(skill)
          h(3pt)
        }
      ],
    )
    v(5pt)
  }

  // ════════════════════════════════════════════════════════════════════
  // EDUCATION
  // ════════════════════════════════════════════════════════════════════
  section-heading("Education")

  for entry in app.education {
    grid(
      columns: (1fr, auto),
      grid.cell(align: left)[
        #text(font: font-sans, size: size-body, weight: "semibold")[#entry.institution]
        #h(5pt)
        #text(font: font-sans, size: size-body, fill: color-secondary)[#entry.degree]
      ],
      grid.cell(align: right)[
        #meta-text[#entry.period]
      ],
    )
    if "notes" in entry {
      v(space-tight)
      text(size: size-body, fill: color-secondary, style: "italic")[#entry.notes]
    }
    v(space-entry)
  }

  // ════════════════════════════════════════════════════════════════════
  // LANGUAGES
  // ════════════════════════════════════════════════════════════════════
  section-heading("Languages")

  grid(
    columns: app.languages.len() * (80pt,),
    gutter: 8pt,
    ..app.languages.map(lang =>
      grid.cell[
        #text(font: font-sans, size: size-body, weight: "semibold")[#lang.name]
        #h(4pt)
        #text(font: font-sans, size: size-small, fill: color-muted)[#lang.level]
      ]
    )
  )
}
