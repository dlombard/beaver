---
name: commit-message
description: Generate appropriate commit messages for git commits.
---

# Commit Message Skill

Use this skill when creating git commits.

## Format

```
<type>(<scope>): <subject>
```

- **Subject max length:** 100 characters (including type and scope prefix)
- **Subject:** lowercase first letter, no period at end, imperative mood ("add" not "added")

## Allowed Types

| Type | Use When |
|------|----------|
| `feat` | New feature or capability |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `ci` | CI/CD pipeline changes |
| `chore` | Maintenance, tooling, config |
| `refactor` | Code restructuring (no behavior change) |
| `perf` | Performance improvement |
| `test` | Adding or updating tests |
| `style` | Formatting, whitespace, linting fixes |
| `build` | Build system or dependency changes |
| `revert` | Reverting a previous commit |

## Allowed Scopes

| Scope | Directory |
|-------|-----------|
| `backend` | `backend/` |
| `chat-engine` | `chat-engine/` |
| `content-hub` | `content-hub/` |
| `creator-studio` | `creator-studio/` |
| `infra` | `infra/` |
| `agents` | Agent-specific changes across services |
| `deps` | Dependency updates |
| `ci` | `.github/workflows/` and CI config |

## Scope Selection Rules

1. If changes touch **only one service directory**, use that service as scope
2. If changes touch **CI/workflows only**, use `ci` scope
3. If changes touch **infra only**, use `infra` scope
4. If changes span **multiple directories**, either:
   - Use the primary scope (the most impactful change)
   - Omit the scope: `feat: add cross-service feature`
5. Scope is **optional** per commitlint config (warning level, not error)

## Examples

```bash
# Single-service feature
feat(backend): add file upload endpoint

# Chat engine fix
fix(chat-engine): resolve mypy type errors in retrieval service

# Infrastructure change
feat(infra): add Cloud Run service for chat engine

# CI change
ci(ci): add chat-engine-ci workflow to gate

# Cross-cutting change (no scope)
feat: add chat engine to dev.sh and infra deployment

# Dependency update
chore(deps): bump fastapi to 0.115.2

# Documentation
docs(backend): add API endpoint reference
```

## Common Mistakes to Avoid

- Using a scope not in the allowed list (e.g., `api`, `app`, `tests`)
- Capitalizing the subject: `Fix bug` should be `fix bug`
- Ending with a period: `add feature.` should be `add feature`
- Exceeding 100 character subject line
- Using past tense: `added feature` should be `add feature`
