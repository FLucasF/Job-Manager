# React Rendering Performance

Referência para otimizar rendering React somente após identificar custo relevante.

## Contents

- Fix architecture before memoization
- State placement
- Effect-driven renders
- Expensive calculations
- React Compiler
- `memo`
- `useMemo`
- `useCallback`
- Stable props
- Large lists
- Transitions and deferred work
- Responsibility boundaries

## Diagnose First

[HARD RULE] Consulte `measurement-profiling.md` antes de otimizar rendering.

Não assuma que rerender é um problema apenas porque aparece no Profiler.

## Fix the Cause Before Caching the Symptom

[DEFAULT] Antes de memoization, procure causas estruturais:

```text
state too high in tree
duplicated state
Effect updating state unnecessarily
unstable ownership
expensive work during every render
huge subtree controlled by small local interaction
```

Uma arquitetura melhor frequentemente elimina a necessidade de cache manual.

## Keep State Local

[DEFAULT] Estado transitório deve permanecer no menor boundary necessário.

Exemplo:

```text
hover state
modal local state
input draft
```

não deve subir para um ancestor amplo apenas por conveniência.

State placement detalhado pertence a architecture/state-placement.

## Avoid Effect → State Render Chains

[HARD RULE] Não use Effect para calcular state derivável.

Evite:

```text
render
→ Effect
→ setState
→ render again
```

quando o valor pode ser calculado durante render.

Detalhes pertencem a skill `react` (effects-synchronization.md).

## Expensive Pure Calculations

[SITUATIONAL] Se profiling mostrar cálculo relevante repetido com os mesmos inputs, considere:

```text
better algorithm
precomputation
move work to appropriate boundary
memoization
```

[HARD RULE] Não escolha `useMemo` antes de verificar se o cálculo é realmente caro no hot path.

## Compiler Directives

[SITUATIONAL] Diretivas como:

```text
"use memo"
"use no memo"
```

dependem da configuração do React Compiler.

[HARD RULE] Não adicione diretiva sem verificar `compilationMode` e necessidade real.

## `useMemo`

[SITUATIONAL] Use para cachear resultado de cálculo quando existe benefício medido ou requirement de identity.

```tsx
const visibleItems = useMemo(
  () => expensiveFilter(items, filter),
  [items, filter],
)
```

[HARD RULE] Não use para cálculos triviais por padrão.

[HARD RULE] Não dependa de `useMemo` para correctness.

## `useCallback`

[SITUATIONAL] Use quando function identity realmente participa de uma otimização/contract:

```text
memoized child
effect dependency requiring stable identity
library subscription contract
```

[HARD RULE] Não envolva todo handler em `useCallback`.

Criar uma função durante render normalmente não é por si só um problema.

## Stable Props

[SITUATIONAL] Memoization de child pode ser anulada por props sempre novas:

```text
new object
new array
new callback
```

Mas não estabilize props indiscriminadamente.

Primeiro confirme que:

```text
child memoization exists/helps
+
identity is the reason it rerenders
```

Detalhes da API pertencem a skill `react` (memo-stable-props.md).

## Component Boundaries

[DEFAULT] Quando uma interação local faz uma árvore grande rerenderizar, considere mover state/composition boundary antes de memoizar dezenas de descendants.

Exemplo:

```text
large page
└── small interactive panel owns its own state
```

pode ser melhor que estado no page root.

## Children as Composition Boundary

[SITUATIONAL] Wrappers que recebem `children` podem permitir que uma atualização local do wrapper não recrie a subtree externa da mesma forma.

Não use esse padrão artificialmente; preserve uma composição natural.

## Large Lists

[SITUATIONAL] Para listas grandes, primeiro identifique o gargalo:

```text
expensive item rendering
too many DOM nodes
expensive filtering/sorting
frequent parent updates
```

Possíveis respostas diferentes:

```text
memoization
pagination
virtualization
better state placement
better algorithm
```

[HARD RULE] Não introduza virtualization se a lista real não apresenta custo relevante.

## Keys

[HARD RULE] Use keys estáveis que representem identidade dos itens.

Keys instáveis podem causar remounts e trabalho adicional.

Não use random key em cada render.

Correctness de keys vem antes da performance.

## `startTransition`

[SITUATIONAL] Use transition quando uma atualização não urgente pode ser marcada para manter interação urgente responsiva.

[HARD RULE] Não use transition para esconder uma operação síncrona pesada que deveria ser removida/otimizada.

## `useDeferredValue`

[SITUATIONAL] Pode ser útil quando uma parte mais lenta da UI pode acompanhar uma entrada urgente com atraso controlado.

[HARD RULE] Não substitui debounce/network strategy automaticamente.

Escolha conforme o comportamento desejado.

## Common Bug Patterns

Evite:

- `memo` em todo componente;
- `useMemo` para string/boolean trivial;
- `useCallback` em todo handler;
- memoization para corrigir stale state/effects;
- state alto demais na tree;
- Effect derivando state;
- random keys;
- remover memoization em massa após habilitar Compiler;
- adicionar `"use memo"` sem verificar Compiler config;
- virtualization sem evidência.

## Responsibility Boundaries

Esta referência é dona de:

- rendering cost;
- memoization decision;
- React Compiler performance implications;
- component/state boundaries para render performance;
- large render trees.

Outras responsabilidades:

- mechanics de memo APIs → skill `react` (memo-stable-props.md);
- effects correctness → skill `react` (effects-synchronization.md);
- state ownership → architecture/state-placement;
- profiling → `measurement-profiling.md`.

## Stack Mechanism

The stack-specific mechanisms for this concern live in the overlay skill for the
technology in use, when one exists. This reference states the rule; the overlay
states how the stack expresses it. When no overlay exists, the rule still applies
and the mechanism comes from general knowledge of that technology, declared as
such.
