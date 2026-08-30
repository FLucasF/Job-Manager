# Layered Architecture — React mechanisms

Stack mechanisms for the `architecture/layered-architecture.md` concern reference. The rule lives in the
concern reference; this file states how React expresses it.

## Keep Pure Logic Outside React

[DEFAULT] Se uma regra pode existir como função pura, mantenha-a fora de hooks.

Evite:

```tsx
function useCanApplyToVacancy(
  vacancy: Vacancy,
  user: User,
) {
  return canApplyToVacancy(vacancy, user)
}
```

quando o wrapper React não adiciona nenhuma responsabilidade.

Componentes e hooks podem consumir diretamente funções puras quando isso mantém os boundaries corretos.
