# Fluxo de Trabalho Hermes

Ambiente de desenvolvimento autônomo para Hermes, Termux nativo, sem root,
sem proot. Equivalente ao "skip permissions + project boundary" do Claude Code
usando apenas mecanismos nativos do Hermes.

## Wrappers (em ~/.local/bin)

| Comando     | Modo Hermes      | Uso                              |
|-------------|------------------|----------------------------------|
| `hb`        | `smart`          | desenvolvimento diário (seguro)  |
| `hb-auto`   | `off`            | repo confiável (modo Claude Code)|
| `hb-prod`   | `smart`+whitelist | projeto importante (conservador)|
| `hb doctor` | —                | checa saúde do setup             |
| `hb audit`  | —                | resumo da última sessão (state.db)|

## Arquitetura

```
                hb
                 |
      +----------+----------+
      |          |          |
   doctor     audit       run
                             |
        +--------------------+--------------------+
        |                    |                    |
       hb                 hb-auto              hb-prod
     smart                  off               smart + whitelist
  desenvolvimento        confiança             produção
```

## Como funciona (mecanismos nativos do Hermes)

1. **`approvals.mode`** controla a confirmação de comandos:
   - `manual` — sempre pede (padrão)
   - `smart`   — auto-aprova risco baixo, pede em risco alto (usado por `hb`, `hb-prod`)
   - `off`     — pula todas as aprovações (`--yolo`; usado por `hb-auto`)
   Definido por perfil em `~/.hermes/profiles/<nome>/config.yaml`.

2. **Checkpoints** — o Hermes tira snapshot antes de ops arriscadas; restaure
   com `/rollback` ou `/rollback N` (shadow git store, separado do `.git` do repo).

3. **`.hermes.md`** — regras de fronteira do projeto, auto-carregadas quando o
   Hermes roda dentro do repo (first-match, sobe até a raiz git). É uma
   *política* para o modelo, NÃO uma barreira de kernel.

4. **wrapper `hb`** impõe: (a) estar dentro de um repo git, (b) copia o
   `.hermes.md` certo (genérico ou por stack via `-s`), (c) cria um git stash
   de checkpoint antes de iniciar, (d) imprime resumo de confirmação,
   (e) lança `hermes chat --profile <p> --checkpoints`.

## Fluxo recomendado

Antes de grandes mudanças:
1. `git branch <feature>` (nunca mexa direto em main/master)
2. `hb doctor` (valida hermes/modelo/profiles/checkpoints)
3. confirmar que checkpoint está ON (sempre, via wrapper)

Durante:
- `cd /projeto && hb`                 trabalho normal
- `cd /projeto && hb -s python`       aplica regras de stack (1ª vez)
- `cd /projeto && hb-auto "task"`     só em repo com backup/controle
- `cd /projeto && hb-prod "task"`     produção (sem install auto, branch obrigatória)

Depois:
- `hb audit` (o que rolou: arquivos, comandos, checkpoints)
- rodar testes do repo
- `git commit` / `git stash pop` (o wrapper já fez stash de checkpoint)

## Recuperação

- Checkpoint do Hermes: `/rollback` ou `/rollback N` no chat.
- Stash do wrapper: `git stash pop` para restaurar estado pré-sessão.
- `.hermes.md` define a fronteira (não é barreira de kernel).

## Limites conhecidos

- Fronteira é instrucional (`.hermes.md` + checkpoint), não sandbox de SO.
  Teto sem root/proot no Termux (userns desligado).
- `hb-auto` remove o gate de aprovação — usar só em repo confiável.

## Reproduzir em outra máquina

```bash
hb-install --bundle          # gera ~/.hermes/hb-bundle.tar.gz
hb-install --from /path/hb-bundle.tar.gz   # reconstrói tudo
```
