---
phase: 01-foundation
plan: 01
subsystem: infra
tags: [bash, templates, scaffold, two-system-architecture, progressive-disclosure]

requires: []
provides:
  - "resolve-root.sh: KNZINIT_ROOT + KNZINIT_VERSION path resolution with CLAUDE_PLUGIN_ROOT fallback"
  - "CLAUDE.md.tmpl: two-system architecture template (instruction system + learning system), under 200 lines"
  - "STATE.md.tmpl: updated template with two-system reference and version marker"
  - "rules/session-protocol.md.tmpl: session start/end/compaction protocol template"
  - "rules/conventions.md.tmpl: placeholder coding conventions template"
affects: [02-skill-rewrite, 03-hooks, 04-settings, 05-orchestrator]

tech-stack:
  added: []
  patterns:
    - "Version markers: HTML comment at bottom of each generated file using version from plugin.json"
    - "Path resolution: env var check + dynamic walk-up + known-dir fallback pattern"
    - "Progressive disclosure: root CLAUDE.md as identity+pointers only; details deferred to .claude/rules/"
    - "Two-system architecture: instruction system (static) vs learning system (dynamic)"

key-files:
  created:
    - scaffold/resolve-root.sh
    - scaffold/templates/rules/session-protocol.md.tmpl
    - scaffold/templates/rules/conventions.md.tmpl
  modified:
    - scaffold/templates/CLAUDE.md.tmpl
    - scaffold/templates/STATE.md.tmpl

key-decisions:
  - "resolve-root.sh uses BASH_SOURCE[0] walk-up as primary fallback (avoids jq dependency, uses grep/sed)"
  - "CLAUDE.md.tmpl uses lowercase 'instruction system' and 'learning system' to match exact verify patterns"
  - "autoMemoryDirectory/autoMode guidance placed in Auto Memory section per INFR-05 scope restriction"
  - "rules/ templates include version markers at bottom as HTML comments"

patterns-established:
  - "Template verification: verify commands use grep -q lowercase string matching — templates must match exactly"
  - "Version marker format: <!-- knzinit v{{VERSION}} --> at bottom of all generated files"

requirements-completed: [INFR-01, INFR-02, INFR-05, ARCH-01, ARCH-02, ARCH-03, ARCH-04]

duration: 3min
completed: 2026-03-27
---

# Phase 1 Plan 01: Foundation Summary

**resolve-root.sh with CLAUDE_PLUGIN_ROOT fallback, CLAUDE.md.tmpl rewritten for two-system architecture (instruction + learning) with progressive disclosure under 60 lines, STATE.md.tmpl updated, and two .claude/rules/ starter templates created**

## Performance

- **Duration:** ~3 min
- **Started:** 2026-03-27T14:30:35Z
- **Completed:** 2026-03-27T14:33:05Z
- **Tasks:** 3
- **Files modified:** 5

## Accomplishments

- Created resolve-root.sh: sourceable bash script that exports KNZINIT_ROOT (via CLAUDE_PLUGIN_ROOT env var, dynamic walk-up from BASH_SOURCE[0], or known plugin dirs) and KNZINIT_VERSION (read from plugin.json without jq)
- Rewrote CLAUDE.md.tmpl from 42-line 5-layer-referencing template to 58-line two-system architecture template with critical behavioral instructions in the first third
- Updated STATE.md.tmpl to replace 5-layer/LEARNINGS.md language with two-system reference; added version marker
- Created scaffold/templates/rules/session-protocol.md.tmpl (session start, end, compaction recovery protocol)
- Created scaffold/templates/rules/conventions.md.tmpl (placeholder sections for code conventions)

## Task Commits

Each task was committed atomically:

1. **Task 1: Create path resolution helper** - `de5d97f` (feat)
2. **Task 2: Rewrite CLAUDE.md.tmpl and create rules templates** - `826d666` (feat)
3. **Task 3: Update STATE.md.tmpl** - `c6147e3` (feat)

## Files Created/Modified

- `scaffold/resolve-root.sh` - Sourceable bash path resolver; exports KNZINIT_ROOT, KNZINIT_VERSION, knzinit_version_marker()
- `scaffold/templates/CLAUDE.md.tmpl` - Two-system architecture CLAUDE.md template (58 lines, no 5-layer refs)
- `scaffold/templates/STATE.md.tmpl` - Updated with two-system Session Continuity language + version marker
- `scaffold/templates/rules/session-protocol.md.tmpl` - Session start/end/compaction recovery rules template
- `scaffold/templates/rules/conventions.md.tmpl` - Placeholder coding conventions template

## Decisions Made

- Used `grep/sed` in resolve-root.sh to extract version from plugin.json (avoids jq dependency, consistent with existing hook patterns)
- Used lowercase "instruction system" and "learning system" in CLAUDE.md.tmpl to match the exact strings in the plan's verify commands
- Placed auto-memory guidance and scope-restricted settings note (autoMemoryDirectory, autoMode) in the middle third of CLAUDE.md.tmpl per ARCH-04 and INFR-05

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

Minor: The plan's verify command uses `grep -q "instruction system"` (lowercase). The initial template write used "Instruction system" (capitalized). Fixed before commit by lowercasing the bold labels in the template.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

- All templates are in place for Plan 02 (SKILL.md rewrite) to reference
- INFR-01 blocker resolved: resolve-root.sh provides reliable KNZINIT_ROOT resolution
- INFR-02 version markers implemented in all templates
- INFR-05 scope-restriction guidance documented in CLAUDE.md.tmpl
- ARCH-01 through ARCH-04 implemented in CLAUDE.md.tmpl structure

## Self-Check: PASSED

All files verified present:
- scaffold/resolve-root.sh — FOUND
- scaffold/templates/CLAUDE.md.tmpl — FOUND
- scaffold/templates/STATE.md.tmpl — FOUND
- scaffold/templates/rules/session-protocol.md.tmpl — FOUND
- scaffold/templates/rules/conventions.md.tmpl — FOUND
- .planning/phases/01-foundation/01-01-SUMMARY.md — FOUND

All commits verified: de5d97f, 826d666, c6147e3 — FOUND

---
*Phase: 01-foundation*
*Completed: 2026-03-27*
