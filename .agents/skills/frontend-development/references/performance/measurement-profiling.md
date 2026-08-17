# Frontend Performance Measurement and Profiling

Referência para diagnosticar performance antes de alterar código.

## Contents

- Measure before optimizing
- Define the user-visible problem
- Reproduce consistently
- Development vs production
- React Profiler
- Browser profiling
- Network and bundle evidence
- Before/after validation
- Performance budgets
- Responsibility boundaries

## Measure Before Optimizing

[HARD RULE] Não otimize por suposição.

Use:

```text
observe problem
→ reproduce
→ measure
→ identify bottleneck
→ change the smallest responsible boundary
→ measure again
```

[HARD RULE] Não adicione memoization, lazy loading, caching ou custom chunking apenas porque "pode melhorar performance".

## Start From the User-Visible Problem

[DEFAULT] Descreva primeiro o sintoma.

Exemplos:

```text
typing feels delayed
opening dialog freezes briefly
route takes long to become useful
large list scrolls poorly
initial page loads slowly
content jumps while loading
```

Evite começar por:

```text
this component rerenders
this bundle looks large
this hook could use useMemo
```

sem evidência de impacto.

## Define the Interaction or Load Path

[DEFAULT] Meça o fluxo real que apresenta problema.

Exemplo:

```text
open vacancy page
→ content appears
→ user clicks Edit
→ dialog becomes interactive
```

Não misture várias jornadas na mesma medição.

## Reproduce Consistently

[HARD RULE] Compare medições sob condições semelhantes.

Controle quando relevante:

- route;
- dataset size;
- device/CPU throttling;
- network throttling;
- browser;
- production build;
- cache state.

Uma comparação inválida pode produzir otimização baseada em ruído.

## Development vs Production

[HARD RULE] Não use timings de desenvolvimento como evidência final de performance de produção.

Development pode incluir:

```text
Strict Mode checks
HMR instrumentation
unoptimized modules
extra warnings
source tooling
```

[DEFAULT] Use build de produção para validar impacto real quando a tarefa depende de números.

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

## `actualDuration` vs `baseDuration`

[SITUATIONAL] Ao usar `<Profiler>`, interprete as métricas no contexto:

```text
actualDuration
→ custo do update observado

baseDuration
→ estimativa do custo sem otimizações de subtree
```

Não transforme um único sample em conclusão definitiva.

## Browser Performance Tools

[DEFAULT] Quando o problema envolve main thread/browser work, use profiling do browser para identificar:

```text
long tasks
JavaScript execution
style/layout
paint
event handling
network timing
```

[HARD RULE] Não atribua um delay ao React quando o perfil mostra que o custo está em outra camada.

## Network Evidence

Para problema de carregamento, inspecione:

```text
request start time
waterfalls
payload size
duplicate requests
cache behavior
priority
response latency
```

Depois consulte `data-network.md`.

## Bundle Evidence

Para problema de JavaScript inicial:

```text
production bundle
→ entry chunks
→ async chunks
→ unexpectedly large dependencies
```

Depois consulte `bundle-loading.md`.

[HARD RULE] Não faça custom chunking antes de confirmar que bundle/chunk loading é realmente o gargalo.

## Core Web Vitals

Para problemas de experiência de página, classifique quando aplicável:

```text
loading
→ LCP

interaction responsiveness
→ INP

unexpected layout movement
→ CLS
```

Detalhes pertencem a `browser-performance.md`.

## Field vs Lab

[HARD RULE] Lab e field data respondem perguntas diferentes.

```text
lab
→ reproduce and diagnose under controlled conditions

field
→ understand real-user experience
```

[DEFAULT] Quando field data existe, use-o para confirmar que o problema afeta usuários reais.

Não descarte field data porque uma máquina de desenvolvimento está rápida.

## Before/After Comparison

[HARD RULE] Toda otimização deliberada deve possuir uma forma de verificar impacto.

Exemplo:

```text
before
→ interaction profile

change
→ component/state boundary

after
→ repeat same interaction
```

Se não existe diferença relevante, reavalie a complexidade adicionada.

## Avoid Micro-Benchmarks Without Context

[HARD RULE] Não otimize uma função isolada de microsegundos se ela não aparece no hot path real.

Performance local não implica impacto perceptível.

## Performance Regression

[DEFAULT] Se um problema importante já ocorreu antes, considere uma proteção apropriada:

```text
automated benchmark
performance budget
bundle check
browser metric monitoring
```

somente se o projeto possui infraestrutura adequada.

Não transforme todo bug em performance test automatizado.

## Performance Budgets

[SITUATIONAL] Budgets podem ser úteis quando um limite mensurável representa um requisito real.

Exemplos:

```text
initial JS size
LCP threshold
known interaction duration
```

[HARD RULE] Não invente thresholds locais sem requisito, baseline ou padrão do projeto.

## Profiling Changes Behavior

[DEFAULT] Instrumentation possui overhead.

Use profiling para encontrar tendências/bottlenecks, não como relógio absoluto perfeito.

## Responsibility Boundaries

Esta referência é dona de:

- measurement-first workflow;
- React/browser profiling;
- before/after validation;
- deciding which performance reference to load next.

Outras responsabilidades:

- React rendering optimization → `rendering-performance.md`;
- code/bundle loading → `bundle-loading.md`;
- requests/cache/waterfalls → `data-network.md`;
- Core Web Vitals/browser metrics → `browser-performance.md`.
