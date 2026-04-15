# Plan 01: Rewrite install.sh — SUMMARY

**Status:** Complete
**Phase:** 1 — Bootstrap & Package Management

## What was built

Rewrote `install.sh` as a minimal, idempotent chezmoi bootstrap script. Replaced the legacy Go/Terraform/NVM-era approach with:
- OS detection via `uname -s` (macOS/Linux)
- Apple Silicon Homebrew path detection (`/opt/homebrew` vs `/usr/local`)
- Idempotent Homebrew install (checks `command -v brew` first)
- chezmoi install: `brew install chezmoi` on macOS, curl install on Linux
- `chezmoi init --apply` to pull and apply repo

## Key files

- `install.sh` (overwritten — 77 lines added, 23 removed)

## Deviations

None — implemented exactly as specified in plan.

## Self-Check: PASSED

- ✓ `#!/usr/bin/env bash` present
- ✓ `set -euo pipefail` present
- ✓ `uname -s` OS detection
- ✓ `uname -m` arch detection
- ✓ `/opt/homebrew` Apple Silicon path
- ✓ `chezmoi init --apply` present
- ✓ `command -v brew` idempotency guard
- ✓ `command -v chezmoi` idempotency guard
- ✓ No legacy refs (GO_VERSION, GOROOT, GOPATH, terraform, macosv2.sh, ubuntu.sh)
- ✓ `bash -n install.sh` exits 0
