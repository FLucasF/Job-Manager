# React Stale Callbacks

Referência para callbacks que capturam props/state antigos e uso correto de dependências.

## Stale Closure Pattern

[HARD RULE] Um callback deve observar os valores atuais exigidos pelo comportamento.

Problema:

```tsx
function Item({
  id,
  onSelect,
}: {
  id: string
  onSelect: (id: string) => void
}) {
  const handleClick = useCallback(() => {
    onSelect(id)
  }, [])

  return (
    <button onClick={handleClick}>
      Select
    </button>
  )
}
```

O callback usa `id` e `onSelect`, mas declara nenhuma dependency.

Se eles mudarem, o callback pode continuar capturando valores antigos.

## Include Required Dependencies

[HARD RULE] Quando usar `useCallback`, não omita dependências necessárias para forçar estabilidade.

```tsx
const handleClick = useCallback(() => {
  onSelect(id)
}, [id, onSelect])
```

A dependency list deve refletir valores reativos usados pelo callback.

## Remove `useCallback` When It Has No Job

[DEFAULT] Se estabilidade de referência não é necessária, prefira uma função normal/inline.

```tsx
<button onClick={() => onSelect(id)}>
  Select
</button>
```

[HARD RULE] Não use `useCallback` como otimização automática.

Ele deve resolver uma necessidade concreta, como identidade de função relevante para uma boundary memoizada ou outra API que depende dela.

## Do Not Fix Stale State with Missing Dependencies

[HARD RULE] Não silencie lint/dependency rules ou deixe dependency fora do array apenas para impedir recriação do callback.

Reavalie:

- estrutura do callback;
- state ownership;
- updater function;
- necessidade real de memoização.

## Responsibility Boundaries

Esta referência cobre stale closures e dependency correctness.

Outras responsabilidades:

- memoization/stable props → `memo-stable-props.md`;
- state placement → architecture;
- hooks em geral → `custom-hooks.md`.
