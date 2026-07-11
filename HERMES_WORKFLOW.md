# Hermes Workflow (autonomous dev environment)

Setup Termux-native, sem root, sem proot. Equivalente ao Claude Code
"skip permissions + project boundary" usando mecanismos nativos do Hermes.

## Wrappers

| Comando     | Modo Hermes      | Uso                              |
|-------------|------------------|----------------------------------|
| `hb`        | `smart`          | dia a dia (seguro)               |
| `hb-auto`   | `off`            | repo confiável (modo Claude Code)|
| `hb-prod`   | `smart` + whitelist | projeto importante (conservador)|
| `hb doctor` | —                | checa saúde do setup             |
| `hb audit`  | —                | resumo da última sessão (state.db)|

## Fluxo recomendado

Antes de grandes mudanças:
1. `git branch <feature>`  (nunca mexer direto em main/master)
2. `hb doctor`            (valida hermes/modelo/profiles/checkpoints)
3. confirmar que checkpoint está ON (sempre está via wrapper)

Durante:
- `cd /projeto && hb`              trabalho normal
- `cd /projeto && hb -s python`    aplica regras de stack (1ª vez)
- `cd /projeto && hb-auto "task"`  só em repo com backup/controle
- `cd /projeto && hb-prod "task"`  produção (sem install automático, branch obrigatória)

Depois:
- `hb audit`              (o que rolou: arquivos, comandos, checkpoints)
- rodar testes do repo
- `git commit` / `git stash pop` (o wrapper já faz stash de checkpoint)

## Recuperação

- Checkpoint do Hermes: `/rollback` ou `/rollback N` dentro do chat.
- Stash do wrapper: `git stash pop` para restaurar estado pré-sessão.
- `.hermes.md` do repo define a fronteira (não é barreira de kernel).

## Limites conhecidos

- Fronteira é instrucional (`.hermes.md` + checkpoint), não sandbox de SO.
  Teto sem root/proot no Termux (userns desligado).
- `hb-auto` remove o gate de aprovação — usar só em repo confiável.
- Para isolamento real (barreira, não política), seria preciso container/
  namespace, que exige kernel com userns ou root (vetado neste ambiente).

## Reproduzir em outra máquina

`hb-install` recria profiles + stacks + templates + wrappers + permissões.
