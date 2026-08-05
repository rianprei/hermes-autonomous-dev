# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.2] - 2026-08-05

### Security
- **Single source blocklist**: `security/blocklist.txt` — lista única de comandos perigosos usada por `.hermes.md`, profiles e validação
- **`hb-auto` flag anywhere**: `--confirm-i-accept-risks` agora aceita em qualquer posição (antes só no 1º argumento)
- **Prompt injection documented**: seção "Limitações conhecidas" no README com riscos reais

### Fixed
- **Instalador robusto**: `hb-install --from` não falha mais por `hb-bundle-bin.tar.gz` inexistente; fallback copia wrappers do source
- **Termux claim corrigida**: SKILL.md e README agora dizem "requer `proot-distro`" (antes mentia "sem proot"); wrapper `hb` detecta e usa proot automaticamente
- **Windows `hb.ps1`**: aceita `doctor`/`audit` posicionais (não só `-Doctor`/`-Audit`)
- **Wrapper `hb` POSIX**: `set -eu` (sem `pipefail`), compatível com `dash`/`sh`
- **Testes de fumaça no CI**: Linux + Windows cobrem repo sujo, flag em qualquer posição, diretório sem git, repo vazio, auditoria

### Changed
- **CHANGELOG.md** adicionado (Keep a Changelog + SemVer)
- **README.md**: seção "Limitações conhecidas" honesta (blocklist textual, sem sandbox, prompt injection, Termux/proot, bundle não reproduzível, zero testes automatizados)
- **LICENSE**: copyright corrigido para `LucaGuerian (rianprei)`
- **.gitignore**: não ignora mais `releases/*.tar.gz` (assets de release)
- **SKILL.md**: versão 1.1.2, plataformas `[linux, android, windows]`, Termux = proot-distro
- **manifest.yaml**: v1.1.2, `tested: [linux, windows]`, `platforms: [linux, android, windows]`
- **Removidas refs mortas**: `hb-yolo` (renomeado para `hb-auto`)

### CI
- GitHub Actions `validate.yml`: jobs `validate-linux` (ubuntu-latest) + `validate-windows` (windows-latest) **ambos passando**
- Testes usam exit codes, não string matching frágil
- Health check, `hb-auto` flag positions, dirty repo stash, non-git dir, empty repo, audit

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