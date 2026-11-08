#!/usr/bin/env sh
# Run daily by an OpenClaw automation. Dispatches the streak workflow on GitHub.
# Optional: pass a note as $1, e.g. what you worked on today.
set -eu
REPO="Kolgrim33/daily-rust-log"
NOTE="${1:-triggered by OpenClaw on $(hostname) at $(date -u +%H:%MZ)}"
gh workflow run streak.yml -R "$REPO" -f note="$NOTE"
echo "dispatched streak.yml on $REPO"
