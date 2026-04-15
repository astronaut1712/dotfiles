---
phase: 02-dotfiles-configuration
plan: 01
status: complete
---

## What was done

Created `home/dot_zshrc.tmpl` — a chezmoi Go template that replaces the legacy 175-line `.zshrc`. The template:

- **P10k instant prompt** at top, P10k source at bottom
- **OS-conditional PATH**: macOS gets `/opt/homebrew/{bin,sbin}` prepended; Linux gets nothing
- **Oh-My-Zsh** with trimmed plugin list: `(git ssh-agent zsh-autosuggestions tmux docker)`
- **mise activation** via `eval "$(mise activate zsh)"` — replaces nvm, rbenv, goenv
- **fzf integration** with OS-conditional paths (Homebrew on macOS, system on Linux)
- **Clean aliases**: `lg`, `lc`, `weather`, `cm` (chezmoi shortcut)

### Removed legacy cruft

nvm, rbenv, pew, JAVA_HOME, Google Cloud SDK, WAN_IP curl, touchbar/iTerm2, yarn global paths, libxslt/libtool/llvm/make gnubin, openjdk@11, kubeseal alias.

## Files created

- `home/dot_zshrc.tmpl` — 56 lines, valid chezmoi Go template

## Verification

- `chezmoi execute-template < home/dot_zshrc.tmpl` — renders without errors
- macOS conditionals resolve correctly (Homebrew paths, fzf paths, ZSH_HIGHLIGHT dir)

## Commits

- `82d0e43` — feat(02-01): migrate .zshrc into chezmoi Go template
