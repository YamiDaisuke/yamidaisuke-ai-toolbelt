# Design Decisions

Running log of decisions made while building and refining this bootstrap system.
Use this to iterate on the templates without losing context between sessions.

-----

## Session 1 — Initial review of all files

### Target audience: solo / single-dev projects

This bootstrap is designed for personal or single-developer projects, not teams.
Consequences throughout:
- No stakeholders section in REQUIREMENTS template
- No multi-agent concurrency — one task assigned at a time, always serial
- QA handoff is a notification to the User, not a formal agent-to-agent trigger
- The Scrum Master's escalation target is the User (not a PM or product owner)

---

### Status model simplified

Original had five values: `todo | in-progress | in-review | approved | accepted`

**Decision:** Collapse to three: `todo | in-progress | done`

Rationale:
- `in-review` created ambiguity about who owns the task during review
- `approved` and `accepted` were redundant for a solo workflow
- A task stays `in-progress` as long as any work remains (dev, review, QA, bug fixing)
- `done` means the Code Reviewer approved — no further caveats

Applies at task level. Spec level also simplified: `draft | in-progress | done`

---

### Architect must never decide for the user

**Decision:** Architect flags issues and offers alternatives, but always asks before proceeding.

Format:
> "X may not be suitable here because [reasons]. Alternatives: Y because [pros], downside [cons]; Z because [pros], downside [cons]. Which would you like to go with?"

Rationale: the Architect is a structured thinking aid, not an authority. The user owns all decisions.
The same principle applies to the Scrum Master (feature scope, task breakdown, prioritization).

---

### Task sizing

**Decision:** Tasks must be 1-2 hours of human dev work. Prefer more short tasks over fewer large ones.

Rationale: short tasks are easier to review, easier to recover from if wrong, and produce a cleaner commit history. The 1-2h bound is a forcing function against vague or bloated tasks.

---

### Ticket tracker table in SPEC

**Decision:** Each spec has a Ticket Tracker table mapping task IDs to external ticket IDs.

When tickets are created: at spec-write time (not at assignment time). The Scrum Master creates all tickets for a spec after the task list is confirmed, then populates the table before any development starts.

Rationale: having the full feature mapped upfront makes it easier to track progress and reference tickets during development.

---

### Review loop ownership

**Decision:** Task stays `in-progress` through the entire review cycle. The Developer asks the Code Reviewer for approval. On PASS, the Developer (not the Reviewer) marks the task `done` and notifies the Scrum Master.

Flow:
```
Developer → asks Code Reviewer for approval
  PASS → Developer marks done → notifies Scrum Master
  FEEDBACK → Developer addresses comments → asks again → repeat
```

Rationale: keeps status ownership with the Developer. The Reviewer's job is to assess, not to update task state.

---

### Bug report ownership

**Decision:** QA produces a raw bug report. The Scrum Master is responsible for formatting each bug as a proper task, adding it to the spec, creating the ticket, and assigning it to the Developer.

Rationale: the Scrum Master owns the spec structure and ticket creation. QA shouldn't need to know the task format.

---

### ym bootstrap: install via script or Homebrew

**Decision:** `ym` is an installable CLI. Installation options:
```bash
# Via install script
curl -fsSL .../install.sh | bash

# Via Homebrew
brew tap YamiDaisuke/yamidaisuke-ai-toolbelt && brew install --HEAD ym
```

`ym bootstrap <project-name>` clones this repo (`--depth=1`) into a temp directory, selectively copies only the scripts and SPEC.md template into `.ym/`, copies agents to `.claude/agents/` and skills to `.claude/commands/`, writes `CLAUDE.md` from the template, and cleans up via `trap`.

The bootstrapped project's `.ym/` is intentionally minimal — only `scripts/` and `templates/SPEC.md`. Agents and skills live in `.claude/` where Claude Code reads them natively. `ym bootstrap` (no name) updates an existing project and re-runs any `migrate-*.sh` scripts.

---

### .ym/CLAUDE.md is a generic project template

**Decision:** `.ym/CLAUDE.md` contains the universal behavioral guidelines (sections 1-4) plus placeholder sections for project-specific context (description, roles, phase, conventions).

`ym bootstrap` copies it and `sed`-replaces `{PROJECT_NAME}`. The other placeholders (`{PROJECT_DESCRIPTION}`, `{CONVENTIONS_SUMMARY}`) are filled in during the requirements and architecture sessions.

The root `CLAUDE.md` (this repo) is separate — it guides Claude while building the bootstrap system itself and should not be conflated with the shipped template.

---

## Open questions (unresolved)

1. **Review strictness** — should the Code Reviewer always block on missing tests, or is that configurable per spec? Currently up to the Reviewer's judgment.

2. **Claude Code vs chat** — are Developer and Reviewer intended to run as autonomous Claude Code agents, or as guided chat sessions? The files are written to work either way, but the interaction model affects how prescriptive the skill files need to be.
