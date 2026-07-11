# Contribuindo

Obrigado por considerar contribuir!

## Requisitos
- ShellCheck para scripts bash (`shellcheck`)
- Testes manuais em Linux/Termux antes de PR
- Testes em Windows (PowerShell 5.1+) para mudanças em `wrappers/windows/`

## Processo
1. Fork + branch
2. Mudanças mínimas e focadas
3. `shellcheck` passa nos wrappers Unix
4. Teste manual: `hb doctor`, `hb-install --bundle`, fluxo repo
5. PR com descrição clara

## Code Style
- POSIX sh (`#!/bin/sh`) nos wrappers Unix
- `set -euo pipefail` onde suportado
- PowerShell 5.1+ compatível nos `.ps1`
- Mensagens em PT-BR
