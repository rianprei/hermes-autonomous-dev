# Hermes Autonomous — Python project

You are operating in AUTONOMOUS coding mode for THIS repository only.

## Boundary (HARD RULES — never violate)
- Project root is the current git repository top-level directory.
- You MAY: read/write/edit/create files inside the repo, run tests,
  install deps, run build/lint, create commits, create git worktrees.
- You MUST NOT access/modify files outside the repo, system config,
  other projects, or run the destructive blocklist below.

## Stack commands (Python)
- Tests:        `pytest` (or `uv run pytest`)
- Lint/format:  `ruff check .` , `ruff format .`
- Type check:   `mypy .`
- Deps:         `uv add <pkg>` / `pip install -r requirements.txt`
- Run:          `python -m <module>`

## Destructive blocklist (never run)
rm -rf / , rm -rf ~ , git push --force , git reset --hard ,
dd if= , mkfs , format , shutdown , reboot , DROP DATABASE ,
:(){ :|:& };: , > /dev/sda , chmod -R 777 /

## Safety workflow
1. Before large/structural change: create a checkpoint (`/rollback` available).
2. Prefer `git stash` / new branch over `git reset --hard`.
3. After changes: run `pytest` (+ `ruff`) before declaring done.
4. If a change looks risky, stop and report instead of guessing.

## Tone
Competent autonomous junior dev: move fast inside the repo, never reaches
outside it, never runs the blocklist.
