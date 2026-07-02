#!/usr/bin/env bash
# Beaver skill evaluation harness — headless A/B runs (baseline vs treatment).
#
# Usage:
#   evals/run.sh <skill> <case> <mode> [prompt-file]
#     skill        any skill under skills/ (e.g. designing-systems, crafting-code)
#     case         a case directory under evals/<skill>/  (e.g. D1-smart-parking)
#     mode         baseline | trigger | treatment
#     prompt-file  optional prompt filename in the case dir (default: prompt.txt)
#
# Modes:
#   baseline   --safe-mode → no custom skills at all (the agent's natural behavior).
#   trigger    beaver loaded but NOT forced → does the skill fire on its own?
#   treatment  beaver loaded AND forced → the skill's behavior/output when used.
#
# Notes:
#   * --plugin-dir does NOT load under --safe-mode, so baseline uses --safe-mode
#     (which also suppresses the user's ~/.claude/skills), and trigger/treatment
#     load beaver via --plugin-dir with --setting-sources project,local.
#   * Runs in an isolated temp workspace so a run can freely write docs/.
#   * Multi-turn: if the case has followup.txt, turn 2 resumes the same session.
#   * Output format is stream-json, so we can score triggering from the TRANSCRIPT
#     (did the model actually invoke the Skill?) instead of guessing from the
#     output's shape. Each turn writes: turnN.stream.jsonl (raw), turnN.txt (final
#     answer), and — for trigger/treatment — loaded-turnN.txt ("yes: <evidence>" | "no").
#
# Env: MODEL (default claude-sonnet-5). Use the SAME model for both sides of a pair.
set -euo pipefail

BEAVER="$(cd "$(dirname "$0")/.." && pwd)"
SKILL="${1:?usage: run.sh <skill> <case> <mode> [prompt-file]}"
CASE="${2:?case}"; MODE="${3:?mode}"; PF="${4:-prompt.txt}"
MODEL="${MODEL:-claude-sonnet-5}"
CDIR="$BEAVER/evals/$SKILL/$CASE"
[ -f "$CDIR/$PF" ] || { echo "missing prompt: $CDIR/$PF" >&2; exit 1; }

TAG="$MODE"; [ "$PF" = prompt.txt ] || TAG="$MODE-${PF%.txt}"
OUT="$CDIR/out/$TAG"; mkdir -p "$OUT"
WORK="$(mktemp -d)"; trap 'rm -rf "$WORK"' EXIT
# seed the workspace before turn 1 (a starter project, so "build" behavior is observable)
[ -d "$CDIR/seed" ] && cp -R "$CDIR/seed/." "$WORK/"

COMMON=(--print --output-format stream-json --verbose --model "$MODEL" --dangerously-skip-permissions --add-dir "$WORK")
case "$MODE" in
  baseline)  FLAGS=(--safe-mode) ;;
  trigger)   FLAGS=(--setting-sources project,local --plugin-dir "$BEAVER") ;;
  treatment) FLAGS=(--setting-sources project,local --plugin-dir "$BEAVER"
               --append-system-prompt "You have the beaver skill '$SKILL' available. Use it to handle this task, following it fully.") ;;
  *) echo "bad mode: $MODE (baseline|trigger|treatment)" >&2; exit 1 ;;
esac

# extract the final answer from a stream-json transcript
result () {
python3 - "$1" <<'PY'
import json,sys
res=""
for line in open(sys.argv[1],encoding="utf-8",errors="ignore"):
    line=line.strip()
    if not line: continue
    try: o=json.loads(line)
    except: continue
    if o.get("type")=="result" and isinstance(o.get("result"),str): res=o["result"]
print(res)
PY
}

# did the transcript actually invoke the beaver Skill (or read its SKILL.md)?  hard trigger signal
skill_loaded () {
python3 - "$1" "$2" <<'PY'
import json,sys
stream,skill=sys.argv[1],sys.argv[2]
ev=None
for line in open(stream,encoding="utf-8",errors="ignore"):
    line=line.strip()
    if not line: continue
    try: o=json.loads(line)
    except: continue
    m=o.get("message") if isinstance(o.get("message"),dict) else o
    c=m.get("content") if isinstance(m,dict) else None
    if not isinstance(c,list): continue
    for b in c:
        if not (isinstance(b,dict) and b.get("type")=="tool_use"): continue
        inp=json.dumps(b.get("input",{}))
        if b.get("name")=="Skill" and skill in inp: ev="Skill(%s)"%skill; break
        if b.get("name") in ("Read","Bash","Grep") and skill+"/SKILL.md" in inp: ev="read %s/SKILL.md"%skill; break
    if ev: break
print("yes: "+ev if ev else "no")
PY
}

SID="$(uuidgen)"
echo "[$SKILL/$CASE] mode=$TAG model=$MODEL"

# turn 1
( cd "$WORK" && claude "${COMMON[@]}" "${FLAGS[@]}" --session-id "$SID" "$(cat "$CDIR/$PF")" ) > "$OUT/turn1.stream.jsonl"
result "$OUT/turn1.stream.jsonl" > "$OUT/turn1.txt"
if [ "$MODE" != baseline ]; then
  skill_loaded "$OUT/turn1.stream.jsonl" "$SKILL" > "$OUT/loaded-turn1.txt"
  echo "  turn1 skill loaded: $(cat "$OUT/loaded-turn1.txt")"
fi
[ -d "$WORK/docs" ] && { rm -rf "$OUT/docs"; cp -R "$WORK/docs" "$OUT/docs"; }

# turn 2 (multi-turn), if present — skipped in trigger mode (we only test firing there)
if [ -f "$CDIR/followup.txt" ] && [ "$MODE" != trigger ]; then
  [ -d "$CDIR/seed-followup" ] && cp -R "$CDIR/seed-followup/." "$WORK/"
  ( cd "$WORK" && claude "${COMMON[@]}" "${FLAGS[@]}" --resume "$SID" "$(cat "$CDIR/followup.txt")" ) > "$OUT/turn2.stream.jsonl"
  result "$OUT/turn2.stream.jsonl" > "$OUT/turn2.txt"
  [ "$MODE" != baseline ] && skill_loaded "$OUT/turn2.stream.jsonl" "$SKILL" > "$OUT/loaded-turn2.txt"
  [ -d "$WORK/docs" ] && { rm -rf "$OUT/docs-after"; cp -R "$WORK/docs" "$OUT/docs-after"; }
fi
echo "→ $OUT"
