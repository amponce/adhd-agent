<!-- Use the skill on yourself. The PR you're opening is a LOCKED task. -->

## Done =

<!-- One concrete sentence. What lands when this PR merges? -->

## Changes

<!-- Bullet list of what this PR touches. Keep it short — if it's long, this might be more than one task. -->

-

## Also fixed

<!-- Small adjacent fixes you bundled in (typos, missing imports, one-line cleanups).
     If a reviewer would NOT be surprised by them given this PR's scope, they belong here.
     Leave blank if there weren't any. -->

-

## Drift log

<!-- Anything bigger you noticed but deliberately did NOT bundle.
     Either captured here or promoted to its own issue with the `adhd-drift-log` label. -->

-

## Checklist

- [ ] Every change in **Changes** traces to the `Done =` sentence above.
- [ ] Anything in **Also fixed** would not surprise a reviewer of this PR.
- [ ] Anything that would surprise a reviewer is in **Drift log** (or its own issue).
- [ ] `install.sh` still passes its idempotency check (re-running produces no diff).
