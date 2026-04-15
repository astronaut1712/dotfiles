# Plan 03: mise installation script + global config — SUMMARY

**Status:** Complete
**Phase:** 1 — Bootstrap & Package Management

## What was built
Created the chezmoi script that installs mise cross-platform (`brew install mise` on macOS, `curl | sh` on Linux) and the global `~/.mise.toml` config file that pins Go and Node versions. The script automatically runs `mise install` after setup.

## Key files
- `home/run_once_01_install-mise.sh.tmpl` (new)
- `home/dot_mise.toml` (new)

## Deviations
None.

## Self-Check: PASSED
All acceptance criteria verified.
