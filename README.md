# trailhead — Project Scaffolding Plugin

A Claude Code plugin that bootstraps any new project — code, non-code, or undecided — with the files and automation needed to keep Claude effective across sessions.

It scaffolds two systems that work together: an **instruction system** (CLAUDE.md, rules files) that tells Claude how to behave in this project, and a **learning system** (STATE.md, auto-memory) that tracks what's happening so context survives between sessions. The instruction system is static and human-curated; the learning system evolves every session.

On top of that foundation, trailhead installs **session lifecycle hooks** — shell scripts that fire automatically when sessions start, end, or lose context to compaction, so Claude always picks up where it left off without the user re-explaining anything. It also includes an **adaptive health check** that only tests what actually exists in the project (build, tests, docs, security) and skips everything else, so it's safe to run from day one.

## Installation

Claude Code loads plugins from directories listed in your settings. To install trailhead:

1. **Clone the repo** somewhere on your machine:
   ```bash
   git clone https://github.com/kenziecreative/trailhead.git ~/.claude/plugins/trailhead
   ```

2. **Register the plugin** in your Claude Code settings (`~/.claude/settings.json`):
   ```json
   {
     "plugins": [
       "~/.claude/plugins/trailhead"
     ]
   }
   ```

3. **Verify it loaded** by starting Claude Code and running `/trailhead`. The skill should appear and begin the project interview.

You can clone it anywhere — the path in `settings.json` just needs to point to the directory containing `.claude-plugin/plugin.json`.

### Updating

Pull the latest version:
```bash
cd ~/.claude/plugins/trailhead && git pull
```

No restart needed — Claude Code picks up plugin changes on the next session.

## Code and Non-Code Projects

Not every project is a codebase. Research projects, writing projects, strategy work, and process design all benefit from session continuity and structured state — but they don't need linters, security scanners, or build commands.

trailhead handles this by adapting at scaffold time. The interview asks different questions depending on project type: code projects get asked about tech stack, frameworks, and testing; non-code projects get asked about workflow patterns, recurring decisions, and domain terminology. From there, every generated file adjusts — CLAUDE.md encodes workflow processes instead of programming conventions, STATE.md tracks documents and stakeholders instead of branches and dependencies, and the health check skips code-specific checks entirely.

If the project type isn't clear yet, trailhead scaffolds the flexible variant (code pattern) that self-activates as the project takes shape.

## Plugin Structure

This follows the current Claude Code plugin conventions — skills (not commands), `SKILL.md` files in named directories, and a `.claude-plugin/plugin.json` manifest.

```
init-agent/
├── .claude-plugin/
│   └── plugin.json                              # Plugin manifest
├── skills/
│   └── trailhead/
│       └── SKILL.md                             # Main orchestrator skill
├── scaffold/                                    # ALL installable payload lives here
│   ├── agents/
│   │   ├── security-scanner.md                  # SAST-lite + dependency audit
│   │   └── secrets-env-auditor.md               # Secret detection + env hygiene
│   ├── hooks/
│   │   ├── hook-utils.sh                        # Shared utility library (sourced by all hooks)
│   │   ├── milestone-check.sh                   # Blocks stop if milestone work undocumented
│   │   ├── post-compact-orientation.sh          # Restores orientation after context compression
│   │   ├── pre-commit-secrets.sh                # Catches secrets before commit
│   │   ├── pre-compact-check.sh                 # Warns on undocumented changes before compaction
│   │   ├── session-end.sh                       # Captures session state at end
│   │   └── session-start.sh                     # Restores orientation at session start
│   ├── skills/
│   │   ├── handoff/
│   │   │   └── SKILL.md                         # Captures session state to STATE.md
│   │   ├── resume/
│   │   │   └── SKILL.md                         # Reads STATE.md and outputs orientation summary
│   │   └── sanity-check/
│   │       └── SKILL.md                         # Adaptive project health check
│   ├── templates/
│   │   ├── CLAUDE.md.tmpl                       # Instruction system template
│   │   ├── STATE.md.tmpl                        # Learning system template
│   │   ├── decisions-archive.md.tmpl            # Decision history archive
│   │   ├── gitignore.tmpl                       # Baseline .gitignore
│   │   ├── mcp.json.tmpl                        # MCP server configuration
│   │   ├── settings.json.tmpl                   # Hook registration + Claude settings
│   │   └── rules/
│   │       ├── conventions.md.tmpl              # Project conventions (code projects)
│   │       └── session-protocol.md.tmpl         # Session behavior rules
│   └── resolve-root.sh                          # Plugin root path resolution
└── README.md
```

