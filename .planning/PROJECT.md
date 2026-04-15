# dotfiles

## What This Is

A cross-platform dotfiles management system for macOS and Ubuntu/Linux, centered on chezmoi as the dotfiles manager and mise as the universal runtime version manager. A single `./install.sh` command bootstraps the entire developer environment — package manager (Homebrew or apt), chezmoi, mise, and all tool configs — from a clean OS install to a fully productive terminal setup.

## Core Value

Run `./install.sh` once on any clean machine (macOS or Ubuntu) and have a fully configured, identical terminal environment with zero manual steps.

## Requirements

### Validated

<!-- Shipped and confirmed valuable. -->

(None yet — ship to validate)

### Active

<!-- Current scope. Building toward these. -->

**Bootstrap & Installation**
- [ ] `install.sh` detects OS (macOS vs Ubuntu/Linux) and installs the correct package manager (Homebrew or apt)
- [ ] `install.sh` installs chezmoi and runs `chezmoi init --apply` to pull and apply all dotfiles
- [ ] `install.sh` installs mise and configures it for Go + Node version management
- [ ] `install.sh` is idempotent — safe to re-run without side effects

**Runtime Management (mise)**
- [ ] mise manages Go versions (replaces bin/go-update script)
- [ ] mise manages Node.js versions (replaces NVM)
- [ ] `.mise.toml` declares pinned versions for Go and Node
- [ ] mise shell integration is wired into zsh config

**Shell (zsh + Oh-My-Zsh + Powerlevel10k)**
- [ ] chezmoi manages `.zshrc` with mise, fzf, and Oh-My-Zsh integration
- [ ] fzf shell integration is fully wired (keybindings: Ctrl+R, Ctrl+T, Alt+C)
- [ ] Powerlevel10k configuration is managed via chezmoi

**Editor (Neovim)**
- [ ] chezmoi manages only the Neovim init file (`~/.config/nvim/init.lua` or `init.vim`)
- [ ] lazy.nvim self-bootstraps on first run — not managed by chezmoi

**Terminal (WezTerm)**
- [ ] chezmoi manages WezTerm config (`~/.config/wezterm/wezterm.lua`)

**Tmux**
- [ ] chezmoi manages `.tmux.conf`

**macOS-Only Tools**
- [ ] `macosv2.sh` installs Sketchybar and Yabai binaries via Homebrew
- [ ] chezmoi manages Sketchybar config (`.config/sketchybar/`)
- [ ] chezmoi manages Yabai config (`.config/yabai/`)
- [ ] macOS-only blocks are guarded by OS detection in chezmoi templates

**Secrets**
- [ ] chezmoi 1Password integration configured for any secret values (uses `op` CLI)
- [ ] No plaintext secrets in the repo

### Out of Scope

- **NVM** — replaced by mise; NVM won't be installed or configured
- **bin/go-update script** — replaced by mise; script will be removed
- **Neovim plugin management** — lazy.nvim bootstraps itself; chezmoi only manages the init file
- **Vim (legacy)** — `.vimrc` exists but is not the focus; kept as-is or removed
- **SIP-disable automation** — Sketchybar/Yabai require SIP disable; installer documents this but doesn't automate it
- **Windows support** — macOS and Ubuntu/Linux only
- **GUI applications** — only terminal/CLI tooling

## Context

- Existing repo: `github.com/astronaut1712/dotfiles` — has `install.sh`, `macosv2.sh`, `ubuntu.sh`, `.zshrc`, `.vimrc`, `.tmux.conf`, `.config/` directory
- Full rewrite: existing scripts are replaced with the new structured chezmoi-based approach
- chezmoi default source: `~/.local/share/chezmoi/` — chezmoi manages its own internal source directory
- Secrets via 1Password: chezmoi's `op` integration retrieves secrets at apply time — nothing secret in the git repo
- Neovim: lazy.nvim-based setup; chezmoi only needs to seed the init file
- Sketchybar + Yabai are macOS-only and require SIP disabled — installer installs binaries, configs are gated by OS detection in chezmoi templates
- mise replaces both NVM and the Go update script — unified `~/.mise.toml` or per-project `.mise.toml` handles all runtime versions

## Constraints

- **Cross-platform**: Must work on clean macOS (Homebrew) and Ubuntu/Linux (apt) installs
- **Idempotency**: `install.sh` must be safe to re-run — no destructive overwrites, no duplicate entries
- **No secrets in repo**: All secrets fetched via chezmoi + 1Password op CLI at apply time
- **Chezmoi default layout**: Source lives at `~/.local/share/chezmoi/` (chezmoi default) — the git repo IS the chezmoi source repo, initialized with `chezmoi init <github-url>`
- **No NVM**: mise handles Node; NVM is not installed
- **Neovim init only**: chezmoi manages only the init file, not the entire nvim config directory

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Use chezmoi as dotfiles manager | Handles templates, OS-conditional files, 1Password integration natively | — Pending |
| Use mise over asdf | mise is faster, written in Rust, actively maintained, drop-in replacement for asdf and NVM | — Pending |
| chezmoi default source layout | Standard approach; easier to use `chezmoi init <url>` on new machines | — Pending |
| 1Password for secrets | User already uses 1Password; chezmoi has native op CLI integration | — Pending |
| Sketchybar/Yabai macOS-only | These only run on macOS and require SIP disable — gated via OS templates | — Pending |
| Neovim init file only | lazy.nvim self-bootstraps; managing the full nvim dir creates complexity without benefit | — Pending |
| Full rewrite (not incremental) | Existing scripts are not structured for chezmoi; clean start avoids legacy debt | — Pending |

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `/gsd-transition`):
1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with phase reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

**After each milestone** (via `/gsd-complete-milestone`):
1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state

---
*Last updated: 2026-04-15 after initialization*
