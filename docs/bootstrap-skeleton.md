# Project Bootstrap Skeleton

## Spec-Driven Development with Agent Roles

-----

## Directory Structure

```
bin/
└── ym                        # CLI — ym bootstrap <name> or ym bootstrap (update)

Formula/
└── ym.rb                     # Homebrew formula (brew tap YamiDaisuke/yamidaisuke-ai-toolbelt)

install.sh                    # Direct install: curl -fsSL .../install.sh | bash

.bootstrap/
├── agents/
│   ├── architect.md          # Role definition + system prompt
│   ├── scrum-master.md
│   ├── developer.md
│   ├── code-reviewer.md
│   └── qa.md
├── skills/
│   ├── requirements-interview.md   # Section-by-section Q&A guide
│   ├── architecture-interview.md
│   ├── spec-writer.md
│   ├── spec-amend.md               # Amend an existing spec or upstream doc
│   ├── task-runner.md
│   ├── code-review.md
│   └── qa-check.md
├── scripts/
│   ├── bootstrap.sh          # Remote install via curl, clones repo, sets up project
│   ├── new-spec.sh           # Scaffold a new spec file
│   ├── next-task.sh          # Print next incomplete task across specs
│   ├── qa-report.sh          # Aggregate QA status across specs
│   └── migrate-versioning.sh # Retrofit Version header + Revision History into existing docs
├── templates/
│   ├── REQUIREMENTS.md
│   ├── ARCHITECTURE.md
│   └── SPEC.md
└── CLAUDE.md                 # Generic project template for Claude Code sessions
```

```
{project-repo}/
├── .bootstrap/               # Copied from skeleton by bootstrap.sh
├── docs/
│   ├── REQUIREMENTS.md       # Generated
│   ├── ARCHITECTURE.md       # Generated
│   └── specs/
│       ├── feature-auth.md
│       ├── feature-billing.md
│       └── ...
└── CLAUDE.md                 # Project-level Claude Code context (from template)
```

-----

## Task Status Values

Tasks use three statuses only:

| Status | Meaning |
|---|---|
| `todo` | Not started |
| `in-progress` | Any work pending — dev, review, QA, bug fixing |
| `done` | Approved by Code Reviewer, all criteria met |

Spec-level status: `draft | in-progress | done`

-----

## Document Versioning

All three spec-driven documents carry a `Version:` field in their header.

| Document | Bump when |
|---|---|
| `docs/specs/*.md` | Acceptance criteria, task scope, or spec requirements change |
| `docs/REQUIREMENTS.md` | Any FR, NFR, or success criterion is added, changed, or removed |
| `docs/ARCHITECTURE.md` | Any tech stack, data model, API, auth, or convention decision changes |

Version numbers are simple integers: v1, v2, v3. Do not bump for status updates, ticket ID corrections, or rephrasing that preserves meaning. **Rule:** bump when a change would cause a Developer to implement something differently, or cause QA to re-test something already accepted.

Each document has a `## Revision History` table at the bottom:

```
| Version | Date       | Summary                                      |
|---------|------------|----------------------------------------------|
| v1      | 2025-05-20 | Initial spec                                 |
| v2      | 2025-06-01 | Added TASK-04; clarified AC on TASK-02       |
```

Amendments are made via the `spec-amend` skill. For existing projects created before versioning was introduced, run `migrate-versioning.sh` to retrofit the Version header and Revision History section into existing docs.

-----

## Agents

### 🏛️ Architect

**Role:** Technical authority. Leads requirements and architecture sessions,
provides technical input during spec writing, available for design questions
during development.

**Triggers:**

- Start of project → begin requirements session
- Requirements confirmed → begin architecture session
- Called by Scrum Master during spec writing for technical constraints

**Core behaviors:**

- Asks one section at a time, never dumps a full template
- Summarizes what was captured before moving to the next section
- Flags conflicts or ambiguities immediately
- Writes output to docs/ only when the user confirms a section is done
- Never decides for the user — flags issues, offers alternatives with tradeoffs, asks how to proceed
- Never assigns tasks. Never writes implementation code.

