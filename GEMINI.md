<!-- GSD:project-start source:PROJECT.md -->
## Project

**dotfiles**

A cross-platform dotfiles management system for macOS and Ubuntu/Linux, centered on chezmoi as the dotfiles manager and mise as the universal runtime version manager. A single `./install.sh` command bootstraps the entire developer environment — package manager (Homebrew or apt), chezmoi, mise, and all tool configs — from a clean OS install to a fully productive terminal setup.

**Core Value:** Run `./install.sh` once on any clean machine (macOS or Ubuntu) and have a fully configured, identical terminal environment with zero manual steps.

### Constraints

- **Cross-platform**: Must work on clean macOS (Homebrew) and Ubuntu/Linux (apt) installs
- **Idempotency**: `install.sh` must be safe to re-run — no destructive overwrites, no duplicate entries
- **No secrets in repo**: All secrets fetched via chezmoi + 1Password op CLI at apply time
- **Chezmoi default layout**: Source lives at `~/.local/share/chezmoi/` (chezmoi default) — the git repo IS the chezmoi source repo, initialized with `chezmoi init <github-url>`
- **No NVM**: mise handles Node; NVM is not installed
- **Neovim init only**: chezmoi manages only the init file, not the entire nvim config directory
<!-- GSD:project-end -->

<!-- GSD:stack-start source:research/STACK.md -->
## Technology Stack

## chezmoi
- **Current stable**: v2.x (actively maintained, written in Go)
- **Source layout**: `~/.local/share/chezmoi/` — chezmoi default; files prefixed with `dot_` map to dotfiles
- **Init command**: `chezmoi init --apply https://github.com/USER/dotfiles.git`
- **Cross-platform OS detection in templates**:
- **Script types**:
- **`.chezmoi.toml.tmpl`**: Machine-specific variables, `promptOnce` for first-run questions
- **`chezmoidata.toml`**: Static template variables committed to repo
- **Confidence**: High (from official chezmoi.io docs)
## chezmoi + 1Password Integration
- Uses `op` CLI (1Password CLI v2)
- Template functions:
- Config in `chezmoi.toml`:
- Biometric auth (Touch ID): chezmoi handles session automatically — no explicit `op signin` needed
- **Confidence**: High (from chezmoi.io official docs)
## mise
- **Current stable**: v2025.x (Rust, fast, actively maintained)
- **Replaces**: NVM (Node), asdf, individual version scripts
- **Install**: `curl https://mise.run | sh` or `brew install mise`
- **Config file**: `~/.config/mise/config.toml` (global) or `.mise.toml` (per-project)
- **Global `.mise.toml` example**:
- **zsh integration** (add to `.zshrc`):
- **PATH**: mise shims are at `~/.local/share/mise/shims` — activated via `mise activate`
- **Confidence**: High
## install.sh Bootstrap Flow
### macOS
### Ubuntu/Linux
### Key principle
- `install.sh` only bootstraps: package manager + chezmoi + mise
- All further installation delegated to chezmoi `run_once_` scripts inside the repo
- This keeps `install.sh` minimal and stable; the repo scripts evolve independently
## Confidence Levels
| Item | Confidence |
|------|-----------|
| chezmoi source layout | High |
| OS template detection | High |
| 1Password integration | High |
| mise install + config | High |
| Script ordering (ASCII) | High |
| install.sh bootstrap pattern | High |
<!-- GSD:stack-end -->

<!-- GSD:conventions-start source:CONVENTIONS.md -->
## Conventions

Conventions not yet established. Will populate as patterns emerge during development.
<!-- GSD:conventions-end -->

<!-- GSD:architecture-start source:ARCHITECTURE.md -->
## Architecture

Architecture not yet mapped. Follow existing patterns found in the codebase.
<!-- GSD:architecture-end -->

<!-- GSD:workflow-start source:GSD defaults -->
## GSD Workflow Enforcement

Before using Edit, Write, or other file-changing tools, start work through a GSD command so planning artifacts and execution context stay in sync.

Use these entry points:
- `/gsd-quick` for small fixes, doc updates, and ad-hoc tasks
- `/gsd-debug` for investigation and bug fixing
- `/gsd-execute-phase` for planned phase work

Do not make direct repo edits outside a GSD workflow unless the user explicitly asks to bypass it.
<!-- GSD:workflow-end -->



<!-- GSD:profile-start -->
## Developer Profile

> Profile not yet configured. Run `/gsd-profile-user` to generate your developer profile.
> This section is managed by `generate-claude-profile` -- do not edit manually.
<!-- GSD:profile-end -->
