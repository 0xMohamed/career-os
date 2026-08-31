// templates/resume.typ
//
// The resume template router and shell for Career OS.
//
// Responsibilities:
//   - Document metadata and page configuration
//   - Universal typography and spacing setup
//   - Layout dispatching based on CLI sys.inputs, app configuration, or layout parameter:
//       • "editorial" (default / two-column) → layouts/editorial.typ
//       • "standard"  (single-column)       → layouts/standard.typ
//       • "classic"   (traditional single)  → layouts/classic.typ

#import "theme.typ": *
#import "layouts/editorial.typ": render-editorial
#import "layouts/standard.typ": render-standard
#import "layouts/classic.typ": render-classic

#let resume-template(app, layout: "editorial") = {
  let p = app.profile

  // Layout resolution priority:
  // 1. CLI input: --input layout=<name>
  // 2. Application dictionary: app.layout
  // 3. Template argument: layout (default: "editorial")
  let raw-layout = if "layout" in sys.inputs {
    sys.inputs.at("layout")
  } else if "layout" in app and app.layout != none and app.layout != "" {
    app.layout
  } else {
    layout
  }

  let selected-layout = if raw-layout in ("classic", "traditional", "conservative", "minimal") {
    "classic"
  } else if raw-layout in ("standard", "one-column", "single-column", "single", "1-column") {
    "standard"
  } else {
    "editorial"
  }

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
  // HEADER (Shared across modern layouts: editorial & standard)
  // ════════════════════════════════════════════════════════════════════
  let display-tagline = if "tagline" in p and p.tagline != none and p.tagline != "" {
    p.tagline
  } else {
    p.title
  }

  let name-parts = p.name.split(" ")
  let initials = if name-parts.len() >= 2 {
    name-parts.at(0).slice(0, 1) + name-parts.at(-1).slice(0, 1)
  } else {
    p.name.slice(0, 1)
  }

  let modern-header = grid(
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
      #if "phone" in p and p.phone != none and p.phone != "" [
        #let clean-phone = p.phone.replace(" ", "")
        #link("tel:" + clean-phone)[#icon-phone #h(2pt) #p.phone]
        #h(6.5pt)
      ]
      #link("mailto:" + p.email)[#icon-mail #h(2pt) #p.email]
      #h(6.5pt)
      #link("https://" + p.website)[#icon-link #h(2pt) #p.website]
      #h(6.5pt)
      #if "github" in p and p.github != none and p.github != "" [
        #link("https://" + p.github)[#icon-github #h(2pt) GitHub · 0xMohamed]
        #h(6.5pt)
      ]
      #if "linkedin" in p and p.linkedin != none and p.linkedin != "" [
        #link("https://" + p.linkedin)[#icon-linkedin #h(2pt) LinkedIn · 0xMohamed]
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

  // ════════════════════════════════════════════════════════════════════
  // LAYOUT DISPATCH
  // ════════════════════════════════════════════════════════════════════
  if selected-layout == "classic" {
    render-classic(app, p, section-heading, meta-text, dotted-divider, bullet)
  } else if selected-layout == "standard" {
    modern-header
    v(3pt)
    render-standard(app, p, section-heading, meta-text, dotted-divider, bullet)
  } else {
    modern-header
    v(3pt)
    render-editorial(app, p, section-heading, meta-text, dotted-divider, bullet)
  }
}
