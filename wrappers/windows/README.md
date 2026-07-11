# Windows wrappers (nativo, sem WSL)

Estes scripts PowerShell funcionam no **Windows 10/11 nativo** (sem WSL).
O Hermes Agent e o Git devem estar instalados e no PATH.

## Arquivos

| Arquivo            | Equivalente Unix | Uso                          |
|--------------------|------------------|-------------------------------|
| `hb.ps1`           | `hb`             | modo smart (diário)           |
| `hb-auto.ps1`      | `hb-auto`        | modo off (repo confiável)     |
| `hb-prod.ps1`      | `hb-prod`        | produção conservadora         |
| `hb-audit.ps1`     | `hb-audit`       | auditoria da última sessão    |
| `hb-install.ps1`   | `hb-install`     | reproduz o ambiente           |
| `hb.bat`           | (launcher)       | digite `hb` no cmd/powershell |

## Instalação

1. Instale o Hermes Agent e o Git (ambos no PATH).
2. Copie os arquivos `.ps1` e `hb.bat` para uma pasta no PATH
   (ex.: `%USERPROFILE%\.local\bin`).
3. Verifique:

```powershell
hb.ps1 doctor
```

ou, se tiver o `hb.bat` no PATH:

```bat
hb doctor
```

## Uso

```powershell
cd C:\meu\projeto
hb.ps1                 # 1ª vez cria o .hermes.md — revise e rode de novo
hb.ps1 -Stack python   # aplica regras de stack
hb-auto.ps1 "refatore X"# modo off (só repo confiável)
hb-prod.ps1 "corrija Y" # produção
```

## Notas

- No Windows o conceito de "root" não se aplica (lá é Admin/UAC). A fronteira
  de projeto (`.hermes.md`) funciona igual aos outros SO.
- `hb-auto.ps1` remove o gate de aprovação — use só em repo confiável.
- Requer PowerShell 5.1+ (já vem no Windows 10/11).
