---
phase: 03-macos-specific-setup
plan: 01
subsystem: infra

tags: [homebrew, brewfile, chezmoi, macos, sketchybar, yabai, skhd]

requires:
  - phase: 02-app-config-migration
    provides: chezmoi source structure and Brewfile pattern

provides:
  - Brewfile with macOS window management packages (sketchybar, yabai, skhd)
  - One-time macOS WM setup script (SIP detection, SbarLua, helpers, app font)
  - SF Mono and SF Pro font cask entries

affects: [03-macos-specific-setup]

tech-stack:
  added: [sketchybar, yabai, skhd, lua, switchaudio-osx, nowplaying-cli, sf-symbols]
  patterns: [run_once chezmoi script with error-handler wrapping]

key-files:
  created:
    - home/run_once_03_macos-wm-setup.sh.tmpl
  modified:
    - home/Brewfile

key-decisions:
  - "All potentially-failing commands wrapped with || { warn ... } to ensure setup script never exits non-zero"
  - "SIP detection prints informational warning box — does not block installation"
  - "SbarLua checks both /usr/local and /opt/homebrew paths for Apple Silicon compatibility"

patterns-established:
  - "run_once scripts with template gate at top: {{ if ne .chezmoi.os darwin }}exit 0{{ end }}"
  - "Error-handler pattern for advisory setup steps that should not block chezmoi apply"

requirements-completed: [MACOS-01, MACOS-04]

duration: 8min
completed: 2025-07-22
---

# Plan 03-01: macOS Window Management Installation

**Added 9 Homebrew packages for window management and created idempotent one-time setup script with SIP detection.**

## Performance

- **Tasks:** 2 completed
- **Files modified:** 2

## Accomplishments
- Added sketchybar, yabai, skhd, lua, switchaudio-osx, nowplaying-cli, sf-symbols to Brewfile
- Added font-sf-mono and font-sf-pro cask entries
- Created run_once_03 setup script with SIP detection, SbarLua install, helper build, and app font download
- All setup steps are idempotent and wrapped in error handlers

## Task Commits

1. **Task 1: Add macOS WM packages to Brewfile** - `1b8a39b` (feat)
2. **Task 2: Create one-time macOS WM setup script** - `2876316` (feat)

## Files Created/Modified
- `home/Brewfile` - Added Window Management section (7 formulae) and 2 font casks
- `home/run_once_03_macos-wm-setup.sh.tmpl` - One-time setup: SIP check, SbarLua, helpers, app font

## Decisions Made
- Wrapped all setup commands in error handlers to prevent chezmoi apply failures
- SIP detection is informational only (warning box, no exit)

## Deviations from Plan
None - plan executed exactly as written
