---
name: adhd-agent
description: Keep the user on-task without killing exploration. Three modes — SCOUT, LOCKED, DONE. Bundle small adjacent fixes; log true deviations. Adaptive — works with or without a PR workflow.
trigger: /adhd-agent
---

# ADHD Agent

## Activation

This protocol is **opt-in per session.**

- User types `/adhd-agent` → protocol is **active** from this point onward.
- User types `/adhd-agent disable` (or clearly asks to drop the protocol) → protocol is **inactive** for the rest of the session.
- New session starts **inactive** until the user activates it.

When inactive, ignore everything below — work normally. When active, follow the modes strictly and use the vocabulary out loud.

If invoked mid-task without a stated deliverable, ask: *"Scout or lock? If lock, what's the Done sentence?"*

## What it is

A shared protocol between the user and any agent helping them (Claude Code, Codex, Hermes, Cursor). The vocabulary is the contract: *are you scouting or locked? is that drift log? is this done done?* The skill doesn't enforce itself — it gives both sides a shared language so drift is namable.

Pair with Karpathy's guidelines (`andrej-karpathy-skills:karpathy-guidelines`) — Karpathy keeps you from over-engineering inside the task; this skill keeps you from leaving the task.

The skill defines three modes. You move through them sequentially. You can swap a locked task. You cannot skip phases.

## 1. SCOUT — exploration allowed, no edits

Use when the task is genuinely unclear. The cost of scouting is small; the cost of locking the wrong task is huge.

- Read code, run analysis, search the repo, ask questions, run read-only tool calls.
- **No file edits** beyond scratch notes. No commits.
- Time-box ~15 minutes by default. Surface the timer aloud: "Scouting for 15 minutes."
- End with either:
  - **Lock a real task** (move to LOCKED).
  - **Abandon** (no task, no shame, no edits). Output: `Scouted but won't pursue: <one-line why>.`

If you find yourself wanting to edit in SCOUT, stop and either lock or admit you're really in LOCKED already.

## 2. LOCKED — one task, one PR, no surprises

When the task is clear, write the deliverable sentence:

```
Done = <concrete outcome>.
```

Concrete examples: `Done = PR #42 merged into main`, `Done = src/auth/login.ts validates empty email`, `Done = relay-api restarts cleanly under the new env config`. Vague is not allowed — refuse to lock on "clean up auth."

Once locked, every changed line should pass the **reviewer test.**

### The reviewer test

*Would a reviewer of this PR be surprised by this change?*

This is the test you apply to every adjacent observation that comes up mid-task.

- **No surprise — just do it.** Typos. Missing imports. Dead semicolons. A one-line rename that obviously belongs with the change. A docstring that should exist on the function you're already touching. These are good engineering. Fix them inline. Mention them in the PR body under "Also fixed:" so the reviewer sees them, not buried.
- **Surprise — drift log it.** A new feature. A refactor of an unrelated module. Touching a file the PR doesn't otherwise need. "While I'm here let me also redo the styling." These get logged, not bundled.

Don't bureaucratize good engineering. Don't smuggle scope creep through under the wash of "just one more thing."

Hard calls? Lean toward bundling if a reviewer would expect it given the locked deliverable. Lean toward the drift log if they wouldn't. If you genuinely cannot tell, ask the user.

### Where the drift log lives

Default to markdown — GitHub issues are an **explicit promotion**, not the default. Most observations don't deserve project-state tracking.

**Default — append to `docs/ADHD-DRIFT-LOG.md`** in cwd (create file + `docs/` dir if missing):

```
- [YYYY-MM-DD] <one-line idea> (raised during: <locked task>)
```

**Promote to GitHub issue** only when the idea is concrete enough to triage as real work:

```
gh issue create \
  --title "<one-line idea>" \
  --body  "Raised during: <locked task>. Promoted from adhd drift log." \
  --label adhd-drift-log
```

Tell the user where it landed: `Logged: docs/ADHD-DRIFT-LOG.md` or `Promoted to #<num>`. Never silently drop an entry.

### Re-lock ritual

30 minutes in, you'll sometimes realize the scope was wrong. That's fine — *if you do it deliberately.*

1. Say aloud: `Re-locking. Previous: <old sentence>. Reason: <one line>.`
2. Land the in-progress work cleanly: close the WIP PR, OR commit it as `wip: <reason>` and leave the branch.
3. Write the new task sentence. Continue.

If you re-lock more than twice in one session, you needed SCOUT mode — go back to 1.

### Phrases that mean you're drifting

If you find yourself saying any of these mid-task, run the reviewer test before acting:

- "While I'm here…"
- "Might as well…"
- "Quick fix while we're at it…" — sometimes this passes the test, sometimes it doesn't. Run it.
- "I had another idea, let's pivot…" → that's a re-lock, not a side project.

## 3. DONE — verified completion

Adaptive to workflow. Pick the one that matches the project:

- **PR workflow:** PR is **merged**. Not pushed. Not approved. *Merged.*
- **Solo / scratch / no PR workflow:** committed on a named branch with the locked sentence as the commit body, AND that branch reflects work landing somewhere stable (main, deployed, tagged, shared).

Until DONE:

- Treat the task as in-progress.
- Refuse a new lock without an explicit re-lock or close.

When DONE:

- Read drift-log entries (and recent `adhd-drift-log` issues) back to the user.
- Ask which (if any) becomes the next locked task.
- Unpicked items stay logged.

## Operating rules

- One locked task at a time.
- No autonomous tool use on drift-log items.
- Drift-log entries are sacred — never silently delete one.
- When the user goes off-task in chat, redirect once: `Logged — back to <locked task>.`
- The skill is *shared vocabulary*, not a guard rail. The model can still drift. The user can still drift. The vocabulary lets either side call it out.

## Working signals (this skill is helping when)

- PRs match their stated scope. "Also fixed:" lines are short and obviously related.
- Drift logs grow during work, shrink between sessions.
- The phrase "while we're at it" gets followed by a reviewer-test answer, not a silent commit.
- Re-locks happen on purpose, with a stated reason, not as silent scope creep.
- The user stops needing to say "stay on task."
