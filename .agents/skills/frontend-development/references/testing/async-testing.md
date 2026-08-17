# Frontend Async Testing

Referência para sincronização, pending, timers, retries, concorrência e race conditions em testes frontend.

## Contents

- Async strategy
- Waiting
- Pending
- User interactions and promises
- Controlled resolution
- Timers
- Retry
- Concurrency and ordering
- Cancellation
- Optimistic updates
- Polling and timeouts
- Flakiness
- Unit vs integration async
- Responsibility boundaries

## Async Strategy

[HARD RULE] Testes assíncronos devem sincronizar com comportamento observável, não com suposições de tempo.

```text
user action
→ async work starts
→ intermediate state
→ operation resolves
→ observable result
```

[HARD RULE] Não torne comportamento assíncrono artificialmente síncrono apenas para facilitar o teste.

## Do Not Use Arbitrary Sleeps

[HARD RULE] Não use delays fixos como sincronização.

Evite:

```ts
await new Promise(resolve => setTimeout(resolve, 500))
```

Prefira aguardar:

- element appears;
- element disappears;
- state/result becomes visible;
- operation completes;
- known controlled signal.

Sleeps tornam testes lentos, frágeis e dependentes do ambiente.

## Choose the Correct Waiting Strategy

[HARD RULE] Use a estratégia correspondente ao contrato:

```text
must exist now
→ synchronous assertion

appears later
→ async query / wait

disappears later
→ disappearance wait

must remain pending
→ controlled unresolved operation
```

Não torne toda assertion assíncrona por padrão.

## Keep Synchronous Assertions Synchronous

[HARD RULE] Não use `waitFor` quando o estado já deveria existir imediatamente.

Espera desnecessária pode esconder bugs e produzir falhas menos precisas.

## Wait for Observable Results

[DEFAULT] Aguarde o resultado público da aplicação.

Prefira:

```text
content appears
```

a:

```text
promise resolved
internal callback called
internal status changed
```

quando esses detalhes não são o contrato.

## Test Disappearance When It Matters

[DEFAULT] Espere desaparecimento quando ele faz parte do comportamento:

```text
loading → request completes → loading disappears
delete → success → item disappears
confirm → success → dialog closes
```

## `waitFor`

[HARD RULE] Use `waitFor` quando uma condição relevante se torna verdadeira assincronamente e não existe espera mais direta.

Mantenha o callback pequeno e focado.

[HARD RULE] Não execute side effects dentro de callbacks que podem rodar várias vezes.

Evite:

```text
waitFor
→ click Save
→ assert
```

Faça:

```text
click once
→ wait for result
```

## Pending States Must Be Deterministic

[HARD RULE] Quando precisar observar pending, mantenha a operação pendente de forma controlada.

```text
start
→ hold resolution
→ assert pending
→ release
→ assert final state
```

Não dependa de uma janela temporal como “esperar 20ms e torcer para ainda estar pending”.

## Test Pending Only When Relevant

[DEFAULT] Teste pending quando muda comportamento, por exemplo:

- duplicate submission prevention;
- action availability;
- previous content preservation;
- loading feedback.

Semântica funcional pertence a `ui-states/`.

## Initial vs Background Loading

[DEFAULT] Reproduza a diferença quando ela faz parte do contrato:

```text
initial
→ no previous content
→ loading UI

refresh
→ previous content preserved
→ new request pending
```

## Await User Interactions

[HARD RULE] Se a API de interação retorna Promise, aguarde-a:

```ts
await user.type(input, 'Frontend Developer')
await user.click(saveButton)
```

[HARD RULE] Interação concluída não significa que o trabalho assíncrono da aplicação terminou.

Depois da ação, aguarde separadamente o resultado da aplicação.

## Await Relevant Promises

[HARD RULE] Não deixe o teste terminar antes de Promises relevantes.

Isso pode gerar:

- false positive;
- unhandled rejection;
- update after cleanup;
- inter-test interference.

## Async Failures

[DEFAULT] Quando rejection/failure faz parte do contrato, teste o resultado explicitamente.

```text
submit
→ request fails
→ error appears
→ user input preserved
```

Não deixe rejection relevante sem assertion.

## Control External Resolution at the Boundary

[DEFAULT] Atrasos, success e failures externos devem ser controlados na boundary apropriada.

Não mocke partes internas apenas para tornar o fluxo síncrono.

Mock boundaries pertencem a `mocking.md`.

## Avoid Timing Assumptions

[HARD RULE] Não dependa de:

- CPU speed;
- machine load;
- event-loop timing;
- CI performance;
- real network speed.

Controle explicitamente a causa da transição.

## Timers Only When Time Is Behavior

[HARD RULE] Use fake timers/controlled clock quando o comportamento depende realmente de tempo.

Exemplos:

- debounce;
- throttle;
- timeout;
- interval;
- delayed feedback;
- expiration;
- scheduled transition.

Não use fake timers apenas para acelerar qualquer async test.

## Fake Timers Change the Runtime

[DEFAULT] Fake timers podem interagir com Promises, user-event, polling e scheduling de bibliotecas.

Use somente quando necessários.

[HARD RULE] Restaure timers reais após o cenário.

## Debounce

[DEFAULT] Teste deterministicamente:

```text
type
→ threshold not reached
→ no request

advance threshold
→ request occurs
```

Quando relevante:

```text
new input before threshold
→ previous scheduled action replaced
```

Não espere tempo real.

## Throttle

[SITUATIONAL] Teste o contrato temporal público:

