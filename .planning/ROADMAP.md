# Roadmap: dotfiles

**Project:** dotfiles — chezmoi + mise cross-platform dotfiles manager
**Granularity:** Coarse (3-5 phases)
**Created:** 2026-04-15

## Phase Overview

| # | Phase | Goal | Requirements | Success Criteria |
|---|-------|------|--------------|-----------------|
| 1 | Bootstrap & Package Management | `./install.sh` bootstraps a clean machine end-to-end | BOOT-01–05, RTMG-01/02/04, PKGM-01–03 | 8 |
| 2 | Dotfiles Configuration | All tool configs (zsh, nvim, wezterm, tmux) managed by chezmoi | SHLL-01–04, EDIT-01/02, TERM-01, TMUX-01, RTMG-03, SCRT-01/02 | 6 |
| 3 | macOS-Specific Setup | Sketchybar + Yabai installed and configured, macOS defaults applied | MACOS-01–04 | 4 |

---

## Phase 1: Bootstrap & Package Management

**Goal:** Running `./install.sh` on a clean macOS or Ubuntu machine installs Homebrew/apt, chezmoi, and mise, then applies dotfiles — end to end with zero manual steps.

**Requirements:**
- BOOT-01: `install.sh` detects OS and runs correct package manager setup
- BOOT-02: `install.sh` installs chezmoi
- BOOT-03: `install.sh` runs `chezmoi init --apply` from GitHub repo
- BOOT-04: `install.sh` is idempotent
- BOOT-05: Apple Silicon Homebrew path correctly detected
- RTMG-01: mise installed via chezmoi `run_once_` script
- RTMG-02: `dot_mise.toml` declares pinned Go + Node versions
- RTMG-04: `mise install` runs after dotfiles applied
- PKGM-01: Brewfile installs core packages on macOS
- PKGM-02: `run_onchange_` script re-runs `brew bundle` when Brewfile changes
- PKGM-03: apt package list handles Linux installs

**Success Criteria:**
1. `./install.sh` completes without error on a fresh macOS (Intel + Apple Silicon) instance
2. `./install.sh` completes without error on a fresh Ubuntu 22.04/24.04 instance
3. After install: `chezmoi`, `mise`, `go`, `node` are all available in a new shell
4. Re-running `./install.sh` completes without error or duplicate side effects
5. `brew list` shows all packages from Brewfile on macOS
6. `mise list` shows Go and Node at pinned versions
7. Apple Silicon: `brew` resolves to `/opt/homebrew/bin/brew`
8. No hardcoded paths break on Linux (no `brew` calls outside macOS guard)

**Plans:**
1. Rewrite `install.sh` — OS detection, brew/apt bootstrap, chezmoi install, chezmoi init
2. Create chezmoi repo structure (`home/` source dir, `.chezmoi.toml.tmpl`, basic layout)
3. Write `run_once_01_install-mise.sh.tmpl` and `dot_mise.toml`
4. Write `Brewfile` + `run_onchange_02_install-packages.sh.tmpl` (macOS) and Linux apt equivalent
5. Integration smoke test — validate templates, shell lint, chezmoi dry-run

---

## Phase 2: Dotfiles Configuration

**Goal:** All terminal tool configs — zsh, Neovim init, WezTerm, tmux — are managed by chezmoi with correct OS-conditional templates, fzf wired up, and 1Password integration for secrets.

**Requirements:**
- SHLL-01: chezmoi manages `.zshrc` with mise, OMZ, P10k, fzf
- SHLL-02: fzf keybindings active (Ctrl+R, Ctrl+T, Alt+C)
- SHLL-03: Powerlevel10k config managed by chezmoi
- SHLL-04: `.zshrc` is a `.tmpl` with macOS/Linux conditional blocks
- EDIT-01: chezmoi manages only `~/.config/nvim/init.lua`
- EDIT-02: Neovim init bootstraps lazy.nvim
- TERM-01: chezmoi manages `~/.config/wezterm/wezterm.lua`
- TMUX-01: chezmoi manages `.tmux.conf`
- RTMG-03: `eval "$(mise activate zsh)"` in `.zshrc`
- SCRT-01: chezmoi 1Password integration configured
- SCRT-02: No plaintext secrets in repo

