---
name: resume
description: Read STATE.md and recent changes to output rich session orientation
disable-model-invocation: true
allowed-tools: Read, Grep, Glob, Bash(git log *)
---

# /resume — Session Resume

Output a concise orientation summary so you can pick up where the last session left off. This is a **superset of the SessionStart hook** -- the hook gives basic orientation (phase, position, last activity); /resume adds the handoff summary, recent decisions, and changes since last session.

Run this when the automatic SessionStart hook output is not enough context.

## Current State

!`cat .planning/STATE.md 2>/dev/null || echo "No STATE.md found."`

## What to Output

Using the state loaded above, produce an **8-15 line orientation** covering:

1. **Current position** — from `## Current Position` section
2. **Last activity** — from `## Last Activity` section
3. **Session handoff** — from `## Session Continuity` section (the 4-part summary written by /handoff)
4. **Recent decisions** — last 3-5 entries from `## Recent Decisions` table
5. **Changes since last session** — if this is a git repo, run `git log --oneline -10` to show recent commits

## How to Format

Output as a compact bulleted summary. Example:

```
**Resuming: [project name]**

- Position: [current position from STATE.md]
- Last activity: [date and description]
- In progress: [from handoff summary]
- Next steps: [from handoff summary]
- Open questions: [from handoff summary, if any]
- Recent decisions: [last 2-3 decisions, one line each]
- Recent commits: [last 3-5 commit subjects, if git repo]
```

**Keep it to 8-15 lines.** This is a quick orientation, not a full project briefing. If the user wants more detail, they can read STATE.md directly.

## Handling Missing Data

- If `## Session Continuity` is empty or has only the initial placeholder: note "No handoff summary from previous session" and focus on position + decisions
- If not a git repo: skip the "Recent commits" line entirely
- If STATE.md does not exist: output "No STATE.md found. Run /handoff at the end of your next session to enable resume."

**Works for all project types** -- code, non-code, unknown. The orientation format is universal.

## When to Run

- At the start of a new session when the automatic hook output is insufficient
- When resuming after a long break
- When switching back to a project after working on something else
