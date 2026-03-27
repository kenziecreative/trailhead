# Phase 2: Settings - Context

**Gathered:** 2026-03-27
**Status:** Ready for planning

<domain>
## Phase Boundary

Expand generated settings.json from hooks-only to full platform coverage — schema validation, security baselines, environment metadata, project-type-specific permission and behavior rules. Covers SETT-01, SETT-02, SETT-03, SETT-04, SETT-05, SETT-06.

</domain>

<decisions>
## Implementation Decisions

### Security deny rules (SETT-02)
- Strict baseline: deny Write AND Edit for .env*, **/*.pem, **/*.key, **/*credentials*, **/*secret*, **/id_rsa*, **/id_ed25519*
- Same deny rules for ALL project types (code, non-code, unknown) — safety doesn't vary by project type
- No Bash deny rules — too many edge cases for pattern matching; existing pre-commit-secrets hook covers the highest-risk case (committing secrets)

### Project-type allow rules (SETT-03)
- Code and "unsure" projects get common package manager allow rules: npm, yarn, pnpm, bun, npx, pytest, cargo, go test, go build, make
- "Not sure yet" projects default to code variant — allow rules don't hurt non-code projects (commands just won't match), avoids generating weaker settings that need upgrading later

### Non-code behavior flags (SETT-03, SETT-04)
- Non-code projects get both includeGitInstructions:false AND keep-coding-instructions:false
- SKILL.md report includes a note for non-code projects: "Git instructions disabled. If you use git for version control, set includeGitInstructions:true in .claude/settings.json."

### Template structure
- Single template at scaffold/templates/settings.json.tmpl (moved from scaffold/settings.json for consistency with other templates)
- Template contains ALL possible sections — represents the code/unsure variant
- SKILL.md conditionally adapts: code/unsure uses template as-is; non-code removes allow[], adds includeGitInstructions:false and keep-coding-instructions:false

### Merge strategy
- All sections use merge-not-overwrite when .claude/settings.json already exists:
  - hooks: append new hooks to existing
  - permissions.deny: union of existing + new
  - permissions.allow: union of existing + new
  - env: existing keys preserved, new keys added
  - scalar keys ($schema, plansDirectory): set if not present
- SKILL.md merge logic expanded inline in existing Step 4 ("Merge Settings")

### Schema validation (SETT-01)
- Include $schema key pointing to official Anthropic schema URL (researcher to verify exact URL)
- Enables IDE validation in VS Code/Cursor without additional configuration

### Environment metadata (SETT-05)
- env block with KNZINIT_PROJECT_TYPE (normalized values: code | noncode | unknown) and KNZINIT_VERSION (from plugin.json)
- Normalized values for programmatic use — no spaces, no hyphens

### Plans directory (SETT-06)
- plansDirectory set to .planning/plans — keeps plans in-project and version-controlled

### Scope boundary
- Requirements only (SETT-01 through SETT-06) — no extra settings beyond what's scoped

### Claude's Discretion
- Exact ordering of keys within settings.json template
- How SKILL.md implements the conditional adaptation (string manipulation, JSON parsing, etc.)
- Whether to add comments in the template for maintainability

</decisions>

<code_context>
## Existing Code Insights

### Reusable Assets
- `scaffold/settings.json` — Current hooks-only template (40 lines). Will be expanded and moved to scaffold/templates/settings.json.tmpl
- `skills/knzinit/SKILL.md` Step 4 — Existing merge logic ("never overwrite existing hooks"). Will be expanded for all sections
- `scaffold/resolve-root.sh` — Provides KNZINIT_VERSION for the env block

### Established Patterns
- SKILL.md uses `${KNZINIT_ROOT}/scaffold/` for template paths — new template uses `${KNZINIT_ROOT}/scaffold/templates/settings.json.tmpl`
- Hooks reference `$CLAUDE_PROJECT_DIR` for project-local paths — same pattern continues
- Templates in scaffold/templates/ use .tmpl extension — settings template follows this convention

### Integration Points
- `plugin.json` version field → KNZINIT_VERSION env var in generated settings
- `SKILL.md` Step 1 (Orientation) question 2 → determines project type → drives conditional template adaptation
- `SKILL.md` Step 4 (Merge Settings) → expanded to handle all new sections
- Existing hooks in scaffold/settings.json → preserved in new template, new sections added around them

</code_context>

<specifics>
## Specific Ideas

No specific references or "I want it like X" moments — decisions were made on recommended approaches throughout.

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope.

</deferred>

---

*Phase: 02-settings*
*Context gathered: 2026-03-27*
