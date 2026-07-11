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
- **Windows**: o wrapper `hb` é `/bin/sh`; rode dentro do **WSL** (Ubuntu no Windows) como um Linux comum. Sem WSL não roda.
- **VPS / remoto**: é só Linux remoto — funciona igual; você pode rodar o Hermes lá e acessar via gateway.

O foco em "Termux sem root/proot" veio do ambiente onde a skill foi criada. Em
um PC Linux normal funciona do mesmo jeito — e melhor, pois não há a limitação
de user namespaces desligados.

## Instalação

```bash
# A partir do repositório

hb-install --from releases/hb-bundle-v1.0.0.tar.gz
# …ou a partir de um bundle portátil
hb-install --from hb-bundle.tar.gz

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

Este é o teto prático **sem root/proot** no Termux (user namespaces
desabilitados). Para isolamento real de sistema de arquivos seria preciso
container/namespace (root ou userns) — fora do escopo aqui.

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
