---
plan: 03
phase: 1
wave: 2
title: "Write run_once_01_install-mise.sh.tmpl and dot_mise.toml"
depends_on:
  - plan-02
files_modified:
  - home/run_once_01_install-mise.sh.tmpl
  - home/dot_mise.toml
autonomous: true
requirements_addressed:
  - RTMG-01
  - RTMG-02
  - RTMG-04
---

# Plan 03: mise installation script + global config

## Objective

Create the chezmoi script that installs mise, and the global `~/.mise.toml` config file that pins Go and Node versions. After `chezmoi apply`, a new shell will have `go` and `node` available via mise at the declared versions.

## Tasks

### Task 3.1: Write home/run_once_01_install-mise.sh.tmpl

<read_first>
- home/.chezmoidata.toml (mise_install_url variable)
- .planning/research/STACK.md (mise install command, mise activate)
- .planning/research/PITFALLS.md (Pitfall 3 — mise PATH not in run_once_ scripts; Pitfall 4 — #!/usr/bin/env bash)
- .planning/research/SUMMARY.md (watch out for: mise PATH in scripts)
</read_first>

<action>
Create `home/run_once_01_install-mise.sh.tmpl` with the following content exactly:

```bash
#!/usr/bin/env bash
# chezmoi: run_once_ — runs once per content hash (idempotent installs)
# Installs mise runtime version manager.
# Dependency order: 01 — runs FIRST (before Brewfile, before dotfiles applied)

set -euo pipefail

log()  { echo "[mise-install] $*"; }
die()  { echo "[mise-install] ERROR: $*" >&2; exit 1; }

# ── macOS: install via Homebrew ───────────────────────────────────────────────
{{- if eq .chezmoi.os "darwin" }}

if command -v mise &>/dev/null; then
  log "mise already installed — skipping"
  exit 0
fi

if ! command -v brew &>/dev/null; then
  die "Homebrew not found. Run install.sh first."
fi

log "Installing mise via Homebrew..."
brew install mise

# ── Linux: install via curl ───────────────────────────────────────────────────
{{- else if eq .chezmoi.os "linux" }}

if command -v mise &>/dev/null; then
  log "mise already installed — skipping"
  exit 0
fi

log "Installing mise via curl..."
curl https://mise.run | sh

# Add mise to PATH for this script (non-interactive shell — .zshrc not sourced)
export PATH="$HOME/.local/share/mise/bin:$HOME/.local/bin:$PATH"

{{- end }}

# ── Verify installation ───────────────────────────────────────────────────────
if command -v mise &>/dev/null; then
  log "mise installed: $(mise --version)"
else
  die "mise installation failed — binary not found after install"
fi

# ── Run mise install to pull declared tool versions ───────────────────────────
# Activate mise in this non-interactive shell before running mise install
export PATH="$HOME/.local/share/mise/shims:$PATH"

log "Running mise install to pull pinned Go + Node versions..."
mise install --yes

log "mise setup complete."
```

**Key implementation notes:**
- The `{{- if eq .chezmoi.os "darwin" }}` block selects `brew install mise` on macOS
- The `{{- else if eq .chezmoi.os "linux" }}` block uses the `curl https://mise.run | sh` URL
- `export PATH="$HOME/.local/share/mise/shims:$PATH"` is required because chezmoi runs scripts in non-interactive shells where `~/.zshrc` is NOT sourced
- The `command -v mise` idempotency guard at the top prevents re-installation
</action>

<acceptance_criteria>
- `home/run_once_01_install-mise.sh.tmpl` exists
- File contains `#!/usr/bin/env bash`
- File contains `set -euo pipefail`
- File contains `{{ if eq .chezmoi.os "darwin" }}` (macOS template block)
- File contains `{{ if eq .chezmoi.os "linux" }}` OR `{{ else if eq .chezmoi.os "linux" }}` (Linux template block)
- File contains `brew install mise` (macOS path)
- File contains `curl https://mise.run | sh` (Linux path)
- File contains `command -v mise` (idempotency guard)
- File contains `export PATH=` with mise shims path (non-interactive shell PATH fix)
- File contains `mise install`
- `bash -n home/run_once_01_install-mise.sh.tmpl 2>&1` — note: template syntax may cause a parse warning, but file must be readable
</acceptance_criteria>

---

### Task 3.2: Write home/dot_mise.toml

<read_first>
- .planning/research/STACK.md (mise config file format, Global .mise.toml example)
- .planning/requirements (RTMG-02: pinned Go + Node versions)
</read_first>

<action>
Create `home/dot_mise.toml` with the following content. This file will be managed by chezmoi and applied to `~/.mise.toml`:

```toml
# ~/.mise.toml — Global mise tool version config
# Managed by chezmoi. Edit via: chezmoi edit ~/.mise.toml
# Run `mise install` after changes to pull new versions.

[tools]
go   = "1.22"
node = "lts"
```

**Notes:**
- `go = "1.22"` pins to the latest Go 1.22.x patch (mise resolves latest patch automatically)
- `node = "lts"` pins to the current LTS release at install time
- This file does NOT use `.tmpl` suffix since it contains no OS-conditional template syntax
</action>

<acceptance_criteria>
- `home/dot_mise.toml` exists
- File contains `[tools]` section
- File contains `go` entry with a version string (e.g., `go = "1.22"`)
- File contains `node` entry (e.g., `node = "lts"`)
- File does NOT have `.tmpl` extension (no template syntax needed)
- `cat home/dot_mise.toml | grep -c '\[tools\]'` outputs `1`
</acceptance_criteria>
