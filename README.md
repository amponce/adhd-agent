# adhd-agent

You ask an AI to fix a bug. Forty minutes later it's rewritten three files, added a new abstraction, "improved" your tests, and the original bug is still there.

This is the discipline file that stops that.

## Four behaviors

Modeled on Karpathy's guidelines. Four words, four principles:

- **Simple** — asks *"what does done look like?"* and writes the answer down before touching anything.
- **Smart** — bundles obvious adjacent fixes (typos, missing imports). Surfaces surprises.
- **Verify** — won't call it done until it's actually done (merged PR or committed branch).
- **Remind** — nudges you when you drift. *"Hey, that's outside what we said done was. Stick or pivot?"* Then waits for you.

It doesn't block. It doesn't lecture. It's a partner you can override.

## What it looks like

```
You:    /adhd-agent
You:    fix the empty-email crash in src/auth/login.ts
Agent:  Done = src/auth/login.ts rejects empty strings.

[mid-task]
Agent:  Hey, the helper module's undocumented — that's outside
        what we said done was. Stick or pivot?
You:    stick
Agent:  Logged → docs/ADHD-DRIFT-LOG.md. Back to validation.

[later]
You:    PR's merged
Agent:  Done. One thing in the drift log: undocumented helper
        module. Want that as the next task?
```

## Pair with Karpathy

These two skills together cover both AI failure modes:

- **adhd-agent** keeps you from *leaving* the task.
- **karpathy-guidelines** (`andrej-karpathy-skills` in oh-my-claudecode) keeps you from *over-building inside* the task.

Install both. They're designed to stack.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/amponce/adhd-agent/main/install.sh | bash
```

Drops `SKILL.md` into every AI assistant on your machine. Runtimes you don't have are skipped silently.

Targets: `~/.claude/skills/`, `~/.codex/skills/`, `~/.hermes/skills/`, plus a `bootstrap-adhd-agent` helper for Cursor projects.

Use in a session:

```
/adhd-agent              # turn it on
/adhd-agent disable      # turn it off
```

### Cursor

`bootstrap-adhd-agent` in any project drops the rule into `.cursor/rules/`. For global coverage, paste `SKILL.md` into Cursor → Settings → Rules → User Rules once.

### Hermes on a remote server

SSH in, run the same one-liner.

## Make it yours

It's a template. Fork, edit `SKILL.md` to match your workflow, re-run your fork's `install.sh`. PR back if you find something other people would benefit from.

## License

MIT.
