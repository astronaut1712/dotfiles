# Stack Research: chezmoi + mise dotfiles

## chezmoi

- **Current stable**: v2.x (actively maintained, written in Go)
- **Source layout**: `~/.local/share/chezmoi/` — chezmoi default; files prefixed with `dot_` map to dotfiles
- **Init command**: `chezmoi init --apply https://github.com/USER/dotfiles.git`
  - Clones repo to `~/.local/share/chezmoi/`, applies immediately
  - Bootstrap: `sh -c "$(curl -fsLS get.chezmoi.io)"` or `brew install chezmoi`
- **Cross-platform OS detection in templates**:
  - `{{ if eq .chezmoi.os "darwin" }}` → macOS
  - `{{ if eq .chezmoi.os "linux" }}` → Linux
  - `{{ .chezmoi.osRelease.id }}` → ubuntu, debian, fedora, etc.
- **Script types**:
  - `run_once_*.sh.tmpl` → runs once per content hash (idempotent installs)
  - `run_onchange_*.sh.tmpl` → reruns when content changes (config updates)
  - `run_before_*` / `run_after_*` → ordering control
  - Script execution order is ASCII alphabetical — use numeric prefixes: `run_once_01_brew.sh.tmpl`
- **`.chezmoi.toml.tmpl`**: Machine-specific variables, `promptOnce` for first-run questions
- **`chezmoidata.toml`**: Static template variables committed to repo
- **Confidence**: High (from official chezmoi.io docs)

## chezmoi + 1Password Integration

- Uses `op` CLI (1Password CLI v2)
- Template functions:
  - `{{ onepasswordRead "op://vault/item/field" }}` — simple field read
  - `{{ (onepassword "item-uuid").fields.field_name.value }}` — structured item
  - `{{ onepasswordDocument "item-uuid" }}` — binary/document fields
- Config in `chezmoi.toml`:
  ```toml
  [onepassword]
  command = "op"   # default, override if needed
  ```
- Biometric auth (Touch ID): chezmoi handles session automatically — no explicit `op signin` needed
- **Confidence**: High (from chezmoi.io official docs)

## mise

- **Current stable**: v2025.x (Rust, fast, actively maintained)
- **Replaces**: NVM (Node), asdf, individual version scripts
- **Install**: `curl https://mise.run | sh` or `brew install mise`
- **Config file**: `~/.config/mise/config.toml` (global) or `.mise.toml` (per-project)
- **Global `.mise.toml` example**:
  ```toml
  [tools]
  go = "latest"
  node = "lts"
  ```
- **zsh integration** (add to `.zshrc`):
  ```bash
  eval "$(mise activate zsh)"
  ```
- **PATH**: mise shims are at `~/.local/share/mise/shims` — activated via `mise activate`
- **Confidence**: High

## install.sh Bootstrap Flow

### macOS
```bash
1. Check if Homebrew installed → install if not (curl homebrew install script)
2. brew install chezmoi mise
3. chezmoi init --apply https://github.com/USER/dotfiles.git
   (chezmoi scripts handle further package installs via Brewfile)
```

### Ubuntu/Linux
```bash
1. apt-get update && apt-get install -y curl git
2. curl https://mise.run | sh
3. sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply https://github.com/USER/dotfiles.git
```

### Key principle
- `install.sh` only bootstraps: package manager + chezmoi + mise
- All further installation delegated to chezmoi `run_once_` scripts inside the repo
- This keeps `install.sh` minimal and stable; the repo scripts evolve independently

## Confidence Levels

| Item | Confidence |
|------|-----------|
| chezmoi source layout | High |
| OS template detection | High |
| 1Password integration | High |
| mise install + config | High |
| Script ordering (ASCII) | High |
| install.sh bootstrap pattern | High |
