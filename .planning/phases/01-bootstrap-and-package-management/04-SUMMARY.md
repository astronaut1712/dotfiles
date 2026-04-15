# Plan 04: Brewfile + package install scripts — SUMMARY

**Status:** Complete
**Phase:** 1 — Bootstrap & Package Management

## What was built
Created the macOS Brewfile with all required packages (fzf, neovim, wezterm, tmux, mise, chezmoi, 1password-cli plus CLI tools), a `run_onchange_` script that re-runs `brew bundle` whenever the Brewfile changes (using sha256sum content hashing), and a `run_once_` Linux script that installs equivalent packages via apt.

## Key files
- `home/Brewfile` (new) — 26 brew/cask/tap entries covering all PKGM-01 required packages
- `home/run_onchange_02_install-packages.sh.tmpl` (new) — macOS brew bundle with Brewfile change detection, Apple Silicon path handling
- `home/run_once_02_linux-packages.sh.tmpl` (new) — Linux apt package install with chezmoi idempotency guard and zsh default shell setup

## Requirements addressed
- PKGM-01: Brewfile installs core packages on macOS
- PKGM-02: `run_onchange_` script re-runs `brew bundle` when Brewfile changes
- PKGM-03: apt package list handles Linux installs

## Deviations
None.

## Self-Check: PASSED
All acceptance criteria verified — 26 package entries in Brewfile, all 7 required packages present, OS guards in both scripts, sha256sum trigger mechanism, idempotency checks, strict mode enabled.
