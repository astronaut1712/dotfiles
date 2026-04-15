---
plan: 04
phase: 1
wave: 2
title: "Write Brewfile + run_onchange_02_install-packages.sh.tmpl (macOS) and Linux apt equivalent"
depends_on:
  - plan-02
files_modified:
  - home/Brewfile
  - home/run_onchange_02_install-packages.sh.tmpl
  - home/run_once_02_linux-packages.sh.tmpl
autonomous: true
requirements_addressed:
  - PKGM-01
  - PKGM-02
  - PKGM-03
---

# Plan 04: Brewfile + package install scripts

## Objective

Create:
1. `home/Brewfile` — curated list of core packages for macOS (PKGM-01)
2. `home/run_onchange_02_install-packages.sh.tmpl` — macOS script that runs `brew bundle` whenever the Brewfile changes (PKGM-02)
3. `home/run_once_02_linux-packages.sh.tmpl` — Linux script that installs equivalent packages via apt (PKGM-03)

## Tasks

### Task 4.1: Write home/Brewfile

<read_first>
- .planning/requirements (PKGM-01: required packages: fzf, neovim, wezterm, tmux, mise, chezmoi, 1password-cli)
- macosv2.sh (existing brew installs — reference for what is currently used)
- .planning/research/FEATURES.md (Brewfile via run_onchange_ pattern)
</read_first>

<action>
Create `home/Brewfile` with the following content:

```ruby
# Brewfile — Core packages for macOS.
# Managed by chezmoi. Applied via: brew bundle --file ~/.Brewfile
# Re-runs automatically when this file changes (run_onchange_ script).

# ── Package managers / taps ──────────────────────────────────────────────────
tap "homebrew/bundle"
tap "FelixKratz/formulae"        # sketchybar
tap "koekeishiya/formulae"       # yabai, skhd

# ── Shell ────────────────────────────────────────────────────────────────────
brew "zsh"
brew "zsh-syntax-highlighting"
brew "zsh-autosuggestions"
brew "zsh-completions"
brew "fzf"                       # required: PKGM-01

# ── Dotfiles manager ─────────────────────────────────────────────────────────
brew "chezmoi"

# ── Runtime manager ──────────────────────────────────────────────────────────
brew "mise"

# ── Editor ───────────────────────────────────────────────────────────────────
brew "neovim"                    # required: PKGM-01

# ── Terminal ─────────────────────────────────────────────────────────────────
cask "wezterm"                   # required: PKGM-01
brew "tmux"                      # required: PKGM-01

# ── Secrets ──────────────────────────────────────────────────────────────────
cask "1password-cli"             # required: PKGM-01 (op CLI)

# ── Fonts ────────────────────────────────────────────────────────────────────
tap "homebrew/cask-fonts"
cask "font-meslo-lg-nerd-font"   # recommended for Powerlevel10k
cask "font-jetbrains-mono-nerd-font"

# ── CLI productivity ─────────────────────────────────────────────────────────
brew "bat"
brew "fd"
brew "ripgrep"
brew "btop"
brew "tldr"
brew "tree"
brew "lazygit"
brew "jq"
brew "git"
```
</action>

<acceptance_criteria>
- `home/Brewfile` exists
- File contains `brew "fzf"` (PKGM-01 required package)
- File contains `brew "neovim"` (PKGM-01 required package)
- File contains `brew "tmux"` (PKGM-01 required package)
- File contains `brew "mise"` (PKGM-01 required package)
- File contains `brew "chezmoi"` (PKGM-01 required package)
- File contains `cask "1password-cli"` (PKGM-01 required package)
- File contains `cask "wezterm"` (PKGM-01 required package)
- `grep -c "^brew\|^cask\|^tap" home/Brewfile` returns a positive count
</acceptance_criteria>

---

### Task 4.2: Write home/run_onchange_02_install-packages.sh.tmpl (macOS)

<read_first>
- home/Brewfile (the file this script runs bundle on)
- .planning/research/STACK.md (run_onchange_ scripts — reruns when content changes)
- .planning/research/FEATURES.md (run_onchange_ for Brewfile — embed checksum to trigger on change)
- .planning/research/PITFALLS.md (Pitfall 1 — idempotency, Pitfall 4 — shebang)
</read_first>

<action>
Create `home/run_onchange_02_install-packages.sh.tmpl` with the following content:

```bash
#!/usr/bin/env bash
# chezmoi: run_onchange_ — reruns when THIS FILE changes (Brewfile checksum changes → file changes → reruns)
# Installs / updates Homebrew packages from Brewfile.
# Only runs on macOS.

set -euo pipefail

{{- if ne .chezmoi.os "darwin" }}
exit 0  # Not macOS — skip silently
{{- end }}

log()  { echo "[brew-packages] $*"; }
die()  { echo "[brew-packages] ERROR: $*" >&2; exit 1; }

# Ensure Homebrew is on PATH (Apple Silicon vs Intel)
if [[ "$(uname -m)" == "arm64" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  eval "$(/usr/local/bin/brew shellenv 2>/dev/null || true)"
fi

if ! command -v brew &>/dev/null; then
  die "Homebrew not found. Run install.sh first."
fi

# The Brewfile content is embedded as a template comment so chezmoi detects changes.
# chezmoi_brewfile_hash: {{ include "Brewfile" | sha256sum }}

BREWFILE_PATH="$(chezmoi source-path)/Brewfile"
if [[ ! -f "$BREWFILE_PATH" ]]; then
  # Fallback: use the applied location
  BREWFILE_PATH="$HOME/.Brewfile"
fi

log "Running brew bundle from $BREWFILE_PATH ..."
brew bundle --file="$BREWFILE_PATH" --no-lock

log "brew bundle complete."
```

