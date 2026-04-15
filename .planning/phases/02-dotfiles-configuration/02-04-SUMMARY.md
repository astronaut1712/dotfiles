---
phase: 02-dotfiles-configuration
plan: 04
status: complete
---

## What was done

1. Copied all WezTerm files (8 total) verbatim into `home/dot_config/wezterm/`:
   - 6 Lua files: wezterm.lua, keybinds.lua, tab_bar.lua, status_bar.lua, on.lua, utils.lua (816 lines total)
   - 2 color themes: colors/nightfox.toml, colors/nordfox.toml

2. Created `home/dot_tmux.conf.tmpl` — chezmoi Go template with:
   - OS-conditional powerline sourcing: macOS uses `/opt/homebrew/lib/python3.9/...`, Linux uses `/usr/share/powerline/...` with existence check
   - Removed commented-out cruft (themepack, old status bars)
   - TPM initialization at bottom preserved

3. Added TPM to `home/.chezmoiexternal.toml` as archive from `tmux-plugins/tpm` master.

## Files created/modified

- `home/dot_config/wezterm/` — 8 files (verbatim copy)
- `home/dot_tmux.conf.tmpl` — new chezmoi template (~80 lines)
- `home/.chezmoiexternal.toml` — added TPM entry

## Commits

- `2226e2b` — feat(02-04): migrate wezterm, tmux template, add TPM external
