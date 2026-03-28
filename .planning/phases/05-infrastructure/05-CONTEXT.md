# Phase 5: Infrastructure - Context

**Gathered:** 2026-03-27
**Status:** Ready for planning

<domain>
## Phase Boundary

Add MCP configuration template generation and decisions archive with sanity-check integration. Projects using external services get a .mcp.json template alongside enableAllProjectMcpServers in settings. All projects get a decisions-archive.md file and the sanity-check warns when STATE.md decisions exceed 20 entries. Covers INFR-03, INFR-04.

</domain>

<decisions>
## Implementation Decisions

### MCP template generation (INFR-03)
- Interview question added to Step 1 as **question 4**: "Does this project use external services (APIs, databases, Slack, etc.)?" — accepts "yes", "no", and "not sure yet"
- Asked for **all project types** (code, non-code, unknown) — non-code projects use MCP for Notion, Google Docs, Slack, etc.
- "Not sure yet" skips .mcp.json generation — user can create it later manually
- Template contains an **empty JSON structure with comments** explaining the format — user fills in their actual servers
- .mcp.json created in **Step 3A** alongside other project config files
- `enableAllProjectMcpServers` added to settings.json via **SKILL.md merge logic** in Step 4 — only when .mcp.json was generated, not in the base template

### Decisions archive (INFR-04)
- decisions-archive.md **scaffolded for every project** during /knzinit — created in Step 3A under Learning System alongside STATE.md
- **Same table format as STATE.md** (# | Decision | Date | Context) — newest archived entries at top, consistent and grep-friendly
- Archiving is **user-prompted, not automatic** — sanity-check detects >20 entries and warns with a suggested action
- Sanity-check warning is **actionable**: "STATE.md has 23 decisions (cap: 20). Archive the 3 oldest to .planning/decisions-archive.md?"
- Overflow check added to **sanity-check Section 2 (Documentation Currency)** — STATE.md health is already checked there, decisions cap is a natural addition

### Claude's Discretion
- .mcp.json template exact comment wording and JSON structure
- decisions-archive.md header/boilerplate content
- Exact wording of the sanity-check overflow warning
- How SKILL.md Step 4 conditionally adds enableAllProjectMcpServers (inline check or separate paragraph)

</decisions>

<code_context>
## Existing Code Insights

### Reusable Assets
- `scaffold/templates/STATE.md.tmpl` — Already references decisions-archive.md at line 17 ("Archive older decisions to `.planning/decisions-archive.md`"). Archive file just needs to exist
- `scaffold/templates/settings.json.tmpl` — Base template for merge logic. No changes needed to template itself; enableAllProjectMcpServers added via SKILL.md merge
- `scaffold/skills/sanity-check/SKILL.md` — Section 2 (Documentation Currency) already checks STATE.md currency. Decisions count check adds to this section
- `skills/knzinit/SKILL.md` — Step 1 has 3 questions (project, type, git). Q4 adds here. Step 3A creates config files. Step 4 handles settings merge

### Established Patterns
- Single template + conditional adaptation in SKILL.md (Phase 2 pattern) — MCP generation follows this: conditional on interview answer, not template markers
- Merge-not-overwrite for settings (Phase 2) — enableAllProjectMcpServers uses set-if-absent scalar key merge rule
- All interview questions accept "not sure yet" — MCP question follows this convention
- Templates in scaffold/templates/ use .tmpl extension — .mcp.json template follows this as mcp.json.tmpl

### Integration Points
- `SKILL.md` Step 1 → Q4 answer stored, drives conditional .mcp.json generation in Step 3A and settings merge in Step 4
- `SKILL.md` Step 3A (Learning System) → decisions-archive.md created here alongside STATE.md
- `SKILL.md` Step 3A (config files) → .mcp.json created here when user answered yes to external services
- `SKILL.md` Step 4 (Merge Settings) → enableAllProjectMcpServers conditionally added
- `SKILL.md` Step 6 (Report) → mention .mcp.json and decisions-archive.md in created files list
- `scaffold/skills/sanity-check/SKILL.md` Section 2 → decisions count check added

</code_context>

<specifics>
## Specific Ideas

No specific requirements — open to standard approaches.

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope.

</deferred>

---

*Phase: 05-infrastructure*
*Context gathered: 2026-03-27*
