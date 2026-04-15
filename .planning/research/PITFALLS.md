# Pitfalls Research: chezmoi dotfiles

## Pitfall 1: Non-idempotent install scripts
- **Warning signs**: Script uses `echo >> ~/.zshrc`, `mkdir`, `git clone` without guards
- **Prevention**: Always check before acting: `command -v brew || install_brew`, `grep -q "pattern" file || add_line`, `[ -d "$DIR" ] || git clone`
- **Phase**: Bootstrap (Phase 1)

## Pitfall 2: Script execution order bugs
- **Warning signs**: Script 2 depends on a tool installed by Script 3
- **Prevention**: Use numeric prefixes `01_`, `02_`, `03_` — chezmoi executes in ASCII order. Map out dependency chain first.
- **Phase**: Bootstrap (Phase 1)

## Pitfall 3: mise/PATH not activated for run_once_ scripts
- **Warning signs**: `run_once_` script calls `go` or `node` but they're not found — mise hasn't been activated in the non-interactive shell chezmoi uses
- **Prevention**: In chezmoi scripts, source mise explicitly: `export PATH="$HOME/.local/share/mise/shims:$PATH"` or `eval "$(mise activate bash)"` at top of script. Don't rely on `~/.zshrc` being sourced.
- **Phase**: Bootstrap (Phase 1)

## Pitfall 4: Forgetting #!/usr/bin/env bash (vs hardcoded path)
- **Warning signs**: Script fails on Linux with "bad interpreter" because `/bin/bash` doesn't exist or differs
- **Prevention**: Always use `#!/usr/bin/env bash` not `#!/bin/bash`. Or use chezmoi's `#!{{ lookPath "bash" }}` template function.
- **Phase**: All phases with scripts

## Pitfall 5: Template files that should be plain files
- **Warning signs**: `.tmpl` extension on files with no template syntax — performance overhead; risk of accidental template parse errors if user's config has `{{` in it
- **Prevention**: Only add `.tmpl` extension to files that actually use template syntax. Plain config files (tmux.conf, wezterm.lua without OS conditionals) stay as plain files.
- **Phase**: Config (Phase 2)

## Pitfall 6: chezmoi managed files edited directly in ~/
- **Warning signs**: `chezmoi diff` shows unexpected changes; your edits get overwritten by next `chezmoi apply`
- **Prevention**: Always edit via `chezmoi edit ~/.zshrc` or directly in `~/.local/share/chezmoi/`. Document this in README.
- **Phase**: Ongoing

## Pitfall 7: 1Password not signed in during chezmoi apply
- **Warning signs**: `chezmoi apply` fails with "op: not signed in" or template render error
- **Prevention**: 
  - With Touch ID: op CLI handles auth automatically via biometric
  - On headless/CI: skip 1Password templates with `{{ if .op_available }}` guard
  - Guard: check `op account list` returns successfully before apply
- **Phase**: Config (Phase 2)

## Pitfall 8: Neovim config — managing too much
- **Warning signs**: chezmoi manages entire `~/.config/nvim/` including lazy.nvim lock files → conflicts on update
- **Prevention**: chezmoi manages ONLY `init.lua` (or `init.vim`). lazy.nvim manages itself. Add `~/.config/nvim/` to chezmoi's ignore except for init file.
- **Phase**: Config (Phase 2)

## macOS-Specific Pitfalls

### Pitfall 9: Sketchybar/Yabai without SIP disabled
- **Warning signs**: Yabai silently fails to manage windows; Sketchybar can't access menu bar
- **Prevention**: Install binaries unconditionally on macOS. In README, document SIP disable steps clearly. Scripts should NOT fail if SIP is enabled — just warn.
- **Phase**: macOS setup (Phase 3)

### Pitfall 10: Homebrew PATH on Apple Silicon vs Intel
- **Warning signs**: `brew` not found after install on Apple Silicon — `/opt/homebrew/bin` vs `/usr/local/bin`
- **Prevention**: In install.sh, detect architecture: `if [[ $(uname -m) == "arm64" ]]; then eval "$(/opt/homebrew/bin/brew shellenv)"; fi`
- **Phase**: Bootstrap (Phase 1)

### Pitfall 11: Gatekeeper blocking downloaded binaries
- **Warning signs**: `sketchybar` or `yabai` open dialog saying "cannot be opened because the developer cannot be verified"
- **Prevention**: After install, run `xattr -cr /usr/local/bin/yabai` or install via Homebrew (avoids Gatekeeper). Prefer `brew install` for all macOS tools.
- **Phase**: macOS setup (Phase 3)

## mise Pitfalls

### Pitfall 12: mise not in PATH for new shells
- **Warning signs**: Fresh terminal after install shows `mise: command not found`
- **Prevention**: The chezmoi-managed `.zshrc` must include `eval "$(mise activate zsh)"`. Ensure mise is installed BEFORE chezmoi applies `.zshrc`, or the first shell after install may need a reload.
- **Phase**: Bootstrap (Phase 1)

### Pitfall 13: Global .mise.toml vs project .mise.toml conflicts  
- **Warning signs**: Project expects Go 1.21 but global config has Go 1.22 pinned
- **Prevention**: Use `~/.config/mise/config.toml` for global defaults. Per-project `.mise.toml` overrides. Document this clearly.
- **Phase**: Config (Phase 2)
