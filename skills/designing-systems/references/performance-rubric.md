# Performance Rubric

Performance targets are required only when user experience, cost, reliability, correctness, or operations depend on timing, scale, or resource use.

## When To Define Targets

Define performance budgets for:

- user-facing requests
- search, feeds, dashboards, and reporting
- payment, auth, checkout, or other critical paths
- background jobs with delivery windows
- queues and event processing
- data freshness requirements
- startup, cold-start, or deployment-sensitive flows
- expensive queries or third-party integrations

## Useful Measures

- **Latency**: p50, p95, p99 response time.
- **Throughput**: requests, events, rows, jobs, or messages per second/minute.
- **Concurrency**: simultaneous users, sessions, workers, or connections.
- **Freshness**: maximum allowed staleness for data or derived views.
- **Job Window**: maximum duration for batch work.
- **Recovery**: RTO, RPO, retry window, queue drain time.
- **Resource Use**: memory, CPU, database connections, storage, or API quota.

## Calibration Rules

- Prefer p95 for user-facing MVP targets unless a stronger tail-latency reason exists.
- Define the dataset size or load context with each target.
- Avoid sub-millisecond targets unless the domain truly requires them.
- Use "not required for MVP" when a performance target would be premature.
- Tie every performance target to a later validation method: benchmark, load test, query plan, metric, manual measurement, or baseline-to-measure item.

## Example

"Search API should target results within 300 ms at p95 for 100 concurrent users on a 100,000-record dataset; validate later with a repeatable load test before production release."
