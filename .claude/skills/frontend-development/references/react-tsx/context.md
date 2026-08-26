# React Context with TypeScript

Referência para Context, providers e consumo seguro em React.

## Contents

- Context responsibility
- Explicit type
- Missing provider
- Consumer hook
- React 19 provider syntax
- Conditional reading
- Provider value
- Responsibility boundaries

## Context Responsibility

[SITUATIONAL] Use Context quando vários descendants precisam de uma dependência/estado compartilhado através de um provider boundary apropriado.

[HARD RULE] Não use Context apenas para evitar passar uma prop por poucos níveis.

Decisão de state placement pertence às referências de architecture.

## Explicit Context Type

[DEFAULT] Defina o contrato do Context explicitamente.

```tsx
interface ThemeContextValue {
  theme: 'light' | 'dark'
  toggleTheme: () => void
}
```

Quando ausência do provider é inválida, represente-a no valor inicial:

```tsx
const ThemeContext =
  createContext<ThemeContextValue | null>(null)
```

## Missing Provider

[HARD RULE] Se o Context exige provider, falhe explicitamente quando ele estiver ausente.

Não permita que consumidores operem silenciosamente com `undefined`/`null` inválido.

## Consumer Hook

[DEFAULT] Centralize o acesso e a validação em um hook:

```tsx
function useTheme(): ThemeContextValue {
  const value = useContext(ThemeContext)

  if (value === null) {
    throw new Error(
      'useTheme must be used within <ThemeContext>'
    )
  }

  return value
}
```

Isso evita repetir checks nos consumidores.

## React 19 Provider Syntax

[DEFAULT] Em React 19, o próprio Context pode ser usado como provider:

```tsx
<ThemeContext value={value}>
  {children}
</ThemeContext>
```

[SITUATIONAL] Preserve sintaxe legada somente quando o código precisa suportar uma versão anterior.

## Conditional Context Reading with `use()`

[SITUATIONAL] Em React 19, `use()` pode ser utilizado quando a leitura do Context precisa ocorrer condicionalmente.

Use apenas quando essa necessidade realmente existe.

`useContext` continua adequado para leitura normal no topo do componente/hook.

## Provider Value

[DEFAULT] O valor fornecido deve refletir o contrato real do Context.

Não estabilize objetos/callbacks preventivamente apenas porque estão em um provider.

Se houver problema real de renderização/referência, consulte `memo-stable-props.md`.

## Responsibility Boundaries

Esta referência cobre:

- Context contract;
- provider presence;
- consumer hook;
- React 19 provider/conditional context APIs.

Outras responsabilidades:

- state placement → architecture;
- generic hooks → `custom-hooks.md`;
- memoization/performance → `memo-stable-props.md`.
