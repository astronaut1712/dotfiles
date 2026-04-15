---
phase: 01-bootstrap-and-package-management
plan: 05
type: execute
wave: 3
depends_on: [04]
files_modified: []
autonomous: true
requirements:
  - BOOT-03
  - BOOT-04
  - BOOT-05
  - PKGM-01
  - PKGM-02
  - PKGM-03

must_haves:
  truths:
    - "All chezmoi templates parse without syntax errors"
    - "All shell scripts pass bash syntax and shellcheck validation"
    - "chezmoi dry-run apply completes without errors on macOS"
    - "No cross-OS path contamination (no bare brew calls in Linux scripts, no bare apt calls in macOS scripts)"
  artifacts: []
  key_links:
    - from: "home/*.tmpl"
      to: "chezmoi template engine"
      via: "chezmoi execute-template"
      pattern: "chezmoi execute-template"
    - from: "install.sh"
      to: "chezmoi init --apply"
      via: "bootstrap flow"
      pattern: "chezmoi init"
---

<objective>
Validate the entire Phase 1 bootstrap chain — template syntax, shell correctness, and chezmoi apply dry-run — to catch integration issues before moving to Phase 2.

Purpose: Plans 01-04 built individual pieces. This plan validates they work together as a coherent bootstrap flow.
Output: Passing validation (no new files created — this is a verification-only plan).
</objective>

<execution_context>
@$HOME/.copilot/get-shit-done/workflows/execute-plan.md
@$HOME/.copilot/get-shit-done/templates/summary.md
</execution_context>

<context>
@.planning/PROJECT.md
@.planning/ROADMAP.md
@.planning/STATE.md
@install.sh
@home/.chezmoi.toml.tmpl
@home/.chezmoidata.toml
@home/.chezmoiexternal.toml
@home/.chezmoiignore
@home/Brewfile
@home/dot_mise.toml
@home/run_once_01_install-mise.sh.tmpl
@home/run_onchange_02_install-packages.sh.tmpl
@home/run_once_02_linux-packages.sh.tmpl
</context>

<tasks>

<task type="auto">
  <name>Task 1: Static validation — template syntax + shell lint</name>
  <files></files>
  <action>
Run the following validation checks (no files created — validation only):

**1a. Bash syntax check on install.sh:**
```bash
bash -n install.sh
```
Must exit 0.

**1b. ShellCheck on install.sh:**
```bash
shellcheck install.sh
```
Must exit 0 (or only produce SC-level info/style warnings — no errors).

**1c. Chezmoi template parsing for each .tmpl file:**
For each template file in `home/`, run chezmoi's template validator. Since templates use chezmoi data (`.chezmoi.os`, etc.) which requires chezmoi context, use `chezmoi execute-template` with the source directory:

```bash
# Validate .chezmoi.toml.tmpl parses (skip — it uses promptStringOnce which is interactive)
# Instead, verify it's valid Go text/template syntax by checking for balanced delimiters:
grep -c '{{' home/.chezmoi.toml.tmpl
grep -c '}}' home/.chezmoi.toml.tmpl
# Counts must match

# Validate run_once/run_onchange scripts parse as templates:
chezmoi execute-template < home/run_once_01_install-mise.sh.tmpl > /dev/null
chezmoi execute-template < home/run_onchange_02_install-packages.sh.tmpl > /dev/null
chezmoi execute-template < home/run_once_02_linux-packages.sh.tmpl > /dev/null
```
Each must exit 0.

**1d. ShellCheck on generated scripts (post-template-expansion):**
Expand each template to a temp file, then shellcheck it:
```bash
chezmoi execute-template < home/run_once_01_install-mise.sh.tmpl > /tmp/sc_mise.sh
shellcheck /tmp/sc_mise.sh || true  # Report but don't block on info-level

chezmoi execute-template < home/run_onchange_02_install-packages.sh.tmpl > /tmp/sc_brew.sh
shellcheck /tmp/sc_brew.sh || true

chezmoi execute-template < home/run_once_02_linux-packages.sh.tmpl > /tmp/sc_linux.sh
shellcheck /tmp/sc_linux.sh || true
```
Review each output. Fix any error-level (SC error) issues found. Info/style warnings are acceptable.

