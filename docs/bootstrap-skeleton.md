# Project Bootstrap Skeleton

## Spec-Driven Development with Agent Roles

-----

## Directory Structure

```
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
│   ├── task-runner.md
│   ├── code-review.md
│   └── qa-check.md
├── scripts/
│   ├── bootstrap.sh          # Init a new repo from this skeleton
│   ├── new-spec.sh           # Scaffold a new spec file
│   ├── next-task.sh          # Print next incomplete task across specs
│   └── qa-report.sh          # Aggregate QA status across specs
├── templates/
│   ├── REQUIREMENTS.md
│   ├── ARCHITECTURE.md
│   └── SPEC.md
└── CLAUDE.md                 # Context file for Claude Code sessions
```

```
{project-repo}/
├── .bootstrap/               # Symlink or copy of the above
├── docs/
│   ├── REQUIREMENTS.md       # Generated
│   ├── ARCHITECTURE.md       # Generated
│   └── specs/
│       ├── feature-auth.md
│       ├── feature-billing.md
│       └── ...
└── CLAUDE.md                 # Project-level Claude Code context
```

-----

## Agents

### 🏛️ Architect

**Role:** Technical authority. Leads requirements and architecture sessions,
provides technical input during spec writing, available for design questions
during development.

**Triggers:**

- Start of project (requirements phase)
- After requirements complete (architecture phase)
- Called by Scrum Master during spec writing for technical constraints

**Core behaviors:**

- Asks one section at a time, never dumps a full template
- Summarizes what was captured before moving to the next section
- Flags conflicts or ambiguities immediately
- Writes output to docs/ only when the user confirms a section is done

**Skill refs:** `requirements-interview`, `architecture-interview`

-----

### 🗂️ Scrum Master

**Role:** Flow orchestrator. Breaks requirements into features, coordinates
spec writing, assigns tasks to Developer, tracks completion, triggers QA.

**Triggers:**

- After ARCHITECTURE.md is written
- After each task is approved by Code Reviewer
- After all tasks in a spec are complete (triggers QA)

**Core behaviors:**

- Maintains a simple task board (status fields in spec files)
- Assigns one task at a time to Developer
- Escalates blockers to Architect or User
- Never writes code, never reviews code

**Skill refs:** `spec-writer`, `task-runner`

-----

### 💻 Developer

**Role:** Implementation. Receives one atomic task at a time, implements it,
submits for review, iterates on feedback.

**Triggers:**

- Task assigned by Scrum Master

**Core behaviors:**

- Reads the full spec before starting any task
- Reads ARCHITECTURE.md for conventions
- Commits after each task, never bundles unrelated changes
- Marks task as `in-review` before submitting

**Skill refs:** `task-runner`

-----

### 🔍 Code Reviewer

**Role:** Quality gate before merge. Reviews each task implementation against
the spec's acceptance criteria and ARCHITECTURE.md conventions.

**Triggers:**

- Developer submits a completed task

**Review checklist:**

- Does the code satisfy the acceptance criteria in the spec?
- Does it follow the conventions in ARCHITECTURE.md?
- Are there obvious bugs, security issues, or performance concerns?
- Is test coverage present where required?

**Output:** `PASS` (notifies Scrum Master) or `FEEDBACK` (returned to Developer
with specific, actionable comments referencing line numbers and spec criteria).

**Skill refs:** `code-review`

-----

### ✅ QA

**Role:** Feature acceptance gate. Runs after all tasks in a spec are
Developer-approved. Tests the full feature against functional and
non-functional requirements.

**Triggers:**

- Scrum Master signals all spec tasks are `approved`

**QA checklist:**

- Does each acceptance criterion in the spec pass?
- Does the feature match the REQUIREMENTS.md functional requirements?
- Edge cases and error states covered?
- Non-functional requirements met (perf, a11y, security as applicable)?

**Output:** `ACCEPTED` (Scrum Master marks spec complete) or `BUG REPORT`
(filed as new tasks back to Developer, with spec references).

**Skill refs:** `qa-check`

-----

## Skills

### `requirements-interview`

Guides the Architect through a structured requirements session.

**Sections (in order):**

1. Project vision & problem statement
1. Target users & stakeholders
1. Functional requirements (what the system does)
1. Non-functional requirements (perf, security, scale, a11y)
1. Out of scope
1. Constraints & dependencies
1. Success criteria

**Rules:**

- One section at a time
- Summarize what was captured, ask "does this look right?" before continuing
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

**Rules:** Same as `requirements-interview` — one section, confirm, write.

-----

### `spec-writer`

