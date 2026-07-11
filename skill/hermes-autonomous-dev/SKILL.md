---
name: hermes-autonomous-dev
description: "Set up and operate the Hermes autonomous coding environment (hb/hb-auto/hb-prod wrappers, profiles, stacks, checkpoints) — the Claude Code 'skip permissions + project boundary' equivalent, Termux-native, no root/proot."
version: 1.1.0
author: Hermes Agent + user
license: MIT
platforms: [linux, android, windows]
tags: [hermes, autonomous, coding, devops, termux, no-root, windows]
metadata:
  hermes:
    tags: [hermes, coding, devops, termux, autonomous, windows]
    category: development
---

# Desenvolvimento Autônomo no Hermes

Termux nativo, SEM root, SEM proot. Equivalente ao
"--dangerously-skip-permissions + project boundary" do Claude Code usando
apenas mecanismos nativos do Hermes.

## Propósito
Operar o Hermes como agente de desenvolvimento autônomo dentro de um repo:
trabalha sem pedir confirmação, mas não consegue sair do projeto, e qualquer
erro é reversível via checkpoints.

## Fluxo rápido
- `hb`        → desenvolvimento diário (`approvals.mode: smart`)
- `hb-auto`   → modo sem aprovação (`off`) — só repos confiáveis
- `hb-prod`   → produção conservadora (`smart` + whitelist + branch obrigatória)
- `hb doctor` → verificação de saúde do setup
- `hb audit`  → resumo da última sessão (state.db)
- `hb-install` → reproduz o ambiente (clone / bundle / from)

## Como mapeia para o Hermes nativo
- **Sem prompts:** `approvals.mode` (`smart` | `off`) por perfil.
- **Fronteira:** `.hermes.md` na raiz do repo, auto-carregado (first-match, git root).
- **Rollback:** `checkpoints.enabled: true`; recupere com `/rollback [N]`.
- **Isolamento:** cada modo é um profile separado em `~/.hermes/profiles/`.

## Carregue as referências quando precisar
- `references/wrappers.md` — código/fonte dos wrappers.
- `references/autonomous-config-example.yaml` — exemplos de config de profile.
- `references/security-model.md` — por que a fronteira é política (não kernel) + limites.
- `references/troubleshooting.md` — falhas comuns e correções.

## Templates (copie para um repo)
- `templates/AGENTS.template.md`  — ponte curta para esta skill.
- `templates/.hermes.md` — regras genéricas de fronteira.
- `templates/production.md` — regras strict de produção (para `hb -s production`).

## Reproduza em outra máquina
```bash
hb-install --bundle                 # na origem: cria ~/.hermes/hb-bundle.tar.gz
hb-install --from /path/hb-bundle.tar.gz   # no destino: reconstrói tudo
```

## Regras críticas (sempre)
- Nunca edite main/master direto — crie uma branch de feature primeiro.
- Checkpoints estão ON — recupere com `/rollback` ou `git stash pop`.
- NÃO use soluções root/proot (restrição do dispositivo).
- `hb-auto` (`off`) remove o gate de aprovação — só repos confiáveis.
