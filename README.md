# daily-rust-log

[![GitHub Streak](https://streak-stats.demolab.com/?user=Kolgrim33&theme=dark&background=0D1117&border=30363D&stroke=30363D&ring=E8B730&fire=E8B730&currStreakNum=F1E9D2&sideNums=F1E9D2&currStreakLabel=E8B730&sideLabels=A9AECB&dates=7C8CC4)](https://github.com/Kolgrim33/daily-rust-log)

A daily Rust log, written and committed by a small Rust binary (`streak`) running in GitHub Actions.

Each day gets an entry in `log/YYYY-MM.md` with a Rust tip and checkpoint commits, targeting **500 commits per day** by default (overridable via `STREAK_MAX`).

## How it runs

1. **GitHub cron (cloud schedule).** The workflow runs automatically across 6 UTC schedule slots (`01:23`, `05:23`, `09:23`, `13:23`, `17:23`, and `20:23` UTC). The first 5 slots commit 100 each (500 total), and the `20:23` UTC slot tops up any missed runs up to 500 — pushing in batches of 100 commits at a time.
2. **OpenClaw / manual dispatch.** An OpenClaw automation runs `openclaw/trigger.sh` every 10 minutes, picking 5 random times between 08:00 and 22:59 and dispatching 100 commits per slot. `trigger.sh --show` prints today's plan; `trigger.sh --now` dispatches right away and tops up to 500.

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

Environment variables: `STREAK_NOTE` (the note), `STREAK_MAX` (daily commit cap, default `500`), `STREAK_COUNT` (commits per invocation, default `1`), `STREAK_DATE` (override the date, `YYYY-MM-DD`).

## Note

Commits only count toward the contribution graph if the author email is linked to the account. The workflow commits as `252664188+Kolgrim33@users.noreply.github.com` for that reason.
