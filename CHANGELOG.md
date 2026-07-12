# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- Initial structure for future releases

## [1.1.2] - 2026-07-12
### Fixed
- Fixed POSIX compatibility of `wrappers/hb` (replace `;;&` with `;;`)
- Ensure `PROJECT_RULES_TEMPLATE.md` is tracked in Git (was untracked, causing Windows CI failures)
- Updated `manifest.yaml` version to 1.1.2 to match tag
- Updated README to reflect Windows CI testing status
### Changed
- Improved `hb doctor` and `hb` wrapper robustness (set -euo pipefail, proper arg parsing)
- Windows `hb-install.ps1` and `hb-auto.ps1` tests now use exit codes instead of fragile string matching
- Audit step in CI now only checks command execution, not output requiring API keys

## [1.1.1] - 2026-06-28
### Added
- Initial release of Hermes Autonomous Dev Kit
- Core wrappers: `hb`, `hb-auto`, `hb-prod`, `hb-audit`, `hb-install`
- Profiles: `autonomous`, `autonomous-prod`, `autonomous-yolo`
- Stacks for Python, JavaScript, Rust, Android, Production
- Templates: `.hermes.md`, `HERMES_WORKFLOW.md`
- Example workflows and documentation

## [1.1.0] - 2026-06-15
### Added
- Early access release with basic autonomous workflow
- Initial `hb` and `hb-auto` wrappers
- Basic profile configuration

## [1.0.0] - 2026-06-01
### Added
- Project initialization
- Basic Hermes skill structure