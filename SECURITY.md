# Segurança

Este documento declara, explicitamente, contra o que o Hermes Autonomous Dev
Kit protege e contra o que **não** protege. Leia antes de usar o `hb-auto`.

## Contra o que protege

- **Trabalhar no diretório errado** — o `hb` exige um repo git e imprime um
  resumo de confirmação (projeto / modo / perfil / checkpoints / fronteira)
  antes de iniciar.
- **Comandos destrutivos óbvios** — o `.hermes.md` proíbe `rm -rf /`,
  `git push --force`, `git reset --hard HEAD`, `dd`, `mkfs`, `shutdown`,
  `reboot`, `DROP DATABASE`, etc.
- **Perda de mudanças** — checkpoints do Hermes (`/rollback [N]`) mais um git
  stash criado pelo `hb` antes de cada sessão. Ambos são reversíveis.
- **Regressão de código** — o `hb-prod` exige uma branch de feature dedicada e
  proíbe instalação automática de dependências.
- **Fadiga de aprovação** — o `hb` usa `approvals.mode: smart` (auto-aprova
  risco baixo, pede em risco alto).

## Contra o que NÃO protege

- **Isolamento em nível de kernel** — **não há** container, namespace ou
  filtro de syscall. A fronteira é uma *política* (instruções `.hermes.md` ao
  modelo), não uma barreira do SO. Este é o teto **sem root/proot** no Termux
  (user namespaces desabilitados: `unshare --map-root-user` falha).
- **Modelo que ignora instruções** — se o modelo decidir agir fora do repo, o
  SO não o impedirá. O rollback recupera o estado; não previne a ação.
- **Dependência maliciosa que você aprova** — `hb`/`hb-prod` podem instalar
  deps via o gerenciador do repo; um pacote malicioso que você autorizar vai
  executar.
- **Script externo malicioso executado conscientemente** — qualquer script que
  você pedir ao agente para rodar será executado.
- **Má interpretação de instrução ambígua** — um pedido vago pode ser
  executado de forma diferente do pretendido. Prefira prompts explícitos e
  estreitos.

## Modos — nível de confiança

| Modo       | `approvals.mode` | Gate | Caso de uso                 |
|------------|------------------|------|-----------------------------|
| `hb`       | `smart`          | sim  | desenvolvimento diário       |
| `hb-auto`  | `off`            | **não** | **só** repos confiáveis  |
| `hb-prod`  | `smart` + whitelist | sim | produção / código sensível |

O `hb-auto` remove o último gate de aprovação. **Use apenas em repositórios
que você controla e tem backup.** Não é o padrão.

### `hb-auto` — uso seguro (v1.1.1+)

```bash
# Modo OFF (sem aprovação) — REQUER confirmação explícita:
hb-auto --confirm-i-accept-risks "refatore X"

# Windows:
hb-auto.ps1 -ConfirmIAcceptRisks "refatore X"
```

> **⚠️ AVISO**: `hb-auto` desabilita TODAS as aprovações. O modelo pode executar qualquer comando. Use APENAS em repositórios que VOCÊ controla e confia. Em repos de terceiros = execução arbitrária de código.

## Recomendações

1. Use `hb` por padrão. Reserve `hb-auto` para repos descartáveis ou com backup.
2. Sempre crie uma branch de feature antes de grandes mudanças (`hb-prod` obriga).
3. Rode `hb doctor` após qualquer mudança de ambiente.
4. Verifique a integridade do bundle com o SHA256 publicado antes de instalar:
   `sha256sum -c releases/hb-bundle-v1.1.1.sha256`.
5. Lembre-se: isto é um **workflow seguro**, não uma sandbox.