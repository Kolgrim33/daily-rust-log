#!/usr/bin/env sh
# Run by OpenClaw every 10 minutes. On the first run of each day it picks
# 1-4 random times between 08:00 and 22:59 (local). Each time a picked slot
# passes, it dispatches the streak workflow once, which makes one commit.
#
#   trigger.sh            normal (scheduled) mode
#   trigger.sh --now      dispatch immediately, ignoring the slots
#   trigger.sh --show     print today's plan
set -eu
REPO="Kolgrim33/daily-rust-log"
STATE="${XDG_STATE_HOME:-$HOME/.local/state}/streak"
TODAY=$(date +%F)
PLAN="$STATE/$TODAY.plan"
DONE="$STATE/$TODAY.done"
mkdir -p "$STATE"

rand() { od -An -N2 -tu2 /dev/urandom | tr -d ' '; }   # 0..65535

dispatch() {
  gh workflow run streak.yml -R "$REPO" -f note="${1:-}"
  echo "dispatched streak.yml on $REPO"
}

if [ "${1:-}" = "--now" ]; then dispatch "${2:-manual}"; exit 0; fi

if [ ! -f "$PLAN" ]; then
  n=$(( $(rand) % 4 + 1 ))
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

dispatch "random slot $((done_n + 1)) at $(date +%H:%M)"
echo $((done_n + 1)) > "$DONE"
