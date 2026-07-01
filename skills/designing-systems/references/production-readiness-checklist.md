# Production Readiness Checklist

Use this checklist to add only relevant production requirements.

## Reliability

- clear failure modes and degraded behavior
- timeouts, retries, idempotency, and circuit breaking where needed
- data backup, restore, migration, and rollback strategy
- RTO/RPO expectations when data loss or downtime matters

## Scalability and Capacity

- capacity sized to the Constraint Register (peak QPS, concurrency, data growth, storage)
- horizontal scaling / autoscaling path, and its limits or bottlenecks
- load/stress test to a known breaking point before launch
- graceful degradation and load shedding under overload

## Dependencies and Third-Party

- timeout, retry, and failure behavior defined for each external dependency
- rate limits / quotas handled with backoff; fallback or cache when a dependency is down
- vendor lock-in and data-portability considered

## Security and Privacy

- authentication and authorization model
- least-privilege access
- secret handling
- input validation and output encoding
- audit logs for sensitive actions
- data retention, deletion, and export expectations
- PII classification and encryption needs

## Observability

- structured logs for important state transitions and failures
- metrics for traffic, errors, latency, saturation, and business-critical events
- traces across service boundaries when distributed calls exist
- alerts tied to user impact, not noisy internals

## Delivery and Operations

- build, test, lint, and migration checks
- deployment and rollback path
- environment configuration
- feature flags when rollout risk is high
- runbook for common incidents
- ownership and escalation path when relevant

## Cost and Efficiency

- cost model per request/user (and per inference/token for AI); budget ceiling
- cost alerts and right-sizing; scale-to-zero where load is bursty
- main cost drivers named (egress, storage, third-party APIs, inference)

## AI / LLM Readiness

Add when the system uses a model (see `references/ai-system-design.md`).

- evaluation gate (retrieval + generation quality) before shipping model/prompt changes
- model and prompt versioning/pinning; rollback for a bad prompt or model update
- guardrails: prompt-injection defense, output validation, PII kept out of prompts/logs
- token/cost monitoring and provider rate-limit (TPM/RPM) handling; fallback or degraded mode
- grounding/citation checks; human-in-the-loop approval for high-risk actions

## Documentation

- setup instructions
- architecture notes
- API contracts
- operational runbook
- known limitations and out-of-scope items