**Skill refs:** `requirements-interview`, `architecture-interview`

-----

### 🗂️ Scrum Master

**Role:** Flow orchestrator. Breaks requirements into features, coordinates
spec writing, assigns tasks to Developer one at a time, tracks completion,
and signals when a spec is ready for QA.

**Triggers:**

- `ARCHITECTURE.md` confirmed → propose feature breakdown, begin spec writing
- Task marked `done` by Developer → assign next task
- All tasks in a spec reach `done` → notify User that spec is ready for QA
- Bug report received from QA → format each bug as a task, add to spec, assign to Developer

**Core behaviors:**

- Proposes feature breakdown from REQUIREMENTS.md and confirms with User before writing any spec
- Maintains task status in spec files. Never tracks state outside the spec.
- Assigns one task at a time. Does not assign next until current is `done`.
- Escalates blockers to Architect (technical) or User (scope/priority)
- Never decides for the user — presents options with tradeoffs and asks
- Never writes code. Never reviews code.

**Skill refs:** `spec-writer`, `task-runner`

-----

### 💻 Developer

**Role:** Implementation. Receives one atomic task at a time, implements it,
iterates through review until approved, then marks done.

**Triggers:**

- Task assigned by Scrum Master with status `todo`

**Core behaviors:**

- Reads the full spec and ARCHITECTURE.md before starting any task
- Marks task `in-progress` on start; it stays `in-progress` through the review cycle
- Implements only what the task's acceptance criteria require
- Asks Code Reviewer for approval when ready; iterates on feedback until approved
- Marks task `done` and notifies Scrum Master only after Code Reviewer approves
- Never makes architectural decisions — escalates to Architect if ARCHITECTURE.md doesn't cover it
- Commits after each task. Never bundles changes from multiple tasks.

**Skill refs:** `task-runner`

-----

### 🔍 Code Reviewer

**Role:** Quality gate. Reviews each task implementation against the spec's
acceptance criteria and ARCHITECTURE.md conventions.

**Triggers:**

- Developer asks for approval on a completed task

**Review checklist:**

- Does the code satisfy the acceptance criteria in the spec?
- Does it follow the conventions in ARCHITECTURE.md?
- Are there obvious bugs, security issues, or performance concerns?
- Is test coverage present where required?

**Output:** `PASS` (notifies Developer, who marks task `done` and notifies Scrum Master)
or `FEEDBACK` (returned to Developer with specific, actionable comments referencing
line numbers and spec criteria).

**Skill refs:** `code-review`

-----

### ✅ QA

**Role:** Feature acceptance gate. Runs after all tasks in a spec are `done`.
Tests the full feature against functional and non-functional requirements.

**Triggers:**

- Scrum Master signals all spec tasks are `done`

**QA checklist:**

- Does each acceptance criterion in the spec pass?
- Does the feature match the REQUIREMENTS.md functional requirements?
- Edge cases and error states covered?
- Non-functional requirements met (perf, a11y, security as applicable)?

**Output:** `ACCEPTED` (Scrum Master marks spec `done`) or `BUG REPORT`
(sent to Scrum Master, who formats each bug as a task, adds to spec, and assigns it).

**Skill refs:** `qa-check`

-----

## Skills

### `requirements-interview`

Guides the Architect through a structured requirements session.

**Sections (in order):**

1. Project vision & problem statement
1. Target users
1. Functional requirements (what the system does)
1. Non-functional requirements (perf, security, scale, a11y)
1. Out of scope
1. Constraints & dependencies
1. Success criteria

**Rules:**

- One section at a time
- Summarize what was captured, ask "does this look right?" before continuing
- If the user's answer raises a concern, flag it before writing — explain the issue, offer alternatives, ask how to proceed
- Generate a draft section in REQUIREMENTS template format only after confirmation
- Never skip sections; offer to mark a section as TBD if the user is unsure

-----

### `architecture-interview`

Guides the Architect through a structured architecture session, using
REQUIREMENTS.md as input context.

