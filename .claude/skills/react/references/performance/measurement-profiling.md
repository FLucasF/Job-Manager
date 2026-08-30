# Measurement Profiling — React mechanisms

Stack mechanisms for the `performance/measurement-profiling.md` concern reference. The rule lives in the
concern reference; this file states how React expresses it.

## React DevTools Profiler

[DEFAULT] Para problema de rendering React, use React DevTools Profiler antes de aplicar memoization manual.

Procure:

```text
which interaction triggered render?
which subtree consumed meaningful time?
which components rerendered?
was the work expensive or merely frequent?
```

[HARD RULE] "Renderizou novamente" não significa automaticamente "problema de performance".

Render barato pode ser preferível a complexidade de memoization.

## React `<Profiler>`

[SITUATIONAL] Use `<Profiler>` quando a aplicação/teste precisa coletar timing programaticamente para uma subtree.

Exemplo conceitual:

```tsx
<Profiler id="VacancyList" onRender={onRender}>
  <VacancyList />
</Profiler>
```

[HARD RULE] Não mantenha instrumentation de profiling espalhada pela aplicação sem uma finalidade explícita.
