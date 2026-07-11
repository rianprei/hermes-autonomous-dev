# Security Model

## Why the boundary is policy, not a kernel barrier

The project boundary is enforced by:

1. `.hermes.md` — instructions injected into the system prompt. The model is
   *asked* to stay inside the repo. This is a policy, not a syscall filter.
2. `checkpoints` — Hermes snapshots before risky ops; `/rollback` undoes them.
   Rollback is recovery, not prevention.
3. `approvals.mode: smart` — high-risk commands still prompt (in `hb`/`hb-prod`).

Consequence: a model that "decides" to ignore `.hermes.md` is not stopped by
the OS. This is the practical ceiling **without root/proot on Termux**, where
user namespaces are disabled (`unshare --map-root-user` → `Invalid argument`).

## Modes compared

| Mode       | approvals | Install auto | Branch req. | Use                |
|------------|-----------|--------------|-------------|--------------------|
| `hb`       | smart     | yes          | no          | daily              |
| `hb-auto`  | off       | yes          | no          | trusted repo only  |
| `hb-prod`  | smart     | no           | yes         | production         |

## Hardening notes
- Keep `hb` (smart) as the default. Reserve `hb-auto` (off) for repos with
  backup/version control you control.
- `hb-prod` adds a whitelist + mandatory feature branch; it does NOT install
  dependencies automatically — it proposes them in the plan.
- The git stash created by `hb` is an extra safety net on top of Hermes
  checkpoints (two different intents: project state vs. agent changes).

## What would make it a real barrier
A container / mount namespace isolating the filesystem (e.g. bubblewrap,
`unshare` with userns, or a real sandbox). All require root or a kernel with
userns — both out of scope on this device. Until then, policy + rollback is
the best available trade-off.
