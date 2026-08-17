# React Events with TypeScript

Referência para tipagem de eventos React e callbacks públicos de componentes.

## Inline Handlers

[DEFAULT] Em handlers inline, deixe o TypeScript inferir o evento quando o contexto já fornece o tipo correto.

```tsx
<input
  onChange={(event) => {
    console.log(event.target.value)
  }}
/>
```

Não adicione annotation que apenas repete a inferência.

## Extracted Handlers

Quando o handler é extraído e perde o contextual typing, use o tipo de evento correspondente.

```tsx
function handleChange(
  event: React.ChangeEvent<HTMLInputElement>,
) {
  console.log(event.target.value)
}
```

Tipos comuns:

```text
React.MouseEvent<HTMLButtonElement>
React.ChangeEvent<HTMLInputElement>
React.FormEvent<HTMLFormElement>
React.KeyboardEvent<HTMLInputElement>
```

## Public Component Callbacks

[DEFAULT] A API pública do componente deve expor o valor ou intenção relevante, não o evento React interno.

```tsx
interface SearchBarProps {
  onSearch: (query: string) => void
}
```

```tsx
function SearchBar({ onSearch }: SearchBarProps) {
  return (
    <input
      onChange={(event) => onSearch(event.target.value)}
    />
  )
}
```

[HARD RULE] Não faça consumidores dependerem do elemento DOM interno sem necessidade.

Evite:

```tsx
onChange: (
  event: React.ChangeEvent<HTMLInputElement>
) => void
```

quando o contrato real é apenas:

```tsx
onSearch: (query: string) => void
```

## Responsibility Boundaries

Esta referência cobre:

- contextual typing de events;
- tipos de handlers extraídos;
- callback contracts.

Outras responsabilidades:

- props gerais → `props.md`;
- keyboard semantics/accessibility → accessibility references;
- form behavior → forms references.
