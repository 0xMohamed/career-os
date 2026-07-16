# Career OS

> A personal career operating system. One source of truth. Multiple outputs.

Career OS stores professional information once and generates multiple outputs from it. Today, the only output is a Resume PDF. The same source of truth is designed to generate cover letters, portfolios, personal websites, LinkedIn summaries, and more — without ever duplicating content.

The Resume is only one renderer. Typst is only the first rendering engine.

---

## Vision

Career information should never be duplicated.

- Projects should only be described once.
- Experience should only be written once.
- Skills should only exist once.
- Presentation must always be separated from content.

If Typst disappeared tomorrow, the content architecture should survive.

---

## Architecture

The system is organized as a layered pipeline. Dependencies only flow downward.

```
projects/    ←  Reusable professional assets (what each project IS)
    ↓
content/     ←  Personal information (profile, experience, education, languages, skills)
    ↓
profiles/    ←  Job family composition (inactive in Phase 1)
    ↓
applications/ ← Specific job application composition (what to include, in what order)
    ↓
templates/   ←  Rendering (only receives prepared data, knows nothing about content)
    ↓
output/      ←  Generated artifacts (resume.pdf)
```

### Layer Responsibilities

| Layer | Responsibility | Knows about |
|---|---|---|
| `projects/` | What each project IS | Technologies, achievements, links, metadata |
| `content/` | Personal information | Profile, experience, education, languages, skills |
| `profiles/` | Job family composition (Phase 2) | Project ordering, skill emphasis |
| `applications/` | Specific job application | Which content, which projects, which skills |
| `templates/` | Rendering only | Receiving prepared data, visual layout |
| `output/` | Generated artifacts | Nothing — write-only |

---

## Repository Structure

```
career/
├── README.md          # Project documentation
├── CHANGELOG.md       # Release and version history
├── LICENSE            # MIT License
├── package.json       # Project version & script workflows
│
├── projects/          # Reusable professional assets
│   ├── lintu.typ
│   ├── modra.typ
│   ├── oqel.typ
│   ├── basira.typ
│   └── deskby.typ
│
├── content/           # Personal information (Single Source of Truth)
│   ├── profile.typ    # Identity & contact details
│   ├── experience.typ # Employment history & highlights
│   ├── education.typ  # Academic background
│   ├── languages.typ  # Language proficiencies
│   └── skills.typ     # Technical skill categorization
│
├── profiles/          # Job family composition (Phase 2)
│   └── README.md
│
├── applications/      # Specific job applications
│   └── oto.typ        # Active application entry point
│
├── templates/         # Rendering engine
│   ├── resume.typ     # PDF layout template
│   └── theme.typ      # Colors, typography & spacing tokens
│
├── scripts/           # Build & validation tooling
│   ├── build.js       # Typst compile wrapper with --root setup
│   ├── watch.js       # Live reloading typst watcher
│   └── lint.js        # File presence & syntax validator
│
├── assets/            # Static assets (avatars, logos)
└── output/            # Generated artifacts (git-ignored)
```

---

## Typst Setup

Typst is the rendering engine for Phase 1. It is a modern, fast typesetting system.

### macOS (Homebrew)
```bash
brew install typst
```

### Windows (Winget)
```bash
winget install --id Typst.Typst
```

### Cargo (cross-platform)
```bash
cargo install typst-cli
```

### Verify installation
```bash
typst --version
```

---

## Development Workflow

### Install (no dependencies in Phase 1)
```bash
pnpm install
```

### Build resume PDF
```bash
pnpm build
# → output/resume.pdf
```

### Watch for live recompile
```bash
pnpm watch
# Recompiles on every .typ file change
```

### Lint content structure
```bash
pnpm lint
# Checks all required files exist + Typst syntax validation
```

### Clean output
```bash
pnpm clean
```

---

## Design Principles

1. **Single Source of Truth** — Content is written once, never duplicated.
2. **Separation of Concerns** — Content, composition, and rendering are strictly separated.
3. **Content over Presentation** — What you did matters more than how it looks.
4. **Renderer Independence** — Typst is a plugin, not a dependency.
5. **Modularity** — Each layer has one responsibility.
6. **Simplicity First** — If something isn't needed today, don't build it.
7. **Extensible by Design** — The architecture can evolve without rewriting.

---

## How to Add a New Project

1. Create `projects/your-project.typ`
2. Expose the structured dictionary following the enriched schema:
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
     links: (live: "...", github: "...")
   )
   ```
3. Import it in `applications/oto.typ`
4. Add it to the `projects` array in the application composition.
5. Run `pnpm build` to compile.

---

## How to Create a New Application

A new application represents a specific job application or target audience.

1. Create `applications/new-job.typ`
2. Import content and projects from the layers above.
3. Compose the `app` dictionary (select projects, set skill categories, optionally override summary).
4. Pass `app` to `#resume-template(app)`
5. Update `scripts/build.js` to compile the new entry point, or compile directly:
   ```bash
   typst compile --root . applications/new-job.typ output/new-job-resume.pdf
   ```

---

## PDF Metadata Support & Limitations

When compiling, Typst automatically embeds metadata into the generated PDF headers. Currently, the following fields are defined in the template:
- **Title**: `Career OS Resume`
- **Author**: `Mohamed Sayed Seoudy`
- **Keywords**: `Frontend, React, TypeScript, TanStack, Redux Toolkit, Data Visualization`

> [!NOTE]
> **Typst Metadata Limitations**: Typst's `#set document()` rule natively supports `title`, `author`, `keywords`, and `date` configurations. It does not support a dedicated `subject` field. The subject description has been integrated into the `title` and `keywords` metadata to optimize searchability.

---

## The Profiles Layer (Phase 2)

The `profiles/` layer is intentionally empty in Phase 1.

Profiles will be introduced when a second application exists with meaningfully different composition requirements (e.g., frontend-focused vs. systems-focused). At that point, shared composition logic can be extracted from applications into reusable profile files.

See [`profiles/README.md`](profiles/README.md) for full intent documentation.

---

## Future Roadmap

The architecture is open for these future outputs. None of these are implemented.

- [ ] Cover Letter generator
- [ ] Portfolio page generator
- [ ] Personal website generator
- [ ] LinkedIn About section generator
- [ ] HTML renderer (alternative to Typst)
- [ ] Markdown renderer
- [ ] CLI interface
- [ ] AI-assisted application customization
- [ ] Multiple themes
- [ ] Application history and versioning

---

## Philosophy

> Avoid premature abstractions.  
> Avoid enterprise architecture.  
> Avoid solving future problems today.  
> Prefer evolution over speculation.  

Every abstraction in this repository exists because there was a concrete need for it — not because it might be useful someday.
