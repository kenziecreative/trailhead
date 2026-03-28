---
phase: 05-infrastructure
plan: 01
subsystem: infra
tags: [mcp, decisions-archive, knzinit, sanity-check, scaffold]

requires:
  - phase: 04-non-code-and-skills
    provides: knzinit SKILL.md with three-question Step 1 and Step 3A two-system architecture

provides:
  - mcp.json.tmpl with empty mcpServers structure and explanatory comments
  - decisions-archive.md.tmpl with STATE.md-compatible table format
  - knzinit Q4 (external services) expanding interview from 3 to 4 questions
  - Conditional .mcp.json generation in Step 3A (yes-only trigger)
  - Unconditional decisions-archive.md scaffolding in Step 3A
  - Conditional enableAllProjectMcpServers in Step 4 merge (set-if-absent when .mcp.json generated)
  - sanity-check decisions overflow warning with actionable count and archive target

affects:
  - knzinit scaffold workflow
  - sanity-check skill
  - any future plans that reference decisions rotation

tech-stack:
  added: []
  patterns:
    - "Conditional file generation gated on interview answer (yes-only, not-sure-yet skips)"
    - "Set-if-absent merge rule extended to enableAllProjectMcpServers"
    - "Decisions overflow detection with actionable N-20 archive count"

key-files:
  created:
    - scaffold/templates/mcp.json.tmpl
    - scaffold/templates/decisions-archive.md.tmpl
  modified:
    - skills/knzinit/SKILL.md
    - scaffold/skills/sanity-check/SKILL.md

key-decisions:
  - "Q4 (external services) asked for ALL project types — not gated on code/non-code"
  - ".mcp.json generation is yes-only: both no and not-sure-yet skip the file"
  - "decisions-archive.md is created unconditionally for every project"
  - "enableAllProjectMcpServers uses existing set-if-absent merge rule (not a new merge strategy)"
  - "Decisions overflow warning goes in sanity-check Section 2 as a STATE.md sub-check with exact count"

patterns-established:
  - "Conditional scaffold files: generate only when user explicitly says yes; skip on no or not-sure-yet"
  - "Overflow detection pattern: count table entries, warn with exact numbers, point to archive file"

requirements-completed: [INFR-03, INFR-04]

duration: 2min
completed: 2026-03-27
---

# Phase 5 Plan 01: MCP Template and Decisions Archive Summary

**MCP project template and decisions-archive scaffolding added to knzinit, with conditional .mcp.json generation gated on Q4 external services answer and overflow detection in sanity-check**

## Performance

- **Duration:** 2 min
- **Started:** 2026-03-28T04:15:55Z
- **Completed:** 2026-03-28T04:17:21Z
- **Tasks:** 2
- **Files modified:** 4

## Accomplishments

- Two new scaffold templates created: `mcp.json.tmpl` (empty MCP config with explanatory comments) and `decisions-archive.md.tmpl` (matching STATE.md table format with version marker)
- knzinit Step 1 expanded from 3 to 4 questions — Q4 asks about external services for all project types
- Step 3A gets conditional `.mcp.json` generation (yes-only) and unconditional `decisions-archive.md` creation
- Step 4 settings merge gets conditional `enableAllProjectMcpServers` using existing set-if-absent rule
- sanity-check Section 2 now counts decisions entries and warns when >20 with exact archive count

## Task Commits

Each task was committed atomically:

1. **Task 1: Create mcp.json.tmpl and decisions-archive.md.tmpl templates** - `3349b20` (feat)
2. **Task 2: Update SKILL.md orchestrator and sanity-check with MCP generation and decisions overflow** - `cfdc19d` (feat)

**Plan metadata:** (docs commit — this summary)

## Files Created/Modified

- `scaffold/templates/mcp.json.tmpl` - Empty MCP config template with mcpServers structure and how-to comments; version-marked
- `scaffold/templates/decisions-archive.md.tmpl` - Decisions archive with matching STATE.md table format, version-marked under 20 lines
- `skills/knzinit/SKILL.md` - Four targeted edits: Q4 added to Step 1, .mcp.json conditional in Step 3A, decisions-archive unconditional in Step 3A, enableAllProjectMcpServers conditional in Step 4, both new files in Step 6 report
- `scaffold/skills/sanity-check/SKILL.md` - Section 2 STATE.md check extended with decisions overflow sub-check (>20 entries warns with actionable N-20 count)

## Decisions Made

- Q4 (external services) asked for ALL project types — not gated on code/non-code, consistent with the pattern that all Step 1 questions are universal
- .mcp.json generation is yes-only: both "no" and "not sure yet" skip the file (matches plan spec exactly)
- decisions-archive.md is created unconditionally for every project (no conditional needed)
- enableAllProjectMcpServers uses the existing set-if-absent merge rule from Step 4 (no new merge strategy introduced)
- Decisions overflow warning placed inside the existing STATE.md bullet in sanity-check Section 2 (sub-item, since decisions are a STATE.md health concern)

## Deviations from Plan

None — plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

None — no external service configuration required.

## Next Phase Readiness

- Phase 5 Plan 01 complete. All four integration points verified.
- The knzinit workflow now has full MCP scaffolding support and decisions rotation infrastructure.
- No blockers for subsequent phase 5 plans.

---
*Phase: 05-infrastructure*
*Completed: 2026-03-27*
