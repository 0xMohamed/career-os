// projects/modra.typ
//
// Modra — AI-powered presentation platform.
//
// This file describes what Modra IS, not how to present it on a resume.
// All achievements represent verified implementations from repository code and architecture.

#let modra = (
  title:      "Modra",
  role:       "Founding Engineer",
  company:    "Modra",
  type:       "Product",
  status:     "Completed",
  period:     "2026",
  team_size:  "Solo",

  summary:    "AI-powered presentation platform with modular canvas editing.",

  technologies: (
    "React", "TypeScript", "TanStack Router", "Zustand",
    "TipTap", "Zod", "Express", "Prisma", "PostgreSQL",
    "Tailwind CSS", "shadcn/ui",
  ),

  achievements: (
    (
      id: "shared-contracts",
      statement: "Architected the @modra/ai-contracts shared monorepo package with strict Zod schemas, validating AI generation payloads and discriminated-union chart blocks between the React client and Express backend.",
      method: "Centralized payload schemas in a shared library enforcing parameter limits (1–20 slides, tone enum, chart density) and strict output types for chart blocks and slide structures.",
      outcome: "Enforced compile-time and runtime type validation between the TanStack Router web application and Express backend services.",
      metric: "Shared monorepo contracts package covering request/response schemas",
      evidence: "modra/packages/ai-contracts & docs/architecture/ai-architecture.md",
      skills: ("TypeScript", "Zod", "Express", "Prisma", "Monorepos", "Component Architecture"),
      tags: ("architecture", "contracts", "backend", "monorepo"),
    ),
    (
      id: "document-persistence",
      statement: "Built RESTful document and template services in Express with Prisma and PostgreSQL, supporting JSON slide snapshot persistence, pagination, and token-based public sharing.",
      method: "Implemented route controllers with Zod validation middleware, database querying via Prisma ORM with PostgreSQL, and Cloudflare R2 asset storage for slide thumbnails.",
      outcome: "Enabled secure document CRUD operations, immutable snapshot versioning, and public read-only link access.",
      metric: "Express REST API with Prisma PostgreSQL persistence and R2 storage",
      evidence: "modra/apps/api/src/modules/documents/documents.service.ts & documents.routes.ts",
      skills: ("Express", "Prisma", "PostgreSQL", "REST APIs", "TypeScript", "Node.js"),
      tags: ("backend", "contracts", "fullstack"),
    ),
    (
      id: "ai-hydration",
      statement: "Implemented asynchronous AI image hydration workflows utilizing transient pending states in Zustand, maintaining UI responsiveness while background generation completes.",
      method: "Structured optimistic state transitions with background polling and fallback rendering while waiting for remote generation jobs to resolve.",
      outcome: "Prevented UI blocking during multi-second image generation tasks, providing visual progress feedback to the user.",
      metric: "Non-blocking optimistic UI with transient state handling",
      evidence: "modra/apps/web/src/features/editor/state/editor.store.ts",
      skills: ("React", "Zustand", "AI Workflows", "State Management", "TypeScript"),
      tags: ("ai", "frontend", "state-management"),
    ),
    (
      id: "dual-shells",
      statement: "Engineered dual presentation shells using custom breakpoint hooks (useIsMobile) and shadcn/ui components, routing desktop users to a multi-rail editor and mobile users to a touch slide pager.",
      method: "Implemented viewport detection logic (768px breakpoint) combined with shadcn/ui sheet/dialog overlays, dynamically mounting either a desktop multi-panel workspace or MobilePresentationShell.",
      outcome: "Delivered device-appropriate slide authoring and presentation experiences across varied viewport form factors.",
      metric: "Dedicated mobile presentation shell and touch slide pager",
      evidence: "modra/apps/web/src/features/editor/components/EditorLayout.tsx & MobilePresentationShell.tsx",
      skills: ("React", "TypeScript", "Tailwind CSS", "shadcn/ui", "Responsive Design", "Component Architecture"),
      tags: ("frontend", "ui", "editor", "responsive"),
    ),
  ),

  tags: ("ai", "data-visualization", "product", "frontend", "monorepo"),

  links: (
    live: "usemodra.xyz",
  ),
)
