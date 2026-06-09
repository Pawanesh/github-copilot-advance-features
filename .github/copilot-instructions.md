# Copilot / AI Agent Instructions

Purpose
- Give an AI coding agent the immediately actionable knowledge to be productive in this repository.

Repo snapshot (current)
- Root files: [README.md](../README.md), [LICENSE](../LICENSE), .gitignore.
- This repository is documentation-only today (no source code, no package manifests, no CI configs).

Quick agent checklist
- Read the root `README.md` and `LICENSE` for project intent and license constraints.
- Search the repo for agent and CI config files using this glob:
  - **Search glob:** **/{.github/copilot-instructions.md,AGENT.md,AGENTS.md,CLAUDE.md,.cursorrules,.windsurfrules,.clinerules,.cursor/rules/**,.windsurf/rules/**,.clinerules/**,README.md}
- When code appears, detect toolchain by presence of these files: `package.json`, `pyproject.toml`, `go.mod`, `Cargo.toml`, `Gemfile`, `.github/workflows/*`.

What to document in this file (actionable, exact)
- Minimal reproducible commands: install, test, lint, build (single-line examples). Example formats to include when relevant:
  - Node: `npm ci && npm test`
  - Python: `python -m venv .venv && .venv/bin/pip install -r requirements.txt && pytest -q`
  - Go: `go test ./...`
- Source layout: list directories where code and tests live (e.g., `src/`, `pkg/`, `cmd/`, `packages/`).
- One-line architecture summary: major components, responsibilities, and external integrations.

Practical agent behaviors
- Prefer exact, copy-paste commands over generic guidance. If you add a command, run or validate it locally when possible and record it here.
- When refactoring or moving files, update the `Repo snapshot` and the short layout notes.

Integration & detection hints
- No integrations detected today. Future indicators:
  - Presence of `Dockerfile` or `docker-compose.yml` → containerized apps
  - `.github/workflows/` → CI steps to reproduce locally
  - `terraform/` or `*.tf` → infra as code

Agent merge guidance
- If merging changes into this file, keep the checklist and the concrete commands. Remove stale commands only after verifying replacements work.

Where to look next
- [README.md](../README.md) — primary human-facing description.

Maintenance notes
- Keep this file short (20–40 lines). Focus on reproducible commands and file locations rather than general development philosophies.

Feedback
- Tell me what's missing or unclear in these instructions and I will iterate.
