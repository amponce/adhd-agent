---
name: adhd-agent
description: Keep the user on-task without killing exploration. Three modes — SCOUT, LOCKED, DONE. Capture off-task ideas instead of pursuing them. Adaptive — works with or without a PR workflow.
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

A shared protocol between the user and any agent helping them (Claude Code, Codex, Hermes, Cursor). The vocabulary is the contract: *are you scouting or locked? is that parking lot? is this done done?* The skill doesn't enforce itself — it gives both sides a shared language so drift is namable.

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

## 2. LOCKED — one task, one PR, no drift

When the task is clear, write the deliverable sentence:

```
Done = <concrete outcome>.
```

Concrete examples: `Done = PR #42 merged into main`, `Done = src/auth/login.ts validates empty email`, `Done = relay-api restarts cleanly under the new env config`. Vague is not allowed — refuse to lock on "clean up auth."

Once locked:

- Every changed line must trace to that sentence.
- Anything that doesn't → capture (see below) and return.
- The lock holds until DONE or a deliberate re-lock.

### Capture off-task ideas

Default to markdown — GitHub issues are an **explicit promotion**, not the default. Most thoughts don't deserve project-state tracking.

**Default — append to `docs/ADHD-PARKING-LOT.md`** in cwd (create file + `docs/` dir if missing):

```
- [YYYY-MM-DD] <one-line idea> (raised during: <locked task>)
```

**Promote to GitHub issue** only when the idea is concrete enough to triage as real work:

```
gh issue create \
  --title "<one-line idea>" \
  --body  "Raised during: <locked task>. Promoted from adhd parking lot." \
  --label adhd-parking-lot
```

Tell the user where it landed: `Parked: docs/ADHD-PARKING-LOT.md` or `Promoted to #<num>`. Never silently drop a capture.

### Re-lock ritual

30 minutes in, you'll sometimes realize the scope was wrong. That's fine — *if you do it deliberately.*

1. Say aloud: `Re-locking. Previous: <old sentence>. Reason: <one line>.`
2. Land the in-progress work cleanly: close the WIP PR, OR commit it as `wip: <reason>` and leave the branch.
3. Write the new task sentence. Continue.

If you re-lock more than twice in one session, you needed SCOUT mode — go back to 1.

### Drift refuses

In-scope or out-of-scope? Test: *would the locked PR pass review with this change reverted?* If yes → out-of-scope → capture.

Phrases that mean "you're drifting, capture it":

- "While I'm here…"
- "Might as well…"
- "Quick fix while we're at it…"
- "I had another idea, let's pivot…" → that's a re-lock, not a side project.

## 3. DONE — verified completion

Adaptive to workflow. Pick the one that matches the project:

- **PR workflow:** PR is **merged**. Not pushed. Not approved. *Merged.*
- **Solo / scratch / no PR workflow:** committed on a named branch with the locked sentence as the commit body, AND that branch reflects work landing somewhere stable (main, deployed, tagged, shared).

Until DONE:

- Treat the task as in-progress.
- Refuse a new lock without an explicit re-lock or close.

When DONE:

- Read parking-lot entries (and recent `adhd-parking-lot` issues) back to the user.
- Ask which (if any) becomes the next locked task.
- Unpicked items stay parked.

## Operating rules

- One locked task at a time.
- No autonomous tool use on parking-lot items.
- Captures are sacred — never silently delete an entry.
- When the user goes off-task in chat, redirect once: `Capturing — back to <locked task>.`
- The skill is *shared vocabulary*, not a guard rail. The model can still drift. The user can still drift. The vocabulary lets either side call it out.

## Working signals (this skill is helping when)

- Diffs shrink. Parking lots grow during work, shrink between sessions.
- PRs match their stated scope without "and also" additions in the description.
- The phrase "while we're at it" only appears in chat that ends in a capture, never in code.
- The user stops needing to say "stay on task."
- Re-locks happen on purpose, with a stated reason, not as silent scope creep.
