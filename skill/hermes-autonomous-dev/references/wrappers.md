# Hermes Autonomous — wrapper scripts (reproducible)

Drop these in `~/.local/bin/` (on PATH), chmod +x. They assume the
profiles `autonomous` (smart), `autonomous-yolo` (off), `autonomous-prod`
(smart + conservative) and templates under `~/.hermes/stacks/` exist.

## hb (main wrapper — smart, subcommands doctor/audit)

```sh
#!/bin/sh
# hb / hb-auto / hb doctor / hb audit — autonomous wrapper.
set -u
HB_HOME="$HOME/.hermes"
MODE="${HB_MODE:-smart}"
PROFILE="${HB_PROFILE:-autonomous}"

# subcomandos do wrapper (não exigem repo)
case "${1:-}" in
  audit)  exec hb-audit ;;
esac

STACK=""
while [ $# -gt 0 ]; do
  case "$1" in
    -s|--stack) STACK="$2"; shift 2;;
    *) break;;
  esac
done

PROJECT_ROOT="$(pwd)"
if ! git -C "$PROJECT_ROOT" rev-parse --show-toplevel >/dev/null 2>&1; then
  echo "hb: ERRO — não está dentro de um repositório git." >&2
  exit 1
fi

if [ ! -f "$PROJECT_ROOT/.hermes.md" ]; then
  SRC="$HB_HOME/PROJECT_RULES_TEMPLATE.md"
  [ -n "$STACK" ] && [ -f "$HB_HOME/stacks/$STACK.md" ] && SRC="$HB_HOME/stacks/$STACK.md"
  cp "$SRC" "$PROJECT_ROOT/.hermes.md"
  echo "hb: revise o .hermes.md e rode hb novamente." >&2
  exit 0
fi

if [ -n "$(git -C "$PROJECT_ROOT" status --porcelain 2>/dev/null)" ]; then
  git -C "$PROJECT_ROOT" stash push -u -m "hb-checkpoint-$(date +%s)" >/dev/null 2>&1 && \
    echo "hb: stash de checkpoint criado (git stash pop para recuperar)"
fi

cat <<EOF
Hermes Autonomous
-----------------
Project : $PROJECT_ROOT
Mode    : $MODE
Profile : $PROFILE
Checkpoint (git stash): ENABLED
Checkpoint (Hermes)  : ENABLED
Boundary : .hermes.md
-----------------
EOF

cd "$PROJECT_ROOT"
if [ "$#" -gt 0 ]; then
  exec hermes chat --profile "$PROFILE" --checkpoints -q "$*"
else
  exec hermes chat --profile "$PROFILE" --checkpoints
fi
```

## hb-auto (off mode — trusted repos only)

```sh
#!/bin/sh
HB_MODE=off HB_PROFILE=autonomous-yolo exec hb "$@"
```

## hb-prod (conservative production mode)

```sh
#!/bin/sh
HB_MODE=smart HB_PROFILE=autonomous-prod exec hb -s production "$@"
```

## hb-audit (reads state.db — no repo needed)

```sh
#!/bin/sh
set -u
PY="$HOME/.hermes/hb_audit.py"
[ -f "$PY" ] || cat > "$PY" <<'PYEOF'
import os, sqlite3, glob, sys
home = os.path.expanduser("~/.hermes")
db = os.path.join(home, "state.db")
if not os.path.exists(db):
    print("[FAIL] state.db não encontrado em", db); sys.exit(1)
con = sqlite3.connect(db); con.row_factory = sqlite3.Row; cur = con.cursor()
cur.execute("SELECT name FROM sqlite_master WHERE type='table'")
tables = [r[0] for r in cur.fetchall()]
print("Tabelas:", ", ".join(tables))
def colsof(t):
    cur.execute(f"PRAGMA table_info({t})"); return [r[1] for r in cur.fetchall()]
sess_tbl = None
for t in tables:
    cols = colsof(t)
    if any(c in ("title","created_at","model","session_id","id") for c in cols) and ("messages" in cols or "created_at" in cols):
        sess_tbl = t; break
if sess_tbl:
    cols = colsof(sess_tbl)
    order = "created_at" if "created_at" in cols else ("id" if "id" in cols else cols[0])
    cur.execute(f"SELECT * FROM {sess_tbl} ORDER BY {order} DESC LIMIT 1")
    row = cur.fetchone()
    if row:
        for c in cols:
            s = str(row[c])
            if len(s) > 200: s = s[:200] + "…"
            print(f"  {c}: {s}")
cp_dir = os.path.join(home, "checkpoints")
if os.path.isdir(cp_dir):
    cps = glob.glob(os.path.join(cp_dir, "**", "*.json"), recursive=True)
    print(f"\n=== CHECKPOINTS ({len(cps)}) ===")
    for c in sorted(cps)[-5:]: print("  ", os.path.relpath(c, cp_dir))
logs = os.path.join(home, "logs")
if os.path.isdir(logs):
    print("\n=== LOGS ===")
    for f in sorted(os.listdir(logs))[-5:]: print("  ", f)
con.close()
PYEOF
python3 "$PY" 2>&1
```

## hb-install (reproducibility)

Recreates the whole environment. Modes:
```sh
hb-install            # from current ~/.hermes into target HERMES_HOME
hb-install --bundle   # makes ~/.hermes/hb-bundle.tar.gz (+ -bin.tar.gz)
hb-install --from TAR # rebuilds everything from a bundle on another machine
```
Supports `HERMES_HOME` and `HB_INSTALL_SRC` env overrides. A lightweight
`scripts/hb-install-check.sh` verifies all pieces exist (also honors
`HERMES_HOME`).

## Pitfalls
- `hb-install-check.sh` honors `HERMES_HOME`. If you exported `HERMES_HOME`
  to a throwaway dir during testing, `unset HERMES_HOME` before running it,
  or it reports MISSING against the wrong path.
- `hermes -q "prompt"` directly fails ("invalid choice") — the `chat`
  subcommand is required. `hb` already adds it.
- `hb-yolo` was renamed to `hb-auto`; removing the old `hb-yolo` is safe.

## hb doctor (health check — inline in hb)

Embed in `hb` as an `if [ "${1:-}" = "doctor" ]` block checking:
hermes binary, git, each profile's `config.yaml`, `model.default` set,
inside a git repo, `.hermes.md` present, `checkpoints.enabled: true`,
and `df -h "$HOME"`. Print `[OK]`/`[WARN]`/`[FAIL]` per item.
