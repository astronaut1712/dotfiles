# AGENTS.md - dotfiles

This is a personal dotfiles repository managed by **chezmoi**, not a software project.

## Architecture
- **chezmoi** manages all dotfiles — templates in `home/` are applied to `~/`
- OS-conditional templates (`.tmpl` files) handle macOS vs Linux differences
- External dependencies (Oh-My-Zsh, Powerlevel10k, TPM) are fetched via `.chezmoiexternal.toml`
- **mise** replaces nvm/rbenv/goenv for runtime version management (Go, Node)
- 1Password CLI (`op`) integration for secrets (optional, auto-detected)

## Repository structure
- `install.sh` - Bootstrap script: installs Homebrew (macOS) or baseline packages (Linux), then installs and runs `chezmoi init --apply`
- `home/` - chezmoi source directory containing:
  - `dot_zshrc.tmpl` - ZSH config (Oh-My-Zsh + Powerlevel10k, OS-conditional)
  - `dot_tmux.conf.tmpl` - Tmux config (OS-conditional powerline paths)
  - `dot_p10k.zsh` - Powerlevel10k theme config
  - `dot_mise.toml` - mise tool versions (Go 1.22, Node LTS)
  - `Brewfile` - Homebrew packages for macOS (applied via `run_onchange_` script)
  - `dot_config/nvim/` - Neovim config (lazy.nvim based)
  - `dot_config/wezterm/` - WezTerm terminal config
  - `dot_config/sketchybar/` - macOS menu bar (Lua-based, with C helper providers)
  - `dot_config/yabai/` - macOS tiling window manager
  - `run_once_*.sh.tmpl` - One-time setup scripts (mise install, Linux packages, macOS WM)
  - `run_onchange_*.sh.tmpl` - Re-run on change scripts (Brewfile)
  - `.chezmoiexternal.toml` - External downloads (Oh-My-Zsh, Powerlevel10k, zsh-autosuggestions, TPM)
  - `.chezmoiignore` - Excludes (lazy-lock.json, macOS-only configs on Linux)
- `bin/` - Helper scripts (Go update script)
- `scripts/` - Utility scripts (IP lookup)

## Usage

```bash
git clone https://github.com/astronaut1712/dotfiles.git && cd dotfiles && ./install.sh
```

After initial setup, manage dotfiles with:
```bash
chezmoi edit ~/.zshrc    # edit template
chezmoi apply            # apply changes to ~/
chezmoi diff             # preview pending changes
```

## Key configurations
- **Tmux**: Prefix is `Ctrl+A`, split with `i`/`o`, navigate with `j/k/h/l`
- **NVim**: Lazy.nvim plugin manager, Treesitter for syntax, LSP for Go/TS
- **Wezterm**: Terminal emulator with custom keybindings
- **Sketchybar**: macOS menu bar (requires SIP disable for full features)
- **Yabai**: macOS tiling window manager (requires SIP disable)
- **mise**: Runtime versions — Go 1.22, Node LTS

## No standard development workflow
This is a setup repo — no tests, no builds, no CI to run. Changes are applied via `chezmoi apply` or by re-running `install.sh` for a full bootstrap.