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
LOCKED →  one task, one deliverable sentence, drift goes to parking lot
DONE   →  merged PR (or named-branch commit landing somewhere stable)
```

The agent says them out loud. You say them out loud. When either side drifts, the other names it.

### What that looks like

```
You:    /adhd-agent
Agent:  Active. Scout or lock?
You:    fix the empty-email crash in src/auth/login.ts
Agent:  Locked. Done = src/auth/login.ts rejects empty strings under test.

[mid-task]
Agent:  This file has a typo on line 78 and the helper module
        is undocumented. Address either?
You:    no, just the bug
Agent:  Parked both → docs/ADHD-PARKING-LOT.md. Back to validation.

[later]
You:    PR's merged
Agent:  Done. Parking lot has 2 items from this session:
        - typo on line 78
        - undocumented helper module
        Which becomes the next lock?
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

It doesn't enforce anything. It can't — it's a markdown file the model reads. What it does is give *both sides* of the conversation the same words. Once `LOCKED` and `parking lot` and `Done = …` are in your shared vocabulary, drift becomes nameable. And once it's nameable, it stops being silent.

## License

MIT.
