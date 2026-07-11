# Troubleshooting

## `hermes: error: argument command: invalid choice` when running `hb "prompt"`
The `hermes` CLI requires the `chat` subcommand before `-q`. The `hb` wrapper
already handles this: `hb "prompt"` → `hermes chat --profile ... -q "prompt"`.
If you called `hermes -q "..."` directly, add `chat`.

## `hb`: "não está dentro de um repositório git"
`hb` requires cwd inside a git repo (the boundary is the repo root). `cd` into
your project and `git init` / `git clone` first.

## Profile `autonomous`: API 400 "No models provided"
The profile has no model set. Fix:
`hermes config set --profile autonomous model.default "<provider/model>"`

## `hb` copies `.hermes.md` and exits on first run
By design: it seeds the repo's boundary file, then you review and re-run.
This keeps you aware of the rules before the agent starts.

## `hb-auto` / `hb-prod` do nothing / wrong mode
They call `hb` with `HB_MODE`/`HB_PROFILE` env. If `hb-yolo` still exists,
remove it (`rm ~/.local/bin/hb-yolo`) — it was renamed to `hb-auto`.

## Checkpoints not working
Ensure `checkpoints.enabled: true` in the profile config, or pass
`--checkpoints` to `hermes chat`. Recover with `/rollback` (or `/rollback N`)
inside the chat.

## `hb audit` shows empty session
Sessions are stored in `~/.hermes/state.db` (SQLite + FTS5). An empty result
means no prior session row, or the DB schema differs. Check
`~/.hermes/logs/` for agent.log / errors.log.

## `rm -rf` / `find -delete` get blocked
That is the Hermes default approval gate (`approvals.mode: manual/smart`)
protecting destructive commands. Expected behavior — approve or use a safer
command. This is NOT a bug in `hb`.
