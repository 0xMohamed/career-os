# profiles/

This directory is intentionally empty in Phase 1.

## Purpose

Profiles represent job families — distinct audiences that require different emphasis on the same underlying content.

Examples of future profiles:
- `frontend.typ` — emphasizes UI engineering, component systems, and interaction design
- `systems.typ` — emphasizes architecture, performance, and infrastructure
- `dataviz.typ` — emphasizes D3, rendering pipelines, and data-intensive UIs

## What a Profile Does

A profile does not duplicate content. It composes and reorders it:

- Project ordering (which projects appear first for this audience)
- Highlighted skills (which technologies to surface)
- Summary variation (which framing of the professional summary to use)
- Emphasis tags (which project tags are most relevant)

## When to Create a Profile

Create a profile when a second application (`applications/`) exists that needs meaningfully different composition from the same content.

Until then, `applications/oto.typ` imports directly from `content/` and `projects/`.

## Phase 1 Decision

Introducing profiles in Phase 1 would create an abstraction layer with exactly one consumer and no concrete evidence for its shape. The simplest implementation that correctly serves one application is the right implementation today.

Profiles will be extracted naturally from real usage when a second application creates the concrete need.
