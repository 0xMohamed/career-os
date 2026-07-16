# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-07-17

### Added
- **Repository Architecture**: Established a 6-layer decoupled structure: `projects`, `content`, `profiles` (future placeholder), `applications`, `templates`, and `output`.
- **Typst Integration**: Selected Typst as the initial high-performance layout engine, integrated with a `--root` boundary setup.
- **Modular Templates**: Separate `resume.typ` (the template renderer) and `theme.typ` (the color and typographic design system tokens).
- **Structured Content**: Extracted `profile.typ`, `experience.typ`, `education.typ`, and `languages.typ` representing the single source of truth for identity and career data.
- **Single Source of Truth for Skills**: Organized all expertise fields inside `content/skills.typ`.
- **Applications Layer**: Created lightweight configuration entry `applications/oto.typ` to orchestrate which projects and skills render in what order.
- **Enriched Project Metadata**: Extended project definitions with fields like `company`, `team_size`, and direct links (`live`, `github`).
- **Interactive PDF Outputs**: Enabled proper clickable hyperlinks for contact details (Email, Portfolio, GitHub, LinkedIn) and project titles.
- **Developer Workflow**: Configured scripts with `pnpm` (`build`, `watch`, `lint`, and `clean`) using thin Node.js wrapper scripts.
- **Lint Script**: Enabled a syntax check on Typst compilation + content files directory lookup.
- **Documentation**: Provided a detailed `README.md` and `profiles/README.md` explaining layout structure and how to extend/scale.
