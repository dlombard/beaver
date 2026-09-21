# D3 — grounded support copilot (AI first-class + SRD seed)

Tests: the AI/LLM path in `designing-systems` — retrieval, context budget, vector
store, and evaluation are first-class — plus the SRD seed. This is the case where a
strong baseline is likely to draw "LLM" as a single transform box.

## Baseline expectation (no skill)

A reasonable chatbot architecture: "help-center docs → LLM → answer", maybe a vector
DB named in passing. Usually **no context budget**, no grounding/citation design, no
evaluation story, **no SRD seed**, and the LLM is one box in a pipeline.

## Treatment success criteria

**Turn 1 — Must:**
1. Triggers / is used, and produces the **full** artifact set (principal-engineer
   prompt). Includes `data-and-ml-flow.md` as a first-class artifact.
2. Names the assistant **roles** (in-MVP vs deferred): grounded Q&A over help-center +
   tickets, and draft-reply for the agent. Does not bolt on extra agentic toys with no
   constraint.
3. Retrieval/grounding is a designed subsystem: chunking + provenance, embedding model,
   **vector index in the storage model**, retrieve → ground → generate. The model is
   **not** a single "transform" stage that "reads the docs".
4. States a **context budget** (tokens/turn vs window) and how long tickets/articles
   stay inside it (top-k / map-reduce / refuse-when-too-long) — the raw corpus is not
   handed to the model.
5. **SRD seed**: `SYS-n` shalls for grounded answer, citation, draft-reply, and refuse-
   when-ungrounded; external interfaces (help-center corpus, ticket store, agent UI,
   model provider); qualification approach that includes retrieval + generation eval,
   not only latency.
6. Constraint Register includes answer **latency** (time-to-first-token and/or p95),
   **cost per conversation** (or a labeled assumption), and **data sensitivity** of
   tickets (PII). Building-block table includes a vector/index store tied to a
   constraint.

**Turn 2 (follow-up) — Must:**
7. Revises **only** the empty-retrieval / refuse path (and the SYS-n / component /
   data-flow rows it touches). Does not regenerate the whole design.

**Failure signals:** LLM drawn as one transform with no retrieval layer; no vector
index in storage; no context budget; no SRD seed; writes a full SRD or feature specs;
invents a second chatbot/persona with no constraint; on the follow-up, rewrites
unrelated building blocks.

**Uplift check:** did baseline already treat retrieval, context budget, and citations
as first-class *and* seed the SRD? If not, treatment should.
