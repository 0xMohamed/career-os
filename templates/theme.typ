// templates/theme.typ
//
// The design system for Career OS resume output.
//
// This is the ONLY place where visual design decisions live.
// Colors, fonts, spacing, and typographic scale are defined here
// and referenced everywhere else in the template layer.
//
// The content layer never imports from here.
// Applications never import from here.
// Only templates use theme.typ.

// ── Typography ───────────────────────────────────────────────────────
// Universal system sans-serif fonts across macOS, Linux, and Windows.

#let font-sans    = ("Helvetica Neue", "Helvetica", "Arial")
#let font-mono    = ("Menlo", "Courier New", "Courier")

// Typographic scale
#let size-name    = 21pt
#let size-tagline = 9.2pt
#let size-section = 9.2pt
#let size-title   = 8.8pt
#let size-body    = 8.2pt
#let size-small   = 7.6pt
#let size-meta    = 7.4pt

// ── Color palette ────────────────────────────────────────────────────

#let color-ink       = rgb("#0f172a")   // Primary text & solid section rules
#let color-secondary = rgb("#334155")   // Secondary text, roles, summary
#let color-muted     = rgb("#64748b")   // Metadata, dates, locations
#let color-accent    = rgb("#1d4ed8")   // Professional blue: tagline, categories, highlights
#let color-rule      = rgb("#e2e8f0")   // Subtle dotted dividers
#let color-rule-dark = rgb("#0f172a")   // Solid section underline
#let color-underline = rgb("#94a3b8")   // Subtle skill underlines

// ── Spacing (High Density with Calm Readability) ──────────────────────

#let space-section   = 9.5pt // Between major sections
#let space-entry     = 6.5pt // Between entries within a section
#let space-inner     = 2.5pt // Within an entry (title → bullets)
#let space-tight     = 1.5pt // Tight vertical rhythm

// ── Vector Line Icons (Zero-dependency, ATS-safe, 2px uniform stroke) ─

#let svg-icon(svg-str, color: "#64748b", width: 7.5pt, height: 7.5pt, baseline: 12%) = {
  let content = svg-str.replace("STROKE_COLOR", color)
  box(baseline: baseline, width: width, height: height)[
    #image(bytes(content), format: "svg", width: width, height: height)
  ]
}

#let icon-mail = svg-icon(
  "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" width=\"24\" height=\"24\" fill=\"none\" stroke=\"STROKE_COLOR\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><rect width=\"20\" height=\"16\" x=\"2\" y=\"4\" rx=\"2\"/><path d=\"m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7\"/></svg>",
  baseline: 12%,
)

#let icon-link = svg-icon(
  "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" width=\"24\" height=\"24\" fill=\"none\" stroke=\"STROKE_COLOR\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><path d=\"M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71\"/><path d=\"M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71\"/></svg>",
  baseline: 14%,
)

#let icon-github = svg-icon(
  "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" width=\"24\" height=\"24\" fill=\"none\" stroke=\"STROKE_COLOR\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><path d=\"M15 22v-4a4.8 4.8 0 0 0-1-3.5c3 0 6-2 6-5.5.08-1.25-.27-2.48-1-3.5.28-1.15.28-2.35 0-3.5 0 0-1 0-3 1.5-2.64-.5-5.36-.5-8 0C6 2 5 2 5 2c-.3 1.15-.3 2.35 0 3.5A5.403 5.403 0 0 0 4 9c0 3.5 3 5.5 6 5.5-.39.49-.68 1.05-.85 1.65-.17.6-.22 1.23-.15 1.85v4\"/><path d=\"M9 18c-4.51 2-5-2-7-2\"/></svg>",
  baseline: 12%,
)

#let icon-linkedin = svg-icon(
  "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" width=\"24\" height=\"24\" fill=\"none\" stroke=\"STROKE_COLOR\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><path d=\"M16 8a6 6 0 0 1 6 6v7h-4v-7a2 2 0 0 0-2-2 2 2 0 0 0-2 2v7h-4v-7a6 6 0 0 1 6-6z\"/><rect width=\"4\" height=\"12\" x=\"2\" y=\"9\"/><circle cx=\"4\" cy=\"4\" r=\"2\"/></svg>",
  baseline: 12%,
)

#let icon-location = svg-icon(
  "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" width=\"24\" height=\"24\" fill=\"none\" stroke=\"STROKE_COLOR\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><path d=\"M20 10c0 4.993-5.539 10.193-7.399 11.799a1 1 0 0 1-1.202 0C9.539 20.193 4 14.993 4 10a8 8 0 0 1 16 0\"/><circle cx=\"12\" cy=\"10\" r=\"3\"/></svg>",
  baseline: 14%,
)

#let icon-calendar = svg-icon(
  "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" width=\"24\" height=\"24\" fill=\"none\" stroke=\"STROKE_COLOR\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><path d=\"M8 2v4\"/><path d=\"M16 2v4\"/><rect width=\"18\" height=\"18\" x=\"3\" y=\"4\" rx=\"2\"/><path d=\"M3 10h18\"/></svg>",
  baseline: 14%,
)

#let icon-gem = svg-icon(
  "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" width=\"24\" height=\"24\" fill=\"none\" stroke=\"STROKE_COLOR\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><path d=\"M6 3h12l4 6-10 13L2 9Z\"/><path d=\"M11 3 8 9l4 13 4-13-3-6\"/><path d=\"M2 9h20\"/></svg>",
  color: "#1d4ed8",
  width: 8pt,
  height: 8pt,
  baseline: 12%,
)
