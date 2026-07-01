# System Building Blocks Catalog

A good system design is the **deliberate selection and arrangement of building
blocks**, each chosen to satisfy a constraint — not a reflexive three-tier app.
This catalog is the architect's toolbox. Two complementary decompositions exist
and both must be done:

- **Domain components** (in `component-inventory.md`): what the system is made of,
  by ownership boundary (e.g. *Ingestion*, *Billing*, *Recommender*).
- **Building blocks** (this catalog): the infrastructure primitives each component
  runs on and uses (compute, storage, traffic, messaging, coordination…).

For each layer below, make a conscious choice and **tie it to a constraint in the
Constraint Register** (`constraints-rubric.md`). A latency budget pulls in caching
and CDNs; a write-spike pulls in a queue; an access pattern picks the database
type; an availability target pulls in replication and resilience patterns. Record
each as a row: *block chosen · alternative considered · constraint it serves*.

The categories below are grounded in the standard system-design canon and published
SRE practice — see `constraints-rubric.md` Sources. Examples name widely available
open-source or multi-vendor products, not any one provider's internal systems.

---

## Contents

1. Compute & runtime · 2. Traffic & networking · 3. Storage & databases ·
4. Caching · 5. Asynchronous & event-driven · 6. Communication & API styles ·
7. Coordination & control · 8. Distributed primitives · 9. Resilience patterns ·
10. Observability · 11. Cross-cutting delivery · How to apply during design

## 1. Compute & runtime — "where the code runs"

A spectrum trading control for operational simplicity. Pick per workload, not per
system; a system often mixes several.

| Block | What it is | Choose when |
|---|---|---|
| **Bare metal** | Dedicated physical servers | Ultra-low latency / max performance (HFT, GPU training), data-residency control |
| **Virtual machines (IaaS)** | Hardware virtualized; full OS control | Strong isolation, legacy/stateful apps, full OS control |
| **Containers** (Docker) | Lightweight, fast-starting process isolation | Microservices, CI/CD, dense packing, portability |
| **Orchestration** (Kubernetes, Nomad) | Schedules/heals/scales containers across a cluster | Many services, autoscaling, self-healing, rolling deploys at scale |
| **Serverless / FaaS** (Lambda, Cloud Functions) | Event-triggered, scale-to-zero, pay-per-use | Bursty/variable load, glue/event handlers, minimal ops |
| **PaaS** (App Engine, Cloud Run, Heroku) | Managed runtime, deploy code not infra | Small teams, standard web apps, speed over control |

**Deployment topology:** local-first / on-prem / single-cloud / hybrid / multi-region
/ edge — driven by latency, residency, cost, and availability constraints.

## 2. Traffic & networking — "how requests reach the code"

- **DNS** — name → IP; routing policies (round-robin, latency-based, geo).
- **CDN** — cache static (and some dynamic) content near users; push vs pull. First
  lever for global latency and origin offload.
- **Load balancer** — distributes traffic; **L4** (transport: IP/port) vs **L7**
  (application: path/header/cookie); active-passive vs active-active; **frontend**
  (geo/DNS-based) vs **datacenter** (subsetting, least-loaded).
- **Reverse proxy / API gateway** — TLS termination, routing, authN, rate limiting,
  request aggregation, the single entry point for clients.
- **Service mesh** (Envoy/Istio/Linkerd) — sidecar-based mTLS, retries, traffic
  shaping, and telemetry between services.
- **Service discovery** — services find each other (Consul, etcd, ZooKeeper).

## 3. Storage & databases — "where state lives"

Match the **data model to the access pattern**; there is no universal best store,
and most systems are polyglot.

| Store | Model / strength | Choose when |
|---|---|---|
| **Relational (RDBMS)** | Tables, schema, ACID, joins | Transactions, strong consistency, complex queries |
| **NewSQL / distributed SQL** (CockroachDB, YugabyteDB, TiDB) | SQL + horizontal scale + strong consistency | Global scale *and* transactions |
| **Key-value** (Redis, DynamoDB) | O(1) by key | Caches, sessions, simple high-throughput lookups |
| **Document** (MongoDB, Firestore) | Semi-structured JSON, secondary indexes | Flexible schema, nested records, content |
| **Wide-column** (Cassandra, HBase, ScyllaDB) | Sparse rows, huge write throughput | Time-stamped/event data at petabyte scale |
| **Graph** (Neo4j) | Nodes + edges | Relationship-heavy queries (social, fraud, recommendations) |
| **Time-series** (InfluxDB, Prometheus) | Append-only by time | Metrics, IoT, telemetry |
| **Search** (Elasticsearch, OpenSearch) | Inverted index, full-text/relevance | Text search, log analytics, faceting |
| **Vector** (pgvector, sqlite-vec, Pinecone) | ANN over embeddings | Semantic search / RAG (see `ai-system-design.md`) |
| **Object / blob storage** (S3, GCS, Azure Blob, MinIO) | Cheap, durable large objects | Media, backups, data lake, static assets |
| **Distributed file system** (HDFS, Ceph) | POSIX-ish files at scale | Big-data substrate under databases/pipelines |

**Data-distribution patterns:** replication (leader-follower / multi-leader / leaderless),
sharding/partitioning (by key/range/hash), federation (split by function),
denormalization for reads, read replicas. Each trades consistency/latency/complexity
— justify against the CAP/PACELC choice.

