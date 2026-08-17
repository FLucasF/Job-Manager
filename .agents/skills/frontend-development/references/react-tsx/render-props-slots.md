# React Render Props and Slots with TypeScript

Referência para composição quando o consumidor precisa controlar conteúdo ou renderização.

## Contents

- Composition strategy
- Simple slots
- Render props
- Generic render functions
- API complexity
- Responsibility boundaries

## Composition Strategy

[DEFAULT] Use a forma mais simples de composição que atende ao contrato.

```text
static renderable content
→ React.ReactNode slot

consumer needs data from component
→ render function

more structured reusable composition
→ consider component-specific composition patterns
```

[HARD RULE] Não escolha Render Props quando `children` ou um slot `ReactNode` simples resolve o caso.

## Simple Slots

Use `React.ReactNode` para regiões cujo consumidor apenas fornece conteúdo.

```tsx
interface EmptyStateProps {
  icon?: React.ReactNode
  action?: React.ReactNode
  children: React.ReactNode
}
```

## Render Props

[SITUATIONAL] Use uma render function quando o componente possui o dado/contexto, mas o consumidor decide como apresentá-lo.

```tsx
interface ListProps<T> {
  items: T[]
  renderItem: (item: T) => React.ReactNode
}
```

Aqui o componente controla iteração; o consumidor controla a representação do item.

## Generic Render Functions

Preserve a relação genérica entre dados e callback:

```tsx
interface DataTableProps<T> {
  data: T[]
  columns: {
    key: string
    header: string
    render: (item: T) => React.ReactNode
  }[]
  keyExtractor: (item: T) => string
  emptyState?: React.ReactNode
}
```

[HARD RULE] O render callback deve receber o mesmo tipo de dado que o componente controla.

## Slot vs Render Prop

Use:

```tsx
emptyState?: React.ReactNode
```

quando não há dados a fornecer ao consumidor.

Use:

```tsx
renderItem: (item: T) => React.ReactNode
```

quando a customização depende de um valor produzido/gerenciado pelo componente.

## API Complexity

[HARD RULE] Flexibilidade adicional precisa justificar a complexidade adicional.

Render Props podem reduzir legibilidade quando usados para casos triviais.

[DEFAULT] Antes de adicionar uma render function, verifique se:

- prop normal;
- `children`;
- slot `ReactNode`;

já resolvem o caso.

## Responsibility Boundaries

Esta referência cobre:

- simple slots;
- render functions;
- typed render callbacks.

Outras responsabilidades:

- `children` → `children.md`;
- generic component relationships → `generic-components.md`;
- component architecture/composition → architecture references.
