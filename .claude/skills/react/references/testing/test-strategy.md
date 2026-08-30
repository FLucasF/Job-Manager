# Test Strategy — React mechanisms

Stack mechanisms for the `testing/test-strategy.md` concern reference. The rule lives in the
concern reference; this file states how React expresses it.

## Prefer Integration for User-Facing React Behavior

[DEFAULT] Para comportamento visível de uma feature React, prefira integração quando o risco depende de colaboração.

```text
CreateVacancyForm
→ fields
→ validation
→ submission
→ pending
→ server result
```

Testar cada parte separadamente pode deixar o fluxo real quebrado enquanto todas as unidades continuam verdes.
