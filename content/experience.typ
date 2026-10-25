// content/experience.typ
//
// Professional experience — the single source of truth for work history.
// No layout, no rendering. Only structured data.
//
// Each entry exposes:
//   company     — employer name
//   role        — job title
//   period      — employment dates
//   location    — office or remote
//   link        — optional website/live product link
//   summary     — short description of position responsibilities
//   highlights  — array of accomplishment bullets (structured or string)

#let experience = (
  (
    company:   "Summa",
    role:      "Founder & Product Engineer",
    link:      "https://summa.cyou/",
    period:    "Aug 2026 — Present",
    location:  "Remote",
    summary:   "Building a full-stack document platform in a monorepo, with a Studio for authoring content, a server-rendered public viewer, and an API layer.",
    highlights: (
      (
        id: "summa-leadership",
        statement: "Defined shared TypeScript contracts and Zod schemas for document nodes and commands, keeping data structures consistent across the authoring app, API, and viewer.",
        method: "Separated administrative Project aggregates from Document composition roots, enforcing transactional mutations through command schemas and Hono REST endpoints.",
        outcome: "Created decoupled application boundaries between the Studio editor workspace, headless API services, and a Server-Driven UI runtime for public SSR Viewer presentation.",
        metric: "11 monorepo packages across apps/ and packages/",
        evidence: "summa/packages/domain/DOMAIN_MODEL.md & platform-architecture.md",
        skills: ("TypeScript", "React", "Node.js", "Hono", "Server-Driven UI", "Monorepos", "Turborepo", "pnpm Workspaces", "PostgreSQL", "Zod"),
        tags: ("architecture", "backend", "fullstack", "contracts"),
      ),
      (
        id: "summa-testing",
        statement: "Established automated test coverage with 81 Vitest test suites and 3 Playwright end-to-end journeys across Studio and Viewer.",
        method: "Authored isolated unit suites for engine mutations, layout calculations, and schema validators alongside browser-level E2E tests for canvas hydration and sticky storytelling.",
        outcome: "Provided comprehensive automated regression coverage across core document mutation and rendering pipelines.",
        metric: "81 Vitest test suites, 3 Playwright CUJs",
        evidence: "summa/docs/architecture/TESTING_CONVENTIONS.md & e2e/*.spec.ts",
        skills: ("Vitest", "Playwright", "GitHub Actions", "Docker", "Architecture & Engineering"),
        tags: ("testing", "engineering-practices", "quality"),
      ),
      (
        id: "summa-frontend",
        statement: "Developed scalable UI component foundations and a container-query layout engine using React, TypeScript, Tailwind CSS, and shadcn/ui accessible primitives.",
        method: "Composed layout reflow logic using CSS Container Queries (cqi) and integrated shadcn/ui modal and dock primitives with custom design tokens, decoupling UI controls from core canvas state.",
        outcome: "Delivered responsive canvas layouts that adapt cleanly to varying viewport widths without manual resize listeners.",
        metric: "Container-query based layout geometry with shadcn/ui primitives",
        evidence: "summa/docs/architecture/RESPONSIVE_FOUNDATION_V1.md & layout-engine.md",
        skills: ("React", "TypeScript", "Tailwind CSS", "shadcn/ui", "Component Architecture"),
        tags: ("frontend", "ui", "components"),
      ),
    ),
  ),
  (
    company:   "Lintu",
    role:      "Frontend Engineer",
    link:      "https://lintu.io",
    period:    "Jan 2023 — Dec 2025",
    location:  "Giza, Egypt",
    summary:   "Co-founded Lintu, a data-storytelling platform designed for creating interactive reports and visual stories, and led frontend engineering for the editor and public viewer.",
    highlights: (
      (
        id: "lintu-stewardship",
        statement: "Replaced deeply nested editor state with four normalized Redux Toolkit entity stores for projects, pages, sections, and nodes, using Immer patches to support undo/redo without copying the full document state.",
        method: "Designed four normalized entity stores (project, pages, sections, nodes) with memoized selectors and transactional thunks recording forward and inverse patches without full-state snapshots.",
        outcome: "Maintained deterministic state updates, O(1) entity lookups, and reliable multi-step history across complex document structures.",
        metric: "4 normalized entity adapter stores with patch-based undo/redo history",
        evidence: "lintu.io/frontend/src/features/editor/model/entities/ & store/history/",
        skills: ("Redux Toolkit", "TypeScript", "Immer", "State Management", "React"),
        tags: ("state-management", "architecture", "frontend", "contracts"),
      ),
      (
        id: "lintu-loading",
        statement: "Separated editor and public-viewer routes and lazy-loaded Mapbox GL and Three.js features, so heavy mapping and 3D modules loaded only when needed.",
        method: "Configured route chunking in Vite/React Router and wrapped geospatial modules (Mapbox GL, Three.js) in lazy dynamic imports, deferring bundle download until map visual nodes mount.",
        outcome: "Prevented heavy geospatial and 3D rendering libraries from inflating the initial application bundle and server-driven viewer page load.",
        metric: "Route-level chunk splitting and on-demand geospatial module loading",
        evidence: "lintu.io/frontend/src/app/router.tsx & map-visual-node.ts",
        skills: ("React Router", "Vite", "React", "TypeScript", "Performance Optimization", "Component Architecture", "Server-Driven UI", "Mapbox GL", "Three.js"),
        tags: ("frontend", "architecture", "performance"),
      ),
      (
        id: "lintu-composite-chart",
        statement: "Engineered a scene-driven Composite Chart engine for line, bar, area, and scatter visualizations, preventing stale SVG marks from accumulating across scene transitions through explicit replace/overlay rendering modes and validated axis scales.",
        method: "Implemented Zod mark schemas with explicit replace and overlay rendering strategies, validating shared axis scale types (linear, log, categorical) and clearing previous SVG marks on transitions.",
        outcome: "Prevented stale mark accumulation and visual clipping artifacts across multi-scene narrative presentations, delivering predictable cross-layer comparisons.",
        metric: "Multi-mark visual engine (line, bar, area, scatter) with explicit scene lifecycle",
        evidence: "lintu.io/frontend/ARCHITECTURAL_DESIGN_COMPOSITE_CHART.md & composite-chart-visual-node.ts",
        skills: ("D3.js", "Visx", "SVG", "Zod", "Data Visualization", "TypeScript"),
        tags: ("data-visualization", "frontend", "architecture", "contracts"),
      ),
    ),
  ),
  (
    company:   "Contract Projects",
    role:      "Frontend Developer",
    period:    "Feb 2022 — Dec 2022",
    location:  "Hybrid · Giza, Egypt",
    summary:   "Contributed to client-facing frontend prototypes and data visualization work through contract engagements.",
    highlights: (
      (
        id: "mvp-prototyping",
        statement: "Built custom chart prototypes with React, JavaScript, and p5.js, translating bespoke visual concepts into interactive data visualizations beyond standard chart-library configurations.",
        method: "Composed Visx hierarchy and responsive scale packages with Redux Toolkit state stores to create modular charting widgets.",
        outcome: "Delivered interactive dashboard prototypes supporting dynamic visual filtering and multi-resolution rendering.",
        metric: "Custom chart prototypes with p5.js and React",
        evidence: "command_center-master/package.json (@visx/* 11 packages)",
        skills: ("React", "JavaScript", "Redux Toolkit", "Visx", "D3.js", "p5.js"),
        tags: ("frontend", "data-visualization", "ui"),
      ),
      (
        id: "csv-parsing",
        statement: "Collaborated with a backend developer on a large-screen dashboard MVP where users imported CSV files, mapped columns to custom charts, and arranged visualizations in a grid; used PapaParse and code splitting for on-demand chart loading.",
        method: "Integrated PapaParse file stream parsing with structured table viewers and Visx charting components.",
        outcome: "Enabled immediate client-side data exploration from uploaded CSV files without backend processing overhead.",
        metric: "Client-side tabular parsing and chart projection",
        evidence: "command_center-master/package.json (papaparse, react-csv)",
        skills: ("REST APIs", "CSS Modules", "Responsive Design", "Cross-Browser Compatibility"),
        tags: ("frontend", "contracts", "responsive"),
      ),
    ),
  ),
)
