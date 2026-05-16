# task-runner

**Used by:** Developer, Scrum Master

**Input:** A spec file with at least one task at status `todo`.

## Process (Developer — executing a task)

1. Read the full spec file end to end.
2. Read `docs/ARCHITECTURE.md` for conventions.
3. Update the task status to `in-progress` in the spec file.
4. Implement only what the task's acceptance criteria require.
5. Update the task status to `in-review` in the spec file.
6. Commit the implementation and the status update together.
7. Notify the Scrum Master the task is ready for review.

## Process (Scrum Master — assigning a task)

1. Find the next task with status `todo` in the active spec.
2. Assign it to the Developer: provide the spec file path and task ID.
3. Do not assign another task until the current one reaches `approved`.

## Output

- Developer: committed implementation + spec file with task status `in-review`.
- Scrum Master: Developer notified with spec path and task ID.
