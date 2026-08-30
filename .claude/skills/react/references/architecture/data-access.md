# Data Access — React mechanisms

Stack mechanisms for the `architecture/data-access.md` concern reference. The rule lives in the
concern reference; this file states how React expresses it.

## React Integration

[DEFAULT] Hooks podem integrar Repository com server-state tooling.

```tsx
function useVacancies() {
  return useQuery({
    queryKey: ['vacancies'],
    queryFn: vacancyRepository.findAll,
  })
}
```

[HARD RULE] Se Repository é o boundary adotado, não repita raw HTTP dentro do hook.

Hook conhece a **operação**; Repository conhece o **transporte/fonte**.
