# Research Summary: chezmoi + mise dotfiles

## Stack

| Tool | Role | Install |
|------|------|---------|
| **chezmoi** | Dotfiles manager — templates, OS conditionals, secrets | `brew install chezmoi` / curl |
| **mise** | Runtime version manager — Go + Node (replaces NVM + go-update) | `brew install mise` / curl |
| **1Password op CLI** | Secrets at apply time — no plaintext in repo | `brew install 1password-cli` |
| **Homebrew** | macOS + Linux package manager | curl install script |
| **Oh-My-Zsh** | zsh framework — managed via chezmoi externals | chezmoi external |
| **Powerlevel10k** | zsh theme — managed via chezmoi externals or zsh plugin |  |
| **fzf** | Fuzzy finder — keybindings wired in `.zshrc` | `brew install fzf` |

## Recommended Repo Structure

```
dotfiles/
├── install.sh           ← bootstrap only: brew/apt + chezmoi + mise
├── README.md
└── home/               ← chezmoi source (--source ./home)
    ├── .chezmoi.toml.tmpl
    ├── .chezmoiexternal.toml
    ├── dot_zshrc.tmpl
    ├── dot_tmux.conf
    ├── dot_mise.toml
    ├── dot_config/
    │   ├── dot_nvim/init.lua
    │   ├── dot_wezterm/wezterm.lua
    │   ├── dot_sketchybar/  (macOS template-gated)
    │   └── dot_yabai/      (macOS template-gated)
    ├── run_once_01_install-mise.sh.tmpl
    ├── run_onchange_02_install-packages.sh.tmpl
    └── run_once_03_macos-setup.sh.tmpl
```

## Table Stakes

- Single `./install.sh` → fully working environment
- Idempotent: safe to re-run anytime
- Cross-platform: macOS + Ubuntu/Linux with OS-conditional templates
- No secrets in git
- mise for Go + Node versions
- fzf shell integration (Ctrl+R, Ctrl+T, Alt+C)

## Critical Pitfalls to Address in Each Phase

| Phase | Top pitfall | Prevention |
|-------|------------|------------|
| Bootstrap | mise not in PATH for run_once_ scripts | Explicitly export PATH in scripts |
| Bootstrap | Homebrew ARM64 path | Detect `uname -m`, use correct brew prefix |
| Config | Template files without template syntax | Only `.tmpl` for files actually using templates |
| Config | 1Password not signed in | Guard with `op account list` check |
| macOS | Yabai/Sketchybar without SIP | Warn, don't fail; document SIP steps |
| All | Editing files directly in `~/` | Always `chezmoi edit`; document in README |

## Watch Out For

1. **Script order**: chezmoi runs scripts in ASCII order — always use `01_`, `02_` prefixes
2. **mise PATH in scripts**: chezmoi scripts run in non-interactive shells — source mise manually
3. **Idempotency**: Even `run_once_` scripts should be safe to re-run (content changes trigger re-run)
4. **Neovim scope**: chezmoi manages ONLY `init.lua` — lazy.nvim manages everything else
5. **Apple Silicon**: Homebrew at `/opt/homebrew/bin`, not `/usr/local/bin` — detect in install.sh
