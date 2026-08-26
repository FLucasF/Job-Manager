# React Children with TypeScript

Referência para conteúdo renderizável recebido por componentes React.

## Children

[DEFAULT] Use `React.ReactNode` quando a prop pode receber conteúdo renderizável normal do React.

```tsx
interface CardProps {
  title: string
  children: React.ReactNode
}
```

`React.ReactNode` representa, entre outros:

- elementos React;
- strings;
- números;
- fragments;
- `null`.

## Do Not Use `JSX.Element` for General Children

[HARD RULE] Não use `JSX.Element` como tipo padrão de `children`.

Ele é restritivo demais para todo o conjunto de valores renderizáveis.

No React atual, se houver necessidade real de representar especificamente um elemento JSX, use o namespace React correspondente, como:

```ts
React.JSX.Element
```

Mas isso não substitui `React.ReactNode` para `children` comum.

## Optional Renderable Props

Props de conteúdo opcionais também podem usar `React.ReactNode`.

```tsx
interface BadgeProps {
  icon?: React.ReactNode
  children: React.ReactNode
}
```

## Slot Content

[DEFAULT] Slots simples podem ser modelados como props `React.ReactNode`.

```tsx
interface PanelProps {
  header?: React.ReactNode
  footer?: React.ReactNode
  children: React.ReactNode
}
```

Quando o consumidor precisa receber dados do componente para decidir a renderização, considere render function em vez de `ReactNode`.

Consulte `render-props-slots.md`.

## Responsibility Boundaries

Esta referência cobre apenas conteúdo renderizável simples.

Outras responsabilidades:

- render functions e slots avançados → `render-props-slots.md`;
- props gerais → `props.md`;
- componentes genéricos → `generic-components.md`.