**Sections (in order):**

1. Tech stack (language, framework, runtime, infra)
1. Repository & code organization
1. Data model overview
1. API / integration patterns
1. Auth & security approach
1. Testing strategy
1. Deployment & environments
1. Conventions & style rules (naming, error handling, logging)

**Rules:** Same as `requirements-interview` — one section, confirm, flag concerns, write.

-----

### `spec-writer`

Used by Scrum Master to produce a spec file for one feature.

**Spec structure:**

```
# Spec: {Feature Name}
Status: draft

## Overview
One-paragraph summary of the feature.

## Functional Requirements
- FR-01: ...

## Technical Requirements
- TR-01: (references ARCHITECTURE.md sections as needed)

## Tasks
### TASK-01: {short title}
**Description:** ...
**Acceptance Criteria:**
- [ ] ...
**Status:** todo

## Ticket Tracker
| Task    | Ticket ID   |
|---------|-------------|
| TASK-01 | {TICKET_ID} |
```

**Rules:**

- Tasks must be atomic, 1-2 hours of human dev work. Prefer more short tasks over fewer large ones.
- Each task has explicit, testable acceptance criteria
- Scrum Master confirms the task list with User before writing the file
- After writing the spec, create a ticket in the tracking system for each task and populate the Ticket Tracker table

-----

### `spec-amend`

Used by Scrum Master (specs) and Architect (REQUIREMENTS.md and ARCHITECTURE.md) to amend an existing document after initial writing.

**When to use:** Acceptance criteria, task scope, requirements, or architecture decisions must change.

**Not for:** Task status updates, ticket ID corrections, rephrasing that preserves meaning.

**Process:**

1. Identify the exact change and which document
2. Confirm whether a version bump is required (rule above)
3. Present the proposed change and Revision History summary to User — wait for confirmation
4. Edit the document; update `Version:` field and append Revision History row if bumping
5. Notify affected agents (Developer if in-progress tasks are affected; Scrum Master for upstream doc changes)
6. Commit: `git add <file> && git commit -m "docs: amend <filename> to v{N} — <summary>"`

One commit per amended document. Commit message summary must match the Revision History row exactly.

-----

### `task-runner`

Used by Developer (executing) and Scrum Master (assigning).

**Developer process:**

1. Read the full spec and ARCHITECTURE.md
2. Mark task `in-progress`
3. Implement only what the acceptance criteria require
4. Ask Code Reviewer for approval
   - If approved → mark `done`, commit, notify Scrum Master
   - If feedback → address comments, ask again. Repeat until approved.

**Scrum Master process:**

1. Find next task with status `todo`
2. Assign to Developer with spec path and task ID
3. Do not assign another until current is `done`

-----

### `code-review`

Used by Code Reviewer. Structured review against spec and architecture.

**Inputs:** diff/PR, spec file, ARCHITECTURE.md
**Outputs:** Structured feedback with:

- Verdict: PASS or FEEDBACK
- PASS: notify Developer — task is approved
- FEEDBACK: numbered list of issues, each with file+line ref and spec criteria ref
- No vague comments — every issue must be actionable

-----

### `qa-check`

Used by QA agent. Tests a completed spec.

**Inputs:** spec file (all tasks `done`), REQUIREMENTS.md, codebase
**Process:**

1. List all acceptance criteria across all tasks
1. List all functional requirements that apply to this feature
1. For each: PASS / FAIL / PARTIAL with notes
1. Check edge cases, error states, and applicable non-functional requirements
1. Summary verdict: ACCEPTED or BUG REPORT
1. Bug report stubs sent to Scrum Master for task creation, formatting, and assignment

-----

## Scripts

### `bootstrap.sh`

Remote install — downloads and applies the skeleton to a new project.

```bash
# Usage: curl -fsSL <raw-url> | bash -s -- <project-name>
# - Clones bootstrap repo to a temp directory (cleaned up on exit)
# - Copies .bootstrap/ into the current directory
# - Creates docs/REQUIREMENTS.md, docs/ARCHITECTURE.md from templates
# - Creates docs/specs/ directory
# - Writes CLAUDE.md from template with project name substituted
# - Initializes git if not already a repo
```

