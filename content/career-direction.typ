// content/career-direction.typ
//
// Career Direction — structured internal positioning layer.
// No layout, no rendering. Only structured data.
//
// This is an INTERNAL content layer only. It does not add visible
// "Next Step" or "Future Goal" sections to the resume.
//
// It serves as an architectural source of truth for positioning,
// application-tailored summaries, and targeted career variations.
//
// Distinctly separates:
//   1. Demonstrated Experience (proven production foundation)
//   2. Current Focus (active engineering transition)
//   3. Future Direction (emerging domains of growth)

#let career-direction = (
  // Strategic trajectory
  trajectory: (
    current_title: "Frontend Engineer",
    transition_to: "AI-Native Application Engineer",
  ),

  // 1. Demonstrated experience (proven by projects & work history in this repository)
  demonstrated: (
    "Frontend architecture and component systems with React, Next.js, and TypeScript",
    "Complex interactive systems, visual canvas editors, and drag-and-drop engines",
    "Data visualization pipelines with 60 FPS simulations, 3D globes, and mapping (D3, Visx, Mapbox GL)",
    "AI-integrated products with multimodal Gemini workflows, structured JSON outputs, and transient UI hydration",
  ),

  // 2. Current professional focus (active hands-on engineering transition)
  current_focus: (
    "Python development and backend services (Fastify, Express, PostgreSQL, Prisma)",
    "LLM application development and orchestration",
    "Structured outputs, schema-driven prompting, and validation with Zod",
    "End-to-end AI workflows integrating interactive frontends with AI service backends",
  ),

  // 3. Future learning direction (internal positioning only)
  future_direction: (
    "Retrieval-Augmented Generation (RAG) and hybrid search architectures",
    "Vector retrieval, indexing strategies, and embedding models",
    "Agentic systems, tool calling, and multi-agent coordination patterns",
    "Evaluation, reliability, and deterministic validation for generative AI systems",
  ),

  // Application-tailored summaries (used optionally by targeted application variants)
  targeted_summaries: (
    ai_native: "Frontend and product engineer expanding into AI-native application engineering. Combining proven expertise in complex interactive interfaces, state management, and data visualization with active focus on Python backend systems, LLM application orchestration, structured outputs, and reliable AI workflows.",
    data_systems: "Frontend engineer specializing in complex interactive systems and data visualization. Proven track record architecting 60 FPS graphical simulations, visual editors, and real-time dashboards with D3, Visx, and React.",
  ),
)
