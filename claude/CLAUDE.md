# Global Instructions

## Knowledge Graph (Memory MCP)

A persistent knowledge graph is available via the Memory MCP server. Use it as follows:

- **At the start of complex or multi-step tasks**, search the knowledge graph for relevant context about the project, stack, or prior decisions.
- **When the user makes architecture decisions, shares preferences, or encounters gotchas**, store them as observations on the relevant entity.
- **When starting work on a new project**, create an entity for it with key facts (tech stack, location, conventions).
- **Link related entities** with descriptive relations (e.g., "depends_on", "deploys_to", "owns").

## General Preferences

- Jonny prefers portable, automatable setups that can be reproduced on new machines.
- Prefer simple, direct solutions over abstractions.
- When creating config or scripts, make them idempotent (safe to re-run).
