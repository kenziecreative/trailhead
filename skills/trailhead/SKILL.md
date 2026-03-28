---
name: trailhead
description: Bootstrap a new project with two-system architecture (instruction + learning), security agents, and sanity checks
argument-hint: "[project-name]"
disable-model-invocation: true
---

# /trailhead — Project Scaffolding

You are setting up the standard project infrastructure for a new project. This scaffolding is supplemental — it works alongside orchestrators like GSD, not as a replacement. Its purpose is to catch what falls through the cracks: security issues, exposed secrets, documentation drift, and lost context between sessions.

## Step 1: Orientation

Ask the user these four questions. **All four accept "not sure yet" as a valid answer.** Do not force the user down a path — if they don't know, build a flexible foundation that works either way.

1. **What is this project?** (Even a vague idea is fine. "I'm exploring an idea" is a valid answer.)
2. **Is this a code project, a non-code project, or not sure yet?**
3. **Is this already a git repository?** (Check with `git status` first — if it is, tell them and skip the question. If not, ask if they'd like you to initialize one.)
4. **Does this project use external services (APIs, databases, Slack, etc.)?** (Yes, no, or not sure yet.)

Wait for answers before proceeding.

## Step 1B: Non-Code Workflow Questions (non-code projects only)

If the user answered "non-code" in Step 1, ask these additional questions before proceeding to Step 2. **All accept "not sure yet" as a valid answer.** Skip this step entirely for code projects and "not sure yet."

1. **What does a typical work session look like?** (e.g., "I research for 30 min then draft for an hour", "I review documents and leave comments")
2. **What are your main deliverables/outputs?** (e.g., reports, strategies, analyses, documentation)
3. **What decisions come up repeatedly?** (e.g., "which sources to prioritize", "how to structure recommendations")
4. **Any domain terminology Claude should know?** (e.g., industry jargon, acronyms, process names)

Use these answers to populate the Work Stages and Session Patterns sections in CLAUDE.md and the open items in STATE.md. If answers are vague or "not sure yet", use the template defaults.

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

**Non-code adaptation:** If this is a non-code project, skip the last two bullets (language/framework detection and security tooling checks). Instead, check:
- Does the project have existing deliverables or documents?
- Is there an existing workflow or process documented anywhere?

## Step 3: Build the Scaffolding

Create everything below, adapting to the user's answers. If the project type is unknown, build the flexible variant that works for both code and non-code.

### Path Resolution

To locate the plugin's templates, use the same logic as `resolve-root.sh`:

1. If `CLAUDE_PLUGIN_ROOT` is set in the environment, use `${CLAUDE_PLUGIN_ROOT}/scaffold/templates/`
2. If not set, walk up from the skill file's location looking for a directory containing `scaffold/resolve-root.sh`
3. As a fallback, check known plugin directories: `~/.claude/plugins/trailhead/`, `$CLAUDE_PROJECT_DIR/.claude/plugins/trailhead/`

When running shell commands for path resolution, you may source `resolve-root.sh` directly:
`. ${CLAUDE_PLUGIN_ROOT}/scaffold/resolve-root.sh`
This exports `TRAILHEAD_ROOT`, `TRAILHEAD_VERSION`, and the `trailhead_version_marker()` function.

**Version markers:** After generating each file from a template, ensure the version marker comment `<!-- trailhead vX.Y.Z -->` is present at the bottom. Read the version from `.claude-plugin/plugin.json` (or use `TRAILHEAD_VERSION` if resolve-root.sh was sourced).

### 3A: Two-System Architecture

Use the templates in `${TRAILHEAD_ROOT}/scaffold/templates/` as starting points. Adapt each to the project's specifics.

#### instruction system (static, human-curated)

**CLAUDE.md** (always loaded by Claude Code)

If CLAUDE.md doesn't exist, create it from `${TRAILHEAD_ROOT}/scaffold/templates/CLAUDE.md.tmpl`. If it does, extend it. The template uses `{{PROJECT_NAME}}`, `{{PROJECT_DESCRIPTION}}`, `{{VERSION}}`, and `{{DATE}}` placeholders — substitute these with the actual values. Use today's date in YYYY-MM-DD format for `{{DATE}}`.

**Template adaptation for non-code:** The templates (`CLAUDE.md.tmpl`, `STATE.md.tmpl`) contain conditional sections marked with `<!-- IF code/unknown -->` and `<!-- IF noncode -->` comment markers. When generating output:
- For **code** or **not sure yet** projects: include only `<!-- IF code/unknown -->` sections, strip all conditional markers
- For **non-code** projects: include only `<!-- IF noncode -->` sections, strip all conditional markers
- The conditional markers themselves must NOT appear in the generated output

For non-code projects, populate the Work Stages and Session Patterns sections using answers from Step 1B. If the user said "not sure yet" to those questions, keep the template placeholder comments.

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

Create from `${TRAILHEAD_ROOT}/scaffold/templates/STATE.md.tmpl` with:

- Current position (if new project: "Project initialized. No work completed yet.")
- Last activity date (today)
- Recent Decisions table (max 20 entries, with note to archive older ones to `.planning/decisions-archive.md`)
- Open items / pending questions
- Session Continuity section

Target: under 60 lines.

**decisions-archive.md** — Create from `${TRAILHEAD_ROOT}/scaffold/templates/decisions-archive.md.tmpl` in `.planning/decisions-archive.md`. Scaffolded for every project. Substitute `{{VERSION}}` with the current version.

**Auto Memory (MEMORY.md)**

Write an initial MEMORY.md in the auto-memory directory with what's known so far. If almost nothing is known, that's fine — write what you have and note that it will be populated as the project develops.

**.mcp.json** (conditional) — If the user answered "yes" to the external services question (Step 1, Q4), create `.mcp.json` in the project root from `${TRAILHEAD_ROOT}/scaffold/templates/mcp.json.tmpl`. Substitute `{{VERSION}}` with the current version. If the user answered "no" or "not sure yet", skip this file.

### 3B: Security & Sanity Setup

**Only create security agents if this is a code project or the user is unsure.** If explicitly non-code, skip the security scanner and secrets auditor but still create the sanity check.

Install from `${TRAILHEAD_ROOT}/scaffold/`:
- `agents/security-scanner.md` → `.claude/agents/security-scanner.md`
- `agents/secrets-env-auditor.md` → `.claude/agents/secrets-env-auditor.md`
- `hooks/pre-commit-secrets.sh` → `.claude/hooks/pre-commit-secrets.sh` (git repos only)

Install the sanity check skill:
- `skills/sanity-check/SKILL.md` → `.claude/skills/sanity-check/SKILL.md`

**All projects:** Install handoff and resume skills:
- `skills/handoff/SKILL.md` -> `.claude/skills/handoff/SKILL.md`
- `skills/resume/SKILL.md` -> `.claude/skills/resume/SKILL.md`

Adapt each to the project's actual language and framework. If unknown, use the generic versions as-is — they include notes about what to update once the stack is established.

**All projects:** Install these hooks from `${TRAILHEAD_ROOT}/scaffold/hooks/`:
- `hook-utils.sh` → `.claude/hooks/hook-utils.sh` (shared utility library — not executable, sourced by other hooks)
- `pre-compact-check.sh` → `.claude/hooks/pre-compact-check.sh`
- `post-compact-orientation.sh` → `.claude/hooks/post-compact-orientation.sh`
- `session-start.sh` → `.claude/hooks/session-start.sh`
- `session-end.sh` → `.claude/hooks/session-end.sh`

**Git projects only (additional):**
- `milestone-check.sh` → `.claude/hooks/milestone-check.sh`
- `pre-commit-secrets.sh` → `.claude/hooks/pre-commit-secrets.sh`

Register all hooks in `.claude/settings.json` (merge with existing if present) using the pattern in `${TRAILHEAD_ROOT}/scaffold/templates/settings.json.tmpl`. The template includes PreCompact, PostCompact, SessionStart (4 matchers), SessionEnd, Stop, and PreToolUse registrations.

Make hook scripts executable with `chmod +x` (include hook-utils.sh for simplicity, even though it is sourced rather than executed directly).

**If NOT a git repo and user doesn't want one:** Add the Session Discipline section to CLAUDE.md instead of creating hooks.

### 3C: .gitignore (if git repo)

Create a `.gitignore` based on `${TRAILHEAD_ROOT}/scaffold/templates/gitignore.tmpl` if one doesn't already exist.

If the stack is known, add the appropriate language/framework ignores (node_modules/, __pycache__/, target/, build/, dist/, etc.).

### 3D: Create Directories

Ensure these directories exist:
- `.planning/`
- `.planning/security/` (if code project or unsure)
- `.claude/agents/` (if code project or unsure)
- `.claude/skills/`
- `.claude/hooks/`
- `.claude/rules/`

## Step 4: Merge Settings

The canonical template is at `${TRAILHEAD_ROOT}/scaffold/templates/settings.json.tmpl`. It represents the full code/unsure project variant.

**If `.claude/settings.json` already exists:** READ it first, then merge using these section-specific rules (merge-not-overwrite throughout):

- **hooks**: Append new hook entries to existing hook event arrays. Never remove or overwrite existing hooks — add alongside them.
- **permissions.deny**: Union of existing deny rules and template deny rules. No duplicates (match on `filePath` + `operations`).
- **permissions.allow**: Union of existing allow rules and template allow rules. No duplicates (match on `command`).
- **env**: Preserve all existing keys. Add new keys (`TRAILHEAD_PROJECT_TYPE`, `TRAILHEAD_VERSION`) only if not already present.
- **Scalar keys** (`$schema`, `plansDirectory`): Set if not already present; do not overwrite existing values.

**MCP integration (conditional):** If `.mcp.json` was generated in Step 3A (user answered "yes" to external services), add `"enableAllProjectMcpServers": true` as a top-level scalar key in settings.json using the set-if-absent rule. If no .mcp.json was generated, do not add this key.

**If `.claude/settings.json` does not exist:** Create it fresh from the template.

**Project-type adaptation:** After merging, apply these adjustments based on the project type from Step 1:

- **Code or "not sure yet":** Use the template as-is. It already represents the code variant. Set `env.TRAILHEAD_PROJECT_TYPE` to `"code"` or `"unknown"` accordingly.
- **Non-code:** Remove the entire `permissions.allow` array. Add two keys at the top level:
  - `"includeGitInstructions": false`
  - `"keep-coding-instructions": false`
  - Set `env.TRAILHEAD_PROJECT_TYPE` to `"noncode"`.

**All project types:** Substitute `{{VERSION}}` in `env.TRAILHEAD_VERSION` with the actual version from `plugin.json` (use `TRAILHEAD_VERSION` from `resolve-root.sh`). Set `env.TRAILHEAD_PROJECT_TYPE` to the normalized value: `code`, `noncode`, or `unknown`.

## Step 5: Git Commit (if git repo)

If this is a git repo, stage and commit everything with:

```
chore: bootstrap project scaffolding (memory, security, sanity checks)
```

## Step 6: Report

Tell the user what was created and what was adapted. Be specific:

- List every file created, including `.planning/decisions-archive.md` (always created) and `.mcp.json` (if created — note it was generated because user indicated external services)
- Note what was skipped and why
- If anything was left generic (because the project type is unknown), list what should be updated once the stack is established
- Remind them that `/sanity-check` is available and adaptive
- Remind them that `/handoff` captures session state and `/resume` restores orientation
- Note that this scaffolding works alongside GSD — it won't interfere with GSD's planning structure
- If `.mcp.json` was created, remind user to populate it with their actual MCP server configurations

After listing the files, show a brief 3-4 line summary of the two-system architecture:

> **Your project now uses a two-system architecture:**
> - **Instruction system** (static, human-curated): `CLAUDE.md` + `.claude/rules/` — tells Claude how to behave in this project
> - **Learning system** (dynamic, session-updated): `STATE.md` + auto memory — tracks what's happening and what's been learned
> These two systems work together: instructions define the framework; the learning system fills it with project-specific context over time.

If the project type was **non-code**, add:

> **Git instructions disabled.** If you use git for version control, set `includeGitInstructions:true` in `.claude/settings.json`.

If the project type was "not sure yet", add:

> **When the project takes shape:** Once you know the language/framework, update the security scanner's dependency scanning, the secrets auditor's env var patterns, and the sanity check's build commands. The scaffolding will keep working in the meantime — it just won't check code-specific things until those are configured.
