# Requirements: knzinit v2

**Defined:** 2026-03-26
**Core Value:** Every Claude Code session starts oriented and every context boundary recovers gracefully — regardless of project type.

## v1.1 Requirements

Requirements for knzinit v2 release. Each maps to roadmap phases.

### Architecture

- [x] **ARCH-01**: Scaffold documentation and CLAUDE.md template reflect the platform's two-system architecture (instruction system + learning system) rather than the 5-layer memory model (B-01)
- [x] **ARCH-02**: Generated root CLAUDE.md stays under 200 lines with detail loaded on-demand via .claude/rules/, subdirectory CLAUDE.md, skills, and @import (B-02)
- [x] **ARCH-03**: Generated CLAUDE.md places critical behavioral instructions in the first third of the file (B-03)
- [x] **ARCH-04**: Generated CLAUDE.md includes concise auto-memory guidance (200-line cap, index+topic pattern, machine-local scope, STATE.md preferred for critical state) (B-04)

### Settings

- [x] **SETT-01**: Generated settings.json includes $schema key for IDE validation (B-23)
- [x] **SETT-02**: Generated settings.json includes universal permission deny rules for .env and secrets files regardless of project type (B-30)
- [x] **SETT-03**: Generated settings.json varies by project type — code projects get build/test allow rules, non-code projects get includeGitInstructions:false (B-10, B-05)
- [x] **SETT-04**: Non-code project settings include keep-coding-instructions:false to disable default programming behavior (B-06)
- [x] **SETT-05**: Generated settings.json includes env key with KNZINIT_PROJECT_TYPE and KNZINIT_VERSION for runtime metadata (B-13)
- [x] **SETT-06**: Generated settings.json sets plansDirectory to in-project path (.planning/plans) (B-14)

### Hooks

- [x] **HOOK-01**: PreCompact hook saves current state to STATE.md before compaction (B-07, existing hook refined)
- [x] **HOOK-02**: PostCompact hook reads STATE.md after compaction and outputs orientation summary (B-07, new)
- [x] **HOOK-03**: SessionStart hook fires on all four matchers (startup, resume, clear, compact) and reads STATE.md to output session orientation (B-08)
- [x] **HOOK-04**: SessionEnd hook captures session summary and appends to session-log.md (B-09)
- [x] **HOOK-05**: Generated CLAUDE.md includes 2-3 lines of compaction instructions (preserve task context, re-read STATE.md) (B-11)
- [x] **HOOK-06**: All hooks include error handling — trap failures, log to .claude/hook-errors.log, emit clear stderr (B-12)
- [x] **HOOK-07**: Hooks that don't depend on git work in non-git projects (B-22)

### Non-Code

- [x] **NCODE-01**: Scaffold offers non-code CLAUDE.md templates that encode workflow processes rather than project metadata (B-15)
- [x] **NCODE-02**: Interview asks different questions for non-code projects (workflow, recurring decisions, session patterns, domain terminology) (B-15)
- [x] **NCODE-03**: Non-code projects get project-type-appropriate health checks instead of security agents (B-16)
- [x] **NCODE-04**: STATE.md template varies by project type with domain-appropriate fields (B-17)

### Skills

- [x] **SKIL-01**: /handoff skill captures current session state to STATE.md with structured summary (what done, in progress, next, open questions) (B-18)
- [x] **SKIL-02**: /resume skill reads STATE.md + recent changes and outputs session orientation summary (B-18)

### Infrastructure

- [x] **INFR-01**: CLAUDE_PLUGIN_ROOT verified as stable, or fallback path resolution added if unstable (B-29)
- [x] **INFR-02**: All scaffolded files include version marker as HTML comment (<!-- knzinit v2.0.0 -->) (B-21)
- [x] **INFR-03**: Scaffold generates .mcp.json template for projects using external services, with enableAllProjectMcpServers in settings (B-19)
- [x] **INFR-04**: Scaffold generates decisions-archive.md and sanity check warns when STATE.md decisions exceed 20-entry cap (B-20)
- [x] **INFR-05**: Generated CLAUDE.md includes guidance on scope-restricted settings (autoMemoryDirectory, autoMode) that users must configure at user/local scope (B-24)

## v2 Requirements

Deferred to future release (P3 items).

### Iteration

- **ITER-01**: /knzinit refine skill for iterative CLAUDE.md improvement (B-25)
- **ITER-02**: /knzinit upgrade command for version-aware re-scaffolding (B-27)
- **ITER-03**: Formal template variable substitution replacing informal Claude adaptation (B-28)

### Advanced

- **ADV-01**: claudeMdExcludes scaffolding for monorepo projects (B-26)

## Out of Scope

| Feature | Reason |
|---------|--------|
| Agent teams hooks (TaskCreated, TaskCompleted, TeammateIdle) | Too new, design architecture to accept later |
| New interactive /init flow integration | Behind feature flag, wait for stable release |
| Plugin marketplace distribution | Not elaborated, treat as potentially changing |
| AI-specific security patterns (prompt injection, context leakage) | Insufficient evidence to design checks (Q26) |
| Context budget monitoring API | Platform limitation, no hook/setting exposes utilization (Q27) |

## Traceability

Which phases cover which requirements. Updated during roadmap creation.

| Requirement | Phase | Status |
|-------------|-------|--------|
| ARCH-01 | Phase 1 | Complete |
| ARCH-02 | Phase 1 | Complete |
| ARCH-03 | Phase 1 | Complete |
| ARCH-04 | Phase 1 | Complete |
| SETT-01 | Phase 2 | Complete |
| SETT-02 | Phase 2 | Complete |
| SETT-03 | Phase 2 | Complete |
| SETT-04 | Phase 2 | Complete |
| SETT-05 | Phase 2 | Complete |
| SETT-06 | Phase 2 | Complete |
| HOOK-01 | Phase 3 | Complete |
| HOOK-02 | Phase 3 | Complete |
| HOOK-03 | Phase 3 | Complete |
| HOOK-04 | Phase 3 | Complete |
| HOOK-05 | Phase 3 | Complete |
| HOOK-06 | Phase 3 | Complete |
| HOOK-07 | Phase 3 | Complete |
| NCODE-01 | Phase 4 | Complete |
| NCODE-02 | Phase 4 | Complete |
| NCODE-03 | Phase 4 | Complete |
| NCODE-04 | Phase 4 | Complete |
| SKIL-01 | Phase 4 | Complete |
| SKIL-02 | Phase 4 | Complete |
| INFR-01 | Phase 1 | Complete |
| INFR-02 | Phase 1 | Complete |
| INFR-03 | Phase 5 | Complete |
| INFR-04 | Phase 5 | Complete |
| INFR-05 | Phase 1 | Complete |

**Coverage:**
- v1.1 requirements: 28 total
- Mapped to phases: 28
- Unmapped: 0 ✓

---
*Requirements defined: 2026-03-26*
*Last updated: 2026-03-26 after roadmap creation*
