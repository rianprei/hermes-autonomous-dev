# Security

This document states, explicitly, what the Hermes Autonomous Dev Kit
protects against and what it does **not** protect against. Read it before
using `hb-auto`.

## What it protects against

- **Working in the wrong directory** — `hb` requires a git repo and prints a
  confirmation summary (project / mode / profile / checkpoints / boundary)
  before starting.
- **Obvious destructive commands** — `.hermes.md` forbids `rm -rf /`, `git
  push --force`, `git reset --hard HEAD`, `dd`, `mkfs`, `shutdown`, `reboot`,
  `DROP DATABASE`, etc.
- **Losing changes** — Hermes checkpoints (`/rollback [N]`) plus a git stash
  created by `hb` before each session. Both are reversible.
- **Code regression** — `hb-prod` enforces a dedicated feature branch and
  prohibits automatic dependency installs.
- **Unintended approval prompts fatigue** — `hb` uses `approvals.mode:
  smart` (auto-approves low-risk, prompts on high-risk).

## What it does NOT protect against

- **Kernel-level isolation** — there is **no container, namespace, or
  syscall filter**. The boundary is a *policy* (`.hermes.md` instructions to
  the model), not an OS barrier. This is the ceiling **without root/proot**
  on Termux (user namespaces are disabled: `unshare --map-root-user` fails).
- **A model that ignores instructions** — if the model decides to act
  outside the repo, the OS will not stop it. Rollback recovers state; it
  does not prevent the action.
- **Malicious dependency you approve** — `hb`/`hb-prod` can install deps via
  the repo's package manager; a malicious package you authorize will run.
- **Malicious external script you run consciously** — any script you ask the
  agent to execute will execute.
- **Ambiguous instruction misinterpretation** — a vaguely worded request can
  be carried out differently than intended. Prefer explicit, narrow prompts.

## Modes — trust level

| Mode       | `approvals.mode` | Gate | Use case                    |
|------------|------------------|------|-----------------------------|
| `hb`       | `smart`          | yes  | daily development            |
| `hb-auto`  | `off`            | **no** | trusted repos ONLY         |
| `hb-prod`  | `smart` + whitelist | yes | production / sensitive code |

`hb-auto` removes the last approval gate. **Only use it on repositories you
control and have backed up.** It is not a default.

## Recommendations

1. Default to `hb`. Reserve `hb-auto` for throwaway or fully backed-up repos.
2. Always create a feature branch before large changes (`hb-prod` enforces this).
3. Run `hb doctor` after any environment change.
4. Verify bundle integrity with the published SHA256 before installing:
   `sha256sum -c releases/hb-bundle-v1.0.0.sha256`.
5. Remember: this is a **safe workflow**, not a sandbox.
