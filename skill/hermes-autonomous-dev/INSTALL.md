# Hermes Autonomous Dev — Install

Equivalent to Claude Code "skip permissions + project boundary", Termux-native,
NO root, NO proot. Uses only native Hermes mechanisms.

## Install (from bundle)

```bash
# 1. Extract the bundle
tar -xzf hb-bundle.tar.gz -C ~/

# 2. Install everything (profiles, stacks, wrappers, skill)
hb-install --from ~/.hermes/hb-bundle.tar.gz

# 3. Verify health
hb doctor

# 4. Enter a git repository
cd /path/to/your/project

# 5. First run seeds the project boundary file — review it, then re-run
hb

# Daily usage
hb            # smart mode (daily)
hb -s python  # apply stack rules (first time)
hb-prod       # production (conservative)
hb-auto       # off mode — trusted repos ONLY
```

## Modes

| Command   | Mode   | Use                          |
|-----------|--------|------------------------------|
| `hb`      | smart  | daily development             |
| `hb-auto` | off    | trusted repositories only    |
| `hb-prod` | smart+ | production (whitelist, branch)|

## Recover

- Hermes checkpoint: `/rollback` or `/rollback N` in chat.
- Wrapper stash: `git stash pop`.
- `hb audit` — what changed in the last session.

## Limits

Boundary is policy (`.hermes.md`) + checkpoints, NOT a kernel sandbox.
Ceiling without root/proot on Termux. `hb-auto` removes the approval gate —
trusted repos only.
