# Constraints & Requirements Elicitation Rubric

A system design is only as good as the constraints it is held to. Project briefs
almost always describe **what** to build ("a Netflix-like app") and almost never
state the **constraints** that actually determine the architecture ("recommendations
must return in < 100 ms at p95 for 50M users"). Eliciting those constraints is the
first job of this skill, not an afterthought. An architecture chosen without a
latency budget, a scale target, an availability target, and a consistency choice is
a guess.

This rubric distills the convergent guidance of the major system-design references
(see Sources). They all share one shape: **functional requirements → non-functional
requirements (constraints) → capacity estimation → trade-offs**, with every
non-functional requirement made measurable.

## Contents

1. The constraint-elicitation gate
2. Constraint taxonomy (the checklist that gets forgotten)
3. Capacity / back-of-the-envelope estimation
4. Trade-offs to surface
5. Making constraints measurable
6. Availability / downtime reference
- Sources

## 1. The constraint-elicitation gate

When this skill triggers, before committing to an architecture, drive the brief to a
**Constraint Register**. For each critical user-facing operation and the system as a
whole, establish — or explicitly mark as an assumption / baseline-to-measure — the
constraints below. Ask the user only for constraints that materially change the
architecture, within the skill's question budget; otherwise propose a defensible
default and label it an assumption.

The test for a real constraint (vs. a vanity target): it names **the operation, the
metric, the target value, the load/condition, and how it will be validated.**
"The system should be fast" is not a constraint. "Search returns in < 300 ms at p95
for 1,000 concurrent users over a 100M-row index, verified by a load test" is.

## 2. Constraint taxonomy (the checklist that gets forgotten)

Grouped from ISO/IEC 25010 quality characteristics + the system-design-interview
canon. Not every system needs every line — but each should be a conscious *include*
or *exclude*, never an accidental omission.

**Scale & load (size the problem first)**
- Users: total, DAU/MAU, concurrent peak vs. average.
- Traffic: requests/sec (read and write separately), read:write ratio, peak-to-average ratio.
- Data: total volume, growth rate, per-record size, retention window.
- Bandwidth and storage implied by the above (see §3).

**Performance** (deepen with `performance-rubric.md`)
- Latency budget per critical operation: p50 / p95 / p99 (e.g. *recommendations < 100 ms p95*).
- Throughput target: sustained and peak.
- Time-to-first-byte / time-to-first-token for streaming or AI responses.

**Availability & reliability**
- Uptime target in "nines" → downtime budget (see §5 table) → SLA/SLO/SLI + error budget.
- Durability: acceptable data-loss window (RPO) and recovery time (RTO).
- Fault tolerance: which failures must be survived (node, zone, region, dependency).

**Consistency & correctness**
- Strong vs. eventual consistency per data class; the CAP choice under partition and
  the PACELC latency-vs-consistency choice under normal operation (see §4).
- Ordering, idempotency, exactly/at-least-once delivery where it matters.

**Security, privacy & compliance**
- AuthN/AuthZ model, data sensitivity/classification, encryption in transit/at rest.
- Regulatory regime: GDPR, HIPAA, PCI-DSS, SOC 2, data residency.
- Tenancy/isolation requirements.

**Cost**
- Budget ceiling; cost per request / per user / per inference; infra constraints.

**Environment & platform constraints**
- Device limits: memory, battery, offline/local-first, bandwidth caps.
- On-prem/cloud/region constraints, existing infrastructure commitments.

**Operability & maintainability**
- Observability expectations (metrics/logs/traces), deploy/rollback, team size/skills.
- Usability/accessibility targets where user-facing.

**Delivery constraints**
- Timeline/milestone, MVP boundary, hard external deadlines or dependencies.

## 3. Capacity / back-of-the-envelope estimation

When a constraint or a build-vs-buy/shard-or-not decision depends on scale, do the
arithmetic (don't calculate just to say "it's a lot"). Standard chain:

- **QPS**: `DAU × actions/user/day ÷ 86,400` → average; multiply by peak factor (often 2–10×).
- **Storage**: `writes/day × bytes/write × retention days` (× replication factor).
- **Bandwidth**: `QPS × payload size`, ingress and egress separately.
- **Memory/cache**: working set or hot fraction (e.g. 20% of data) that must fit in RAM.

Anchor estimates with order-of-magnitude latency numbers (Jeff Dean / Norvig):

| Operation | ~Latency |
|---|---|
| L1 cache reference | 0.5 ns |
| Main memory reference | 100 ns |
| SSD random read | 150 µs |
| Read 1 MB sequentially from memory | 250 µs |
| Round trip within same datacenter | 500 µs |
| Read 1 MB from SSD | 1 ms |
| Disk seek | 10 ms |
| Round trip CA ↔ Netherlands | ~150 ms |

Implication: a cross-region round trip (~150 ms) alone blows a 100 ms budget — so a
100 ms recommendation must serve from a local cache/precomputed store, not a remote DB.

## 4. Trade-offs to surface

Constraints conflict; a good design names the conflict and the chosen side.

- **CAP**: under a network partition, choose consistency *or* availability.
- **PACELC**: even without partitions, choose lower latency *or* stronger consistency.
- **Sensitivity points** (ATAM): a decision that strongly affects one quality attribute.
- **Trade-off points** (ATAM): a decision that improves one attribute at another's expense
  (e.g. caching improves latency, weakens consistency). Record these explicitly.

## 5. Making constraints measurable

Two complementary forms — use whichever fits the audience:

**Quality-attribute scenario (ATAM six-part)** — precise and testable:
`source → stimulus → artifact → environment → response → response measure`.
e.g. *"When (stimulus) a user requests recommendations (source: client) under peak
load (environment) the recommender (artifact) returns a ranked list (response) within
100 ms at p95 (response measure)."*

**SLI / SLO / SLA (Google SRE)** — for run-time targets:
- **SLI**: the measured quantity (e.g. proportion of requests < 100 ms).
- **SLO**: the target for that SLI (e.g. 99% of requests < 100 ms over 28 days).
- **SLA**: the contractual consequence of missing it. The gap from 100% is the **error budget**.

Every constraint should reduce to a SMART success criterion (`smart-criteria-rubric.md`):
named operation, metric, target, condition, validation method.

## 6. Availability / downtime reference

| Availability | Downtime / year | Downtime / month |
|---|---|---|
| 99% ("two nines") | 3.65 days | 7.2 hours |
| 99.9% | 8.77 hours | 43.8 minutes |
| 99.99% | 52.6 minutes | 4.38 minutes |
| 99.999% | 5.26 minutes | 26.3 seconds |

## Sources

- Alex Xu, *System Design Interview* (ByteByteGo) — 4-step framework; functional vs non-functional; back-of-the-envelope.
- *The System Design Primer* (Donne Martin) — use cases, constraints & assumptions; capacity estimation.
- Hello Interview, *System Design in a Hurry* — quantified non-functional requirements; 8 NFR categories.
- ISO/IEC 25010 (SQuaRE) — eight software product quality characteristics (NFR taxonomy).
- SEI, *Architecture Tradeoff Analysis Method (ATAM)* — quality-attribute scenarios, utility trees, sensitivity & trade-off points.
- Google, *Site Reliability Engineering* — SLI/SLO/SLA and error budgets.
- Martin Kleppmann, *Designing Data-Intensive Applications* — reliability, scalability, maintainability; load parameters; tail latency percentiles.
- CAP theorem (Brewer) and PACELC (Abadi) — consistency/availability/latency trade-offs.
- Jeff Dean / Peter Norvig — "Latency Numbers Every Programmer Should Know."
