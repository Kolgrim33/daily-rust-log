# daily-rust-log

[![GitHub Streak](https://streak-stats.demolab.com/?user=Kolgrim33&theme=dark&background=0D1117&border=30363D&stroke=30363D&ring=E8B730&fire=E8B730&currStreakNum=F1E9D2&sideNums=F1E9D2&currStreakLabel=E8B730&sideLabels=A9AECB&dates=7C8CC4)](https://github.com/Kolgrim33/daily-rust-log)

A daily Rust log, written and committed by a small Rust binary (`streak`) running in GitHub Actions.

Each day gets an entry in `log/YYYY-MM.md` with a Rust tip and checkpoint commits, targeting **1000 commits per day** across **5 daily runs** (overridable via `STREAK_MAX`).

## How it runs

1. **GitHub cron (cloud schedule).** The workflow runs automatically 5 times a day across UTC schedule slots (`02:23`, `07:23`, `12:23`, `16:23`, and `20:23` UTC). The first 4 slots commit 200 each (800 total), and the `20:23` UTC slot commits the final 200 and tops up any missed runs up to 1000 — pushing in batches of 100 commits at a time.
2. **OpenClaw / manual dispatch.** An OpenClaw automation runs `openclaw/trigger.sh` every 10 minutes, picking 5 random times between 08:00 and 22:59 and dispatching 200 commits per slot (1000/day total). `trigger.sh --show` prints today's plan; `trigger.sh --now` dispatches right away and tops up to 1000.

## Set up the OpenClaw automation

```sh
openclaw cron add --name "GitHub streak" --cron "*/10 * * * *" --tz Africa/Harare \
  --command "$HOME/Documents/daily-rust-log/openclaw/trigger.sh"
```

## Run locally

```sh
cargo test
cargo run -- --dry-run --count 10 --note "what I did today"
```

Environment variables: `STREAK_NOTE` (the note), `STREAK_MAX` (daily commit cap, default `1000`), `STREAK_COUNT` (commits per invocation, default `1`), `STREAK_DATE` (override the date, `YYYY-MM-DD`).

## Note

Commits only count toward the contribution graph if the author email is linked to the account. The workflow commits as `252664188+Kolgrim33@users.noreply.github.com` for that reason.
