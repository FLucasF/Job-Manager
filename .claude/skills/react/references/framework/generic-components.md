# React Generic Components with TypeScript

Referência para componentes que trabalham com diferentes tipos preservando relações entre props.

## When to Use

[SITUATIONAL] Use componente genérico quando a mesma API precisa funcionar com múltiplos formatos de dados mantendo type safety.

Exemplos:

- list;
- select;
- table;
- autocomplete;
- reusable data component.

[HARD RULE] Não introduza generic quando uma união concreta ou componente específico representa melhor o domínio.

## Generic Props

```tsx
interface SelectProps<T> {
  items: T[]
  value: T | null
  onChange: (item: T) => void
  getLabel: (item: T) => string
  getKey: (item: T) => string | number
}
```

O mesmo `T` deve representar o mesmo conceito em todas as props relacionadas.

## Preserve Relationships

[HARD RULE] Não perca a relação entre:

```text
items
value
onChange
getLabel
getKey
```

Substituir partes por `unknown`/`any` elimina justamente a segurança que justificou o generic.

## Prefer Inference

[DEFAULT] Estruture as props para que `T` seja inferido a partir do uso.

```tsx
<Select
  items={users}
  value={selectedUser}
  onChange={setSelectedUser}
  getLabel={(user) => user.name}
  getKey={(user) => user.id}
/>
```

Evite exigir generic explícito do consumidor quando as props já fornecem informação suficiente.

## Keep the Generic API Small

[DEFAULT] Não propague `T` para props que não dependem do tipo parametrizado.

Quanto mais relações genéricas desnecessárias, mais difícil fica usar e diagnosticar a API.

## Responsibility Boundaries

Esta referência cobre generic component API design.

Outras responsabilidades:

- generics da linguagem → skill `typescript` (inference-generics.md);
- render functions → `render-props-slots.md`;
- props gerais → `props.md`;
- design-system variants → `design-system-components.md`.
