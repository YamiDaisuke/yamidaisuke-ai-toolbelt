# CLAUDE.md

Behavioral guidelines for {PROJECT_NAME}.

<!-- Replace {PROJECT_NAME} with the project name. Fill in sections 5–7 after bootstrapping. -->

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

## 5. Project Context

<!-- What is this project? What problem does it solve? What are the key constraints? -->

{PROJECT_DESCRIPTION}

## 6. Roles & Documents

### Roles active in this repo
- Architect: see .claude/agents/architect.md
- Scrum Master: see .claude/agents/scrum-master.md
- Developer: see .claude/agents/developer.md
- Code Reviewer: see .claude/agents/code-reviewer.md
- QA: see .claude/agents/qa.md

### Key documents
- Requirements: docs/REQUIREMENTS.md
- Architecture: docs/ARCHITECTURE.md
- Specs: docs/specs/*.md

### Current phase
<!-- Update this as the project progresses -->
[ ] Requirements
[ ] Architecture
[ ] Spec writing
[ ] Development
[ ] QA

## 7. Conventions

<!-- Short-form of ARCHITECTURE.md conventions for quick reference. Fill in after architecture is confirmed. -->

{CONVENTIONS_SUMMARY}

## 8. Definition of Done

A task is done when:

- It satisfies all acceptance criteria in the spec
- It could be handed to a Code Reviewer with no additional explanation
- It contains no TODOs or incomplete implementations

-----

**This system is working if:** a Claude Code agent reading only CLAUDE.md and one agent file
knows exactly what to do, what not to do, and where to find everything else.
