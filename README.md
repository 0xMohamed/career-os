# Career OS

> A personal career operating system. One source of truth. Multiple outputs.

Career OS stores professional career data once and generates tailored outputs from it. Today, the primary output is an ATS-compliant, print-ready Resume PDF. The same source of truth is designed to generate cover letters, portfolios, personal websites, and LinkedIn summaries — without ever duplicating content.

The Resume is only one renderer. Typst is only the first rendering engine.

---

## Vision

Career information should never be duplicated:

- Projects should only be described once.
- Experience should only be written once.
- Skills should only exist once.
- Presentation must always be separated from content.

If Typst disappeared tomorrow, the core content architecture survives untouched.

---

## Architecture

The system is organized as a layered pipeline. Dependencies only flow downward:

```
projects/     ←  Reusable professional assets (what each project IS)
    ↓
content/      ←  Universal personal information (profile, experience, education, languages, skills)
    ↓
profiles/     ←  Job family composition (Phase 2)
    ↓
applications/ ←  Specific job application composition (what to include, in what order, overrides)
    ↓
templates/    ←  Rendering & layouts (receives prepared data, presentation only)
    ↓
output/       ←  Generated artifacts (resume.pdf, resume-siemens.pdf)
```

### Layer Responsibilities

| Layer | Responsibility | Knows about |
|---|---|---|
| `projects/` | What each project IS | Technologies, achievements, links, metadata |
| `content/` | Universal personal information | Profile, experience, education, languages, skills, career trajectory |
| `profiles/` | Job family composition (Phase 2) | Project ordering, skill emphasis across a discipline |
| `applications/` | Specific job application | Selection, ordering, tailored overrides, layout choice |
| `templates/` | Rendering engine | Layout templates, design tokens, typography |
| `scripts/` | Dynamic build & validation tooling | Generic discovery, compilation, linting, and ATS tests |
| `output/` | Generated artifacts | Nothing — write-only |

---

## Repository Structure

```
career/
├── README.md          # Project documentation
├── CHANGELOG.md       # Release and version history
├── LICENSE            # MIT License
├── package.json       # Tooling scripts and engine definitions
│
├── projects/          # Reusable professional assets (Source of Truth)
│   ├── lintu.typ
│   ├── modra.typ
│   ├── oqel.typ
│   ├── basira.typ
│   ├── deskby.typ
│   └── cargolab.typ
│
├── content/           # Universal personal information (Source of Truth)
│   ├── profile.typ    # Identity & contact details
│   ├── experience.typ # Employment history & highlights
│   ├── education.typ  # Academic background
│   ├── languages.typ  # Language proficiencies
│   ├── skills.typ     # Technical skill categorization
│   ├── strengths.typ  # Core engineering competencies
│   └── career-direction.typ # Strategic positioning & targeted summaries
│
├── profiles/          # Job family composition (Phase 2)
│   └── README.md
│
├── applications/      # Specific application compositions
│   ├── master.typ     # Canonical master resume
│   └── siemens.typ    # Tailored Siemens application variant
│
├── templates/         # Rendering engine & layouts
│   ├── resume.typ     # Template entry & layout dispatcher
│   ├── theme.typ      # Design tokens (colors, typography, spacing)
│   └── layouts/       # Presentation layouts
│       ├── editorial.typ # Modern two-column layout
│       ├── standard.typ  # Clean single-column layout
│       └── classic.typ   # Conservative monochrome single-column layout
│
├── scripts/           # Generic build & test tooling
│   ├── config.js      # Shared paths & dynamic discovery helpers
│   ├── build.js       # Generic Typst compiler
│   ├── watch.js       # Live-reloading watcher
│   ├── lint.js        # Dynamic content & syntax validator
│   └── verify-ats.js  # Generic ATS compatibility test suite
│
├── assets/            # Static assets (logos, avatars)
└── output/            # Generated PDF artifacts (git-ignored)
```

---

## Layout Options

Career OS provides three built-in layout engines out of the box:

1. **`editorial`** (Default): Modern two-column layout with visual accents, monogram initials badge, and balanced parallel sidebars. Best for creative, product, and modern tech roles.
2. **`standard`**: Modern full-width single-column layout with clean horizontal divider rules, high-density 2-column competencies grid, and tabular skills matrix.
3. **`classic`**: Conservative, traditional monochrome single-column layout with standard text delimiters, left-aligned header, and zero decorative color treatment. Designed for maximum ATS parsing certainty in traditional enterprise environments.

---

## Typst Setup

Typst is the rendering engine. It is a modern, fast typesetting system written in Rust.

### macOS (Homebrew)
```bash
brew install typst
```

### Windows (Winget)
```bash
winget install --id Typst.Typst
```

### Cargo (Cross-platform)
```bash
cargo install typst-cli
```

