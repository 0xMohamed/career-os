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
// Using system fonts available on macOS/Windows without installation.
// macOS: Charter (serif), Helvetica Neue (sans), Menlo (mono)
// Windows fallback: Georgia, Arial, Courier New

#let font-body    = ("Charter", "Georgia", "Times New Roman")
#let font-sans    = ("Helvetica Neue", "Helvetica", "Arial")
#let font-mono    = ("Menlo", "Courier New", "Courier")

// Typographic scale
#let size-name    = 22pt
#let size-title   = 10pt
#let size-section = 9.5pt
#let size-body    = 9pt
#let size-small   = 8pt
#let size-meta    = 7.8pt

// ── Color palette ────────────────────────────────────────────────────

#let color-ink       = rgb("#1a1a1a")   // Primary text
#let color-secondary = rgb("#4a4a4a")   // Secondary text, roles
#let color-muted     = rgb("#7a7a7a")   // Meta, dates, locations
#let color-accent    = rgb("#1d4ed8")   // Links, section headers
#let color-rule      = rgb("#e0e0e0")   // Dividers
#let color-tag-bg    = rgb("#f0f4ff")   // Skill tag backgrounds
#let color-tag-fg    = rgb("#2563eb")   // Skill tag text

// ── Spacing ──────────────────────────────────────────────────────────

#let space-section   = 14pt  // Between major sections
#let space-entry     = 8pt   // Between entries within a section
#let space-inner     = 4pt   // Within an entry (role → bullets)
#let space-tight     = 2pt   // Tight vertical rhythm
