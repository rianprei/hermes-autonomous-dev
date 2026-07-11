# Hermes Autonomous Dev — Instalação

Equivalente ao "skip permissions + project boundary" do Claude Code, Termux
nativo, SEM root, SEM proot. Usa apenas mecanismos nativos do Hermes.

## Instalar (a partir do bundle)

```bash
# 1. Extraia o bundle
tar -xzf hb-bundle.tar.gz -C ~/

# 2. Instale tudo (perfis, stacks, wrappers, skill)
hb-install --from ~/.hermes/hb-bundle.tar.gz

# 3. Verifique a saúde
hb doctor

# 4. Entre em um repositório git
cd /caminho/do/seu/projeto

# 5. A 1ª execução cria o .hermes.md do projeto — revise e rode de novo
hb

# Uso diário
hb            # modo smart (diário)
hb -s python  # aplica regras de stack (1ª vez)
hb-prod       # produção (conservador)
hb-auto       # modo off — SÓ repos confiáveis
```

## Modos

| Comando   | Modo   | Uso                           |
|-----------|--------|-------------------------------|
| `hb`      | smart  | desenvolvimento diário         |
| `hb-auto` | off    | apenas repositórios confiáveis |
| `hb-prod` | smart+ | produção (whitelist, branch)  |

## Recuperar

- Checkpoint do Hermes: `/rollback` ou `/rollback N` no chat.
- Stash do wrapper: `git stash pop`.
- `hb audit` — o que mudou na última sessão.

## Limites

A fronteira é política (`.hermes.md`) + checkpoints, NÃO um sandbox de kernel.
Teto sem root/proot no Termux. `hb-auto` remove o gate de aprovação — só repos
confiáveis.