### Verify installation
```bash
typst --version
```

---

## Development Workflow

### Install
```bash
pnpm install
```

### Build Resumes

```bash
# Compile canonical resume (master @ editorial) → output/resume.pdf
pnpm build

# Compile all applications and all layout variants
pnpm build:all

# Compile a specific application using its default layout
pnpm build -- siemens
# → compiles applications/siemens.typ → output/resume-siemens.pdf

# Compile an application with a specific layout override
pnpm build -- master standard
# → compiles applications/master.typ @ standard → output/single.pdf

pnpm build -- master classic
# → compiles applications/master.typ @ classic → output/classic.pdf
```

### Watch Mode (Live Recompile)

```bash
# Watch canonical master resume
pnpm watch

# Watch a specific application variant
pnpm watch -- siemens
```

### Lint & Structural Validation

Checks that all core content, template, project, and application files exist, and dry-compiles all discovered applications to ensure zero syntax errors:

```bash
pnpm lint
```

### ATS Compatibility Verification

Runs cross-platform PDF text extraction, contact validation, structural heading checks, technical keyword verification, and hyperlink checks using Mozilla's `pdfjs-dist` (pure Node.js, zero macOS/Swift dependencies):

```bash
# Verify all generated PDFs
pnpm test:ats

# Verify a specific application or PDF
node scripts/verify-ats.js siemens
node scripts/verify-ats.js resume.pdf
```

### Phone Privacy & Contact Configuration

By default, Career OS compiles resumes with a safe placeholder so personal phone numbers are never committed to public repositories.

To inject your real phone number into the generated output:

1. **Environment Variable (Recommended):**
   ```bash
   CAREER_PHONE="+1 555 123 4567" pnpm build:all
   ```
2. **Local Config (`private.json`):**
   Create a local, git-ignored `private.json` in the project root:
   ```json
   {
     "phone": "+1 555 123 4567"
   }
   ```
   The build and watch scripts automatically read this file if present.

### Clean Output

```bash
pnpm clean
```

---

## How to Add a New Project

1. Create `projects/your-project.typ`.
2. Export a structured dictionary following the project schema:
   ```typst
   #let your-project = (
     title: "...",
     role: "...",
     company: "...",
     type: "...",
     status: "...",
     period: "...",
     team_size: "...",
     summary: "...",
     technologies: ("...", "..."),
     achievements: ("...", "..."),
     tags: ("...", "..."),
     links: (live: "...", github: "..."),
   )
   ```
3. Import the project in `applications/master.typ` (and any tailored application that requires it).
4. Run `pnpm lint` and `pnpm build`.

---

## How to Create a New Application Variant

A new application represents a specific job application or target company.

Applications are **configuration-driven and automatically discovered**:
- You do **not** need to edit `scripts/build.js`, `scripts/lint.js`, or `scripts/verify-ats.js`.
- Simply creating `applications/<name>.typ` automatically registers it with the entire build, lint, watch, and ATS test pipeline.

### Steps:

1. Create `applications/<company>.typ` (e.g. `applications/stripe.typ`).
2. Import canonical content and projects:
   ```typst
   #import "../content/profile.typ": profile
   #import "../content/experience.typ": experience
   #import "../content/education.typ": education
   #import "../content/languages.typ": languages
   #import "../content/skills.typ": skills
   #import "../projects/lintu.typ": lintu
   #import "../projects/modra.typ": modra
   ```
3. Compose the application:
   ```typst
   #let app = (
     layout: "classic", // "editorial" | "standard" | "classic"
     profile: (..profile, tagline: "Tailored Headline"),
     projects: (lintu, modra),
     experience: experience,
     education: education,
     languages: languages,
     skills: skills,
   )

   #import "../templates/resume.typ": resume-template
   #resume-template(app, layout: "classic")
   ```
4. Build and verify:
   ```bash
   pnpm build -- stripe
   # → generates output/resume-stripe.pdf

   node scripts/verify-ats.js stripe
   # → verifies ATS extractability
   ```

---

## Design Principles

1. **Single Source of Truth** — Content is written once, never duplicated.
2. **Separation of Concerns** — Universal content, application composition, and presentation templates are strictly segregated.
3. **Zero Hardcoded Registry** — Applications and projects are discovered dynamically from the filesystem.
4. **Content over Presentation** — What you built and delivered matters more than decorative styling.
5. **Renderer Independence** — Typst is a rendering plugin; the content architecture survives even if the typesetting engine changes.
6. **Simplicity First** — Avoid enterprise over-engineering; build clean, predictable, extensible conventions.
7. **Zero Hallucination** — Resumes represent 100% verified, documented technical accomplishments.

---

## License

[MIT](LICENSE) © 2026 Mohamed Sayed Seoudy
