---
plan: 01
phase: 1
wave: 1
title: "Rewrite install.sh — OS detection, brew/apt bootstrap, chezmoi install, chezmoi init"
depends_on: []
files_modified:
  - install.sh
autonomous: true
requirements_addressed:
  - BOOT-01
  - BOOT-02
  - BOOT-03
  - BOOT-04
  - BOOT-05
---

# Plan 01: Rewrite install.sh

## Objective

Replace the existing `install.sh` (which references Go, Terraform, and legacy scripts) with a minimal, idempotent bootstrap script that:
1. Detects macOS vs Linux
2. Installs Homebrew (macOS) or ensures apt baseline (Linux)
3. Correctly handles Apple Silicon (`/opt/homebrew`) vs Intel (`/usr/local`) Homebrew paths
4. Installs chezmoi (via brew on macOS, via curl on Linux)
5. Runs `chezmoi init --apply` from the GitHub repo

## Tasks

### Task 1.1: Write new install.sh

<read_first>
- install.sh (current state — understand what to replace)
- macosv2.sh (reference for Homebrew install pattern)
- ubuntu.sh (reference for apt baseline)
- .planning/research/STACK.md (install.sh bootstrap patterns)
- .planning/research/PITFALLS.md (Pitfall 2 — script execution order, Pitfall 10 — Apple Silicon PATH)
</read_first>

<action>
Overwrite `install.sh` with the following content exactly:

```bash
#!/usr/bin/env bash
# install.sh — Bootstrap dotfiles on a clean machine.
# Usage: ./install.sh [--repo <github-url>]
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

# ── 4. Install chezmoi ────────────────────────────────────────────────────────
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

# ── 5. Run chezmoi init --apply ───────────────────────────────────────────────
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

install_chezmoi
run_chezmoi_init

log "Bootstrap complete. Open a new shell to activate your environment."
```
</action>

<acceptance_criteria>
- `install.sh` contains `#!/usr/bin/env bash`
- `install.sh` contains `set -euo pipefail`
- `install.sh` contains `uname -s` for OS detection
- `install.sh` contains `uname -m` for architecture detection
- `install.sh` contains `HOMEBREW_PREFIX="/opt/homebrew"` (Apple Silicon path)
- `install.sh` contains `chezmoi init --apply`
- `install.sh` does NOT contain references to `GO_VERSION`, `GOROOT`, `GOPATH`, `terraform`, `macosv2.sh`, or `ubuntu.sh`
- `install.sh` contains `command -v brew` guard (idempotency check for Homebrew)
- `install.sh` contains `command -v chezmoi` guard (idempotency check for chezmoi)
- `chmod +x install.sh && bash -n install.sh` exits 0 (syntax check)
</acceptance_criteria>
