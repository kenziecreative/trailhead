---
name: sanity-check
description: Verify project health before context clear, milestone completion, or deployment
---

# /sanity-check

Run this to verify the project is in a clean, consistent state. This check adapts to the current state of the project — it only checks what exists.

## Behavior

### 1. Project Health

**Detect project type:** Read `KNZINIT_PROJECT_TYPE` from `.claude/settings.json` env block. If missing or set to `code`/`unknown`, use code behavior. If set to `noncode`, use non-code behavior.

**Code projects (code/unknown/missing):**
- **Compilation/type check**: Run the project's build or type-check command
- **Test suite**: Run tests if a test framework is configured
- **Lint**: Run the linter if configured
- **Debug artifacts**: Scan for console.log/print statements, TODO/FIXME/HACK comments, hardcoded localhost URLs, hardcoded file paths containing /Users/ or /home/

If no build/test/lint commands are established yet, skip and note: "Code health checks will activate once build tooling is configured."

**Non-code projects (noncode):**
- **Deliverable Currency**: Are WIP deliverables referenced in STATE.md still active? Are open items still relevant?
- **Work Stages accuracy**: Does the "Work Stages" section in CLAUDE.md reflect where things actually are?
- **Stale references**: Are there references to completed or abandoned deliverables that should be archived?

### 2. Documentation Currency

Read and verify these files are current (check whichever exist):

1. **`.planning/STATE.md`** — Does the current position match reality? Is the last activity date current?
   - **Decisions overflow:** Count the entries in the Recent Decisions table. If more than 20 entries, warn: "STATE.md has {N} decisions (cap: 20). Archive the oldest {N-20} to `.planning/decisions-archive.md` to keep STATE.md lean."
2. **`CLAUDE.md`** — Does it reflect the actual project state?
3. **Auto memory (MEMORY.md)** — Is it populated? Are entries relevant and not stale?

If any are stale, update them now.

### 3. Context Handoff

Verify that a fresh session would understand the project:

1. Read `CLAUDE.md` — does it point to the right starting docs?
2. Read `.planning/STATE.md` — would a new session know where to resume?
3. Are there implicit decisions from this session that need documenting?

### 4. Summary

Output a summary table:

| Check | Status | Issues |
|-------|--------|--------|
| Project Health | pass/skip/fail | ... |
| Documentation | pass/fail | ... |
| Context Handoff | pass/fail | ... |

If all pass: **"Sanity check passed. Safe to clear context or proceed."**

If any fail, fix them before proceeding.

## When to Run

- Before clearing context on a long session
- Before starting a new major task or milestone
- After a significant refactoring or architectural change
- When something feels "off" about the project state
