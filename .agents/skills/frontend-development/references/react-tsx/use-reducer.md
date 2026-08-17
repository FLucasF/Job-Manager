# React useReducer with TypeScript

Referência para estado local com múltiplas transições relacionadas.

## Contents

- When to use
- State
- Discriminated actions
- Reducer
- Exhaustiveness
- Dispatch contract
- Responsibility boundaries

## When to Use

[SITUATIONAL] Use `useReducer` quando múltiplas transições de estado relacionadas ficam mais claras como ações explícitas.

Exemplos:

- wizard;
- cart/edit state;
- related toggles;
- local state machine.

Tradeoff:

```text
more boilerplate
↔
explicit and testable transitions
```

[HARD RULE] Não use reducer apenas porque o componente possui mais de um `useState`.

A complexidade das transições deve justificar a abstração.

## State

Defina a estrutura real do estado:

```tsx
interface CartState {
  items: CartItem[]
  lastUpdated: number
}
```

## Discriminated Actions

[DEFAULT] Modele actions como union discriminada:

```tsx
type CartAction =
  | { type: 'add'; item: CartItem }
  | { type: 'remove'; itemId: string }
  | {
      type: 'updateQuantity'
      itemId: string
      quantity: number
    }
  | { type: 'clear' }
```

Cada action carrega somente os dados necessários para sua transição.

## Reducer

```tsx
function cartReducer(
  state: CartState,
  action: CartAction,
): CartState {
  switch (action.type) {
    case 'add':
      return {
        ...state,
        items: [...state.items, action.item],
      }

    case 'remove':
      return {
        ...state,
        items: state.items.filter(
          item => item.id !== action.itemId,
        ),
      }

    case 'updateQuantity':
      return {
        ...state,
        items: state.items.map(item =>
          item.id === action.itemId
            ? { ...item, quantity: action.quantity }
            : item
        ),
      }

    case 'clear':
      return {
        ...state,
        items: [],
      }
  }
}
```

O discriminant `type` permite narrowing correto de cada payload.

## Exhaustiveness

[DEFAULT] Quando o conjunto de actions precisa ser exaustivo, preserve uma estratégia que permita detectar actions não tratadas.

Não adicione fallback silencioso se ele puder esconder uma nova action sem implementação.

## Dispatch Contract

```tsx
const [cart, dispatch] = useReducer(
  cartReducer,
  initialState,
)
```

Consumers devem despachar apenas actions compatíveis com a union.

## Responsibility Boundaries

Esta referência cobre `useReducer` e modelagem de actions locais.

Outras responsabilidades:

- decisão de onde estado vive → architecture/state-placement;
- reducer puro testing → testing/unit-testing;
- generic TypeScript unions/narrowing → TypeScript references.
