# React Props with TypeScript

Referência de decisões para contratos de props em componentes React.

## Contents

- Props strategy
- Required vs optional
- Native element wrappers
- Prop collisions
- Public callbacks
- Hook-derived props
- Responsibility boundaries

## Props Strategy

[DEFAULT] Para objetos de props, prefira `interface` quando isso estiver alinhado ao padrão do projeto.

```tsx
interface ButtonProps {
  variant: 'primary' | 'secondary' | 'ghost'
  size?: 'sm' | 'md' | 'lg'
  isLoading?: boolean
}
```

[HARD RULE] O contrato deve representar o que o componente realmente exige.

Não torne props opcionais apenas para eliminar erros do TypeScript.

## Required vs Optional

Use `?` somente quando a ausência da prop é válida.

```tsx
interface TextFieldProps {
  label: string
  error?: string
}
```

Se `label` é obrigatório para o contrato do componente, mantenha-o obrigatório.

[HARD RULE] Não transfira verificações desnecessárias para todos os consumidores tornando tudo opcional.

## Wrapping Native Elements

[DEFAULT] Quando um componente encapsula um elemento HTML nativo, preserve os atributos nativos relevantes.

```tsx
interface ButtonProps
  extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant: 'primary' | 'secondary' | 'ghost'
}
```

No componente:

```tsx
function Button({
  variant,
  children,
  ...rest
}: ButtonProps) {
  return (
    <button {...rest}>
      {children}
    </button>
  )
}
```

[HARD RULE] Não descarte atributos nativos sem uma decisão explícita de API.

## Prop Collisions with Native Attributes

Quando uma prop customizada reutiliza um nome nativo com outro contrato, remova primeiro a definição nativa.

```tsx
type Base = Omit<
  React.InputHTMLAttributes<HTMLInputElement>,
  'size' | 'onChange'
>

interface TextFieldProps extends Base {
  size: 'sm' | 'md' | 'lg'
  onChange: (value: string) => void
  label: string
}
```

[DEFAULT] Use `Omit` somente para conflitos reais.

## Public Callback Props

[DEFAULT] Exponha valores e intenções do componente, não detalhes do evento DOM usado internamente.

Prefira:

```tsx
interface SearchBarProps {
  onSearch: (query: string) => void
}
```

a expor `React.ChangeEvent<HTMLInputElement>` quando o consumidor só precisa do valor.

Detalhes de event typing pertencem a `events.md`.

## Do Not Derive Props from Hook Return Types

[HARD RULE] Não derive o contrato público de um componente diretamente da implementação de um hook.

Evite:

```ts
type Props = ReturnType<typeof useVacancies>
```

Isso acopla a UI à forma atual do retorno do hook.

Defina o contrato do componente a partir das necessidades da UI:

```ts
interface VacancyListProps {
  vacancies: Vacancy[]
  onSelect: (id: string) => void
}
```

O hook pode evoluir sem alterar desnecessariamente a API do componente.

## Responsibility Boundaries

Esta referência cobre:

- required/optional props;
- native element wrappers;
- prop collisions;
- callback contracts;
- hook-derived prop coupling.

Outras responsabilidades:

- conteúdo renderizável → `children.md`;
- React events → `events.md`;
- refs → `refs.md`;
- generic component APIs → `generic-components.md`;
- design-system variant APIs → `design-system-components.md`.