**Key notes:**
- The line `# chezmoi_brewfile_hash: {{ include "Brewfile" | sha256sum }}` embeds the Brewfile's content hash into the script. When Brewfile changes, this line changes, which changes the script's content hash, which triggers chezmoi to re-run it.
- `{{- if ne .chezmoi.os "darwin" }} exit 0 {{- end }}` safely skips on Linux.
- `brew bundle --no-lock` avoids creating/requiring `Brewfile.lock.json`.
</action>

<acceptance_criteria>
- `home/run_onchange_02_install-packages.sh.tmpl` exists
- File contains `#!/usr/bin/env bash`
- File contains `{{ if ne .chezmoi.os "darwin" }}` guard (Linux skip)
- File contains `{{ include "Brewfile" | sha256sum }}` (content-hash trigger mechanism)
- File contains `brew bundle`
- File contains Apple Silicon path guard (`uname -m` check for `arm64`)
- File name starts with `run_onchange_` (correct chezmoi prefix)
</acceptance_criteria>

---

### Task 4.3: Write home/run_once_02_linux-packages.sh.tmpl

<read_first>
- ubuntu.sh (existing Linux package installs — reference for what is currently used)
- .planning/requirements (PKGM-03: apt package list for Linux installs)
- .planning/research/PITFALLS.md (Pitfall 1 — idempotency guards, Pitfall 4 — shebang)
- .planning/research/STACK.md (Linux bootstrap: apt-get update + packages)
</read_first>

<action>
Create `home/run_once_02_linux-packages.sh.tmpl` with the following content:

```bash
#!/usr/bin/env bash
# chezmoi: run_once_ — runs once per content hash.
# Installs core packages on Ubuntu/Linux via apt.
# Only runs on Linux.

set -euo pipefail

{{- if ne .chezmoi.os "linux" }}
exit 0  # Not Linux — skip silently
{{- end }}

log()  { echo "[linux-packages] $*"; }

log "Updating apt package lists..."
sudo apt-get update -qq

log "Installing core packages..."
sudo apt-get install -y \
  zsh \
  curl \
  git \
  tmux \
  wget \
  vim \
  neovim \
  fzf \
  jq \
  ripgrep \
  bat \
  fd-find \
  tree \
  btop \
  tldr

# ── Install chezmoi (if not already present) ──────────────────────────────────
if ! command -v chezmoi &>/dev/null; then
  log "Installing chezmoi via curl..."
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
  export PATH="$HOME/.local/bin:$PATH"
fi

# ── Set zsh as default shell (if not already) ─────────────────────────────────
CURRENT_SHELL="$(getent passwd "$USER" | cut -d: -f7)"
ZSH_PATH="$(command -v zsh)"
if [[ "$CURRENT_SHELL" != "$ZSH_PATH" ]]; then
  log "Setting zsh as default shell..."
  chsh -s "$ZSH_PATH" "$USER" || log "Warning: could not change shell automatically. Run: chsh -s $(which zsh)"
fi

log "Linux package install complete."
```
</action>

<acceptance_criteria>
- `home/run_once_02_linux-packages.sh.tmpl` exists
- File contains `#!/usr/bin/env bash`
- File contains `set -euo pipefail`
- File contains `{{ if ne .chezmoi.os "linux" }}` guard (macOS skip)
- File contains `apt-get install -y` with a package list that includes `zsh`, `git`, `tmux`, `neovim`, `fzf`
- File name starts with `run_once_` (correct chezmoi prefix)
- File contains `command -v chezmoi` idempotency check
</acceptance_criteria>

## must_haves

After all 4 plans in Phase 1 are executed:

1. `./install.sh` is a minimal script that: detects macOS/Linux, installs Homebrew or apt baseline, installs chezmoi, runs `chezmoi init --apply`
2. `home/` directory exists as chezmoi source root with `.chezmoi.toml.tmpl`, `.chezmoiexternal.toml`, `.chezmoidata.toml`, `.chezmoiignore`
3. `home/run_once_01_install-mise.sh.tmpl` installs mise cross-platform and runs `mise install`
4. `home/dot_mise.toml` pins Go 1.22 and Node LTS
5. `home/Brewfile` lists all required packages including fzf, neovim, wezterm, tmux, mise, chezmoi, 1password-cli
6. `home/run_onchange_02_install-packages.sh.tmpl` runs brew bundle with Brewfile change detection
7. `home/run_once_02_linux-packages.sh.tmpl` installs equivalent packages on Ubuntu via apt
8. All scripts use `#!/usr/bin/env bash` and `set -euo pipefail`
9. No references to NVM, GOROOT, GOPATH, Terraform in any new files
