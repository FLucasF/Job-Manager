# React + TypeScript Review Checklist

Checklist operacional para revisão de componentes, hooks, Context, Effects e APIs React com TypeScript.

[DEFAULT] Use este arquivo primeiro em revisão React + TypeScript.

[HARD RULE] Consulte uma referência detalhada somente quando um item exigir investigação.

## Props

- [ ] Props representam o contrato real do componente?
- [ ] Somente props realmente opcionais usam `?`?
- [ ] Wrappers de elementos nativos preservam atributos necessários?
- [ ] Conflitos com props nativas usam modelagem explícita quando necessário?
- [ ] Callbacks públicos expõem valores/intenção em vez de eventos DOM internos quando possível?
- [ ] Props não são derivadas diretamente de `ReturnType<typeof useX>`?

## Children and Composition

- [ ] Conteúdo renderizável comum usa `React.ReactNode`?
- [ ] `JSX.Element` não é usado como tipo geral de `children`?
- [ ] Slots simples usam `ReactNode` quando suficiente?
- [ ] Render function só existe quando o consumidor precisa de dados do componente?
- [ ] Render Props não adicionam complexidade onde composição simples resolve?

## Events

- [ ] Handlers inline aproveitam contextual typing?
- [ ] Handlers extraídos usam o tipo React adequado?
- [ ] APIs públicas não vazam eventos React sem necessidade?

## Refs

- [ ] Ref é usada apenas para necessidade imperativa real?
- [ ] Código React 19+ evita `forwardRef` desnecessário?
- [ ] Compatibilidade legada só é mantida quando necessária?
- [ ] Ref não substitui fluxo declarativo de props/state?

## Custom Hooks

- [ ] O hook possui responsabilidade/reutilização real?
- [ ] Retorno é inferido quando não precisa de contrato explicitamente publicado?
- [ ] Generics são inferíveis a partir dos argumentos quando possível?
- [ ] Consumers não dependem de detalhes internos do hook?

## Context

- [ ] Context é apropriado para o state/dependency boundary?
- [ ] O tipo do Context está explícito?
- [ ] Ausência do provider é validada quando inválida?
- [ ] Existe consumer hook quando ele centraliza contrato/validação?
- [ ] React 19 usa provider syntax atual quando apropriado?
- [ ] `use()` condicional só é usado quando necessário?

## Effects and Synchronization

- [ ] Cada Effect sincroniza com um sistema externo real?
- [ ] Valor derivável não está sendo copiado para state através de Effect?
- [ ] Operação causada por interação específica ficou em event handler?
- [ ] Dependencies representam todos os reactive values usados?
- [ ] Nenhuma dependency foi omitida apenas para reduzir execuções?
- [ ] `exhaustive-deps` não foi silenciado sem justificativa?
- [ ] `[]` representa realmente ausência de reactive dependencies?
- [ ] Setup possui cleanup simétrico quando necessário?
- [ ] Cleanup continua correto antes de re-synchronization, não apenas no unmount?
- [ ] Processos independentes foram separados em Effects distintos?
- [ ] Objects/functions não causam re-synchronization acidental?
- [ ] Memoization não foi adicionada automaticamente só para estabilizar Effect dependencies?
- [ ] `useEffectEvent` não está escondendo dependency que deveria ser reativa?
- [ ] Fetch em Effect não contorna data-access/server-state abstractions existentes?
- [ ] `useLayoutEffect` só é usado quando pre-paint timing é realmente necessário?
- [ ] O Effect continua correto sob verificações adicionais de development/Strict Mode?

## Generic Components

- [ ] Generic existe porque múltiplos formatos realmente compartilham a API?
- [ ] O mesmo `T` preserva relações entre props dependentes?
- [ ] `T` é inferível a partir das props quando possível?
- [ ] `any`/`unknown` não quebram a relação que justificou o generic?

## State and Reducers

- [ ] `useReducer` é usado porque transições relacionadas justificam a abstração?
- [ ] Actions usam union discriminada quando apropriado?
- [ ] Cada action carrega somente o payload necessário?
- [ ] State placement continua pertencendo à arquitetura?

## Callbacks and Memoization

- [ ] Callbacks não capturam props/state antigos?
- [ ] Dependencies necessárias não foram omitidas para forçar estabilidade?
- [ ] `useCallback` só existe quando identidade de função importa?
- [ ] `React.memo`/`useMemo` não foram adicionados preventivamente?
- [ ] Memoization não está escondendo state placement/composition ruim?

## Design-System Components

- [ ] Variants representam opções reais do design system?
- [ ] API pública não expõe detalhes internos de Tailwind/CSS sem necessidade?
- [ ] Native element behavior é preservado quando necessário?
- [ ] Roles/ARIA seguem a semântica real do componente?

## Cross-Cutting Boundaries

- [ ] Mecânica geral de TypeScript permanece em `references/typescript/`?
- [ ] State placement/data access permanecem em architecture?
- [ ] Form behavior permanece em forms?
- [ ] UI state semantics permanecem em ui-states?
- [ ] Acessibilidade permanece em accessibility?
- [ ] Styling permanece em Tailwind?

## Escalation

```text
props / native wrappers / hook-derived props
→ props.md

children / renderable content
→ children.md

event typing
→ events.md

refs
→ refs.md

custom hooks
→ custom-hooks.md

Context
→ context.md

Effects / synchronization / dependencies / cleanup
→ effects-synchronization.md

generic components
→ generic-components.md

render functions / slots
→ render-props-slots.md

useReducer
→ use-reducer.md

stale closures
→ stale-callbacks.md

memoization / prop identity
→ memo-stable-props.md

design-system APIs
→ design-system-components.md
```

[HARD RULE] Não carregue todas as referências React + TypeScript apenas para uma revisão geral.
