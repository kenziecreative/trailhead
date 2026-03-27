---
name: knzinit
description: Bootstrap a new project with two-system architecture (instruction + learning), security agents, and sanity checks
---

# /knzinit — Project Scaffolding

You are setting up the standard project infrastructure for a new project. This scaffolding is supplemental — it works alongside orchestrators like GSD, not as a replacement. Its purpose is to catch what falls through the cracks: security issues, exposed secrets, documentation drift, and lost context between sessions.

## Step 1: Orientation

Ask the user these three questions. **All three accept "not sure yet" as a valid answer.** Do not force the user down a path — if they don't know, build a flexible foundation that works either way.

1. **What is this project?** (Even a vague idea is fine. "I'm exploring an idea" is a valid answer.)
2. **Is this a code project, a non-code project, or not sure yet?**
3. **Is this already a git repository?** (Check with `git status` first — if it is, tell them and skip the question. If not, ask if they'd like you to initialize one.)

Wait for answers before proceeding.

## Step 2: Explore What Exists

Before creating anything, check what's already in place:

- Does `CLAUDE.md` exist? (extend, don't replace)
- Does `.planning/` exist? (extend, don't replace)
- Does `.claude/` exist with agents, skills, hooks, or settings? (merge, don't overwrite)
- Does `.claude/rules/` exist? (extend, don't replace)
- Does `MEMORY.md` exist in the auto-memory directory? (extend, don't replace)
- What language/framework/package manager is present? (if any code exists)
- Does the project have existing security tooling? (ESLint security plugins, Semgrep, pre-commit hooks, etc.)

If anything substantial exists, ask the user how to integrate rather than replacing it.

## Step 3: Build the Scaffolding

Create everything below, adapting to the user's answers. If the project type is unknown, build the flexible variant that works for both code and non-code.

### Path Resolution

To locate the plugin's templates, use the same logic as `resolve-root.sh`:

1. If `CLAUDE_PLUGIN_ROOT` is set in the environment, use `${CLAUDE_PLUGIN_ROOT}/scaffold/templates/`
2. If not set, walk up from the skill file's location looking for a directory containing `scaffold/resolve-root.sh`
3. As a fallback, check known plugin directories: `~/.claude/plugins/knzinit/`, `~/.config/claude/plugins/knzinit/`

When running shell commands for path resolution, you may source `resolve-root.sh` directly:
`. ${CLAUDE_PLUGIN_ROOT}/scaffold/resolve-root.sh`
This exports `KNZINIT_ROOT`, `KNZINIT_VERSION`, and the `knzinit_version_marker()` function.

**Version markers:** After generating each file from a template, ensure the version marker comment `<!-- knzinit vX.Y.Z -->` is present at the bottom. Read the version from `.claude-plugin/plugin.json` (or use `KNZINIT_VERSION` if resolve-root.sh was sourced).

### 3A: Two-System Architecture

Use the templates in `${KNZINIT_ROOT}/scaffold/templates/` as starting points. Adapt each to the project's specifics.

#### instruction system (static, human-curated)

**CLAUDE.md** (always loaded by Claude Code)

If CLAUDE.md doesn't exist, create it from `${KNZINIT_ROOT}/scaffold/templates/CLAUDE.md.tmpl`. If it does, extend it. The template uses `{{PROJECT_NAME}}`, `{{PROJECT_DESCRIPTION}}`, and `{{VERSION}}` placeholders — substitute these with the actual values.

- What the project is (use the user's description, however vague)
- "When Starting a Session" section pointing to STATE.md
- Auto Memory section with save/prune guidelines
- Pointers to `.planning/STATE.md` and `.claude/rules/`
- If non-code or no git: add a "Session Discipline" section reminding Claude to update STATE.md before ending sessions

Target: under 200 lines. If the project is brand new and vague, this will be short — that's fine. It grows as the project takes shape.

**.claude/rules/** (loaded per-session by Claude Code)

Generate 1-2 starter rules files based on project type:

- **Code projects:** Copy `rules/session-protocol.md.tmpl` → `.claude/rules/session-protocol.md` AND `rules/conventions.md.tmpl` → `.claude/rules/conventions.md`
- **Non-code projects:** Copy `rules/session-protocol.md.tmpl` → `.claude/rules/session-protocol.md` only (conventions not relevant)
- **Not sure yet:** Copy both files (code project pattern — they won't hurt non-code work)

Substitute `{{VERSION}}` in each file with the current version from `plugin.json`. Add the version marker comment at the bottom of each generated file.

#### Learning System (dynamic, session-updated)

**STATE.md** (read at session start)

Create from `${KNZINIT_ROOT}/scaffold/templates/STATE.md.tmpl` with:

- Current position (if new project: "Project initialized. No work completed yet.")
- Last activity date (today)
- Recent Decisions table (max 20 entries, with note to archive older ones to `.planning/decisions-archive.md`)
- Open items / pending questions
- Session Continuity section

Target: under 60 lines.

**Auto Memory (MEMORY.md)**

Write an initial MEMORY.md in the auto-memory directory with what's known so far. If almost nothing is known, that's fine — write what you have and note that it will be populated as the project develops.

### 3B: Security & Sanity Setup

**Only create security agents if this is a code project or the user is unsure.** If explicitly non-code, skip the security scanner and secrets auditor but still create the sanity check.

Install from `${KNZINIT_ROOT}/scaffold/`:
- `agents/security-scanner.md` → `.claude/agents/security-scanner.md`
- `agents/secrets-env-auditor.md` → `.claude/agents/secrets-env-auditor.md`
- `hooks/pre-commit-secrets.sh` → `.claude/hooks/pre-commit-secrets.sh` (git repos only)

Install the sanity check skill:
- `scaffold/skills/sanity-check/SKILL.md` → `.claude/skills/sanity-check/SKILL.md`

Adapt each to the project's actual language and framework. If unknown, use the generic versions as-is — they include notes about what to update once the stack is established.

**If git repo (or user chose to init one):**

Install hooks from `${KNZINIT_ROOT}/scaffold/hooks/`:
- `pre-compact-check.sh` → `.claude/hooks/pre-compact-check.sh`
- `milestone-check.sh` → `.claude/hooks/milestone-check.sh`

Register both in `.claude/settings.json` (merge with existing if present) using the pattern in `${KNZINIT_ROOT}/scaffold/templates/settings.json.tmpl`.

Register the pre-commit secrets hook as a PreToolUse hook in `.claude/settings.json` that triggers when a Bash command contains `git commit`.

Make hook scripts executable with `chmod +x`.

**If NOT a git repo and user doesn't want one:** Add the Session Discipline section to CLAUDE.md instead of creating hooks.

### 3C: .gitignore (if git repo)

Create a `.gitignore` based on `${KNZINIT_ROOT}/scaffold/templates/gitignore.tmpl` if one doesn't already exist.

If the stack is known, add the appropriate language/framework ignores (node_modules/, __pycache__/, target/, build/, dist/, etc.).

### 3D: Create Directories

Ensure these directories exist:
- `.planning/`
- `.planning/security/` (if code project or unsure)
- `.claude/agents/` (if code project or unsure)
- `.claude/skills/`
- `.claude/hooks/` (if git repo)
- `.claude/rules/`

## Step 4: Merge Settings

The canonical template is at `${KNZINIT_ROOT}/scaffold/templates/settings.json.tmpl`. It represents the full code/unsure project variant.

**If `.claude/settings.json` already exists:** READ it first, then merge using these section-specific rules (merge-not-overwrite throughout):

- **hooks**: Append new hook entries to existing hook event arrays. Never remove or overwrite existing hooks — add alongside them.
- **permissions.deny**: Union of existing deny rules and template deny rules. No duplicates (match on `filePath` + `operations`).
- **permissions.allow**: Union of existing allow rules and template allow rules. No duplicates (match on `command`).
- **env**: Preserve all existing keys. Add new keys (`KNZINIT_PROJECT_TYPE`, `KNZINIT_VERSION`) only if not already present.
- **Scalar keys** (`$schema`, `plansDirectory`): Set if not already present; do not overwrite existing values.

**If `.claude/settings.json` does not exist:** Create it fresh from the template.

**Project-type adaptation:** After merging, apply these adjustments based on the project type from Step 1:

- **Code or "not sure yet":** Use the template as-is. It already represents the code variant. Set `env.KNZINIT_PROJECT_TYPE` to `"code"` or `"unknown"` accordingly.
- **Non-code:** Remove the entire `permissions.allow` array. Add two keys at the top level:
  - `"includeGitInstructions": false`
  - `"keep-coding-instructions": false`
  - Set `env.KNZINIT_PROJECT_TYPE` to `"noncode"`.

**All project types:** Substitute `{{VERSION}}` in `env.KNZINIT_VERSION` with the actual version from `plugin.json` (use `KNZINIT_VERSION` from `resolve-root.sh`). Set `env.KNZINIT_PROJECT_TYPE` to the normalized value: `code`, `noncode`, or `unknown`.

## Step 5: Git Commit (if git repo)

If this is a git repo, stage and commit everything with:

```
chore: bootstrap project scaffolding (memory, security, sanity checks)
```

## Step 6: Report

Tell the user what was created and what was adapted. Be specific:

- List every file created
- Note what was skipped and why
- If anything was left generic (because the project type is unknown), list what should be updated once the stack is established
- Remind them that `/sanity-check` is available and adaptive
- Note that this scaffolding works alongside GSD — it won't interfere with GSD's planning structure

After listing the files, show a brief 3-4 line summary of the two-system architecture:

> **Your project now uses a two-system architecture:**
> - **Instruction system** (static, human-curated): `CLAUDE.md` + `.claude/rules/` — tells Claude how to behave in this project
> - **Learning system** (dynamic, session-updated): `STATE.md` + auto memory — tracks what's happening and what's been learned
> These two systems work together: instructions define the framework; the learning system fills it with project-specific context over time.

If the project type was **non-code**, add:

> **Git instructions disabled.** If you use git for version control, set `includeGitInstructions:true` in `.claude/settings.json`.

If the project type was "not sure yet", add:

> **When the project takes shape:** Once you know the language/framework, update the security scanner's dependency scanning, the secrets auditor's env var patterns, and the sanity check's build commands. The scaffolding will keep working in the meantime — it just won't check code-specific things until those are configured.
