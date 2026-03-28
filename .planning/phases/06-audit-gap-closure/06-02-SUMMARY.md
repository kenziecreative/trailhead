---
phase: 06-audit-gap-closure
plan: 02
subsystem: documentation
tags: [skill, template, hooks, json, session-protocol]

# Dependency graph
requires:
  - phase: 05-infrastructure
    provides: mcp.json.tmpl, settings.json.tmpl, pre-commit-secrets.sh, session-protocol.md.tmpl built
  - phase: 06-audit-gap-closure-01
    provides: audit findings list (INT-02 through INT-09, FLOW-B, FLOW-C) identified
provides:
  - Corrected SKILL.md with {{DATE}} substitution, unconditional hooks dir, correct skill paths, correct fallback paths
  - settings.json.tmpl SessionEnd passes "end" arg to session-end.sh
  - session-protocol.md.tmpl field names matching STATE.md.tmpl headings
  - pre-commit-secrets.sh with accurate PreToolUse trigger comment
  - mcp.json.tmpl as valid JSON with _knzinit_version marker
affects: [any project initialized with /knzinit after this fix]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "JSON templates must be valid JSON — no // comments, use _comment keys for inline docs"
    - "Hook commands pass matcher type as $1 argument for accurate session logging"

key-files:
  created: []
  modified:
    - skills/knzinit/SKILL.md
    - scaffold/templates/settings.json.tmpl
    - scaffold/templates/rules/session-protocol.md.tmpl
    - scaffold/hooks/pre-commit-secrets.sh
    - scaffold/templates/mcp.json.tmpl

key-decisions:
  - "mcp.json.tmpl uses _comment key (JSON convention) instead of // comments (invalid JSON)"
  - "SessionEnd passes 'end' as matcher arg so session-end.sh logs 'end' not 'unknown'"
  - ".claude/hooks/ created unconditionally — session hooks install for all projects, not just git repos"

patterns-established:
  - "Template placeholders: {{PROJECT_NAME}}, {{PROJECT_DESCRIPTION}}, {{VERSION}}, {{DATE}} — all four must be documented together"
  - "Skill install paths in SKILL.md are relative to scaffold/ base — no redundant scaffold/ prefix"

requirements-completed: [INT-02, INT-03, INT-04, INT-05, INT-06, INT-07, INT-08, INT-09, FLOW-B, FLOW-C]

# Metrics
duration: 3min
completed: 2026-03-28
---

# Phase 6 Plan 02: Audit Gap Closure — Documentation and Template Corrections Summary

**Closed 8 integration gaps and 2 flow issues by aligning SKILL.md instructions with resolve-root.sh, fixing JSON validity in mcp.json.tmpl, and correcting field name references across session-protocol.md.tmpl and settings.json.tmpl**

## Performance

- **Duration:** ~3 min
- **Started:** 2026-03-28T12:49:10Z
- **Completed:** 2026-03-28T12:51:26Z
- **Tasks:** 2
- **Files modified:** 5

## Accomplishments

- Fixed SKILL.md Step 3D to create `.claude/hooks/` unconditionally (was incorrectly gated on git repo)
- Added `{{DATE}}` placeholder substitution instruction to SKILL.md Step 3A alongside existing placeholders
- Corrected Step 3B skill install paths from `scaffold/skills/` to `skills/` (redundant prefix removed)
- Updated SKILL.md fallback path docs from `~/.config/claude/plugins/knzinit/` to `$CLAUDE_PROJECT_DIR/.claude/plugins/knzinit/` matching resolve-root.sh actual behavior
- settings.json.tmpl SessionEnd now passes `"end"` as argument so session-end.sh logs "end" not "unknown"
- session-protocol.md.tmpl "Stopped at" references updated to "Current Position" to match STATE.md.tmpl headings
- pre-commit-secrets.sh comment corrected — accurately states it fires on any Bash tool use, not just "git commit"
- mcp.json.tmpl replaced with valid JSON using `_comment` and `_knzinit_version` keys (removed illegal // comments)

## Task Commits

Each task was committed atomically:

1. **Task 1: Fix SKILL.md instruction gaps (INT-02, INT-03, INT-04, INT-07)** - `d0a9884` (fix)
2. **Task 2: Fix template polish issues (INT-05, INT-06, INT-08, INT-09)** - `e29f2db` (fix)

## Files Created/Modified

- `skills/knzinit/SKILL.md` — Four targeted fixes: hooks dir unconditional, {{DATE}} added, skill paths corrected, fallback paths aligned
- `scaffold/templates/settings.json.tmpl` — SessionEnd command now passes "end" argument to session-end.sh
- `scaffold/templates/rules/session-protocol.md.tmpl` — "Stopped at" replaced with "Current Position" in two locations
- `scaffold/hooks/pre-commit-secrets.sh` — Comment on line 3 rewritten to accurately describe PreToolUse/Bash trigger
- `scaffold/templates/mcp.json.tmpl` — Entire file replaced with valid JSON structure

## Decisions Made

- mcp.json.tmpl uses `_comment` key (widely-used JSON convention) instead of `//` comments which are invalid JSON
- SessionEnd passes `"end"` as the matcher argument — the session-end.sh already accepted `$1`, just wasn't being passed
- `.claude/hooks/` directory creation is unconditional because session hooks (hook-utils.sh, session-start.sh, session-end.sh, pre-compact-check.sh, post-compact-orientation.sh) install for ALL projects

## Deviations from Plan

None — plan executed exactly as written. The INT-05 verify command pattern `'"end"'` does not match the JSON-escaped form `\"end\"` in the file, but the implementation is correct and verified with an adjusted grep pattern.

## Issues Encountered

The plan's verify command for INT-05 used `grep -q '"end"'` but the string appears as `\"end\"` in the JSON template (escaped for the command string). Verified with `grep -q 'session-end.sh.*end'` instead — confirms the argument is correctly passed.

## User Setup Required

None — no external service configuration required.

## Next Phase Readiness

- All 10 audit items (INT-02 through INT-09, FLOW-B, FLOW-C) from phase 06-01 are now closed
- Phase 06 is complete — v2.0 milestone audit gap closure finished
- No blockers

---
*Phase: 06-audit-gap-closure*
*Completed: 2026-03-28*
