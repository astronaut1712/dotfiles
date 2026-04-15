# Features Research: dotfiles with chezmoi

## Table Stakes (every good dotfiles setup must have)

- **Single-command bootstrap**: `./install.sh` or `chezmoi init --apply <url>` gets you from 0 to productive
- **Idempotency**: Safe to re-run without side effects (no duplicate PATH entries, no failed package installs)
- **Secret safety**: No plaintext credentials in git history — ever
- **Cross-platform guard**: macOS-only configs don't break on Linux and vice versa
- **Version pinning**: Runtime versions declared in config, not assumed from system
- **Shell reload**: After init, a new shell session works correctly (PATH, completions, plugins)
- **Existing config preservation**: chezmoi warns before overwriting manually edited files

## Differentiators (great vs basic)

- **chezmoi templates** for OS-conditional content (vs maintaining 2 separate files)
- **`run_once_` scripts** for package installs — tied to content hash, not timestamps
- **`run_onchange_` scripts** for config that must re-apply when changed (e.g., Brewfile)
- **mise global config** declared in dotfiles — Go and Node versions pinned and reproducible
- **1Password integration** for secrets — no `.env` files in the repo
- **Numeric script ordering** — `01_`, `02_` prefixes prevent execution order bugs
- **Separate macOS-only script** for Sketchybar/Yabai — doesn't run on Linux

## chezmoi-specific features worth using

### `run_once_` scripts
- Use for: installing Homebrew, installing Oh-My-Zsh, first-time tool setup
- Always write idempotently even though they "only run once" — content can change
- Naming: `run_once_01_install-homebrew.sh.tmpl`, `run_once_02_install-packages.sh.tmpl`

### `run_onchange_` scripts  
- Use for: Brewfile package installs (re-run when Brewfile changes), font installs
- Naming: `run_onchange_install-brew-packages.sh.tmpl`
- Embed the Brewfile checksum in a comment to trigger on change

### Templates (`.tmpl` suffix)
- Use for: `.zshrc`, any file with OS-conditional content
- Variables: `{{ .chezmoi.os }}`, `{{ .chezmoi.hostname }}`, `{{ .email }}`
- Keep non-templated files as plain files (faster apply, no template processing)

### `externals` (`.chezmoiexternal.toml`)
- Use for: Oh-My-Zsh (clone from GitHub instead of tracking in repo)
- Avoids polluting dotfiles repo with Oh-My-Zsh's 3000 files
- chezmoi manages the clone and keeps it updated

### NOT worth using (for this project)
- **age encryption**: 1Password handles secrets — no need for file encryption
- **Nix**: Overkill for a personal dotfiles setup; Homebrew handles packages well
- **Bitwarden/KeePass**: User already on 1Password

## install.sh vs chezmoi scripts pattern

**Recommendation**: Two-layer approach
1. `install.sh` — pure bootstrap (package manager + chezmoi + mise). Minimal, rarely changes.
2. chezmoi `run_once_` scripts — all actual tool installation and config. Lives in the repo, versioned.

**Why**: Keeps `install.sh` a stable entry point. All evolution happens inside the chezmoi repo. If you re-run: `install.sh` is idempotent (checks before installing), chezmoi handles the rest.

## Anti-features (deliberately avoid)

- Storing secrets in dotfiles git repo (even encrypted-ish)
- Managing lazy.nvim plugins via chezmoi — lazy.nvim self-bootstraps
- Managing full `~/.config/nvim/` — only init file, plugins are ephemeral
- Symlinking (stow) approach — chezmoi copies/templates are more robust
- Installing NVM — mise replaces it
- Hardcoding machine names in configs — use `{{ .chezmoi.hostname }}` or data variables
