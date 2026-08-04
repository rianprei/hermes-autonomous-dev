# Hermes Autonomous Dev Kit (v1.1.2)

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
| **Windows** | ✅ Testado em CI | Scripts PowerShell em `wrappers/windows/` (`hb.ps1`, `hb-auto.ps1`, etc.) + `hb.bat`. Requer PowerShell 5.1+ (já no Windows 10/11) e `hermes`/`git` no PATH. Validado por CI do GitHub Actions (windows-latest). Veja `wrappers/windows/README.md`. |
| **Termux (Android)** | 🟡 Com workaround | Hermes nativo falha no Termux (issue upstream #17009). **Workaround**: use `proot-distro install ubuntu` e rode o Hermes dentro do Ubuntu no Termux. O wrapper `hb` detecta e usa automaticamente. |
| **VPS / remoto** | ✅ Declarado | Linux remoto — funciona igual; rode o Hermes lá e acesse via gateway. |

> **Nota**: No Windows o conceito de "root" não se aplica (lá é Admin/UAC); a fronteira de projeto (`.hermes.md`) funciona igual. Windows agora tem validação via CI do GitHub Actions.

## Instalação

```bash
# A partir do repositório (Linux/macOS/Termux)
hb-install --from releases/hb-bundle-v1.1.2.tar.gz
# Windows: veja wrappers/windows/README.md (hb-install.ps1)

hb doctor          # verifica
cd /seu/projeto
hb                 # 1ª execução cria o .hermes.md — revise, depois rode de novo
```

### Windows

```powershell
# 1. Instale Hermes e Git (ambos no PATH)
# 2. Baixe o bundle da release v1.1.2
# 3. Extraia e instale:
.\wrappers\windows\hb-install.ps1 -From releases\hb-bundle-v1.1.2.tar.gz

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

### Limitações conhecidas

| Limitação | Detalhes | Mitigação |
|-----------|----------|-----------|
| **Blocklist é apenas textual** | A lista de comandos perigosos está em `security/blocklist.txt` e no `.hermes.md` como instrução ao modelo. Não há interceptação técnica no runtime. | Use `hb` (modo `smart`) que mantém gate de aprovação; revise comandos antes de aprovar. |
| **`hb-auto` flag position** | Antes aceitava `--confirm-i-accept-risks` apenas como primeiro argumento. **Corrigido na v1.1.2** — agora aceita em qualquer posição. | Use a flag obrigatória. |
| **Termux nativo não funciona** | Hermes falha no Termux sem `proot-distro` (issue upstream #17009). | Use `proot-distro install ubuntu` — o wrapper `hb` detecta e usa automaticamente. |
| **Sem sandbox de SO** | Fronteira é apenas um prompt ao modelo. Modelo pode ignorar. | Não use `hb-auto` em repos de terceiros. Use `hb` para gate de aprovação. |
| **Prompt injection via arquivos** | Se o modelo abrir arquivo malicioso, pode sobrescrever a interpretação da fronteira. | Não processe arquivos não confiáveis com `hb-auto`. |
| **`hb-audit` diverge Linux/Windows** | Linux usa Python + SQLite; Windows usa `sqlite3.exe` CLI. Implementações diferentes. | Use `hb doctor` para health check unificado. |
| **Bundle não reproduzível** | Bundle publicado não foi gerado pelo `hb-install --bundle` atual. | Use `hb-install --from` com source do repo (via `HB_INSTALL_SRC`). |
| **Zero testes automatizados** | CI testa apenas caminho feliz. Sem smoke tests para edge cases. | Planejado para v1.2.0. |

## Estrutura

```
skill/hermes-autonomous-dev/   a skill do Hermes (SKILL.md + references/templates/scripts)
profiles/                     autonomous, autonomous-prod, autonomous-yolo (config.yaml)
stacks/                       regras de fronteira por linguagem
wrappers/                     hb, hb-auto, hb-prod, hb-audit, hb-install
wrappers/windows/             hb.ps1, hb-auto.ps1, hb-prod.ps1, hb-audit.ps1, hb-install.ps1, hb.bat, hb-install-check.ps1
releases/                     hb-bundle-v1.1.2.tar.gz (+ .sha256)
manifest.yaml                 manifesto de componentes
security/blocklist.txt        fonte única de comandos perigosos
```

## Licença

MIT — veja `LICENSE`.