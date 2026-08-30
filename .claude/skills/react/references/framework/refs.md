# React Refs with TypeScript

Referência para refs de elementos DOM e APIs de componentes que precisam expor acesso imperativo.

## Contents

- When to use refs
- React 19+
- Older React compatibility
- Native element props
- Ref boundaries
- Responsibility boundaries

## When to Use Refs

[SITUATIONAL] Use refs quando acesso direto ao DOM é realmente necessário, por exemplo:

- focus;
- measurement;
- scroll;
- animation;
- integração imperativa com API externa.

[HARD RULE] Não use ref para substituir fluxo normal de props/state.

## React 19+

[DEFAULT] Em React 19+, function components podem receber `ref` como prop.

```tsx
interface InputProps
  extends React.ComponentPropsWithoutRef<'input'> {
  label: string
  ref?: React.Ref<HTMLInputElement>
}
```

```tsx
function Input({
  label,
  ref,
  ...rest
}: InputProps) {
  return (
    <label>
      {label}
      <input ref={ref} {...rest} />
    </label>
  )
}
```

Não introduza `forwardRef` em código React 19+ sem necessidade de compatibilidade.

## Older React Compatibility

[SITUATIONAL] Em código React anterior ao suporte de `ref` como prop, use `forwardRef` quando o componente precisar encaminhar a ref.

```tsx
const Input = React.forwardRef<
  HTMLInputElement,
  InputProps
>((props, ref) => {
  return <input ref={ref} {...props} />
})
```

Quando essa forma for usada, mantenha o componente identificável nas ferramentas de desenvolvimento quando o projeto exigir isso.

[DEFAULT] Verifique a versão do React antes de introduzir um padrão legado.

## `ComponentPropsWithoutRef`

[DEFAULT] Quando a `ref` é tratada separadamente, use:

```tsx
React.ComponentPropsWithoutRef<'input'>
```

para os demais atributos nativos.

[HARD RULE] Evite modelos que introduzam duas definições concorrentes de `ref`.

## Ref Boundaries

[HARD RULE] Exponha uma ref somente quando o consumidor realmente precisa de acesso imperativo ao elemento/handle.

Não transforme refs em uma API paralela para:

- atualizar estado;
- passar dados;
- disparar lógica que deveria ser declarativa.

## Responsibility Boundaries

Esta referência cobre:

- DOM refs;
- ref forwarding/prop;
- native element typing relacionado a refs.

Outras responsabilidades:

- props de wrappers → `props.md`;
- focus behavior → accessibility references;
- state/data flow → architecture and React references.
