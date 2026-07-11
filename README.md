# Hermes Autonomous Dev Kit (v1.1.1)

Equivalente ao "skip permissions + project boundary" do Claude Code para o
**Hermes Agent** — construído usando apenas mecanismos nativos do Hermes.

## O que ele oferece

| Comando     | Modo Hermes | Uso                                |
|-------------|-------------|------------------------------------|
| `hb`        | `smart`     | desenvolvimento autônomo diário    |
| `hb-auto`   | `off`       | modo sem aprovação (repos confiáveis) |
| `hb-prod`   | `smart`+    | fluxo de produção conservador      |
| `hb doctor` | —           | verificação de saúde do ambiente   |
| `hb audit`  | —           | resumo da última sessão (state.db) |
| `hb-install`| —           | reproduz o ambiente                |

- **Sem prompts de aprovação** → `approvals.mode` (`smart`/`off`) por perfil.
- **Fronteira do projeto** → `.hermes.md` carregado automaticamente dentro do repo.
- **Rollback** → checkpoints do Hermes (`/rollback [N]`) + git stash.
- **Contexto por stack** → `python` / `javascript` / `rust` / `android` / `production`.

## Plataformas

| Plataforma | Status | Detalhes |
|------------|--------|----------|
| **Linux** (desktop, server, VPS) | ✅ Testado | git + bash + hermes nativos |
| **macOS** | 🟡 Declarado | bash, git, hermes via pip/installer — **não testado em CI** |
| **Windows** | 🟡 **Experimental, não testado** | Scripts PowerShell em `wrappers/windows/` (`hb.ps1`, `hb-auto.ps1`, etc.) + `hb.bat`. Requer PowerShell 5.1+ (já no Windows 10/11) e `hermes`/`git` no PATH. **Nunca rodou em Windows real** — sem CI, sem validação manual. Veja `wrappers/windows/README.md`. |
| **Termux (Android)** | 🟡 Com workaround | Hermes nativo falha no Termux (issue upstream #17009). **Workaround**: use `proot-distro install ubuntu` e rode o Hermes dentro do Ubuntu no Termux. O wrapper `hb` detecta e usa automaticamente. |
| **VPS / remoto** | ✅ Declarado | Linux remoto — funciona igual; rode o Hermes lá e acesse via gateway. |

> **Nota**: O foco original era "Termux sem root/proot". Em PC Linux/macOS normal funciona igual — e melhor, pois não há limitação de user namespaces. No Windows o conceito de "root" não se aplica (lá é Admin/UAC); a fronteira de projeto (`.hermes.md`) funciona igual. **Windows e macOS nunca rodaram em CI nem foram testados manualmente.**

## Instalação

```bash
# A partir do repositório (Linux/macOS/Termux)
hb-install --from releases/hb-bundle-v1.1.2.tar.gz
# Windows: veja wrappers/windows/README.md (hb-install.ps1)
# Windows (experimental): veja wrappers/windows/README.md (hb-install.ps1)

hb doctor          # verifica
cd /seu/projeto
hb                 # 1ª execução cria o .hermes.md — revise, depois rode de novo
```

### Windows (experimental)

```powershell
# 1. Instale Hermes e Git (ambos no PATH)
# 2. Baixe o bundle da release v1.1.1
# 3. Extraia e instale:
.\wrappers\windows\hb-install.ps1 -From releases\hb-bundle-v1.1.1.tar.gz

# 4. Verifique:
.\wrappers\windows\hb-install-check.ps1
```

## Reproduzir em outra máquina

```bash
hb-install --bundle        # cria ~/.hermes/hb-bundle.tar.gz
# copie hb-bundle.tar.gz para a nova máquina, depois:
hb-install --from hb-bundle.tar.gz
```

### `hb-auto` — uso seguro

```bash
# Modo OFF (sem aprovação) — REQUER confirmação explícita:
hb-auto --confirm-i-accept-risks "refatore X"

# Windows:
hb-auto.ps1 -ConfirmIAcceptRisks "refatore X"
```

> **⚠️ AVISO**: `hb-auto` desabilita TODAS as aprovações. O modelo pode executar qualquer comando. Use APENAS em repositórios que VOCÊ controla e confia. Em repos de terceiros = execução arbitrária de código.

## Modelo de segurança (leia isto)

A fronteira do projeto é **política, não uma barreira de kernel**:

- `.hermes.md` instrui o modelo a permanecer dentro do repo.
- Checkpoints deixam você *recuperar* (`/rollback`), não *impedir*.
- `hb-auto` (`off`) remove o último gate de aprovação — **só repos confiáveis**.
- **Sem root/proot** = sem isolamento de kernel. No Termux, user namespaces estão desligados.

Este é o teto prático **sem root/proot** (ex.: no Termux, user namespaces desligados). Em PC Linux/macOS normal você pode ir além e usar container/namespace real para isolamento de sistema de arquivos — fora do escopo desta skill, mas compatível.

## Estrutura

```
skill/hermes-autonomous-dev/   a skill do Hermes (SKILL.md + references/templates/scripts)
profiles/                     autonomous, autonomous-prod, autonomous-yolo (config.yaml)
stacks/                       regras de fronteira por linguagem
wrappers/                     hb, hb-auto, hb-prod, hb-audit, hb-install
wrappers/windows/             hb.ps1, hb-auto.ps1, hb-prod.ps1, hb-audit.ps1, hb-install.ps1, hb.bat, hb-install-check.ps1
releases/                     hb-bundle-v1.1.2.tar.gz (+ .sha256)
manifest.yaml                 manifesto de componentes
```

## Licença

MIT — veja `LICENSE`.