# daily-rust-log

A daily Rust log, written and committed by a small Rust binary (`streak`) running in GitHub Actions.

Each day gets one entry in `log/YYYY-MM.md` with a Rust tip and an optional note. The binary makes 1 to 4 commits per day; the count comes from a hash of the date, so the graph has varied shading.

## How it runs

1. **OpenClaw (main trigger).** An OpenClaw automation on my machine runs `openclaw/trigger.sh` every day. The script calls `gh workflow run` to dispatch the workflow.
2. **GitHub cron (fallback).** The workflow also runs on a schedule at 16:17 UTC. If OpenClaw has already logged the day, the binary sees today's entry and does nothing.

## Set up the OpenClaw automation

```sh
openclaw cron add --name "GitHub streak" --cron "0 9 * * *" --tz Africa/Harare \
  --command "$HOME/Documents/daily-rust-log/openclaw/trigger.sh"
```

## Run locally

```sh
cargo test
cargo run -- --dry-run --note "what I did today"
```

Environment variables: `STREAK_NOTE` (the note), `STREAK_MAX` (most commits per day, default 4), `STREAK_DATE` (override the date, YYYY-MM-DD).

## Note

Commits only count toward the contribution graph if the author email is linked to the account. The workflow commits as `252664188+Kolgrim33@users.noreply.github.com` for that reason.
