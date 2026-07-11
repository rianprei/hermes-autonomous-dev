# Wrappers — Referência Rápida

## hb
Modo diário (smart). Inicia Hermes no profile `autonomous` com `approvals.mode: smart`.

```bash
hb                    # modo interativo
hb "refatore X"       # comando único
hb -s python          # primeira vez: copia stack template
```

## hb-auto
Modo sem aprovação (off). **Requer flag explícita**.

```bash
hb-auto --confirm-i-accept-risks "refatore X"
```

⚠️ Remove TODAS as aprovações. Use só em repos próprios/confiáveis.

## hb-prod
Modo conservador (smart + whitelist + branch obrigatória).

```bash
hb-prod "corrija bug crítico"
```

## hb doctor
Health check do ambiente.

```bash
hb doctor
```

## hb audit
Auditoria da última sessão (lê `state.db`).

```bash
hb audit
```

## hb-install
Reproduz o ambiente (profiles, stacks, wrappers, skill).

```bash
hb-install --bundle          # gera bundle em ~/.hermes/hb-bundle.tar.gz
hb-install --from bundle.tar # instala a partir de bundle
```
