# CLAUDE.md

Behavioral guidelines for building and maintaining this bootstrap system.
This repo IS the skeleton — every file you create here will be copied into future projects.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

-----

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:

- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them — don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing files:

- Don't "improve" adjacent content, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated issues, mention them — don't fix them silently.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

For multi-step tasks, state a brief plan before starting:

```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Wait for confirmation on the plan before writing any file.

-----

## 5. What This Repo Is

A reusable bootstrap skeleton for spec-driven development with agent roles.
It is not a runnable application. The deliverables are text files — markdown, bash scripts, and templates.

```
.bootstrap/
├── agents/          # Role definitions (architect, scrum-master, developer, code-reviewer, qa)
├── skills/          # Skill guides used by each agent
├── scripts/         # Bash scripts: bootstrap.sh, new-spec.sh, next-task.sh, qa-report.sh
└── templates/       # Blank starting templates: REQUIREMENTS.md, ARCHITECTURE.md, SPEC.md

CLAUDE.md            # This file — also the template shipped to new projects (see note below)
```

Reference document: `docs/bootstrap-skeleton.md` is the source of truth for what gets built.
Do not add files not described there without explicit approval.

## 6. The CLAUDE.md Duality

This file serves two purposes:

1. **Right now:** guides Claude Code while building this bootstrap repo.
1. **When shipped:** copied into new projects via `bootstrap.sh` as their starting CLAUDE.md,
   where sections 5–6 are replaced with project-specific context.

Do not conflate the two. When editing this file, consider whether a change belongs here
(bootstrap-build context) or in the shipped template (`templates/CLAUDE.md`).

## 7. File Authoring Rules

These files will be read by Claude Code agents in future projects. Write them accordingly:

- **Agent files** (`agents/*.md`): role definition first, then triggers, then behaviors, then skill refs.
  Be prescriptive. Agents follow instructions literally — vague guidance produces vague behavior.
- **Skill files** (`skills/*.md`): inputs → process (numbered steps) → output format. No prose padding.
- **Scripts** (`scripts/*.sh`): include usage comment at top, keep logic minimal, exit with clear errors.
- **Templates** (`templates/*.md`): placeholder tokens use `{UPPER_SNAKE_CASE}`. Every section that
  must be filled in should have a one-line instruction comment.

## 8. Definition of Done

A file is done when:

- It matches the spec in `docs/bootstrap-skeleton.md`
- It could be handed to a Claude Code agent in a new project with no additional explanation
- It contains no TODOs, placeholder logic, or "coming soon" stubs unless explicitly allowed

-----

**This system is working if:** a Claude Code agent reading only CLAUDE.md and one agent file
knows exactly what to do, what not to do, and where to find everything else.
