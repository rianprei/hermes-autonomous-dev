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
2. Baixe o bundle da release v1.1.2:
   ```powershell
   Invoke-WebRequest -Uri "https://github.com/rianprei/hermes-autonomous-dev/releases/download/v1.1.2/hb-bundle-v1.1.2.tar.gz" -OutFile "hb-bundle-v1.1.2.tar.gz"
   ```
3. Extraia e instale:
   ```powershell
   tar -xzf hb-bundle-v1.1.2.tar.gz -C ~/
   .\wrappers\windows\hb-install.ps1 -From hb-bundle-v1.1.2.tar.gz
   ```
4. Verifique:
   ```powershell
   hb.ps1 doctor
   ```

## Uso

```powershell
cd C:\meu\projeto
hb.ps1                 # 1ª vez cria o .hermes.md — revise e rode de novo
hb.ps1 -Stack python   # aplica regras de stack
hb-auto.ps1 -ConfirmIAcceptRisks "refatore X"  # modo off (só repo confiável)
hb-prod.ps1 "corrija Y" # produção
```

## Notas

- No Windows o conceito de "root" não se aplica (lá é Admin/UAC). A fronteira
  de projeto (`.hermes.md`) funciona igual aos outros SO.
- `hb-auto.ps1` remove o gate de aprovação — use só em repo confiável.
- Requer PowerShell 5.1+ (já vem no Windows 10/11).
