# Roadmap: knzinit v2

## Overview

v2 rebuilds knzinit around the platform's actual two-system architecture, expanding settings and hook coverage from minimal to comprehensive, adding full session lifecycle recovery, and delivering first-class non-code project support. Phase 1 resolves the infrastructure blocker and restructures the CLAUDE.md template foundation. Phases 2-3 expand settings and hook surface. Phase 4 adds non-code templates and handoff skills. Phase 5 finishes standalone infrastructure items.

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

Decimal phases appear between their surrounding integers in numeric order.

- [ ] **Phase 1: Foundation** - Resolve CLAUDE_PLUGIN_ROOT blocker and restructure CLAUDE.md templates around the two-system architecture
- [ ] **Phase 2: Settings** - Expand generated settings.json from minimal to full platform coverage with project-type variants
- [ ] **Phase 3: Hooks** - Implement complete session lifecycle with compaction recovery and error handling
- [ ] **Phase 4: Non-Code and Skills** - Add non-code project templates, differentiated interview flow, and handoff/resume skills
- [ ] **Phase 5: Infrastructure** - Add MCP template generation and decisions archive with sanity-check integration

## Phase Details

### Phase 1: Foundation
**Goal**: The plugin resolves its own path reliably and generates CLAUDE.md templates that accurately reflect the platform's two-system architecture with progressive disclosure
**Depends on**: Nothing (first phase)
**Requirements**: INFR-01, INFR-02, INFR-05, ARCH-01, ARCH-02, ARCH-03, ARCH-04
**Success Criteria** (what must be TRUE):
  1. Running /knzinit does not fail due to CLAUDE_PLUGIN_ROOT being unset or unresolvable — either the variable is verified stable or a fallback path is used automatically
  2. The generated root CLAUDE.md correctly describes the two-system architecture (instruction system + learning system), not the 5-layer model
  3. The generated root CLAUDE.md is under 200 lines, with behavioral detail deferred to .claude/rules/, subdirectory CLAUDE.md files, and skills
  4. Critical behavioral instructions appear in the first third of the generated CLAUDE.md
  5. All generated files include a version marker comment, and the generated CLAUDE.md includes guidance on scope-restricted settings users must configure manually
**Plans**: 2 plans

Plans:
- [ ] 01-01-PLAN.md — Path resolution infrastructure + template rewrites (CLAUDE.md, STATE.md, rules)
- [ ] 01-02-PLAN.md — SKILL.md orchestrator rewrite + plugin.json v2.0.0

### Phase 2: Settings
**Goal**: Generated settings.json provides full project-type coverage — schema validation, security baselines, environment metadata, and project-type-specific permission and behavior rules
**Depends on**: Phase 1
**Requirements**: SETT-01, SETT-02, SETT-03, SETT-04, SETT-05, SETT-06
**Success Criteria** (what must be TRUE):
  1. Generated settings.json includes $schema key and IDE validation activates in VS Code / Cursor without errors
  2. Generated settings.json always denies write access to .env and secrets files regardless of project type — a code project cannot bypass this
  3. Code projects get allow rules for build/test commands; non-code projects get includeGitInstructions:false and keep-coding-instructions:false
  4. Generated settings.json includes env block with KNZINIT_PROJECT_TYPE and KNZINIT_VERSION populated at scaffold time
  5. Generated settings.json sets plansDirectory to .planning/plans for the in-project planning workflow
**Plans**: TBD

Plans:
- [ ] 02-01: TBD

### Phase 3: Hooks
**Goal**: Every context boundary (compaction, clear, new session) recovers gracefully via a complete session lifecycle hook chain with robust error handling
**Depends on**: Phase 1
**Requirements**: HOOK-01, HOOK-02, HOOK-03, HOOK-04, HOOK-05, HOOK-06, HOOK-07
**Success Criteria** (what must be TRUE):
  1. After a compaction event, the next Claude message includes an orientation summary drawn from STATE.md — the user does not need to re-explain context
  2. Starting a new session (startup, resume, clear, compact) fires SessionStart and Claude immediately outputs current task context from STATE.md
  3. Ending a session appends a structured summary to session-log.md without user prompting
  4. A hook failure does not silently abort — the error appears in .claude/hook-errors.log and in stderr output the user can see
  5. Hooks that exclude git operations work correctly in a project directory that has no .git folder
**Plans**: TBD

Plans:
- [ ] 03-01: TBD

### Phase 4: Non-Code and Skills
**Goal**: Non-code projects (research, writing, strategy, process work) get templates, interview questions, health checks, and STATE.md fields that match their actual workflows, plus handoff and resume skills for all project types
**Depends on**: Phase 1
**Requirements**: NCODE-01, NCODE-02, NCODE-03, NCODE-04, SKIL-01, SKIL-02
**Success Criteria** (what must be TRUE):
  1. When /knzinit runs on a non-code project, the generated CLAUDE.md template encodes workflow processes and recurring decisions rather than programming conventions
  2. The /knzinit interview asks different questions for non-code projects — workflow patterns, recurring decisions, session patterns, and domain terminology rather than tech stack questions
  3. Non-code projects get a project-appropriate health check skill that does not reference security scanning, dependency audits, or code linting
  4. Non-code projects get a STATE.md template with domain-appropriate fields (e.g., current document, stakeholders, open decisions) rather than code-oriented fields
  5. /handoff captures current state to STATE.md with a structured summary; /resume reads STATE.md and outputs orientation without requiring user to re-explain context
**Plans**: TBD

Plans:
- [ ] 04-01: TBD

### Phase 5: Infrastructure
**Goal**: Projects using external services get an MCP configuration template, and the decisions archive pattern is scaffolded with automated overflow warnings
**Depends on**: Phase 1
**Requirements**: INFR-03, INFR-04
**Success Criteria** (what must be TRUE):
  1. When /knzinit runs on a project that uses external services, a .mcp.json template is generated alongside settings.json with enableAllProjectMcpServers configured
  2. Scaffolded projects include decisions-archive.md, and the sanity-check skill warns the user when STATE.md decisions exceed 20 entries
**Plans**: TBD

Plans:
- [ ] 05-01: TBD

## Progress

**Execution Order:**
Phases execute in numeric order: 1 → 2 → 3 → 4 → 5

Note: Phases 2, 3, and 4 all depend on Phase 1 but are otherwise independent. Default execution order is sequential; phases 2-4 could parallelize if needed.

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Foundation | 1/2 | In Progress|  |
| 2. Settings | 0/TBD | Not started | - |
| 3. Hooks | 0/TBD | Not started | - |
| 4. Non-Code and Skills | 0/TBD | Not started | - |
| 5. Infrastructure | 0/TBD | Not started | - |
