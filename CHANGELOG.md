# Changelog

## 1.0.0
- Workflow autônomo inicial para Hermes (equivalente ao "skip perms + boundary" do Claude Code).
- Wrappers: `hb` (smart), `hb-auto` (off), `hb-prod` (smart+whitelist+branch).
- `hb doctor` (verificação de saúde) e `hb audit` (resumo da última sessão via state.db).
- Templates `.hermes.md` por stack (python / javascript / rust / android / production).
- `hb-install` (clone / --bundle / --from) para setup reproduzível.
- Script de sanidade `hb-install-check.sh` ciente de `HB_HOME`.
- Modelo de segurança documentado: fronteira é política (não kernel); rollback é recuperação (não prevenção).
- Skill reestruturada: `SKILL.md` (manual) + `references/` + `templates/` + `scripts/`.
- Skill duplicada em `skills/hermes/` removida.
- Frontmatter versionado (`version`, `platforms`, `metadata.hermes.category`).