## What It Does

trailhead sets up the infrastructure that keeps a project healthy across sessions. It's supplemental — it works alongside orchestrators like GSD, not as a replacement. Its job is to catch what falls through the cracks: security issues, exposed secrets, documentation drift, and lost context between sessions.

## Where It Fits

trailhead is step 4 in the project lifecycle pipeline:

```
Research → Generate PRD → Design → /trailhead → Start Project → Build
```

By the time trailhead runs, the product is defined and designed. trailhead scaffolds the build environment so the project can focus on execution.

## Skills

### `/trailhead` — Project Bootstrap

The main skill. Walks the user through orientation questions, explores what already exists in the project, then creates the full scaffolding adapted to the project type. Invoked manually when starting a new project.

### `/sanity-check` — Project Health Check

An adaptive health check that only checks what exists — safe to run on brand new projects.

- **Code Health**: Runs build/type-check, test suite, linter, and scans for debug artifacts (console.log/print, TODO/FIXME/HACK, hardcoded localhost, hardcoded user paths). Skipped if no code exists yet.
- **Documentation Currency**: Verifies STATE.md and CLAUDE.md are current. Updates stale files.
- **Context Handoff**: Validates that a fresh session could pick up where this one left off.

Output is a pass/skip/fail summary table. If anything fails, it fixes the issues before proceeding.

**When to run**: Before clearing context, before starting a new milestone, after significant refactoring, or when something feels off.

### `/handoff` — Session State Capture

Writes current session state directly to STATE.md for continuity. Captures decisions made, work completed, and next steps so the next session starts oriented.

### `/resume` — Session Orientation

Reads STATE.md and outputs a structured orientation summary. A superset of the automatic session-start hook — adds depth on demand when resuming after a break.

## What It Scaffolds Into Target Projects

When `/trailhead` runs in a target project, it creates:

### Two-System Architecture

trailhead scaffolds two systems that work together: a static instruction system that tells Claude how to behave, and a dynamic learning system that tracks what's happening.

#### Instruction System (static, human-curated)

Files that define how Claude behaves in this project. Set once, adjusted deliberately.

| File | Purpose | Loaded |
|------|---------|--------|
| `CLAUDE.md` | Project identity, session startup instructions, pointers to other files | Always (system prompt) |
| `.claude/rules/session-protocol.md` | Session behavior rules — how to start, end, and hand off | Per-session |
| `.claude/rules/conventions.md` | Project conventions and style guidelines (code projects only) | Per-session |

#### Learning System (dynamic, session-updated)

Files that evolve as the project progresses. Updated each session.

| File | Purpose | Loaded |
|------|---------|--------|
| `.planning/STATE.md` | Current position, recent decisions, open items, session continuity | At session start |
| Auto Memory (`MEMORY.md`) | User preferences, project context, feedback, external references | On relevance |
| `.planning/decisions-archive.md` | Historical decisions moved out of STATE.md when it gets long | On demand |

### Security Agents

#### Security Scanner → `.claude/agents/security-scanner.md`
- **Model**: Sonnet
- **What it does**: SAST-lite code review for injection flaws, OWASP Top 10, and cryptographic weaknesses. Runs the project's package manager audit command for dependency scanning. Validates security headers, cookie settings, TLS, and auth configuration.
- **Output**: `.planning/security/security-scan-<date>.md`
- **Pass/Fail**: Fails on any Critical finding or any High with a known public exploit.
- **Adapts to**: The project's actual language and framework. Generic until the stack is established.

