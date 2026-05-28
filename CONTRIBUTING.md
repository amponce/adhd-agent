# Contributing

Thanks for opening this. Short rules so PRs land fast:

## How to contribute

1. Fork → branch from `main` → PR back. The repo blocks direct pushes from non-owners.
2. PRs are squash-merged. Write the PR title and body like a commit message — short imperative title, body explains the *why*.
3. Branches are auto-deleted on merge.

## Use the skill on the PR itself

Yes, run this skill on the PR you're making to it. That's the whole point. Open the PR with one `Done = …` sentence and stay inside it. Surprising drift gets logged, not committed. Small adjacent fixes are welcome — bundle them under "Also fixed:" in the PR body.

The PR template asks for that sentence. Fill it in.

## What I'll accept

Welcome:

- Better wording in `SKILL.md` that makes the four principles (Simple / Smart / Verify / Remind) clearer.
- Install-script fixes for runtimes I missed.
- New runtime targets (`mirror_to` calls in `install.sh`) — keep them idempotent.
- Examples that make the protocol click faster.
- Bug fixes to the Cursor helper.

Probably not without a discussion first:

- New top-level principles beyond Simple / Smart / Verify / Remind.
- A capture mechanism that requires external services beyond GitHub.
- Behavior changes the README would no longer accurately describe.

If you're unsure, open an issue first.

## What "Done" means here

PR is merged into `main`. Not approved, not pushed — merged. Until then the task is in progress.
