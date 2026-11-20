#!/usr/bin/env sh
# Run by OpenClaw every 10 minutes. On the first run of each day it picks
# 5 random times between 08:00 and 22:59 (local). Each time a picked slot
# passes, it dispatches the streak workflow for 100 commits (500/day total).
#
#   trigger.sh                    normal (scheduled) mode
#   trigger.sh --now [note] [n]   dispatch immediately (n defaults to 0 = top up to 500)
#   trigger.sh --show             print today's plan
set -eu
REPO="Kolgrim33/daily-rust-log"
STATE="${XDG_STATE_HOME:-$HOME/.local/state}/streak"
TODAY=$(date +%F)
PLAN="$STATE/$TODAY.plan"
DONE="$STATE/$TODAY.done"
mkdir -p "$STATE"

rand() { od -An -N2 -tu2 /dev/urandom | tr -d ' '; }   # 0..65535

dispatch() {
  gh workflow run streak.yml -R "$REPO" -f note="${1:-}" -f count="${2:-100}"
  echo "dispatched streak.yml on $REPO (count=${2:-100})"
}

if [ "${1:-}" = "--now" ]; then dispatch "${2:-manual}" "${3:-0}"; exit 0; fi

if [ ! -f "$PLAN" ]; then
  n=5
  i=0
  while [ $i -lt $n ]; do echo $(( 480 + $(rand) % 900 )); i=$((i + 1)); done | sort -n > "$PLAN"
  echo 0 > "$DONE"
  find "$STATE" -name '*.plan' -mtime +7 -delete 2>/dev/null || true
  find "$STATE" -name '*.done' -mtime +7 -delete 2>/dev/null || true
fi

if [ "${1:-}" = "--show" ]; then
  echo "plan for $TODAY ($(cat "$DONE") done):"
  while read -r m; do printf '  %02d:%02d\n' $((m / 60)) $((m % 60)); done < "$PLAN"
  exit 0
fi

now=$(( $(date +%-H) * 60 + $(date +%-M) ))
due=$(awk -v now="$now" '$1 <= now' "$PLAN" | wc -l)
done_n=$(cat "$DONE")

if [ "$due" -le "$done_n" ]; then
  echo "nothing due ($done_n/$(wc -l < "$PLAN") done)"
  exit 0
fi

dispatch "random slot $((done_n + 1)) at $(date +%H:%M)" 100
echo $((done_n + 1)) > "$DONE"