**Success Criteria:**
1. `chezmoi apply` on a configured machine results in correct dotfiles at expected paths
2. New shell after apply: mise is active, `go version` and `node --version` work
3. fzf keybindings respond in zsh (Ctrl+R opens history search)
4. Neovim starts, lazy.nvim bootstraps and installs plugins on first run
5. WezTerm launches with correct config (no errors in WezTerm log)
6. tmux starts with prefix Ctrl+A and custom splits/navigation working
7. No secrets appear in `git log` or `git diff` output

**Plans:** 5 plans

Plans:
- [ ] 02-01-PLAN.md — Migrate .zshrc into chezmoi Go template (mise, OMZ, fzf, OS guards)
- [ ] 02-02-PLAN.md — Capture Powerlevel10k config (dot_p10k.zsh)
- [ ] 02-03-PLAN.md — Migrate Neovim init.lua into chezmoi
- [ ] 02-04-PLAN.md — Migrate WezTerm + tmux configs (TPM as external)
- [ ] 02-05-PLAN.md — Verify 1Password integration and audit for secrets

---

## Phase 3: macOS-Specific Setup

**Goal:** On macOS, Sketchybar and Yabai are installed via Homebrew and their configs are managed by chezmoi. The setup warns if SIP is not disabled but does not fail.

**Requirements:**
- MACOS-01: Chezmoi `run_once_` script installs Sketchybar + Yabai via brew (macOS-only)
- MACOS-02: chezmoi manages Sketchybar config (template-gated)
- MACOS-03: chezmoi manages Yabai config (template-gated)
- MACOS-04: macOS script warns (not fails) if SIP is not disabled

**Success Criteria:**
1. `chezmoi apply` on macOS installs Sketchybar and Yabai binaries
2. `~/.config/sketchybar/` and `~/.config/yabai/` exist after apply on macOS
3. On Linux, these scripts and configs are silently skipped (no errors)
4. If SIP is enabled, user sees a clear warning message with instructions — process does not exit non-zero
5. README documents SIP disable steps clearly

**Plans:** 2 plans

Plans:
- [ ] 03-01-PLAN.md — macOS WM installation (Brewfile + run_once_03 with SIP detection)
- [ ] 03-02-PLAN.md — Migrate Sketchybar & Yabai configs to chezmoi source

---

## Requirement Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| BOOT-01 | Phase 1 | Pending |
| BOOT-02 | Phase 1 | Pending |
| BOOT-03 | Phase 1 | Pending |
| BOOT-04 | Phase 1 | Pending |
| BOOT-05 | Phase 1 | Pending |
| RTMG-01 | Phase 1 | Pending |
| RTMG-02 | Phase 1 | Pending |
| RTMG-03 | Phase 2 | Pending |
| RTMG-04 | Phase 1 | Pending |
| PKGM-01 | Phase 1 | Pending |
| PKGM-02 | Phase 1 | Pending |
| PKGM-03 | Phase 1 | Pending |
| SHLL-01 | Phase 2 | Pending |
| SHLL-02 | Phase 2 | Pending |
| SHLL-03 | Phase 2 | Pending |
| SHLL-04 | Phase 2 | Pending |
| EDIT-01 | Phase 2 | Pending |
| EDIT-02 | Phase 2 | Pending |
| TERM-01 | Phase 2 | Pending |
| TMUX-01 | Phase 2 | Pending |
| MACOS-01 | Phase 3 | Pending |
| MACOS-02 | Phase 3 | Pending |
| MACOS-03 | Phase 3 | Pending |
| MACOS-04 | Phase 3 | Pending |
| SCRT-01 | Phase 2 | Pending |
| SCRT-02 | Phase 2 | Pending |

**Coverage:**
- v1 requirements: 26 total
- Mapped to phases: 26
- Unmapped: 0 ✓

---
*Roadmap created: 2026-04-15*
*Last updated: 2026-04-15 after initial creation*
