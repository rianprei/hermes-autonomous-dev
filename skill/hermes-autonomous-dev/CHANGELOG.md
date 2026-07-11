# Changelog

## 1.0.0
- Initial autonomous Hermes workflow (Claude Code "skip perms + boundary" equivalent).
- Added wrappers: `hb` (smart), `hb-auto` (off), `hb-prod` (smart+whitelist+branch).
- Added `hb doctor` (health check) and `hb audit` (last-session summary via state.db).
- Added per-stack `.hermes.md` templates (python / javascript / rust / android / production).
- Added `hb-install` (clone / --bundle / --from) for reproducible setup.
- Added `HB_HOME`-aware `hb-install-check.sh` sanity script.
- Documented security model: boundary is policy (not kernel); rollback is recovery (not prevention).
- Restructured skill: `SKILL.md` (manual) + `references/` + `templates/` + `scripts/`.
- Removed duplicated skill under `skills/hermes/`.
- Versioned frontmatter (`version`, `platforms`, `metadata.hermes.category`).
