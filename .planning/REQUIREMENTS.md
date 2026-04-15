# Requirements: dotfiles

**Defined:** 2026-04-15
**Core Value:** Run `./install.sh` once on any clean machine (macOS or Ubuntu) and have a fully configured, identical terminal environment with zero manual steps.

## v1 Requirements

### Bootstrap

- [ ] **BOOT-01**: `install.sh` detects OS (macOS vs Ubuntu/Linux) and runs the correct package manager setup (Homebrew or apt)
- [ ] **BOOT-02**: `install.sh` installs chezmoi (via brew on macOS, curl on Linux)
- [ ] **BOOT-03**: `install.sh` runs `chezmoi init --apply` to pull and apply all dotfiles from the GitHub repo
- [ ] **BOOT-04**: `install.sh` is idempotent — safe to re-run without side effects
- [ ] **BOOT-05**: On Apple Silicon Macs, Homebrew path (`/opt/homebrew/bin`) is correctly detected and exported before use

### Runtime Management

- [ ] **RTMG-01**: mise is installed via a chezmoi `run_once_` script
- [ ] **RTMG-02**: `dot_mise.toml` (→ `~/.mise.toml`) declares pinned versions for Go and Node
- [ ] **RTMG-03**: mise is activated in zsh via `eval "$(mise activate zsh)"` in `.zshrc`
- [ ] **RTMG-04**: `mise install` runs after dotfiles are applied, pulling Go and Node at pinned versions

### Shell

- [ ] **SHLL-01**: chezmoi manages `.zshrc` — includes mise activation, Oh-My-Zsh init, Powerlevel10k, fzf integration
- [ ] **SHLL-02**: fzf keybindings are active in zsh (Ctrl+R history, Ctrl+T file, Alt+C directory)
- [ ] **SHLL-03**: Powerlevel10k config is managed by chezmoi (`dot_p10k.zsh`)
- [ ] **SHLL-04**: chezmoi manages `.zshrc` as a template (`.tmpl`) with macOS/Linux conditional blocks

### Package Management

- [ ] **PKGM-01**: A `Brewfile` in the chezmoi source installs core packages on macOS (fzf, neovim, wezterm, tmux, mise, chezmoi, 1password-cli)
- [ ] **PKGM-02**: A chezmoi `run_onchange_` script re-runs `brew bundle` whenever the Brewfile changes
- [ ] **PKGM-03**: An equivalent apt package list handles Linux package installs via a `run_once_` script

### Editor

- [ ] **EDIT-01**: chezmoi manages only the Neovim init file (`~/.config/nvim/init.lua`)
- [ ] **EDIT-02**: The Neovim init file bootstraps lazy.nvim (self-installs if not present)

### Terminal

- [ ] **TERM-01**: chezmoi manages WezTerm config (`~/.config/wezterm/wezterm.lua`)

### Tmux

- [ ] **TMUX-01**: chezmoi manages `.tmux.conf`

### macOS-Only Setup

- [ ] **MACOS-01**: A chezmoi `run_once_` script (macOS-only, template-gated) installs Sketchybar and Yabai via Homebrew
- [ ] **MACOS-02**: chezmoi manages Sketchybar config (`~/.config/sketchybar/`) — gated by `{{ if eq .chezmoi.os "darwin" }}`
- [ ] **MACOS-03**: chezmoi manages Yabai config (`~/.config/yabai/`) — gated by `{{ if eq .chezmoi.os "darwin" }}`
- [ ] **MACOS-04**: macOS setup script warns (does not fail) if SIP is not disabled, explaining Yabai/Sketchybar limitations

### Secrets

- [ ] **SCRT-01**: chezmoi 1Password integration is configured to use the `op` CLI for fetching secrets at apply time
- [ ] **SCRT-02**: No plaintext secrets exist in the git repository

## v2 Requirements

### Quality of Life

- **QUAL-01**: `chezmoi diff` shows pending changes cleanly before apply
- **QUAL-02**: Per-machine overrides via `.chezmoidata.toml` (email, Git author name)
- **QUAL-03**: `chezmoi update` in a single command syncs and applies the latest dotfiles from GitHub

### Tooling Additions

- **TOOL-01**: Git global config (`~/.gitconfig`) managed by chezmoi
- **TOOL-02**: SSH config (`~/.ssh/config`) managed via chezmoi template (public hosts only)

## Out of Scope

| Feature | Reason |
|---------|--------|
| NVM | Replaced by mise — will not be installed or configured |
| `bin/go-update` script | Replaced by mise — will be removed |
| Full `~/.config/nvim/` management | lazy.nvim self-bootstraps; managing plugins via chezmoi adds complexity without benefit |
| `.vimrc` (legacy Vim) | Not the focus; will be removed or left as-is |
| SIP disable automation | Cannot be scripted non-interactively on macOS; documented in README |
| Windows support | macOS and Ubuntu/Linux only |
| GUI application config | Only terminal/CLI tooling |
| Nix/NixOS | Homebrew is sufficient; Nix adds steep learning curve |
| age/GPG encryption | 1Password handles secrets; file encryption is redundant |
| Shared/team dotfiles | Personal dotfiles only |

## Traceability

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
*Requirements defined: 2026-04-15*
*Last updated: 2026-04-15 after initial definition*
