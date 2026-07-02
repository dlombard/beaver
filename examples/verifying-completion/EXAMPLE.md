# Example — verifying-completion

**Skill:** `verifying-completion` · **Grade scale:** see [../README.md](../README.md)

Paste the snippet and the prompt into a fresh session. The skill should trigger on its
own (an "is it done?" / verify-the-build request).

## Prompt

> Our spec for the tasks endpoint says: **AC-1** `POST /tasks` with a title returns
> 201 and the created task; **AC-2** an empty title returns 400; **AC-3** two requests
> carrying the same `Idempotency-Key` header create only one task. Implementation and
> tests below — tests are green, so I think we're done. Verify.
>
> ```python
> # app.py
> from fastapi import FastAPI, HTTPException
> app = FastAPI()
> TASKS = []
>
> @app.post("/tasks", status_code=201)
> def create_task(body: dict):
>     title = (body.get("title") or "").strip()
>     if not title:
>         raise HTTPException(status_code=400, detail="title required")
>     task = {"id": len(TASKS) + 1, "title": title}
>     TASKS.append(task)
>     return task
> ```
>
> ```python
> # test_app.py — all green
> def test_create(client):
>     assert client.post("/tasks", json={"title": "a"}).status_code == 201
> def test_empty_title(client):
>     assert client.post("/tasks", json={"title": ""}).status_code == 400
> ```

## What the skill should do

Assemble the checklist from the spec (all three ACs — not from the code), demonstrate
each with executed evidence, and catch that **AC-3 is missing**: nothing reads
`Idempotency-Key`, no test covers it, and "tests are green" only proves AC-1/AC-2.
Verdict: **not done**.

## Reference — what good looks like

- **Checklist from the requirements**: three rows (AC-1, AC-2, AC-3) with the spec as
  source — the checklist is not shrunk to what the code implements.
- **Evidence, not code-reading**: runs the tests and/or exercises the endpoint to
  verify AC-1 and AC-2; if the environment truly can't execute, marks them
  `blocked`/`inspection` with the reason — never a silent pass from reading.
- **AC-3 named `missing`** (not "broken"): duplicate `Idempotency-Key` requests would
  create two tasks; no code path or test touches the header. "Tests pass" is exposed
  as covering only 2 of 3 criteria.
- **Traceability report** with a per-item verdict, the gap (AC-3, missing, severity),
  and what closes it: implement key handling + a duplicate-key test.
- **Verdict `not done`** — partial credit lives in the gap list, not the verdict — and
  no fixing: the skill reports; it doesn't patch the code unasked.

## Rubric

**Must (all required to pass):**
1. Builds the checklist **from the spec** — all three ACs appear, each with a verdict.
2. Backs AC-1/AC-2 verdicts with **executed evidence** (test run or endpoint
   exercised), or explicitly marks them `blocked`/`inspection` with the reason.
3. Flags **AC-3 as missing**, with the failure mode named and what would close it.
4. Final verdict is **not done**, despite green tests.

**Failure signals (any ⇒ fail):**
- Declares it done because the tests pass.
- Passes any item from code-reading alone while execution was possible, or without
  marking the substitution.
- Drops or waters down AC-3 because no test exists for it.
- Rewrites the code to add idempotency instead of reporting the gap.
- Drifts into style/architecture review.

**Grade:** ✅ Pass = all Musts, no signals · ⚠️ Partial = minor gaps only · ❌ Fail =
any Must missed or any signal present.
