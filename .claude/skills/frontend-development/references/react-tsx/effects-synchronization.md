 # React Effects and Synchronization

Referência para decidir quando usar Effects e como sincronizar componentes React com sistemas externos.

## Contents

- Effect responsibility
- You might not need an Effect
- Events vs Effects
- Dependencies
- Cleanup
- Independent synchronization
- Objects and functions
- Effect Events
- Data fetching boundary
- Layout and insertion effects
- Strict Mode
- Common bug patterns
- Responsibility boundaries

## Effect Responsibility

[HARD RULE] Use Effect para sincronizar um componente com algo **fora do fluxo declarativo normal do React**.

Exemplos:

- browser APIs;
- subscriptions;
- timers;
- event listeners externos;
- widgets ou libraries imperativas;
- conexão com sistemas externos;
- sincronização com APIs não-React.

Conceitualmente:

```text
render
→ commit
→ synchronize external system
```

[HARD RULE] Effect não é o mecanismo padrão para organizar o data flow da aplicação.

## You Might Not Need an Effect

[HARD RULE] Antes de criar `useEffect`, pergunte:

```text
Estou sincronizando com um sistema externo?
```

Se não, reavalie se a lógica pode acontecer:

- durante renderização;
- em event handler;
- como valor derivado;
- através de state placement melhor;
- na abstração responsável pelos dados.

Evite Effects usados apenas para copiar um valor derivável:

```tsx
const [fullName, setFullName] = useState('')

useEffect(() => {
  setFullName(`${firstName} ${lastName}`)
}, [firstName, lastName])
```

Prefira derivar durante render:

```tsx
const fullName = `${firstName} ${lastName}`
```

[HARD RULE] Não crie Effect para manter dois estados que representam a mesma informação sincronizados.

## Events vs Effects

Use event handler quando a side effect acontece por uma interação específica:

```text
user clicks Save
→ submit
```

Use Effect quando a sincronização precisa acontecer porque o componente está renderizado com determinado estado:

```text
roomId changes
→ reconnect external chat connection
```

[DEFAULT] Se existe um evento específico que explica por que a operação acontece, prefira o event handler correspondente.

## Effects Are Synchronization Processes

[DEFAULT] Pense em cada Effect como um processo independente:

```text
start synchronization
→ external system active
→ stop synchronization
```

O ciclo pode ocorrer várias vezes durante a vida do componente.

Não modele Effect mentalmente apenas como:

```text
componentDidMount
componentDidUpdate
componentWillUnmount
```

O contrato relevante é sincronizar e deixar de sincronizar quando dependencies mudam.

## Dependencies Are Determined by the Effect

[HARD RULE] Não escolha dependencies manualmente para controlar quando o Effect "deveria" executar.

Toda reactive value utilizada pelo Effect deve estar representada corretamente em suas dependencies.

```tsx
useEffect(() => {
  const connection = createConnection(roomId)

  connection.connect()

  return () => connection.disconnect()
}, [roomId])
```

[HARD RULE] Não omita dependency para impedir uma reexecução.

Se uma dependency indesejada aparece, reavalie a estrutura do Effect.

## Do Not Silence Dependency Rules

[HARD RULE] Não desabilite a regra de exhaustive dependencies apenas para fazer o Effect executar menos vezes.

Quando o linter identifica uma dependency:

1. verifique se o Effect é necessário;
2. verifique se ele representa um único processo de sincronização;
3. mova lógica de evento para event handler quando apropriado;
4. remova objetos/functions desnecessariamente recriados;
5. considere Effect Event somente para lógica genuinamente não reativa dentro de um Effect.

## Empty Dependency Array

Use:

```tsx
useEffect(() => {
  // synchronization
}, [])
```

somente quando o Effect não lê reactive values que precisam re-sincronizar.

[HARD RULE] `[]` não significa "execute uma vez porque eu quero".

Ele significa que aquele processo não depende de valores reativos do componente.

## Cleanup

[HARD RULE] Quando o Effect inicia algo que precisa ser encerrado, retorne cleanup correspondente.

```tsx
useEffect(() => {
  const connection = createConnection(roomId)
  connection.connect()

  return () => {
    connection.disconnect()
  }
}, [roomId])
```

Pares comuns:

```text
connect     ↔ disconnect
subscribe   ↔ unsubscribe
add listener ↔ remove listener
start timer ↔ clear timer
```

[DEFAULT] Cleanup deve desfazer a sincronização iniciada pelo mesmo Effect.

## Cleanup Runs Before Re-Synchronization

[HARD RULE] Não assuma que cleanup acontece apenas no unmount.

Quando dependencies mudam:

```text
old synchronization
→ cleanup
→ new synchronization
```

A implementação deve continuar correta quando esse ciclo acontecer repetidamente.

## Split Independent Synchronization

[HARD RULE] Se um Effect sincroniza processos independentes, considere separá-los.

Evite um Effect grande que mistura:

```text
analytics
subscription
timer
DOM synchronization
```

quando cada parte possui dependencies e lifecycle próprios.

