---
name: react
description: React framework idioms and APIs: components and props, hooks and custom hooks, context, refs, effects and synchronization, events, memoization and stable props, render props and slots, useReducer, React Compiler, lazy loading and profiling. Use as the framework overlay when the affected boundary uses React. Load together with the concern skill that owns the decision. Do not use for TypeScript language semantics, routing or styling, which have their own overlays.
---

# React

Framework overlay for the `react` technology. It carries only idioms and APIs.

The concern skill owns the decision: frontend-development. Load it for the rule and load
this skill for the mechanism. When the two appear to disagree, the rule wins and
the disagreement is reported.

`CLAUDE.md` governs the spec gate, RPI workflow, architecture authority,
security, validation and completion. This skill authorizes no technology,
dependency, requirement or architecture.

## Reference Routing

- Props, native wrappers, optionality, callback contracts e hook-derived prop coupling:
  [props.md](references/framework/props.md)

- `children`, `React.ReactNode` e conteúdo renderizável:
  [children.md](references/framework/children.md)

- Event handlers e callbacks públicos:
  [events.md](references/framework/events.md)

- DOM refs, React 19 ref props e compatibilidade com `forwardRef`:
  [refs.md](references/framework/refs.md)

- Design e tipagem de custom hooks:
  [custom-hooks.md](references/framework/custom-hooks.md)

- Context, providers, consumer hooks e `use()`:
  [context.md](references/framework/context.md)

- Effects, external synchronization, dependencies, cleanup e Effect Events:
  [effects-synchronization.md](references/framework/effects-synchronization.md)

- Componentes genéricos e relações entre props:
  [generic-components.md](references/framework/generic-components.md)

- Render Props, render functions e slots:
  [render-props-slots.md](references/framework/render-props-slots.md)

- Estado local com actions tipadas e `useReducer`:
  [use-reducer.md](references/framework/use-reducer.md)

- Stale closures, dependency arrays e callbacks:
  [stale-callbacks.md](references/framework/stale-callbacks.md)

- `React.memo`, memoization e estabilidade de props:
  [memo-stable-props.md](references/framework/memo-stable-props.md)

- APIs tipadas de componentes de design system:
  [design-system-components.md](references/framework/design-system-components.md)

- Revisão React + TypeScript:
  [review-checklist.md](references/framework/review-checklist.md)

[HARD RULE] Mecânica geral da linguagem TypeScript pertence à skill `typescript`;
esta skill cobre apenas decisões específicas de React.

## Concern Overlays

These files carry only the React mechanism for a concern whose rule lives in
`frontend-development`. Read the concern reference first.

- architecture / data access:
  [data-access.md](references/architecture/data-access.md)
- architecture / layered architecture:
  [layered-architecture.md](references/architecture/layered-architecture.md)
- performance / bundle loading:
  [bundle-loading.md](references/performance/bundle-loading.md)
- performance / measurement profiling:
  [measurement-profiling.md](references/performance/measurement-profiling.md)
- performance / rendering performance:
  [rendering-performance.md](references/performance/rendering-performance.md)
- security / untrusted content:
  [untrusted-content.md](references/security/untrusted-content.md)
- testing / test strategy:
  [test-strategy.md](references/testing/test-strategy.md)
