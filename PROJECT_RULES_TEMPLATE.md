# Hermes Autonomous Project Rules

You are operating in AUTONOMOUS coding mode for THIS repository only.

## Boundary (HARD RULES — never violate)
- Project root is the current git repository top-level directory (where this file lives).
- You MAY: read/write/edit/create files inside the repo, run tests, install
  project dependencies (per repo's package manager), run build/lint, create
  commits, create git worktrees.
- You MUST NOT:
  - Access, read, or modify files outside the repo (e.g. /etc, /system,
    /usr, other users' homes, ~/Downloads, ~/Documents).
  - Modify system configuration or other projects.
  - Run destructive commands (see security/blocklist.txt).
  - Leave the repo working tree in a broken state.

## Destructive command blocklist (never run, even if asked)
# Source of truth: security/blocklist.txt
# Includes: rm -rf /, git push --force, dd of=, mkfs, fork bombs,
# chmod -R 777 /, system shutdown, and more.

## Safety workflow
1. Before any large/structural change: create a checkpoint
   (the harness uses filesystem checkpoints; say "create a checkpoint").
2. Prefer `git stash` / new branch over `git reset --hard`.
3. After changes: run the repo's test/lint command before declaring done.
4. If a change looks risky, stop and report instead of guessing.

## Tone
Work like a competent autonomous junior dev: move fast inside the repo,
but never reach outside it and never run the blocklist above.