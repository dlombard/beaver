# Spec 0007 — Report CSV Export

**Status:** Approved

## Scope

Add an endpoint that exports a single report as CSV.

- **Endpoint:** `GET /reports/{report_id}/export`
- **Auth:** caller must be authenticated and authorized for `report_id` (owner or
  admin). Unauthorized → 403; unknown `report_id` → 404.
- **Columns (in order):** `id, created_at, label, value`. `created_at` in ISO-8601.
- **CSV format:** RFC 4180 — header row, comma-separated, values with commas/quotes/
  newlines are quoted. `Content-Type: text/csv`.
- **Errors:** parameterized queries only (no string interpolation of `report_id`).

## Out of scope

Multi-report/bulk export, async/streamed export of very large reports, custom column
selection. (Deferred.)

## Definition of Done

- Endpoint implemented per above; auth + 403/404 paths covered.
- No SQL injection (parameterized query).
- OpenAPI doc for the endpoint in `docs/api/`.
- Tests: happy path, unauthorized, not-found, and CSV-escaping of a value containing a comma.
