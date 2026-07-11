# Changelog

## 1.1.1
- **Windows hardening**:
  - Added `hb-install-check.ps1` — native Windows health check (mirrors Unix `hb-install-check.sh`).
  - `hb.ps1 audit`: graceful fallback when `sqlite3` not available on Windows (informs user to install or use Linux).
  - `hb-install.ps1`: robust wrapper detection for both bundle and repo clone sources.
  - Updated `manifest.yaml` to include `hb-install-check.ps1` in `windows_wrappers`.
- Bundle v1.1.1 includes all Windows wrappers + health check.

## 1.1.0
- **Windows native support**: PowerShell wrappers (`hb.ps1`, `hb-auto.ps1`, `hb-prod.ps1`, `hb-audit.ps1`, `hb-install.ps1`, `hb.bat`) — 100% feature parity with Unix wrappers, no WSL required.
- Added `wrappers/windows/` directory with README.
- Updated `manifest.yaml` with `platforms: [linux, android, windows]` and `windows_wrappers` component.
- Updated skill frontmatter: `version: 1.1.0`, `platforms: [linux, android, windows]`.
- Bundle regeneration includes Windows wrappers.
- Release assets include Windows wrappers in bundle.

## 1.0.0
- Initial autonomous Hermes workflow (Claude Code "skip perms + boundary" equivalent).
- Wrappers: `hb` (smart), `hb-auto` (off), `hb-prod` (smart+whitelist+branch).
- `hb doctor` (health check), `hb audit` (last session summary via state.db), `hb-install` (reproducible setup).
- Per-stack `.hermes.md` templates (python / javascript / rust / android / production).
- Profiles: `autonomous` (smart), `autonomous-yolo` (off), `autonomous-prod` (smart restricted).
- Security model documented: boundary is policy (not kernel), rollback is recovery (not prevention).
- Skill restructured: `SKILL.md` (manual) + `references/` + `templates/` + `scripts/`.
- Removed duplicate skill under `skills/hermes/`.
- Versioned frontmatter (`version`, `platforms`, `metadata.hermes.category`).
- Portable bundle (`hb-bundle.tar.gz`) with SHA256.