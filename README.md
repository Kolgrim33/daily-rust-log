# daily-rust-log

A daily Rust log, written and committed by a small Rust binary (`streak`) running in GitHub Actions.

Each day gets one entry in `log/YYYY-MM.md` with a Rust tip. Each run of the binary makes one commit, with a cap of 4 per day.

## How it runs

1. **OpenClaw (main trigger).** An OpenClaw automation runs `openclaw/trigger.sh` every 10 minutes. On its first run each day the script picks 1 to 4 random times between 08:00 and 22:59, and dispatches the workflow once as each time passes. So both the commit count and the commit times change every day. `trigger.sh --show` prints today's plan; `trigger.sh --now` dispatches right away.
2. **GitHub cron (fallback).** The workflow also runs at 21:23 UTC with `--if-empty`, which only commits if the day has no commits yet (for days the PC is off).

## Set up the OpenClaw automation

```sh
openclaw cron add --name "GitHub streak" --cron "*/10 * * * *" --tz Africa/Harare \
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
