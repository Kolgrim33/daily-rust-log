# daily-rust-log

[![GitHub Streak](https://streak-stats.demolab.com/?user=Kolgrim33&theme=dark&background=0D1117&border=30363D&stroke=30363D&ring=E8B730&fire=E8B730&currStreakNum=F1E9D2&sideNums=F1E9D2&currStreakLabel=E8B730&sideLabels=A9AECB&dates=7C8CC4)](https://github.com/Kolgrim33/daily-rust-log)

A daily Rust log, written and committed by a small Rust binary (`streak`) running in GitHub Actions.

Each day gets one entry in `log/YYYY-MM.md` with a Rust tip. Each run of the binary makes one commit, with a cap of 4 per day.

## How it runs

1. **OpenClaw (main trigger).** An OpenClaw automation runs `openclaw/trigger.sh` every 10 minutes. On its first run each day the script picks 1 to 4 random times between 08:00 and 22:59, and dispatches the workflow once as each time passes. So both the commit count and the commit times change every day. `trigger.sh --show` prints today's plan; `trigger.sh --now` dispatches right away.
2. **GitHub cron (safety net).** The workflow runs automatically at 4 schedule slots across the day (09:15, 13:30, 17:45, and 22:20 Harare time) up to the daily cap of 4 commits, ensuring multiple contributions even if the PC is off or OpenClaw is paused.

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
