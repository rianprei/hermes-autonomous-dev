# Hermes Autonomous Dev Kit (v1.0.0)

Equivalente ao "skip permissions + project boundary" do Claude Code para o
**Hermes Agent** — construído usando apenas mecanismos nativos do Hermes.
Termux nativo, **SEM root, SEM proot**.

## O que ele oferece

| Comando     | Modo Hermes | Uso                                |
|-------------|-------------|------------------------------------|
| `hb`        | `smart`     | desenvolvimento autônomo diário    |
| `hb-auto`   | `off`       | modo sem aprovação (repos confiáveis)|
| `hb-prod`   | `smart`+    | fluxo de produção conservador      |
| `hb doctor` | —           | verificação de saúde do ambiente   |
| `hb audit`  | —           | resumo da última sessão (state.db) |
| `hb-install`| —           | reproduz o ambiente                |

- **Sem prompts de aprovação** → `approvals.mode` (`smart`/`off`) por perfil.
- **Fronteira do projeto** → `.hermes.md` carregado automaticamente dentro do repo.
- **Rollback** → checkpoints do Hermes (`/rollback [N]`) + git stash.
- **Contexto por stack** → `python` / `javascript` / `rust` / `android` / `production`.

## Plataformas

A skill é para **qualquer um que rode o Hermes Agent**, não apenas Termux:

- **Linux** (desktop, server, VPS): caso mais natural — git + bash + hermes nativos.
- **macOS**: funciona (bash, git, hermes instalados via pip/installer).
- **Windows**: suporte **nativo** (sem WSL) via scripts PowerShell em
  `wrappers/windows/` (`hb.ps1`, `hb-auto.ps1`, etc.) + `hb.bat`. Requer
  PowerShell 5.1+ (já vem no Windows 10/11) e `hermes`/`git` no PATH.
  Veja `wrappers/windows/README.md`.
- **VPS / remoto**: é só Linux remoto — funciona igual; você pode rodar o
  Hermes lá e acessar via gateway.

O foco em "Termux sem root/proot" veio do ambiente onde a skill foi criada. Em
um PC Linux/macOS normal funciona do mesmo jeito — e melhor, pois não há a
limitação de user namespaces desligados. No Windows o conceito de "root" não
se aplica (lá é Admin/UAC); a fronteira de projeto (.hermes.md) funciona igual.

## Instalação

```bash
# A partir do repositório (Linux/macOS/Termux)
hb-install --from releases/hb-bundle-v1.0.0.tar.gz
# Windows: veja wrappers/windows/README.md (hb-install.ps1)


hb doctor          # verifica
cd /seu/projeto
hb                 # 1ª execução cria o .hermes.md — revise, depois rode de novo
```

Veja `skill/hermes-autonomous-dev/INSTALL.md` para o guia completo e
`skill/hermes-autonomous-dev/SKILL.md` para o manual operacional.

## Reproduzir em outra máquina

```bash
hb-install --bundle        # cria ~/.hermes/hb-bundle.tar.gz
# copie hb-bundle.tar.gz para a nova máquina, depois:
hb-install --from hb-bundle.tar.gz
```

## Modelo de segurança (leia isto)

A fronteira do projeto é **política, não uma barreira de kernel**:

- `.hermes.md` instrui o modelo a permanecer dentro do repo.
- Checkpoints deixam você *recuperar* (`/rollback`), não *impedir*.
- `hb-auto` (`off`) remove o último gate de aprovação — só repos confiáveis.

Este é o teto prático **sem root/proot** (ex.: no Termux, onde user namespaces
estão desligados). Em um PC Linux/macOS normal você pode ir além e usar
container/namespace real para isolamento de sistema de arquivos — fora do
escopo desta skill, mas compatível. Para isolamento real seria preciso
container/namespace (root ou userns).

## Estrutura

```
skill/hermes-autonomous-dev/   a skill do Hermes (SKILL.md + references/templates/scripts)
profiles/                     autonomous, autonomous-prod, autonomous-yolo (config.yaml)
stacks/                       regras de fronteira por linguagem
wrappers/                     hb, hb-auto, hb-prod, hb-audit, hb-install
releases/                     hb-bundle-v1.0.0.tar.gz (+ .sha256)
manifest.yaml                 manifesto de componentes
```

## Licença

MIT — veja `LICENSE`.
