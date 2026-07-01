# Beaver — Agent Skills

🦫 A collection of **Agent Skills** for system design, software architecture, and
specs. Skills follow the open `SKILL.md` standard, so they work in Claude Code,
Codex CLI, Gemini CLI, Cursor (manual placement), and other skill-aware tools.

## Skills in this repo

| Skill | Use it when… |
|---|---|
| **designing-systems** | Turning an idea into a high-level system design/architecture — any domain (software, data/ML/AI, IoT/edge, cyber-physical). Produces a constraint register, building-block selections, component inventory, quality attributes, risks, and a next-phase spec backlog. |
| **architecting-software** | Designing or reviewing a service's structure against Clean Architecture — keeping the domain independent of frameworks, DB, and providers. |
| **crafting-code** | Writing or changing code to a quality standard — a blocking process gate, four quality pillars, and a simplicity ladder. |

A natural pipeline: **designing-systems** (the map) → **architecting-software**
(the structure) → **crafting-code** (the craft).

## Where the skills live

Each skill is a self-contained folder at:

```
skills/<skill-name>/SKILL.md
```

with any supporting `references/` alongside it. To use a skill outside a plugin
manager, copy that `skills/<skill-name>/` folder into your tool's skills directory
(e.g. `~/.claude/skills/`). See `README.md` for per-tool install instructions.

## Conventions

- Skill names are gerund action verbs (`designing-`, `architecting-`, `crafting-`).
- Descriptions carry real trigger phrases and domain breadth so the skill fires on
  its own.
- Examples with pass/fail grading rubrics live in `examples/`.
- Generated documents go under `docs/` in the target repo — `docs/design/` (system
  design), `docs/adr/` (decisions), `docs/specs/` (specs), `docs/api/` (API
  contracts) — unless the repo already uses another layout.
