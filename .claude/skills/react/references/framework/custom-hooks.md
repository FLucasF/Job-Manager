# React Custom Hooks with TypeScript

Referência para design e tipagem de custom hooks.

## Contents

- Hook responsibility
- Return inference
- Return shape
- Generic hooks
- Generic relationships
- Public contract
- Responsibility boundaries

## Hook Responsibility

[DEFAULT] Extraia um custom hook quando existe lógica React reutilizável ou uma responsabilidade coerente que merece uma API própria.

[HARD RULE] Não crie hook apenas para mover algumas linhas para outro arquivo.

O hook deve melhorar ownership, reutilização ou legibilidade do comportamento.

## Return Type

[DEFAULT] Deixe o TypeScript inferir o retorno quando a implementação já define o contrato de forma clara.

```tsx
function useToggle(initial = false) {
  const [value, setValue] = useState(initial)

  const toggle = () => setValue(current => !current)

  return {
    value,
    toggle,
  }
}
```

[SITUATIONAL] Anote explicitamente o retorno quando o hook é parte de uma API pública cuja estabilidade precisa ser declarada, como em uma biblioteca.

## Return Shape

[SITUATIONAL] Use `as const` quando a forma de retorno precisa preservar tipos literais/tuple semantics que seriam alargados sem isso.

Não adicione `as const` automaticamente a todo objeto retornado.

## Generic Hooks

[SITUATIONAL] Use generics quando o hook precisa funcionar com múltiplos tipos mantendo relações entre eles.

```tsx
function useSelection<T>(
  initial: T | null,
) {
  const [value, setValue] = useState<T | null>(initial)

  return {
    value,
    setValue,
  }
}
```

[DEFAULT] Prefira que `T` seja inferível a partir dos argumentos.

```tsx
const selection = useSelection({
  id: '1',
  name: 'React',
})
```

## Preserve Generic Relationships

Quando uma operação depende de uma key e do valor correspondente, preserve a relação:

```ts
function setValue<
  T,
  K extends keyof T,
>(
  object: T,
  key: K,
  value: T[K],
) {
  // ...
}
```

A mecânica geral de generics pertence às referências de TypeScript.

## Public Contract

[HARD RULE] Consumidores devem depender da API do hook, não de detalhes internos como:

- quantidade de states;
- efeitos internos;
- estrutura de helpers;
- ordem interna das operações.

[DEFAULT] Mantenha o retorno tão pequeno quanto necessário para o consumidor.

## Do Not Couple Component Props to Hook Implementation

[HARD RULE] Não use `ReturnType<typeof useX>` para definir automaticamente props de um componente consumidor.

O contrato da UI deve refletir necessidades da UI.

Consulte `props.md`.

## Responsibility Boundaries

Esta referência cobre:

- custom hook ownership;
- return inference;
- generic hooks;
- public hook contracts.

Outras responsabilidades:

- stale closures/dependencies → `stale-callbacks.md`;
- memoization → `memo-stable-props.md`;
- generic TypeScript mechanics → skill `typescript` (inference-generics.md);
- server-state placement → architecture.