**1e. Cross-OS contamination check:**
```bash
# Linux script must NOT call brew directly
! grep -n 'brew ' home/run_once_02_linux-packages.sh.tmpl | grep -v '^#' | grep -v '{{' && echo "PASS: no brew in Linux script"

# macOS script must NOT call apt directly
! grep -n 'apt' home/run_onchange_02_install-packages.sh.tmpl | grep -v '^#' | grep -v '{{' && echo "PASS: no apt in macOS script"
```

If any validation fails with an actual error (not just style warnings), fix the source file before proceeding.
  </action>
  <verify>
    <automated>bash -n install.sh && chezmoi execute-template < home/run_once_01_install-mise.sh.tmpl > /dev/null && chezmoi execute-template < home/run_onchange_02_install-packages.sh.tmpl > /dev/null && chezmoi execute-template < home/run_once_02_linux-packages.sh.tmpl > /dev/null && echo "ALL TEMPLATE CHECKS PASSED"</automated>
  </verify>
  <done>All .tmpl files parse via chezmoi execute-template without error. install.sh passes bash -n. No error-level shellcheck findings. No cross-OS contamination detected.</done>
</task>

<task type="auto">
  <name>Task 2: chezmoi dry-run apply — end-to-end integration</name>
  <files></files>
  <action>
Run chezmoi in dry-run mode to verify the full apply would succeed on this macOS machine. No files will be written to $HOME.

**2a. chezmoi doctor:**
```bash
chezmoi doctor
```
Review output. All critical checks should pass. Warnings about missing optional tools (e.g., `age`, `gpg`) are acceptable.

**2b. chezmoi diff (dry-run preview):**
```bash
chezmoi diff --source-path home/
```
This shows what chezmoi WOULD change. Verify:
- `dot_mise.toml` maps to `~/.mise.toml`
- `Brewfile` maps to `~/.Brewfile` (or wherever .chezmoiexternal puts it)
- run_once/run_onchange scripts are recognized
- No unexpected file conflicts

**2c. chezmoi managed files list:**
```bash
chezmoi managed --source-path home/
```
Verify the list includes expected targets: `.mise.toml`, and any other dot_ prefixed files.

**2d. Verify install.sh references correct chezmoi source:**
```bash
grep -n 'chezmoi init' install.sh
```
Confirm the `chezmoi init --apply` command references the correct GitHub repo URL (`astronaut1712/dotfiles`).

**2e. Verify Brewfile contains all PKGM-01 required packages:**
```bash
for pkg in fzf neovim tmux mise chezmoi; do
  grep -q "\"$pkg\"" home/Brewfile && echo "PASS: $pkg in Brewfile" || echo "FAIL: $pkg missing from Brewfile"
done
grep -q 'wezterm' home/Brewfile && echo "PASS: wezterm in Brewfile" || echo "FAIL: wezterm missing"
grep -q '1password' home/Brewfile && echo "PASS: 1password-cli in Brewfile" || echo "FAIL: 1password-cli missing"
```
All must PASS.

If chezmoi diff or doctor reveals actual errors (not just warnings), diagnose and fix the source files.
  </action>
  <verify>
    <automated>chezmoi doctor 2>&1 | grep -c "error" | grep -q "^0$" && for pkg in fzf neovim tmux mise chezmoi; do grep -q "\"$pkg\"" home/Brewfile || exit 1; done && grep -q 'wezterm' home/Brewfile && grep -q '1password' home/Brewfile && echo "ALL INTEGRATION CHECKS PASSED"</automated>
  </verify>
  <done>chezmoi doctor shows no errors. chezmoi diff produces expected file mappings. All 7 required packages confirmed in Brewfile. install.sh references correct repo.</done>
</task>

</tasks>

<verification>
- All chezmoi templates parse without error
- All shell scripts pass bash -n syntax check
- No error-level shellcheck findings in expanded scripts
- chezmoi doctor shows no errors
- All PKGM-01 required packages present in Brewfile
- No cross-OS path contamination
- install.sh references correct GitHub repo
</verification>

<success_criteria>
Phase 1 bootstrap chain is validated end-to-end: templates parse, scripts lint clean, chezmoi recognizes all managed files, and required packages are declared. Ready to proceed to Phase 2.
</success_criteria>

<output>
After completion, create `.planning/phases/01-bootstrap-and-package-management/05-SUMMARY.md`
</output>
