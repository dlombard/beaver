# Taskman — task-manager web app

REST API in Python (FastAPI) over Postgres. Transactional email is already wired up
via `emailer.send(to, subject, body)`. Auth is session-cookie based; passwords are
stored bcrypt-hashed in the `users` table (`id`, `email`, `password_hash`,
`created_at`).

## Layout

- `api/` — route handlers
- `db/` — migrations (raw SQL, numbered)
- `emailer.py` — outbound email
- `tests/` — pytest
