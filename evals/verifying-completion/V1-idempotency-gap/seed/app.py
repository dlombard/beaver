"""Create-task handler. See docs/specs/SPEC-1-create-task.md."""

TASKS = []


def create_task(body, headers=None):
    """Handle POST /tasks. Returns (status_code, response_body)."""
    title = (body.get("title") or "").strip()
    if not title:
        return 400, {"error": "title required"}
    task = {"id": len(TASKS) + 1, "title": title}
    TASKS.append(task)
    return 201, task
