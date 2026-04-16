#!/usr/bin/env bash
# uninstall.sh — Remove dotfiles setup from this machine.
# Usage: ./uninstall.sh
# Prompts before each destructive step. Use --yes to skip prompts.

set -euo pipefail

AUTO_YES=false
[[ "${1:-}" == "--yes" ]] && AUTO_YES=true

log()  { echo "[uninstall] $*"; }
warn() { echo "[uninstall] WARN: $*" >&2; }

confirm() {
  if $AUTO_YES; then return 0; fi
  printf "[uninstall] %s [y/N] " "$1"
  read -r reply
  [[ "$reply" =~ ^[Yy]$ ]]
}

OS="$(uname -s)"
log "Detected: OS=$OS"

# ── 1. Remove chezmoi-managed dotfiles ────────────────────────────────────────
if command -v chezmoi &>/dev/null; then
  if confirm "Remove all chezmoi-managed dotfiles from \$HOME?"; then
    log "Purging chezmoi-managed files..."
    chezmoi purge --force
    log "Done — chezmoi source and config removed."
  fi
else
  warn "chezmoi not found — skipping managed file removal."
  # Clean up manually if chezmoi is already gone
  if confirm "Remove chezmoi source directory (~/.local/share/chezmoi)?"; then
    rm -rf "${HOME}/.local/share/chezmoi"
    rm -rf "${HOME}/.config/chezmoi"
  fi
fi

# ── 2. Remove Oh-My-Zsh + plugins ────────────────────────────────────────────
if [[ -d "${HOME}/.oh-my-zsh" ]]; then
  if confirm "Remove Oh-My-Zsh (including Powerlevel10k, zsh-autosuggestions)?"; then
    rm -rf "${HOME}/.oh-my-zsh"
    log "Removed ~/.oh-my-zsh"
  fi
fi

# ── 3. Remove tmux plugin manager ────────────────────────────────────────────
if [[ -d "${HOME}/.tmux/plugins/tpm" ]]; then
  if confirm "Remove tmux plugin manager (tpm)?"; then
    rm -rf "${HOME}/.tmux/plugins"
    log "Removed ~/.tmux/plugins"
  fi
fi

# ── 4. Remove mise and installed runtimes ─────────────────────────────────────
if command -v mise &>/dev/null; then
  if confirm "Remove mise and all installed runtimes (Go, Node, etc.)?"; then
    mise implode --yes 2>/dev/null || true
    rm -rf "${HOME}/.local/share/mise" "${HOME}/.config/mise" "${HOME}/.mise.toml"
    log "Removed mise and runtimes."
  fi
fi

# ── 5. Remove chezmoi-deployed config directories ────────────────────────────
CONFIGS=(
  "${HOME}/.config/nvim"
  "${HOME}/.config/wezterm"
  "${HOME}/.config/sketchybar"
  "${HOME}/.config/yabai"
)
for dir in "${CONFIGS[@]}"; do
  if [[ -d "$dir" ]]; then
    if confirm "Remove $dir?"; then
      rm -rf "$dir"
      log "Removed $dir"
    fi
  fi
done

# ── 6. Remove chezmoi-deployed dotfiles ──────────────────────────────────────
DOTFILES=(
  "${HOME}/.zshrc"
  "${HOME}/.tmux.conf"
  "${HOME}/.p10k.zsh"
  "${HOME}/.mise.toml"
)
for f in "${DOTFILES[@]}"; do
  if [[ -f "$f" ]]; then
    if confirm "Remove $f?"; then
      rm -f "$f"
      log "Removed $f"
    fi
  fi
done

# ── 7. macOS: stop window management services ────────────────────────────────
if [[ "$OS" == "Darwin" ]]; then
  for svc in sketchybar yabai skhd; do
    if command -v "$svc" &>/dev/null; then
      if confirm "Stop and unload $svc service?"; then
        brew services stop "$svc" 2>/dev/null || true
        log "Stopped $svc"
      fi
    fi
  done
fi

# ── 8. macOS: uninstall Homebrew packages from Brewfile ──────────────────────
if [[ "$OS" == "Darwin" ]] && command -v brew &>/dev/null; then
  BREWFILE="$(cd "$(dirname "$0")" && pwd)/home/Brewfile"
  if [[ -f "$BREWFILE" ]] && confirm "Uninstall all Homebrew packages from Brewfile?"; then
    log "Removing Brewfile packages..."
    brew bundle cleanup --file="$BREWFILE" --force 2>/dev/null || true
    # Uninstall formulae and casks listed in Brewfile
    while IFS= read -r pkg; do
      brew uninstall --force "$pkg" 2>/dev/null || true
    done < <(grep -E '^(brew|cask) ' "$BREWFILE" | sed 's/^(brew|cask) "//;s/".*//' | sed -E 's/^(brew|cask) "([^"]+)".*/\2/')
    log "Brewfile packages removed."
  fi

  # CLI utilities installed by install.sh
  if confirm "Uninstall CLI utilities (btop, htop, jq, yq, tree, wget, ripgrep, fd, bat, tldr)?"; then
    brew uninstall --force btop htop jq yq tree wget ripgrep fd bat tldr 2>/dev/null || true
    log "CLI utilities removed."
  fi
fi

# ── 9. Linux: remove installed packages ──────────────────────────────────────
if [[ "$OS" == "Linux" ]]; then
  if confirm "Remove CLI utilities installed by install.sh?"; then
    sudo apt-get remove -y btop htop jq tree wget ripgrep bat fd-find tldr 2>/dev/null || true
    sudo rm -f /usr/local/bin/yq
    log "CLI utilities removed."
  fi

  # Remove chezmoi binary if installed to ~/.local/bin
  if [[ -f "${HOME}/.local/bin/chezmoi" ]]; then
    if confirm "Remove chezmoi binary from ~/.local/bin?"; then
      rm -f "${HOME}/.local/bin/chezmoi"
      log "Removed chezmoi binary."
    fi
  fi
fi

# ── 10. Optional: uninstall Homebrew itself ───────────────────────────────────
if [[ "$OS" == "Darwin" ]] && command -v brew &>/dev/null; then
  if confirm "Uninstall Homebrew entirely? (THIS REMOVES ALL BREW PACKAGES)"; then
    log "Uninstalling Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
    log "Homebrew removed."
  fi
fi

log "Cleanup complete. Open a new shell to see the effect."
