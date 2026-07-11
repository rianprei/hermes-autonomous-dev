---
name: hermes-autonomous-dev
description: "Set up and operate the Hermes autonomous coding environment (hb/hb-auto/hb-prod wrappers, profiles, stacks, checkpoints) — the Claude Code 'skip permissions + project boundary' equivalent, Termux-native, no root/proot."
version: 1.0.0
author: Hermes Agent + user
license: MIT
platforms: [linux, android]
tags: [hermes, autonomous, coding, devops, termux, no-root]
metadata:
  hermes:
    tags: [hermes, coding, devops, termux, autonomous]
    category: development
---

# Hermes Autonomous Development

Termux-native, NO root, NO proot. Equivalent to Claude Code
"--dangerously-skip-permissions + project boundary" using Hermes-native
mechanisms only.

## Purpose
Operate Hermes as an autonomous coding agent inside a repo: it works without
asking for confirmation, but cannot leave the project, and any mistake is
reversible via checkpoints.

## Quick workflow
- `hb`        → daily development (`approvals.mode: smart`)
- `hb-auto`   → no-approval mode (`off`) — trusted repos only
- `hb-prod`   → conservative production (`smart` + whitelist + branch mandatory)
- `hb doctor` → health check of the setup
- `hb audit`  → last-session summary (state.db)
- `hb-install` → reproduce the environment (clone / bundle / from)

## How it maps to native Hermes
- **No prompts:** `approvals.mode` (`smart` | `off`) per profile.
- **Boundary:** `.hermes.md` at repo root, auto-loaded (first-match, git root).
- **Rollback:** `checkpoints.enabled: true`; recover with `/rollback [N]`.
- **Isolation:** each mode is a separate profile under `~/.hermes/profiles/`.

## Load references when needed
- `references/wrappers.md` — full `hb` / `hb-auto` / `hb-prod` / `hb-audit` / `hb-install` source + behavior.
- `references/autonomous-config-example.yaml` — profile config examples.
- `references/security-model.md` — why boundary is policy (not kernel) + limits.
- `references/troubleshooting.md` — common failures and fixes.

## Templates (copy into a repo)
- `templates/AGENTS.md`  — short per-project pointer to this skill.
- `templates/.hermes.md` — generic project boundary rules.
- `templates/production.md` — strict production rules (for `hb -s production`).

## Reproduce elsewhere
```bash
hb-install --bundle                 # on source: makes ~/.hermes/hb-bundle.tar.gz
hb-install --from /path/hb-bundle.tar.gz   # on target: rebuilds everything
```

## Critical rules (always)
- Never edit main/master directly — create a feature branch first.
- Checkpoints are ON — recover with `/rollback` or `git stash pop`.
- Do NOT use root/proot solutions (device constraint).
- `hb-auto` (`off`) removes the approval gate — trusted repos only.
