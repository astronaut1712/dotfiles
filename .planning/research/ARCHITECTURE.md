# Architecture Research: chezmoi dotfiles

## Recommended Repo Structure

```
dotfiles/                            ← git repo root
├── install.sh                       ← entry point (bootstrap only)
├── README.md
├── .planning/                       ← GSD planning (gitignored or committed)
│
└── home/                            ← chezmoi source directory (--source flag)
    ├── .chezmoi.toml.tmpl           ← machine-local config generation
    ├── .chezmoiexternal.toml        ← externals (Oh-My-Zsh, etc.)
    ├── .chezmoidata.toml            ← static template variables
    │
    ├── dot_zshrc.tmpl               → ~/.zshrc
    ├── dot_tmux.conf                → ~/.tmux.conf
    ├── dot_mise.toml                → ~/.mise.toml (global mise config)
    │
    ├── dot_config/                  → ~/.config/
    │   ├── dot_nvim/                → ~/.config/nvim/
    │   │   └── init.lua             → ~/.config/nvim/init.lua (init only)
    │   ├── dot_wezterm/             → ~/.config/wezterm/
    │   │   └── wezterm.lua          → ~/.config/wezterm/wezterm.lua
    │   ├── dot_sketchybar/          → ~/.config/sketchybar/ (macOS only, templated)
    │   └── dot_yabai/              → ~/.config/yabai/ (macOS only, templated)
    │
    └── run_once_scripts/            ← chezmoi finds these at source root level
        (actually these live directly under home/, not a subdirectory)
        run_once_01_install-homebrew.sh.tmpl
        run_once_02_install-packages.sh.tmpl
        run_once_03_install-mise.sh.tmpl
        run_onchange_04_install-brew-packages.sh.tmpl
        run_once_05_macos-only.sh.tmpl   (guarded: {{ if eq .chezmoi.os "darwin" }})
```

**Note**: chezmoi scripts live directly under the source root (beside `dot_` files), not in a subdirectory.

## OS Detection in Templates

```go
{{- if eq .chezmoi.os "darwin" -}}
# macOS-specific content
{{- else if eq .chezmoi.os "linux" -}}
# Linux-specific content
{{- end -}}
```

For Linux distro detection:
```go
{{- if eq .chezmoi.osRelease.id "ubuntu" -}}
```

## chezmoi Init Flow (new machine)

```bash
# Option A: via install.sh (recommended for this project)
./install.sh
  → installs brew/apt
  → brew install chezmoi (or curl install)
  → chezmoi init --apply --source ./home https://github.com/astronaut1712/dotfiles.git

# Option B: pure chezmoi bootstrap
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply https://github.com/astronaut1712/dotfiles.git
```

## Build Order (what installs before chezmoi apply)

1. **Package manager** — Homebrew (macOS) or apt update (Linux)
2. **Core CLI tools** — `git`, `curl` (usually pre-installed)
3. **chezmoi** — installed via brew or curl; then `chezmoi init --apply`
4. **chezmoi run_once_ 01**: installs mise
5. **chezmoi run_once_ 02**: installs packages (Brewfile on macOS, apt packages on Linux)
6. **chezmoi applies dotfiles** — zshrc, tmux, nvim init, wezterm, etc.
7. **chezmoi run_once_ 03 (macOS)**: installs Sketchybar, Yabai, fonts
8. **mise install** — Go and Node versions from `.mise.toml` pulled down

## Component Boundaries

| Component | Responsibility | Lives in |
|-----------|---------------|----------|
| `install.sh` | OS detection, pkg manager + chezmoi bootstrap | repo root |
| `chezmoi apply` | Copy/template dotfiles to `~` | chezmoi source (`home/`) |
| `run_once_01_` | Install mise | chezmoi source |
| `run_once_02_` | Install OS packages (Brewfile/apt) | chezmoi source |
| `run_once_05_` (macOS) | Install Sketchybar, Yabai, fonts | chezmoi source |
| `dot_mise.toml` | Pin Go + Node versions | chezmoi source → `~/.mise.toml` |
| `dot_zshrc.tmpl` | Shell init: mise activate, fzf, p10k, OMZ | chezmoi source |
| `dot_config/dot_nvim/init.lua` | Neovim bootstrap (lazy.nvim seed) | chezmoi source |
| 1Password + op CLI | Secret values at apply time | 1Password vault |

## Data Flow

```
install.sh
  → brew/apt
  → chezmoi
    → git clone dotfiles repo to ~/.local/share/chezmoi/
    → run_once_01: install mise
    → run_once_02: install Brewfile / apt packages
    → apply dot_* files to ~/
    → run_once_05 (macOS only): sketchybar, yabai, fonts
  → mise install (from .mise.toml)
    → Go version
    → Node version
```
