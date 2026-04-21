# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles managed by [chezmoi](https://www.chezmoi.io/), supporting macOS and Linux (Ubuntu/Debian).

## Chezmoi Workflow

All source files live in `home/` and are applied to `~/` via chezmoi. Key commands:

```bash
chezmoi apply            # apply changes from home/ to ~/
chezmoi diff             # preview pending changes before applying
chezmoi edit ~/.zshrc    # edit a managed file via its template
chezmoi add ~/some/file  # start tracking a new file
```

**File naming conventions in `home/`:**
- `dot_` prefix → `.` in destination (e.g., `dot_zshrc.tmpl` → `~/.zshrc`)
- `.tmpl` suffix → Jinja-style template processed by chezmoi (uses `.chezmoidata.toml` + `.chezmoi.toml.tmpl` for variables)
- `run_once_*.sh` → runs once on first `chezmoi apply`
- `run_onchange_*.sh` → re-runs when the script's content changes (used for Brewfile)

**Chezmoi data sources:**
- `.chezmoidata.toml` — static shared data (Homebrew taps, mise URL)
- `.chezmoi.toml.tmpl` — machine-specific config (name, email, 1Password integration)
- `.chezmoiexternal.toml` — external downloads managed by chezmoi (Oh-My-Zsh, TPM, zsh plugins — not in git)

## Bootstrap

```bash
# Fresh install on a new machine
curl -fsSL https://dotfiles.zops.dev/install | sh

# Or run locally
./install.sh
```

`install.sh` is idempotent: installs Homebrew (macOS) or apt packages (Linux), installs chezmoi, runs `chezmoi init --apply`, then `mise install`.

## Key Configuration Areas

| Area | Source path | Notes |
|------|-------------|-------|
| ZSH | `home/dot_zshrc.tmpl` | Oh-My-Zsh + Powerlevel10k, fzf, mise activation |
| Neovim | `home/dot_config/nvim/` | Lazy.nvim; config split into `lua/quang/` modules |
| Tmux | `home/dot_tmux.conf.tmpl` | Prefix=Ctrl+A, TPM, vim-style pane nav |
| Sketchybar | `home/dot_config/sketchybar/` | macOS menu bar; Lua-based with widgets in `items/` |
| WezTerm | `home/dot_config/wezterm/` | Terminal emulator config |
| Git | `home/dot_gitconfig` | SSH signing, GitHub helpers, aliases |
| Runtimes | `home/dot_mise.toml` | Go 1.26, Node LTS, Python 3.14, Rust managed by mise |
| Packages | `home/Brewfile` | macOS Homebrew casks + formulae |

## Neovim Structure

`home/dot_config/nvim/lua/quang/` contains modular Lua config:
- `plugins/` — per-plugin config files loaded by lazy.nvim
- `core/` or root files — keymaps, options, autocmds

When adding a plugin, create a new file in `lua/quang/plugins/` following the lazy.nvim spec pattern already used there.

## macOS-specific vs Linux

Templates use chezmoi conditionals. When editing `.tmpl` files, check for `{{- if eq .chezmoi.os "darwin" }}` blocks — macOS-only sections include Sketchybar, Homebrew paths at `/opt/homebrew`, and specific cask installs.

## Tmux Keybindings

- Prefix: `Ctrl+A`
- `Prefix + i` — split vertical
- `Prefix + o` — split horizontal
- `Prefix + j/k/h/l` — navigate panes (vim-style)
