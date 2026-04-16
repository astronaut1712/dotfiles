#!/usr/bin/env bash
# install.sh — Bootstrap dotfiles on a clean machine.
# Usage: ./install.sh
# Idempotent: safe to re-run anytime.

set -euo pipefail

DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/astronaut1712/dotfiles.git}"

log()  { echo "[install] $*"; }
die()  { echo "[install] ERROR: $*" >&2; exit 1; }

# ── 1. Detect OS ──────────────────────────────────────────────────────────────
OS="$(uname -s)"
ARCH="$(uname -m)"

log "Detected: OS=$OS ARCH=$ARCH"

# ── 2. macOS: install Homebrew ────────────────────────────────────────────────
install_homebrew() {
  if command -v brew &>/dev/null; then
    log "Homebrew already installed — skipping"
    return
  fi
  log "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

setup_homebrew_path() {
  # Apple Silicon: /opt/homebrew  |  Intel: /usr/local
  if [[ "$ARCH" == "arm64" ]]; then
    HOMEBREW_PREFIX="/opt/homebrew"
  else
    HOMEBREW_PREFIX="/usr/local"
  fi
  if [[ -x "${HOMEBREW_PREFIX}/bin/brew" ]]; then
    eval "$("${HOMEBREW_PREFIX}/bin/brew" shellenv)"
  fi
}

# ── 3. Linux: ensure curl + git baseline ──────────────────────────────────────
setup_linux_baseline() {
  log "Updating apt and installing curl, git..."
  sudo apt-get update -qq
  sudo apt-get install -y curl git
}

# ── 4. Install common CLI utilities ───────────────────────────────────────────
install_utilities() {
  log "Installing common CLI utilities..."
  if [[ "$OS" == "Darwin" ]]; then
    brew install btop htop jq yq tree wget ripgrep fd bat tldr
  else
    sudo apt-get install -y \
      btop htop jq tree wget ripgrep bat fd-find tldr
    # yq is not in default apt repos — install via binary
    if ! command -v yq &>/dev/null; then
      log "Installing yq..."
      YQ_ARCH="amd64"
      [[ "$ARCH" == "aarch64" ]] && YQ_ARCH="arm64"
      curl -fsSL "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_${YQ_ARCH}" -o /tmp/yq
      sudo install /tmp/yq /usr/local/bin/yq
      rm -f /tmp/yq
    fi
  fi
}

# ── 5. Install chezmoi ────────────────────────────────────────────────────────
install_chezmoi() {
  if command -v chezmoi &>/dev/null; then
    log "chezmoi already installed — skipping"
    return
  fi
  log "Installing chezmoi..."
  if [[ "$OS" == "Darwin" ]]; then
    brew install chezmoi
  else
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
    export PATH="$HOME/.local/bin:$PATH"
  fi
}

# ── 6. Run chezmoi init --apply ───────────────────────────────────────────────
run_chezmoi_init() {
  log "Running chezmoi init --apply from $DOTFILES_REPO ..."
  chezmoi init --apply "$DOTFILES_REPO"
}

# ── Main ──────────────────────────────────────────────────────────────────────
if [[ "$OS" == "Darwin" ]]; then
  install_homebrew
  setup_homebrew_path
elif [[ "$OS" == "Linux" ]]; then
  setup_linux_baseline
else
  die "Unsupported OS: $OS"
fi

install_utilities
install_chezmoi
run_chezmoi_init

log "Bootstrap complete. Open a new shell to activate your environment."
