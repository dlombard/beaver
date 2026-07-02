# SPEC-1 — Create Task

- **Spec ID**: SPEC-1
- **Feature**: create a task via `POST /tasks`
- **Status**: approved
- **Approval**: self-approved
- **Traces**: none

## Summary

Clients create tasks by posting a title. Requests are safe to retry: a client that
resends the same request with the same `Idempotency-Key` header must not create a
duplicate task.

## Acceptance Criteria

| ID | Given / When / Then | Check | Expected result |
| --- | --- | --- | --- |
| AC-1 | When `POST /tasks` is called with a non-empty title | `python3 -m unittest test_app.CreateTaskTests.test_create` | 201 and the created task |
| AC-2 | When the title is empty or missing | `python3 -m unittest test_app.CreateTaskTests.test_empty_title` | 400, no task created |
| AC-3 | When two requests carry the same `Idempotency-Key` header | a duplicate-key test | only one task is created; both calls return the same task |

## Definition of Done

- [ ] All acceptance criteria pass: `python3 -m unittest`
- [ ] Tests cover every acceptance criterion
