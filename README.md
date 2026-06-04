# ym

Bootstrap spec-driven development projects with AI agent roles for Claude Code.

## Install

**Via install script (recommended):**

```bash
curl -fsSL https://raw.githubusercontent.com/YamiDaisuke/yamidaisuke-ai-toolbelt/main/install.sh | bash
```

Installs to `/usr/local/bin/ym`. To use a custom directory:

```bash
curl -fsSL https://raw.githubusercontent.com/YamiDaisuke/yamidaisuke-ai-toolbelt/main/install.sh | YM_INSTALL_DIR=~/.local/bin bash
```

**Via Homebrew:**

```bash
brew tap YamiDaisuke/yamidaisuke-ai-toolbelt
brew install --HEAD ym
```

## Usage

**Bootstrap a new project:**

```bash
mkdir my-project && cd my-project
ym bootstrap my-project
```

This sets up:
- `.ym/` — agent roles, skills, scripts, and templates
- `.claude/agents/` — agent definitions loaded by Claude Code
- `.claude/commands/` — skill commands loaded by Claude Code
- `docs/REQUIREMENTS.md` and `docs/ARCHITECTURE.md` — starting templates
- `docs/specs/` — directory for feature specs
- `CLAUDE.md` — project-level behavioral guidelines

Then open the directory in Claude Code and start with the Architect agent.

**Update an existing project to the latest skeleton:**

```bash
cd existing-project
ym bootstrap
```

Updates `.ym/`, `.claude/agents/`, and `.claude/commands/` from the latest skeleton. Your `docs/` and `CLAUDE.md` are untouched. Migration scripts run automatically to upgrade existing docs.

## What you get

A structured workflow for spec-driven development with five agent roles:

| Agent | Role |
|-------|------|
| Architect | Leads requirements and architecture sessions |
| Scrum Master | Breaks requirements into specs, assigns tasks |
| Developer | Implements one task at a time, submits for review |
| Code Reviewer | Reviews against spec criteria and conventions |
| QA | Acceptance testing after all tasks are done |

Each role is defined as a Claude Code agent file with explicit triggers, behaviors, and skill references.

## Workflow

After bootstrapping, open the project in Claude Code and work through these phases in order:

1. **Requirements** — Switch to the Architect agent. It will run an interview to produce `docs/REQUIREMENTS.md`.
2. **Architecture** — Still with Architect, run the architecture interview to produce `docs/ARCHITECTURE.md`.
3. **Spec** — Switch to the Scrum Master. It breaks a chosen feature into atomic tasks and writes a spec to `docs/specs/<feature>.md`.
4. **Development** — Switch to the Developer. It picks up the next task, implements it, and submits for review.
5. **Code Review** — Switch to the Code Reviewer. It reviews against the spec's acceptance criteria and either passes or returns feedback.
6. **QA** — Once all tasks in a spec are done, switch to the QA agent. It runs acceptance testing and reports bugs (which become new tasks).

Resume at any phase. Run `/ym:help` inside Claude Code to see the current project state and where to pick up.

## Helper scripts

These live in `.ym/scripts/` after bootstrapping:

| Script | What it does |
|--------|-------------|
| `new-spec.sh <slug>` | Scaffolds a new spec file from the template |
| `next-task.sh` | Prints the next incomplete task across all specs |
| `qa-report.sh` | Aggregates QA status across all specs |
