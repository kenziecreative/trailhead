---
phase: 03-hooks
plan: 03
subsystem: infra
tags: [bash, hooks, shell-scripts, settings, scaffold, templates]

# Dependency graph
requires:
  - phase: 03-hooks-01
    provides: post-compact-orientation.sh and hook-utils.sh (scripts being registered)
  - phase: 02-settings
    provides: settings.json.tmpl structure and merge-not-overwrite patterns

provides:
  - settings.json.tmpl registering all 6 hook events (PreCompact, PostCompact, SessionStart x4, SessionEnd, Stop, PreToolUse)
  - CLAUDE.md.tmpl with 3-line compaction recovery guidance
  - SKILL.md with updated hook installation instructions distinguishing all-project vs git-only hooks

affects: [03-02, 03-04, knzinit scaffolding output for all new projects]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "SessionStart registered with 4 separate matcher entries (startup/resume/clear/compact) each passing matcher as argument"
    - "hook-utils.sh installed for all projects (not just git) since session hooks work without git"
    - "All-project vs git-only hook split: session/compaction hooks are universal; milestone/secrets hooks are git-only"

key-files:
  created: []
  modified:
    - scaffold/templates/settings.json.tmpl
    - scaffold/templates/CLAUDE.md.tmpl
    - skills/knzinit/SKILL.md

key-decisions:
  - "SessionStart compact matcher IS registered in settings.json even though session-start.sh treats it as a no-op — ensures hook chain completeness if behavior changes later"
  - "hook-utils.sh, session-start.sh, session-end.sh, pre-compact-check.sh, post-compact-orientation.sh installed for ALL projects; milestone-check.sh and pre-commit-secrets.sh are git-only"
  - "CLAUDE.md.tmpl compaction guidance expanded from 1 line to 3 lines per HOOK-05 requirement"

patterns-established:
  - "All hook events in settings.json.tmpl use CLAUDE_PROJECT_DIR env var for portable hook paths"
  - "SessionStart matchers pass the matcher value as $1 argument to the script"

requirements-completed: [HOOK-05, HOOK-03, HOOK-04]

# Metrics
duration: 1min
completed: 2026-03-27
---

# Phase 3 Plan 03: Hook Registration and Template Updates Summary

**All 6 hook events registered in settings.json.tmpl with 4-matcher SessionStart, plus compaction recovery guidance in CLAUDE.md.tmpl and updated SKILL.md with all-project vs git-only hook split**

## Performance

- **Duration:** 1 min
- **Started:** 2026-03-27T22:02:39Z
- **Completed:** 2026-03-27T22:04:05Z
- **Tasks:** 2
- **Files modified:** 3

## Accomplishments
- Registered PostCompact, SessionStart (4 matchers), and SessionEnd hooks in settings.json.tmpl alongside existing PreCompact, Stop, and PreToolUse
- Expanded CLAUDE.md.tmpl compaction guidance from a single recovery line to 3 lines instructing to preserve context in STATE.md before compaction and rely on hooks for automatic re-orientation
- Updated SKILL.md Step 3B to install all 5 universal hooks (hook-utils.sh, pre-compact-check.sh, post-compact-orientation.sh, session-start.sh, session-end.sh) for all projects, with milestone-check.sh and pre-commit-secrets.sh as git-only additions
- Updated SKILL.md settings.json registration note to reference all 6 hook event types including the new ones

## Task Commits

Each task was committed atomically:

1. **Task 1: Register new hooks in settings.json.tmpl** - `f6b1869` (feat)
2. **Task 2: Add compaction lines to CLAUDE.md.tmpl and update SKILL.md hook installation** - `8168cc1` (feat)

**Plan metadata:** (docs commit — pending)

## Files Created/Modified
- `scaffold/templates/settings.json.tmpl` - Added PostCompact, SessionStart (4 matchers), SessionEnd hook registrations
- `scaffold/templates/CLAUDE.md.tmpl` - Expanded compaction recovery guidance from 1 line to 3 lines
- `skills/knzinit/SKILL.md` - Updated Step 3B with all new hooks, all-project vs git-only split, updated registration note

## Decisions Made
- SessionStart compact matcher is registered in settings.json even though session-start.sh exits immediately for compact — keeps the hook chain complete in case behavior changes later without needing a settings update
- hook-utils.sh included in the chmod +x list for simplicity (even though sourced, not directly executed — it does not hurt)
- All session/compaction hooks (session-start, session-end, pre-compact-check, post-compact-orientation) install for ALL projects since they work without git; milestone-check and pre-commit-secrets install only for git repos

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
None

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- settings.json.tmpl now registers the complete 6-hook chain — any new project scaffolded will automatically get all hooks configured
- SKILL.md correctly guides knzinit installation of all hooks with proper all-project vs git-only separation
- Plan 03-02 (session-start.sh and session-end.sh scripts) has not been executed yet — the scripts are registered in settings.json.tmpl but the actual script files do not exist in scaffold/hooks/ yet; 03-02 should run next
- Plan 03-04 (if any) can proceed once 03-02 creates the referenced scripts

---
*Phase: 03-hooks*
*Completed: 2026-03-27*