### `new-spec.sh`

```bash
# Usage: ./new-spec.sh <feature-slug>
# - Creates docs/specs/<feature-slug>.md from SPEC.md template
```

### `next-task.sh`

```bash
# Scans all specs in docs/specs/
# Prints the first task with status: todo
# Format: [spec-file] TASK-XX: description
```

### `qa-report.sh`

```bash
# Scans all specs
# Prints table: Spec | Tasks Done | Tasks Total | QA Status
```

### `migrate-versioning.sh`

```bash
# Usage: ./migrate-versioning.sh
# - Adds Version: v1 header and Revision History section to existing docs
#   that were created before spec versioning was introduced.
# - Safe to run multiple times (skips files that already have Version:).
# - After running, review with git diff and commit.
```

-----

## CLAUDE.md (project-level)

Generic template with placeholders — written by `bootstrap.sh` with `{PROJECT_NAME}` substituted.
`{PROJECT_DESCRIPTION}` and `{CONVENTIONS_SUMMARY}` are filled in during the project sessions.

```markdown
# CLAUDE.md

Behavioral guidelines for {PROJECT_NAME}.

## 1–4. Universal guidelines
(Think Before Coding, Simplicity First, Surgical Changes, Goal-Driven Execution)

## 5. Project Context
{PROJECT_DESCRIPTION}

## 6. Roles & Documents
- Roles: .bootstrap/agents/*.md
- Requirements: docs/REQUIREMENTS.md
- Architecture: docs/ARCHITECTURE.md
- Specs: docs/specs/*.md
- Current phase checklist

## 7. Conventions
{CONVENTIONS_SUMMARY} — filled in after architecture is confirmed

## 8. Definition of Done
A task is done when all acceptance criteria pass and Code Reviewer approves.
```

-----

## CLI: ym

The primary interface for using this skeleton. Installed once, used across all projects.

### Installation

```bash
# Via install script
curl -fsSL https://raw.githubusercontent.com/YamiDaisuke/yamidaisuke-ai-toolbelt/main/install.sh | bash

# Via Homebrew
brew tap YamiDaisuke/yamidaisuke-ai-toolbelt
brew install --HEAD ym
```

### Commands

**`ym bootstrap <project-name>`** — New project

Clones the skeleton, copies `.bootstrap/`, creates `docs/REQUIREMENTS.md` and `docs/ARCHITECTURE.md` from templates (with today's date substituted), syncs `.claude/agents/` and `.claude/commands/`, writes `CLAUDE.md` with the project name.

**`ym bootstrap`** — Update existing project

Detects `.bootstrap/` in the current directory. Replaces `.bootstrap/` with the latest skeleton, re-syncs `.claude/agents/` and `.claude/commands/`, and runs all `migrate-*.sh` scripts to upgrade existing docs. Does not touch `docs/` user content or `CLAUDE.md`.

### Releasing a new version

1. Update `VERSION` in `bin/ym`
2. Tag the release: `git tag v<version> && git push origin v<version>`
3. Update `Formula/ym.rb` with the tarball URL and SHA256

-----

## Phase Sequence (Summary)

|Phase       |Driver                  |Output          |Done When                  |
|------------|------------------------|----------------|---------------------------|
|Requirements|Architect               |REQUIREMENTS.md |User confirms all sections |
|Architecture|Architect               |ARCHITECTURE.md |User confirms all sections |
|Spec Writing|Scrum Master + Architect|docs/specs/*.md |All features have a spec   |
|Development |Developer loop          |Code commits    |All tasks in spec = `done` |
|QA          |QA agent                |QA report       |All criteria pass → `done` |

-----

## Open Questions (for you to decide)

1. **Review strictness** — should Code Reviewer always block on missing tests, or is that configurable per spec?
1. **Claude Code vs chat** — are Developer and Reviewer running as Claude Code agents (autonomous) or guided chat sessions?
