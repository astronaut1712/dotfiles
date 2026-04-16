# dotfiles

Personal dotfiles managed by [chezmoi](https://www.chezmoi.io/).

## Supported
- macOS
- Linux (Ubuntu/Debian)

## What's included
- **ZSH** with Oh-My-Zsh + Powerlevel10k
- **Neovim** (lazy.nvim plugin manager)
- **Tmux** with TPM plugins
- **WezTerm** terminal emulator
- **mise** for runtime versions (Go 1.22, Node LTS)
- **Sketchybar** macOS menu bar (macOS only)
- **Yabai** tiling window manager (macOS only)
- CLI tools: bat, fd, ripgrep, btop, lazygit, fzf, jq, and more (via Brewfile)

## Install

```bash
curl -fsSL https://dotfiles.zops.dev/install.sh | sh
```

After initial setup, manage dotfiles with:
```bash
chezmoi edit ~/.zshrc    # edit template
chezmoi apply            # apply changes to ~/
chezmoi diff             # preview pending changes
```

## Tmux keybindings
- Prefix: `Ctrl+A`
- `Prefix + i` — split vertical
- `Prefix + o` — split horizontal
- `Prefix + j/k/h/l` — navigate panes (vim-style)