[DEFAULT] Um Effect deve representar um processo de sincronização coerente.

## Avoid Objects and Functions as Accidental Dependencies

[SITUATIONAL] Objetos e functions criados durante render possuem nova identidade a cada render.

Se usados como dependency, podem causar re-synchronization desnecessária.

Antes de adicionar memoization, verifique se o valor pode:

- ser criado dentro do Effect;
- ser movido para fora do componente;
- ser substituído por primitives necessárias;
- deixar de ser dependency através de uma estrutura melhor.

[HARD RULE] Não adicione `useMemo` ou `useCallback` automaticamente apenas para satisfazer um Effect.

Memoization pertence a `memo-stable-props.md`.

## Effect Events

[SITUATIONAL] Em React atual, `useEffectEvent` pode separar lógica não reativa que precisa ler os valores mais recentes sem fazer o Effect re-sincronizar por causa deles.

Exemplo conceitual:

```tsx
const onConnected = useEffectEvent(() => {
  showNotification('Connected', theme)
})

useEffect(() => {
  const connection = createConnection(roomId)

  connection.on('connected', onConnected)
  connection.connect()

  return () => connection.disconnect()
}, [roomId])
```

Aqui:

```text
roomId
→ reactive synchronization dependency

theme
→ latest value used by Effect Event
```

[HARD RULE] Não use `useEffectEvent` como mecanismo para esconder dependencies que deveriam continuar reativas.

Effect Events pertencem à lógica de Effects e não devem ser usados como callbacks gerais de UI.

## State Updates Inside Effects

[HARD RULE] Não use Effect para derivar state quando o valor pode ser calculado durante render.

State update dentro de Effect pode introduzir:

- render adicional;
- estados intermediários;
- dependency cycles;
- sincronização difícil de entender.

[SITUATIONAL] State update pode ser válido quando representa resultado de uma sincronização externa real.

## Infinite Effect Loops

Quando um Effect:

```text
runs
→ sets state
→ render
→ dependency changes
→ Effect runs
```

investigue o modelo antes de aplicar workaround.

Pergunte:

- esse state é realmente necessário?
- o Effect sincroniza algo externo?
- a dependency muda por identidade?
- a atualização deveria acontecer em event handler?

[HARD RULE] Não resolva loop removendo dependency correta.

## Data Fetching Boundary

[SITUATIONAL] Fetch manual em Effect pode ser tecnicamente válido, mas não deve ser o default quando o projeto já possui uma camada responsável por server state/data fetching.

Neste projeto, preserve a separação definida pelas referências de architecture e data access.

[DEFAULT] Componentes não devem criar Effects de fetch apenas para contornar repository/query abstractions existentes.

Use Effect para sincronização que realmente pertence ao lifecycle do componente, não como substituto genérico para data access.

## `useLayoutEffect`

[SITUATIONAL] Use `useLayoutEffect` somente quando a sincronização precisa acontecer antes do browser pintar a tela, como determinadas medições/layout adjustments.

[HARD RULE] Não substitua `useEffect` por `useLayoutEffect` por padrão.

Ele bloqueia repaint e deve ser reservado aos casos que realmente dependem desse timing.

## `useInsertionEffect`

[SITUATIONAL] `useInsertionEffect` é uma API especializada, principalmente para bibliotecas que precisam inserir estilos em timing específico.

[HARD RULE] Não use em código comum de feature sem necessidade concreta.

## Strict Mode and Development Re-Synchronization

[HARD RULE] O Effect deve permanecer correto quando setup e cleanup são exercitados mais de uma vez durante desenvolvimento.

Se execução adicional revela:

- duplicate subscription;
- timer duplicado;
- connection não encerrada;
- side effect não reversível;

corrija o lifecycle/cleanup em vez de tentar impedir a verificação.

## Common Bug Patterns

Evite:

- usar Effect para valor derivado;
- copiar props para state via Effect sem necessidade;
- omitir dependencies;
- silenciar exhaustive-deps;
- usar `[]` como "run once";
- misturar processos independentes no mesmo Effect;
- esquecer cleanup;
- assumir cleanup apenas no unmount;
- criar loop de Effect + setState;
- memoizar tudo apenas para estabilizar dependencies;
- usar `useEffectEvent` para esconder dependencies reais;
- fazer fetch em Effect quando a arquitetura já possui data-access/server-state boundary;
- usar `useLayoutEffect` sem necessidade de pre-paint synchronization.

## Responsibility Boundaries

Esta referência cobre:

- `useEffect`;
- external synchronization;
- dependency correctness;
- cleanup;
- Effect lifecycle;
- `useEffectEvent`;
- `useLayoutEffect`;
- `useInsertionEffect`.

Outras responsabilidades:

- callback dependencies fora de Effects → `stale-callbacks.md`;
- memoization → `memo-stable-props.md`;
- custom hook design → `custom-hooks.md`;
- state placement → architecture;
- server-state/data fetching → architecture/data-access;
- async testing → testing/async-testing.
