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
    summary:   "Leading full-stack platform architecture and engineering for an interactive document platform under active development, establishing monorepo package boundaries, engine contracts, and automated testing.",
    highlights: (
      (
        id: "summa-leadership",
        statement: "Architecting the full-stack platform across an 11-package Turborepo monorepo, establishing Domain-Driven Design service boundaries, shared Zod contracts, and Node.js backend services with PostgreSQL.",
        method: "Separated administrative Project aggregates from Document composition roots, enforcing transactional mutations through command schemas and Hono REST endpoints.",
        outcome: "Created decoupled application boundaries between the Studio editor workspace, headless API services, and a Server-Driven UI runtime for public SSR Viewer presentation.",
        metric: "11 monorepo packages across apps/ and packages/",
        evidence: "summa/packages/domain/DOMAIN_MODEL.md & platform-architecture.md",
        skills: ("TypeScript", "React", "Node.js", "Hono", "Server-Driven UI", "Monorepos", "Turborepo", "PostgreSQL", "Zod"),
        tags: ("architecture", "backend", "fullstack", "contracts"),
      ),
      (
        id: "summa-testing",
        statement: "Established engineering test automation by implementing 81 Vitest test suites and 3 Playwright end-to-end Critical User Journeys across editor and viewer application runtimes.",
        method: "Authored isolated unit suites for engine mutations, layout calculations, and schema validators alongside browser-level E2E tests for canvas hydration and sticky storytelling.",
        outcome: "Provided comprehensive automated regression coverage across core document mutation and rendering pipelines.",
        metric: "81 Vitest test suites, 3 Playwright CUJs",
        evidence: "summa/docs/architecture/TESTING_CONVENTIONS.md & e2e/*.spec.ts",
        skills: ("Vitest", "Playwright", "Engineering Practices"),
        tags: ("testing", "engineering-practices", "quality"),
      ),
      (
        id: "summa-frontend",
        statement: "Engineered scalable UI component foundations and a container-query layout engine using React, TypeScript, Tailwind CSS, and shadcn/ui accessible primitives.",
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
    summary:   "Co-founded and directed frontend architecture, state management, and component systems for Lintu, an interactive data visualization and storytelling platform.",
    highlights: (
      (
        id: "lintu-stewardship",
        statement: "Co-founded Lintu and led frontend architecture, structuring normalized client state across document entities using Redux Toolkit entity adapters and Immer JSON patches for patch-based undo/redo history.",
        method: "Designed four normalized entity stores (project, pages, sections, nodes) with memoized selectors and transactional thunks recording forward and inverse patches without full-state snapshots.",
        outcome: "Maintained deterministic state updates, O(1) entity lookups, and reliable multi-step history across complex document structures.",
        metric: "4 normalized entity adapter stores with patch-based undo/redo history",
        evidence: "lintu.io/frontend/src/features/editor/model/entities/ & store/history/",
        skills: ("Redux Toolkit", "TypeScript", "Immer", "State Management", "React"),
        tags: ("state-management", "architecture", "frontend", "contracts"),
      ),
      (
        id: "lintu-loading",
        statement: "Architected route-level and component-level code splitting separating editor authoring from public viewer runtimes and isolating heavy dependencies.",
        method: "Configured route chunking in Vite/React Router and wrapped geospatial modules (Mapbox GL, Three.js) in lazy dynamic imports, deferring bundle download until map visual nodes mount.",
        outcome: "Prevented heavy geospatial and 3D rendering libraries from inflating the initial application bundle and server-driven viewer page load.",
        metric: "Route-level chunk splitting and on-demand geospatial module loading",
        evidence: "lintu.io/frontend/src/app/router.tsx & map-visual-node.ts",
        skills: ("React Router", "Vite", "React", "TypeScript", "Performance Optimization", "Component Architecture", "Server-Driven UI", "Mapbox GL", "Three.js"),
        tags: ("frontend", "architecture", "performance"),
      ),
      (
        id: "lintu-standards",
        statement: "Built and documented reusable UI component foundations using Tailwind CSS, Storybook (15+ component stories), and typed Zod validation schemas.",
        method: "Constructed the standalone lintu-components design system package with design tokens, responsive layout primitives, and automated form generation contracts.",
        outcome: "Standardized visual styling and component contracts across client deliverables with isolated component visual verification.",
        metric: "Standalone component package covering 15+ UI elements with Storybook",
        evidence: "lintu-components/src/stories & lintu.io/frontend/src/features/editor/model/nodes/core/AutoForm.tsx",
        skills: ("Storybook", "Design Systems", "Tailwind CSS", "Zod", "TypeScript", "Engineering Practices"),
        tags: ("design-systems", "testing", "ui", "frontend"),
      ),
    ),
  ),
  (
    company:   "Contract Projects",
    role:      "Frontend Developer",
    period:    "Feb 2022 — Dec 2022",
    location:  "Hybrid - Giza, Egypt",
    summary:   "Contributed to frontend development for web application prototypes, data visualization tools, and command-center interfaces through contract projects.",
    highlights: (
      (
        id: "mvp-prototyping",
        statement: "Built data-driven web prototypes and interactive dashboard interfaces utilizing React, JavaScript, Redux Toolkit, and Visx charting primitives.",
        method: "Composed Visx hierarchy and responsive scale packages with Redux Toolkit state stores to create modular charting widgets.",
        outcome: "Delivered interactive dashboard prototypes supporting dynamic visual filtering and multi-resolution rendering.",
        metric: "Modular dashboard widget architecture",
        evidence: "command_center-master/package.json (@visx/* 11 packages)",
        skills: ("React", "JavaScript", "Redux Toolkit", "Visx", "D3.js"),
        tags: ("frontend", "data-visualization", "ui"),
      ),
      (
        id: "csv-parsing",
        statement: "Implemented client-side CSV data parsing and dynamic charting pipelines with PapaParse, supporting flexible tabular inspection and responsive visualization.",
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
