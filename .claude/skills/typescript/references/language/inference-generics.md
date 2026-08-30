# TypeScript Inference and Generics

Referência de decisões para inferência, contextual typing e generics.

## Contents

- Inference strategy
- Contextual typing
- Generics
- Constraints
- Multiple generic parameters
- Generic return types and callbacks
- React boundary
- Responsibility boundaries

## Inference Strategy

[DEFAULT] Permita inferência quando o tipo já está claro a partir do valor ou contexto.

```ts
const name = "Lucas";
```

Evite annotations que apenas repetem uma inferência óbvia.

[HARD RULE] Não remova um tipo explícito quando ele comunica um contrato necessário que a inferência não preserva adequadamente.

## Contextual Typing

TypeScript pode inferir parâmetros a partir do contrato da função que recebe o callback.

```ts
declare function setup(
  register: (name: string, age: number) => void,
): void;

setup((name, age) => {
  console.log(name, age);
});
```

[DEFAULT] Não anote manualmente parâmetros quando o contexto já fornece tipos corretos e seguros.

## Generics

[DEFAULT] Use generics quando diferentes tipos precisam compartilhar uma abstração mantendo relações entre entrada e saída.

```ts
function identity<T>(value: T): T {
  return value;
}
```

Aqui `T` preserva a relação entre o argumento e o retorno.

[HARD RULE] Não introduza generic apenas para tornar uma API mais abstrata.

A parametrização deve adicionar reutilização ou segurança de tipos real.

## Generic Constraints

Use constraints quando o tipo parametrizado precisa satisfazer um contrato mínimo.

```ts
function getId<T extends { id: number }>(value: T): number {
  return value.id;
}
```

[DEFAULT] Restrinja somente o que a implementação realmente precisa.

## Multiple Generic Parameters

[SITUATIONAL] Use múltiplos parâmetros genéricos quando relações entre tipos distintos precisam ser preservadas.

```ts
class BiMap<K, V> {
  // implementation
}
```

[HARD RULE] Evite múltiplos generics quando eles não adicionam segurança ou reutilização real.

## Generic Return Types

[DEFAULT] Preserve a relação entre input e output quando ela faz parte do contrato.

```ts
function first<T>(values: T[]): T | undefined {
  return values[0];
}
```

Não substitua essa relação por `any`.

## Generic Callbacks

Use generics quando callbacks precisam preservar tipos entre etapas de uma operação.

[HARD RULE] Não use `any` para simplificar um callback quando a relação de tipos pode ser representada de forma segura.

## React Boundary

[HARD RULE] Regras de componentes React genéricos não pertencem a esta referência.

Use:

```text
skill `react` (generic-components.md)
```

para decisões específicas de componentes React.

Esta referência cobre apenas a mecânica geral de inferência e generics da linguagem.

## Responsibility Boundaries

Esta referência cobre:

- inference;
- contextual typing;
- generics;
- constraints;
- generic parameters;
- generic callbacks.

Outras responsabilidades:

- segurança geral de tipos → `type-safety.md`;
- ausência de valores → `nullability.md`;
- componentes React genéricos → skill `react`, referência `generic-components.md`.