#### Secrets & Environment Auditor → `.claude/agents/secrets-env-auditor.md`
- **Model**: Haiku
- **What it does**: Detects API keys, tokens, credentials, and high-entropy strings. Validates `.env.example` completeness. Checks that `.env` files are gitignored. Scans git history (last 50 commits) for previously committed secrets.
- **Output**: `.planning/security/secrets-audit-<date>.md`
- **Critical rule**: Never prints full secret values — always masks them.
- **Adapts to**: Language-specific env var patterns (process.env, os.environ, os.Getenv, etc.).

### Hooks

All hooks are installed into `.claude/hooks/` in the target project. Universal hooks run for every project type; git-only hooks require a git repository.

#### Universal Hooks (all projects)

**hook-utils.sh** — Shared utility library sourced by all other hooks. Not executed directly.

**session-start.sh** — Event: SessionStart (4 matchers: startup, resume, clear, compact)
Reads STATE.md and outputs an orientation summary at the start of each session. Handles four variants: fresh start, resume, context clear, and post-compact recovery.

**session-end.sh** — Event: SessionEnd
Captures a brief session summary to a rolling log. Reminds Claude to run `/handoff` if state hasn't been updated.

**pre-compact-check.sh** — Event: PreCompact
Checks if substantive files were modified without updating STATE.md. If so, warns that documentation should be updated before context is lost.

**post-compact-orientation.sh** — Event: PostCompact
Restores orientation after context compression by re-reading STATE.md and outputting a recovery summary.

#### Git-Only Hooks

**milestone-check.sh** — Event: Stop (fires when Claude stops responding)
Looks at commits from the last 30 minutes. If they match milestone-like patterns (complete, finish, implement, ship, release, phase, v1, etc.), checks whether STATE.md was updated. Blocks with exit code 2 if not.

**pre-commit-secrets.sh** — Event: PreToolUse (Bash tool, git commit commands)
Scans staged files for common secret patterns — Stripe keys (sk_live_, sk_test_), AWS access keys (AKIA), GitHub tokens (ghp_), GitLab tokens (glpat-), Slack tokens (xox), private key blocks, and JWT patterns. Skips binary files.

## Adaptive Behavior

trailhead adapts to four combinations of project type and git status:

| Project Type | Instruction System | Learning System | Hooks | Security | Skills |
|-------------|-------------------|-----------------|-------|----------|--------|
| **Code + Git** | CLAUDE.md + rules (code variant) | STATE.md + auto memory | All hooks | Agents + pre-commit secrets | All skills |
| **Code, no Git** | CLAUDE.md + rules (code variant) | STATE.md + auto memory | Session hooks only | Agents only | All skills |
| **Non-code + Git** | CLAUDE.md + rules (non-code variant) | STATE.md + auto memory | Session + git hooks | Skipped | All skills (non-code sanity check) |
| **Non-code, no Git** | CLAUDE.md + rules (non-code variant) | STATE.md + auto memory | Session hooks only | Skipped | All skills (non-code sanity check) |

When the project type is "not sure yet", trailhead builds the flexible variant (code pattern) that self-activates as the stack is established.

## Extending

Each component is independent. To iterate:

- **Change what gets scaffolded**: Edit `skills/trailhead/SKILL.md` (the orchestrator logic)
- **Change template content**: Edit files in `scaffold/templates/`
- **Change security scanning**: Edit files in `scaffold/agents/`
- **Change automated guardrails**: Edit files in `scaffold/hooks/` and `scaffold/templates/settings.json.tmpl`
- **Change health checks**: Edit `scaffold/skills/sanity-check/SKILL.md`
- **Change session skills**: Edit `scaffold/skills/handoff/SKILL.md` or `scaffold/skills/resume/SKILL.md`

The orchestrator references components via `${CLAUDE_PLUGIN_ROOT}` paths, so the plugin works regardless of where it's installed.
