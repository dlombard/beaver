# AI / LLM System Design Rubric

Read this whenever the system uses an LLM, generative model, embeddings, or an
"AI assistant / agent / copilot" is part of the product. For these systems the
model is **the spine of the design, not a box in a pipeline**. A design that
draws the LLM as a single "transform" stage is incomplete by default.

The failure mode this rubric exists to prevent: treating "AI" as one component,
omitting the layer that makes a model useful over real data, and assuming the
model can simply be handed the full corpus.

## Contents

1. Name the assistant's role(s)
2. Retrieval / grounding layer (usually the biggest gap)
3. Context budget & the long-context problem
4. Generation orchestration
5. Interactive assistant loop
6. Agentic surface
7. Model & provider boundary
8. Evaluation
9. AI-specific quality attributes
10. AI-specific risks
- Where this lands in the artifacts

## 1. Name the assistant's role(s)

Before architecture, state **what the AI actually is** in the product. Most
assistants are several roles over one substrate. Make each explicit and mark
which are in MVP vs deferred. Common decomposition:

- **Transformer** — batch/ingest-time generation (summaries, extraction,
  artifacts derived from content).
- **Tutor / Q&A** — on-demand grounded conversation over the user's data.
- **Coach / Agent** — goal-driven, multi-step, tool-using behavior (acts, not
  just answers).

A goal like "the assistant helps the user" is invalid. Tie each role to a
behavior, the data it reads, and how its quality is measured.

## 2. Retrieval / grounding layer (usually the biggest gap)

If the model must reason over user data, documents, or history, there is a
retrieval subsystem — design it explicitly as the interface between storage and
the model. Do not let "the model reads the data" stand in for it.

- **Indexing**: how source content becomes retrievable — chunking strategy and
  boundaries, what metadata each chunk carries (source id, offset/timestamp for
  citation), and the **embedding model**.
- **Index store**: the **vector index** and where it lives (dedicated vector DB,
  `sqlite-vec`/`pgvector` alongside relational data, etc.). This belongs in the
  **storage model**, not as an afterthought.
- **Retrieval**: query → embed → retrieve (vector, keyword/FTS, or **hybrid**) →
  top-k. State how relevance is filtered and ranked.
- **Grounding & citations**: retrieved chunks carry provenance so answers cite
  sources and clients can deep-link back to the exact location/timestamp.

## 3. Context budget & the long-context problem

State the model's context window explicitly and design around it. **The model
rarely sees the raw full corpus.** A long document/transcript/history exceeds a
small (often on-device/quantized) context window, so:

- Define the **per-turn context budget** (system + retrieved + history + output).
- Show how a prompt stays within budget: retrieval top-k, truncation,
  summary-of-history, sliding windows.
- Treat context budget as a **quality attribute** with a target, not prose.

## 4. Generation orchestration

The model is usually an orchestrated chain, not one call:

- **Batch transformation** over long content: **map-reduce / hierarchical** —
  summarize chunks → reduce to an outline/concepts → generate each artifact from
  only its relevant chunks. This is what lets a small model handle large input.
- **Interactive turn**: assemble bounded prompt → generate → **stream** to client
  (SSE/websocket), with token/latency expectations.
- Note where outputs are validated, retried, or constrained (schemas, guards).

## 5. Interactive assistant loop (if conversational)

An assistant that can't be talked to is a batch job. Design:

- **Sessions and turns**, message history, per-turn context assembly.
- **Streaming** response path and cancellation.
- State ownership: what's persisted (chats, messages, citations) vs ephemeral.

## 6. Agentic surface (if the assistant acts)

"Quiz me," "grade this," "do X" imply **tools**, not just text:

- Tool/function inventory, their contracts, and which the model may call.
- Orchestration loop (plan → call tool → observe → continue) and its bounds
  (max steps, cost ceiling, approval points for side effects).

## 7. Model & provider boundary

- On-device vs hosted vs hybrid, and the tradeoff (privacy/cost/quality/latency).
- Which models exist: generation LLM, **embedding model**, plus any rerankers,
  ASR, vision, etc. Each is a real dependency with its own footprint.
- Minimum-hardware / minimum-cost story when running multiple models.

## 8. Evaluation

LLM output quality is unverifiable without an eval story. Name it even if
deferred:

- **Retrieval eval** (is the right context found?) and **generation eval**
  (faithfulness/grounding, helpfulness) — golden sets, rubric scoring, or human
  review.
- Regression strategy as prompts/models change.

## 9. AI-specific quality attributes

Add these to Quality Attributes when AI is core:

- **Grounding / faithfulness**: answers traceable to retrieved sources;
  hallucination tolerance.
- **Context budget** (feasibility): tokens assembled per turn vs the model's window.
- **Token / cost budget** (economics + throughput): tokens × price per operation;
  aggregate spend at target scale; provider **rate limits (TPM/RPM)**; tokens/sec
  throughput. Distinct from context budget — a prompt can fit the window yet be too
  expensive or rate-limited at scale.
- **Retrieval quality**: recall/precision target or proxy.
- **Inference latency / on-device footprint**: time-to-first-token, memory, model size.
- **Streaming latency**: time-to-first-token and tokens/sec.
- **Safety**: prompt-injection from retrieved/user content, PII in prompts/logs.

## 10. AI-specific risks

- Hallucination / ungrounded output reaching the user.
- Context-window overflow silently truncating critical input.
- Prompt injection via retrieved or user-supplied content.
- Embedding/model drift when models or chunking change (re-index cost).
- Cost or latency blowups from large contexts or agent loops.
- Eval gap: no way to tell if a change made quality worse.

## Where this lands in the artifacts

- Assistant roles → Product Brief and a dedicated "What the assistant is" section.
- Retrieval/generation/embedding → first-class **components** in the inventory and
  in the **storage model** (vector index), not only in Data/ML Flow.
- Context budget, retrieval quality, grounding → **Quality Attributes** with targets.
- The Data and ML Flow template section captures the end-to-end mechanics.