Used by Scrum Master to produce a spec file for one feature.

**Spec structure:**

```
# Spec: {Feature Name}
Status: draft | in-progress | complete | accepted

## Overview
One-paragraph summary of the feature.

## Functional Requirements
- FR-01: ...
- FR-02: ...

## Technical Requirements
- TR-01: (references ARCHITECTURE.md sections as needed)

## Tasks
### TASK-01: {short title}
**Description:** ...
**Acceptance Criteria:**
- [ ] ...
**Status:** todo | in-progress | in-review | approved

### TASK-02: ...
```

**Rules:**

- Tasks must be atomic (completable in one sitting, reviewable independently)
- Each task has explicit, testable acceptance criteria
- Scrum Master confirms the task list with User before writing the file

-----

### `code-review`

Used by Code Reviewer. Structured review against spec and architecture.

**Inputs:** diff/PR, spec file, ARCHITECTURE.md
**Outputs:** Structured feedback with:

- Verdict: PASS or FEEDBACK
- If FEEDBACK: numbered list of issues, each with file+line ref and spec criteria ref
- No vague comments — every issue must be actionable

-----

### `qa-check`

Used by QA agent. Tests a completed spec.

**Inputs:** spec file, REQUIREMENTS.md, codebase
**Process:**

1. List all acceptance criteria across all tasks
1. List all functional requirements that apply to this feature
1. For each: PASS / FAIL / PARTIAL with notes
1. Summary verdict: ACCEPTED or BUG REPORT
1. Bug report items are formatted as new task stubs (ready for Scrum Master to inject)

-----

## Scripts

### `bootstrap.sh`

Initializes a new repository with this skeleton.

```bash
#!/bin/bash
# Usage: ./bootstrap.sh <project-name>
# - Creates docs/REQUIREMENTS.md, docs/ARCHITECTURE.md from templates
# - Creates docs/specs/ directory
# - Writes CLAUDE.md pointing to docs/
# - Initializes git if not already a repo
```

### `new-spec.sh`

```bash
#!/bin/bash
# Usage: ./new-spec.sh <feature-slug>
# - Creates docs/specs/<feature-slug>.md from SPEC.md template
# - Adds status: draft header
```

### `next-task.sh`

```bash
#!/bin/bash
# Scans all specs in docs/specs/
# Prints the first task with status: todo
# Format: [spec-file] TASK-XX: description
```

### `qa-report.sh`

```bash
#!/bin/bash
# Scans all specs
# Prints table: Spec | Tasks Done | Tasks Total | QA Status
```

-----

## CLAUDE.md (project-level)

```markdown
# Project: {Name}

## Roles active in this repo
- Architect: see .bootstrap/agents/architect.md
- Scrum Master: see .bootstrap/agents/scrum-master.md
- Developer: see .bootstrap/agents/developer.md
- Code Reviewer: see .bootstrap/agents/code-reviewer.md
- QA: see .bootstrap/agents/qa.md

## Key documents
- Requirements: docs/REQUIREMENTS.md
- Architecture: docs/ARCHITECTURE.md
- Specs: docs/specs/*.md

## Current phase
<!-- Update this as the project progresses -->
[ ] Requirements
[ ] Architecture
[ ] Spec writing
[ ] Development
[ ] QA

## Conventions (summary)
<!-- Short-form of ARCHITECTURE.md conventions for quick reference -->
```

-----

## Phase Sequence (Summary)

|Phase       |Driver                  |Output         |Done When                   |
|------------|------------------------|---------------|----------------------------|
|Requirements|Architect               |REQUIREMENTS.md|User confirms all sections  |
|Architecture|Architect               |ARCHITECTURE.md|User confirms all sections  |
|Spec Writing|Scrum Master + Architect|docs/specs/*.md|All features have a spec    |
|Development |Developer loop          |Code commits   |All tasks in spec = approved|
|QA          |QA agent                |QA report      |All criteria pass → ACCEPTED|

-----

## Open Questions (for you to decide)

1. **Tooling for task status** — tracking task status as fields in markdown is simple but requires discipline. Do you want a lightweight JSON/YAML sidecar, or keep it in-file?
1. **Multi-agent concurrency** — can multiple Developers work on different specs in parallel, or always serial?
1. **Review strictness** — should Code Reviewer always block on missing tests, or is that configurable per spec?
1. **Claude Code vs chat** — are Developer and Reviewer running as Claude Code agents (autonomous) or guided chat sessions?
1. **Spec granularity** — do you want a rule for max tasks per spec (e.g. ≤10), or free-form?
