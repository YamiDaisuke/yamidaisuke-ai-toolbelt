---
description: Execute or assign an atomic spec task — Developer implements and iterates through review; Scrum Master finds and assigns the next todo task one at a time.
---

# task-runner

**Used by:** Developer, Scrum Master

**Input:** A spec file with at least one task at status `todo`.

## Git Workflow (Developer)

Before starting any task, create a fresh branch from main:

```bash
git checkout main && git pull origin main
git checkout -b <prefix>/<task-slug>
```

Branch name format: `<prefix>/<kebab-task-title>` — e.g., `feat/user-auth-endpoint`, `fix/token-expiry-bug`.

Commit format: `<prefix>: <imperative summary>` — e.g., `feat: add user auth endpoint`.

Allowed prefixes: `feat`, `fix`, `chore`, `refactor`, `test`, `docs`, `style`, `ci`.

The prefix must match the semantic prefix in the task title.

## Process (Developer — executing a task)

1. Create a fresh branch from main (see Git Workflow above).
2. Read the full spec file end to end.
3. Read `docs/ARCHITECTURE.md` for conventions.
4. Update the task status to `in-progress` in the spec file.
5. Implement only what the task's acceptance criteria require.
6. Ask the Code Reviewer for approval.
   - If approved → mark task `done`, commit using semantic prefix, open a PR, notify Scrum Master.
   - If feedback → address each comment, then ask for approval again. Repeat until approved.

## Process (Scrum Master — assigning a task)

1. Find the next task with status `todo` in the active spec.
2. Assign it to the Developer: provide the spec file path and task ID.
3. Do not assign another task until the current one reaches `done`.

## Output

- Developer: committed implementation on a named branch + PR opened + spec file with task status `done`.
- Scrum Master: Developer notified with spec path and task ID.