```text
first action → accepted
second inside window → ignored
after window → accepted
```

## Delayed Feedback

[SITUATIONAL] Quando UX atrasa spinner para evitar flicker:

```text
fast operation → spinner never shown
slow operation → spinner appears after threshold
```

Teste somente se essa regra é intencional.

## Retry Behavior

[DEFAULT] Teste retry quando ele representa comportamento real:

```text
failure → automatic retry → success
failure → retries exhausted → final error
manual retry → next attempt succeeds
```

[HARD RULE] Não teste internals da retry library quando o resultado público é suficiente.

## Automatic Retries Must Be Deterministic

[HARD RULE] Não espere backoff real.

Controle quando necessário:

- retry count;
- clock;
- external responses.

Se o teste não valida retries, configure-os para não adicionar ruído/espera desnecessária.

## Expected Failure Must Not Be Hidden by Retry

[HARD RULE] Retries automáticos não devem mascarar o cenário de erro esperado.

Garanta que a configuração corresponde ao comportamento que o teste pretende exercer.

## Sequential Responses

[DEFAULT] Deixe tentativas explícitas:

```text
attempt 1 → error
attempt 2 → success
```

Não esconda sequencing importante em helper mágico.

## Concurrent Operations

[HARD RULE] Quando operações podem coexistir, controle cada uma independentemente.

Não use uma única Promise global ou estado compartilhado para requests conceitualmente separados.

## Out-of-Order Responses

[HARD RULE] Quando ordem de resolução pode alterar resultado, reproduza-a explicitamente.

```text
request A starts
request B starts
B resolves
A resolves later
```

Teste qual resultado deve permanecer.

## Race Conditions

[HARD RULE] Regression tests de race condition devem reproduzir a ordem real que causava o bug.

Não reduza o caso a um fluxo sequencial síncrono se o risco depende de concorrência.

## Stale Results

[DEFAULT] Quando request antigo não deve substituir resultado novo, teste exatamente essa condição.

```text
search "re"
→ request A

search "react"
→ request B

B resolves
→ React results

A resolves later
→ must not replace B
```

## Cancellation

[SITUATIONAL] Teste cancellation quando cancelar trabalho muda comportamento relevante.

Valide o contrato público, não o mecanismo interno específico de AbortController/library.

## Optimistic Updates

[DEFAULT] Quando optimistic update faz parte da UX, teste:

```text
action
→ optimistic UI
→ external operation
→ confirm or rollback
```

## Optimistic Rollback

[HARD RULE] Quando failure deve desfazer optimistic state, reproduza a falha e valide rollback observável.

Não teste apenas uma chamada interna de rollback.

## Mutation Ordering

[SITUATIONAL] Quando mutations concorrentes podem produzir conflito, reproduza a sequência relevante explicitamente.

## Polling and Intervals

[SITUATIONAL] Controle clock quando polling é comportamento real.

Teste interval/tick necessário, sem aguardar tempo real.

## Application Timeouts

[SITUATIONAL] Se a aplicação possui timeout funcional, teste a transição de comportamento usando clock controlado.

## Test Runner Timeout Is Not Synchronization

[HARD RULE] Aumentar timeout do test runner não corrige sincronização incorreta.

Timeout maior só deve ser usado quando o cenário legítimo precisa de mais tempo, não para esconder flakiness.

## Flaky Tests Are Bugs

[HARD RULE] Se um teste passa/falha intermitentemente, investigue a fonte de não determinismo.

Não resolva apenas com:

- retries do test runner;
- sleeps maiores;
- timeout maior;
- assertion mais permissiva.

## Async Test Independence

[HARD RULE] Async work, timers, handlers e pending Promises de um teste não podem afetar o seguinte.

Cleanup não substitui sincronização correta.

## Keep Async Scenarios Explicit

[DEFAULT] O teste deve deixar claro:

```text
what starts
what stays pending
what resolves/rejects
what result is expected
```

## Avoid Library Internals

[HARD RULE] Não valide scheduling, retry counters ou status internals de uma biblioteca quando o contrato da aplicação pode ser observado.

## Async Unit Tests

[DEFAULT] Uma unidade assíncrona ainda pode ser unitária se usa dependencies controladas e não requer infraestrutura real.

Teste resolution/rejection/mapping/fallback conforme o contrato.

## Async Integration Tests

[DEFAULT] Quando o risco envolve:

```text
user interaction
+ async operation
+ state transition
+ rendering
```

use integration testing.

Esta referência define sincronização; `integration-testing.md` define o boundary.

## Regression Tests for Async Bugs

[DEFAULT] Preserve a sequência temporal/concurrente que causava o bug.

Não simplifique a ponto de deixar de reproduzir o risco.

## Async Test Quality

[HARD RULE] Um bom async test:

- espera comportamento observável;
- evita sleeps;
- controla pending;
- controla clock só quando necessário;
- explicita ordering quando relevante;
- isola estado assíncrono;
- é reproduzível.

## Responsibility Boundaries

Esta referência cobre:

- async synchronization;
- pending;
- wait strategies;
- timers;
- debounce/throttle;
- retries;
- concurrency;
- race conditions;
- optimistic updates;
- polling/timeouts;
- flaky-test prevention.

Outras responsabilidades:

- escolha do nível → `test-strategy.md`;
- isolated behavior → `unit-testing.md`;
- frontend collaboration → `integration-testing.md`;
- controlled boundaries → `mocking.md`;
- UI state semantics → `ui-states/`;
- revisão → `review-checklist.md`.
