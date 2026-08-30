# React Memoization and Stable Props

Referência para `React.memo` e estabilidade de referências entre renders.

## Memoization Strategy

[SITUATIONAL] Use memoization quando existe um problema real de renderização/performance ou uma boundary cuja identidade de props importa.

[HARD RULE] Não adicione `React.memo`, `useMemo` ou `useCallback` preventivamente por padrão.

## `React.memo` Needs Stable Inputs to Be Useful

Um componente memoizado compara props por referência.

```tsx
<MemoChild style={{ color: 'red' }} />
```

cria um objeto novo a cada render do parent, portanto a prop mudou por referência.

`React.memo` pode não evitar o novo render.

## Stabilize Only When Needed

Quando a estabilidade realmente faz parte da otimização:

```tsx
const childStyle = {
  color: 'red',
} as const
```

```tsx
<MemoChild style={childStyle} />
```

Também pode ser apropriado usar memoização local quando o valor depende de dados do render.

[HARD RULE] Não estabilize cada objeto/callback apenas para “ajudar” React.

A complexidade deve ser justificada por uma boundary real.

## Prefer Simpler Data Flow First

Antes de memoizar, avalie se o problema vem de:

- state colocado alto demais;
- componente com responsabilidade excessiva;
- props muito amplas;
- re-render esperado e barato.

Memoization não substitui boa colocação de estado ou composição.

## Callback Stability

Quando a identidade de callback realmente importa, preserve dependencies corretas.

Nunca omita dependencies para manter a função “estável”.

Consulte `stale-callbacks.md`.

## Responsibility Boundaries

Esta referência cobre memoization e prop identity.

Outras responsabilidades:

- stale callback dependencies → `stale-callbacks.md`;
- state placement → architecture;
- performance measurement específico → ferramentas/processos do projeto.
