# Hermes Autonomous Dev Kit (v1.0.0)

Equivalent to Claude Code's "skip permissions + project boundary" for
**Hermes Agent** — built only with native Hermes mechanisms. Termux-native,
**NO root, NO proot**.

## What it gives you

| Command   | Hermes mode | Use                                |
|-----------|-------------|------------------------------------|
| `hb`      | `smart`     | daily autonomous development       |
| `hb-auto` | `off`       | no-approval mode (trusted repos)  |
| `hb-prod` | `smart`+    | conservative production workflow  |
| `hb doctor` | —         | health check of the setup         |
| `hb audit`  | —         | last-session summary (state.db)   |
| `hb-install`| —         | reproduce the environment         |

- **No permission prompts** → `approvals.mode` (`smart`/`off`) per profile.
- **Project boundary** → `.hermes.md` auto-loaded inside the repo.
- **Rollback** → Hermes checkpoints (`/rollback [N]`) + git stash.
- **Per-stack context** → `python` / `javascript` / `rust` / `android` / `production`.

## Install

```bash
# From the repo
hb-install --from releases/hb-bundle-v1.0.0.tar.gz
# …or from a portable bundle
hb-install --from hb-bundle.tar.gz

hb doctor          # verify
cd /your/project
hb                 # first run seeds .hermes.md — review, then re-run
```

See `skill/hermes-autonomous-dev/INSTALL.md` for the full guide and
`skill/hermes-autonomous-dev/SKILL.md` for the operating manual.

## Reproduce on another machine

```bash
hb-install --bundle        # creates ~/.hermes/hb-bundle.tar.gz
# copy hb-bundle.tar.gz to the new machine, then:
hb-install --from hb-bundle.tar.gz
```

## Security model (read this)

The project boundary is **policy, not a kernel barrier**:
- `.hermes.md` instructs the model to stay inside the repo.
- Checkpoints let you *recover* (`/rollback`), not *prevent*.
- `hb-auto` (`off`) removes the last approval gate — trusted repos only.

This is the practical ceiling **without root/proot** on Termux (user
namespaces are disabled). For real filesystem isolation you would need a
container/namespace (root or userns) — out of scope here.

## Layout

```
skill/hermes-autonomous-dev/   the Hermes skill (SKILL.md + references/templates/scripts)
profiles/                     autonomous, autonomous-prod, autonomous-yolo (config.yaml)
stacks/                       per-language boundary rules
wrappers/                     hb, hb-auto, hb-prod, hb-audit, hb-install
releases/                     hb-bundle-v1.0.0.tar.gz (+ .sha256)
manifest.yaml                 component manifest
```

## License

MIT — see `LICENSE`.