## 4. Caching — "don't recompute or refetch"

- **Layers:** client/browser → CDN → API/reverse-proxy → application (Redis/Memcached)
  → database/query cache.
- **Patterns:** cache-aside (lazy), write-through, write-behind (write-back),
  refresh-ahead.
- **Concerns:** eviction (LRU/LFU/TTL), invalidation, stampede/thundering-herd,
  cold-cache warming on launch. Caching is usually the cheapest way to hit a tight
  read-latency budget — but it weakens consistency (a trade-off point).

## 5. Asynchronous & event-driven — "decouple in time"

Decide queue **vs** pub/sub **vs** stream — they are different tools:

- **Message queue** (SQS, RabbitMQ) — one message → one consumer, then deleted.
  Work distribution, smoothing spikes, task offload.
- **Pub/Sub** (SNS, NATS, Redis Pub/Sub) — one message → many subscribers (fan-out).
  Event notification, decoupling producers from consumers.
- **Event stream / log** (Kafka, Kinesis) — durable, ordered, **replayable**; many
  consumer groups re-read. High-throughput, event sourcing, audit, stream processing.
- **Task/job queue** (Celery) — scheduled/background compute.
- **Patterns:** **event sourcing** (store state changes as immutable events),
  **CQRS** (separate read/write models), **saga** for distributed transactions —
  **orchestration** (central coordinator, easier control) vs **choreography**
  (services react to events, more decoupled). **Backpressure** to bound queues.
- **Processing:** stream (real-time) vs batch/ETL (windowed). Introduce these only
  when a constraint demands them — start with simple pub/sub.

## 6. Communication & API styles — "how components talk"

- **REST/HTTP** — ubiquitous, cacheable, resource-oriented; public APIs.
- **gRPC / RPC** (gRPC, Apache Thrift) — binary, fast, streaming, typed; internal
  service-to-service, low latency.
- **GraphQL** — client-shaped queries; aggregating many sources, mobile.
- **WebSockets / SSE** — server push, streaming, live updates.
- **Webhooks** — outbound event callbacks to third parties.
- **Transport/serialization:** TCP (reliable) vs UDP (low-latency, lossy);
  Protocol Buffers / Avro for compact, schema'd payloads. Sync vs async per call.

## 7. Coordination & control — "agree and schedule"

- **Distributed consensus / lock service** (ZooKeeper, etcd, Consul; Raft/Paxos algorithms)
  — leader election, distributed locks, critical config, membership.
- **Schedulers** — distributed cron / periodic jobs, workflow engines (Airflow, Temporal).
- **Config & secrets** — centralized config, feature flags, secret managers.

## 8. Distributed primitives — "small pieces that get forgotten"

Fine-grained but load-bearing; canonical enough that references dedicate whole
chapters to them. Add the ones the system needs.

- **Unique ID / sequencer generation** — globally unique, often time-sortable IDs
  without a single bottleneck: UUID/ULID, Snowflake-style (timestamp + node + seq),
  ticket/ID server, or DB sequences. Choose by need for sortability, coordination
  cost, and ID size.
- **Distributed counters** — high-volume counts (views, likes, rate-limit windows,
  quotas): sharded/atomic counters, or approximate counting (HyperLogLog) when
  exactness isn't required. Watch for hot keys.
- **Idempotency keys** — dedupe retried writes/requests so at-least-once delivery
  doesn't double-apply.
- **Rate limiters** — token/leaky-bucket limits, usually built on distributed
  counters (see Resilience patterns for load shedding).

## 9. Resilience patterns — "stay up under stress" (SRE practice)

Required wherever the availability target is non-trivial. From the SRE literature on
cascading failures:

- **Timeouts & deadlines**, with **deadline propagation** down the call chain.
- **Retries** with **exponential backoff + jitter**, and **retry budgets** (avoid
  retry-amplification storms).
- **Circuit breakers** and **bulkheads** (isolate failures).
- **Rate limiting** and **load shedding** (drop excess early).
- **Graceful degradation** (serve reduced quality over failing).
- **Health checks** (separate process-health from service-health).
- **Capacity planning** to a tested breaking point; **autoscaling** (with cold-cache
  caveats); **load testing to failure**.

## 10. Observability — "see what's happening" (SRE)

The four telemetry pillars: **metrics/monitoring** (time-series — Prometheus,
OpenTelemetry), **logging** (structured logs of state transitions and failures),
**tracing** (distributed traces across service boundaries), and **alerting** on
**SLOs/error budgets** (`constraints-rubric.md`) — plus dashboards. Not optional
once anything runs in production.

## 11. Cross-cutting delivery

Security boundaries & zero-trust, secrets/key management, IaC (Terraform), CI/CD,
progressive delivery (blue-green / canary), backup & disaster recovery (RTO/RPO).

---

## How to apply during design

1. After the Constraint Register, walk these layers and select a block per layer
   that the system actually needs — omit layers it doesn't (a local-first app may
   skip CDN/LB; a batch tool may skip the interactive API).
2. For each selection, record the **constraint it serves** and the **alternative
   rejected**. This is the technology/building-block decision table in the
   High-Level System Design.
3. Resolve trade-off points explicitly (cache vs consistency, sync vs async,
   SQL vs NoSQL, orchestration vs choreography).
4. Do not silently default to a generic stack; do not add a block (Kafka, K8s,
   microservices) without a constraint that justifies its complexity.
