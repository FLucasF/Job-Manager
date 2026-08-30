# Rendering Performance — React mechanisms

Stack mechanisms for the `performance/rendering-performance.md` concern reference. The rule lives in the
concern reference; this file states how React expresses it.

## React Compiler

[HARD RULE] Antes de recomendar `React.memo`, `useMemo` ou `useCallback` em código novo, verifique se React Compiler está habilitado no projeto.

Quando habilitado, o Compiler pode aplicar memoization automaticamente.

[DEFAULT] Em código novo compilado, confie primeiro na otimização do Compiler e use memoization manual apenas quando existir necessidade de controle/evidência.

[HARD RULE] Não remova memoization existente em massa só porque Compiler está habilitado.

Mudanças em memoization existente precisam de validação.

## `React.memo`

[SITUATIONAL] Use quando:

```text
component rerenders frequently
+
props often remain equivalent
+
render cost is meaningful
+
profiling shows benefit
```

[HARD RULE] `memo` é performance optimization, não correção de comportamento.

Se component quebra ao rerenderizar, corrija pure rendering/state/effects.

## Main Thread Work Outside React

[HARD RULE] Se profiling mostra custo em parsing, third-party script, layout ou outro código fora do render React, não tente resolver com `memo`.

Use o boundary responsável.
