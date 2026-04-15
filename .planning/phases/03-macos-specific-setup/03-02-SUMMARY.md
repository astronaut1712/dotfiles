---
phase: 03-macos-specific-setup
plan: 02
subsystem: config

tags: [sketchybar, yabai, chezmoi, chezmoiignore, macos, lua]

requires:
  - phase: 03-macos-specific-setup
    plan: 01
    provides: Brewfile with sketchybar/yabai packages and run_once setup script

provides:
  - 35 sketchybar config files in chezmoi source (Lua, C, makefiles)
  - 1 yabai config in chezmoi source
  - Template-gated .chezmoiignore for macOS-only deployment

affects: [03-macos-specific-setup]

tech-stack:
  added: []
  patterns: [verbatim config copy to chezmoi source, template-gated .chezmoiignore]

key-files:
  created:
    - home/dot_config/sketchybar/ (35 files)
    - home/dot_config/yabai/yabairc
  modified:
    - home/.chezmoiignore

key-decisions:
  - "All config files copied verbatim — no .tmpl suffix needed (pure Lua/C/make)"
  - "helpers/install.sh excluded — logic absorbed by run_once_03 script (Plan 03-01)"
  - "Template gate uses ne .chezmoi.os darwin pattern to exclude on non-macOS"

patterns-established:
  - "Verbatim copy for static configs (no template expressions = no .tmpl suffix)"
  - "Template-gated .chezmoiignore blocks for OS-specific config directories"

requirements-completed: [MACOS-02, MACOS-03]

duration: 5min
completed: 2025-07-22
---

# Plan 03-02: Sketchybar & Yabai Config Migration

**Copied 36 config files verbatim to chezmoi source and template-gated .chezmoiignore for macOS-only deployment.**

## Performance

- **Tasks:** 2 completed
- **Files modified:** 37 (36 created + 1 modified)

## Accomplishments
- Copied 35 sketchybar config files (Lua scripts, C sources, makefiles, .gitignore)
- Copied 1 yabai config (yabairc)
- Added template-conditional block to .chezmoiignore excluding sketchybar/yabai on non-macOS
- Verified file count and content integrity via diff

## Task Commits

1. **Task 1: Copy 36 config files to chezmoi source** - `712e459` (feat)
2. **Task 2: Template-gate macOS configs in .chezmoiignore** - `fc7fa94` (feat)

## Files Created/Modified
- `home/dot_config/sketchybar/` — 35 files: sketchybarrc, 6 Lua modules, 7 items, 6 widgets, 5 helpers, 2 event_provider roots, 3 cpu_load, 3 network_load, 2 menus
- `home/dot_config/yabai/yabairc` — Window manager config
- `home/.chezmoiignore` — Appended macOS template gate

## Decisions Made
- All files static (no template expressions) so no .tmpl suffix
- helpers/install.sh excluded per Plan 03-01 (absorbed into run_once script)

## Deviations from Plan
None - plan executed exactly as written
