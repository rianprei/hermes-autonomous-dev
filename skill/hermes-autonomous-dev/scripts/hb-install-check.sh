#!/bin/sh
# hb-install-check.sh — quick verification that the autonomous-dev
# environment is present and consistent. Part of the hermes-autonomous-dev
# skill. Not a substitute for `hb doctor` (which checks the live Hermes).
set -u
HB_HOME="${HERMES_HOME:-$HOME/.hermes}"
BIN="$HOME/.local/bin"
fail=0

echo "=== hermes-autonomous-dev sanity check ==="

check() { [ -e "$1" ] && echo "[OK] $1" || { echo "[MISSING] $1"; fail=1; }; }

check "$HB_HOME/profiles/autonomous/config.yaml"
check "$HB_HOME/profiles/autonomous-yolo/config.yaml"
check "$HB_HOME/profiles/autonomous-prod/config.yaml"
check "$HB_HOME/stacks/python.md"
check "$HB_HOME/stacks/javascript.md"
check "$HB_HOME/stacks/rust.md"
check "$HB_HOME/stacks/android.md"
check "$HB_HOME/stacks/production.md"
check "$HB_HOME/PROJECT_RULES_TEMPLATE.md"
check "$HB_HOME/HERMES_WORKFLOW.md"
check "$BIN/hb"
check "$BIN/hb-auto"
check "$BIN/hb-prod"
check "$BIN/hb-audit"
check "$BIN/hb-install"

# model set on autonomous profile?
grep -q "default:" "$HB_HOME/profiles/autonomous/config.yaml" 2>/dev/null \
  && echo "[OK] model set (autonomous)" || { echo "[WARN] model not set"; }

echo "---"
[ "$fail" = "0" ] && echo "STATUS: OK — environment complete" || echo "STATUS: incomplete (see MISSING above)"
exit $fail
