# adhd-agent

You ask an AI to fix a bug. Forty minutes later it has rewritten three files, added a new abstraction, "improved" your tests, and the original bug is still there.

This is the discipline file that stops that.

## The two failure modes

AI-assisted coding fails two ways:

- **It leaves the task.** *"While I'm here, let me also clean up…"*
- **It over-builds inside the task.** 50 lines of speculative abstraction for a 3-line problem.

`adhd-agent` fixes the first. Pair it with Karpathy's behavioral guidelines (the `karpathy-guidelines` skill, available under `andrej-karpathy-skills` in oh-my-claudecode) to fix the second. Two skills, two axes, two leaks plugged.

## The protocol — three modes you and the agent both name

```
SCOUT  →  exploration allowed, no edits, ~15 min time-box
LOCKED →  one task, one deliverable sentence, no surprises
DONE   →  merged PR (or named-branch commit landing somewhere stable)
```

The agent says them out loud. You say them out loud. When either side drifts, the other names it.

## The reviewer test (this is the whole game)

While LOCKED, every mid-task observation gets one question: **would a reviewer of this PR be surprised by this change?**

- **No** — just do it. Typo, missing import, one-line obvious adjacent fix. Bundle it. Mention under "Also fixed:" in the PR body so it's visible, not buried.
- **Yes** — drift log it. New feature, unrelated refactor, scope creep. Goes to `docs/ADHD-DRIFT-LOG.md` (default) or a GitHub issue labeled `adhd-drift-log` (promotion).

No bureaucracy for good engineering. No silent scope creep.

### What that looks like

```
You:    /adhd-agent
Agent:  Active. Scout or lock?
You:    fix the empty-email crash in src/auth/login.ts
Agent:  Locked. Done = src/auth/login.ts rejects empty strings under test.

[mid-task]
Agent:  Fixed a typo on line 78 along the way (one-line, related).
        The helper module is undocumented — bigger lift, that one's
        a drift-log unless you want it bundled?
You:    just the bug
Agent:  Logged: docs/ADHD-DRIFT-LOG.md. Back to validation.

[later]
You:    PR's merged
Agent:  Done. Drift log has 1 item from this session:
        - undocumented helper module
        Want that as the next lock?
```

Six lines and you understand the whole protocol.

## Install

One line. Detects every AI assistant on your machine and mirrors the rule into each.

```bash
curl -fsSL https://raw.githubusercontent.com/amponce/adhd-agent/main/install.sh | bash
```

Then in any session:

```
/adhd-agent              # turn it on for this session
/adhd-agent disable      # turn it off mid-session
```

Off by default. On for the rest of the session once you invoke it. New session starts off.

## What gets installed where

| Runtime | Path |
|---|---|
| Claude Code | `~/.claude/skills/adhd-agent/SKILL.md` |
| Codex CLI | `~/.codex/skills/adhd-agent/SKILL.md` |
| Hermes Agent | `~/.hermes/skills/adhd-agent/SKILL.md` |
| Cursor | helper at `~/.local/bin/bootstrap-adhd-agent` |

Runtimes you don't have are skipped silently. Re-run the script any time to refresh from `main`.

### Cursor needs two steps

1. From any project where you want the rule active: `bootstrap-adhd-agent` — drops `.cursor/rules/adhd-agent.mdc`.
2. Once: paste `SKILL.md` into **Cursor → Settings → Rules → User Rules** for global coverage in every project.

### Hermes on a remote box

SSH in and run the same one-liner. Or `scp SKILL.md` into `~/.hermes/skills/adhd-agent/` directly. Skills hot-reload — usually no restart needed.

## Make it yours

This is a template. The whole point is for you to bend it to your own workflow.

```bash
gh repo fork amponce/adhd-agent --clone
cd adhd-agent
# edit SKILL.md — change the modes, the capture mechanism, the success gate, the tone
./install.sh
```

If you find a shape other people would benefit from, PR back.

## Why it works (when it works)

It doesn't enforce anything. It can't — it's a markdown file the model reads. What it does is give *both sides* of the conversation the same words. Once `LOCKED` and `drift log` and `Done = …` are in your shared vocabulary, drift becomes nameable. And once it's nameable, it stops being silent.

## License

MIT.
