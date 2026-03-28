---
name: handoff
description: Capture current session state to STATE.md for seamless session transitions
disable-model-invocation: true
allowed-tools: Read, Write, Edit
---

# /handoff — Session Handoff

Capture what happened this session so the next session (or a different context window) can pick up without re-explanation. This writes directly to STATE.md -- the single source of truth for session continuity.

## What to Capture

Write a **4-section structured summary** to the `## Session Continuity` section of `.planning/STATE.md`:

### 1. What was done this session
List completed work -- decisions made, files created/modified, problems solved. Be specific (file names, not "updated some files").

### 2. What's in progress
Anything started but not finished. Include enough context that the next session can continue without re-reading all the code.

### 3. What's next
Immediate next steps. Prioritize -- what should the next session tackle first?

### 4. Open questions/blockers
Unresolved questions, things waiting on user input, external dependencies, or known issues discovered this session.

## How to Write It

1. Read the current `.planning/STATE.md`
2. Replace the content under `## Session Continuity` with the 4-section summary above
3. Also update `## Current Position` to reflect where things actually are
4. Also update `## Last Activity` with today's date and a brief description
5. If any decisions were made this session, append them to the `## Recent Decisions` table

**Keep it concise.** Each section: 2-5 bullet points. The goal is orientation, not a full session transcript.

**Works for all project types** -- code, non-code, unknown. The 4-section structure is universal.

## When to Run

- Before ending a work session
- Before clearing context on a long session
- When switching to a different area of the project
- Anytime you want to checkpoint progress
