# React Router Data Mode

Referência para loaders, actions, fetchers, route data e revalidation quando o projeto usa Data ou Framework Mode.

## Contents

- Mode prerequisite
- Loaders
- Actions
- Repository boundary
- Form and submission
- Fetchers
- Revalidation
- Pending state
- Parallel loading
- Avoid duplicate server-state ownership
- Responsibility boundaries

## Mode Prerequisite

[HARD RULE] Use esta referência somente quando o projeto está em Data Mode ou Framework Mode.

Antes, confirme em `mode-selection.md`.

Não introduza Data Mode para uma alteração local sem decisão arquitetural.

## Loaders

Loaders fornecem dados ao route boundary antes da renderização daquela rota.

Conceitualmente:

```text
navigation
→ loader
→ route data
→ route component
```

[DEFAULT] Use loader quando route-level data faz parte da estratégia já adotada pelo projeto.

## Loader Is Not Permission to Bypass Data Access

[HARD RULE] Adotar loader não elimina automaticamente Repository/data-access boundaries existentes.

Se a arquitetura é:

```text
loader
→ repository
→ HTTP client
```

não substitua por:

```text
loader
→ raw fetch
```

apenas porque a API permite.

A ownership do transporte continua em architecture/data-access.

## Loader Inputs

`params` e `request` são inputs do route data flow.

[HARD RULE] Route params continuam external input.

Normalize/validate antes de usá-los em operações que exigem contrato mais forte.

## Loaders and UI Components

[DEFAULT] Route component consome route data sem recriar request redundante para a mesma responsabilidade.

Evite:

```text
loader fetches vacancy
+
component query fetches same vacancy
```

sem uma estratégia deliberada de ownership.

## Actions

Actions representam mutations submetidas ao route data flow.

Podem ser acionadas por APIs como:

```text
Form
useSubmit
fetcher
```

dependendo do mode.

[HARD RULE] Não use action apenas como wrapper para mover uma mutation existente sem ganho arquitetural.

## Actions and Repository Boundary

Assim como loaders:

```text
action
→ application/data access boundary
→ repository
```

quando essa é a arquitetura do projeto.

[HARD RULE] Não espalhe endpoint/serialization dentro de route actions se Repository já isola isso.

## `<Form>`

[SITUATIONAL] React Router `Form` integra submission ao route action e navigation/revalidation flow.

Não substitua forms existentes mecanicamente.

Antes, verifique:

- project mode;
- form architecture;
- validation ownership;
- mutation/server-state ownership;
- desired navigation semantics.

Functional form rules continuam em `forms/`.

## `useSubmit`

[SITUATIONAL] Use quando uma submissão ao route action precisa ser disparada imperativamente por uma transição real.

[HARD RULE] Não troque `<Form>` declarativo por `useSubmit` sem necessidade.

## Fetchers

Fetchers permitem interagir com loader/action sem navigation.

Bons casos podem incluir:

```text
inline mutation
background submission
load route data without navigation
```

[HARD RULE] Não use fetcher como store genérica de application state.

## Fetcher vs Navigation

Escolha conforme o comportamento:

```text
operation changes location
→ navigation/action flow

operation stays on current location
→ fetcher may fit
```

A decisão precisa refletir UX real, não preferência de API.

## Automatic Revalidation

Após route actions, React Router pode revalidar loader data associado à página.

[DEFAULT] Aproveite a estratégia do router quando ela é a owner de server state daquela rota.

[HARD RULE] Não adicione manualmente:

```text
action completes
→ refetch all loaders
→ extra query invalidation
→ manual local state update
```

sem necessidade.

Evite múltiplos mechanisms reconciliando o mesmo dado.

## Server-State Ownership

[HARD RULE] Defina uma owner clara se o projeto também usa outra server-state library.

Evite:

```text
React Router loader cache/data
+
query library cache
+
local copied state
```

representando o mesmo recurso sem motivo.

[SITUATIONAL] As ferramentas podem coexistir, mas cada uma precisa ter responsabilidade explícita.

## Pending Navigation

Data routers expõem navigation state para pending UI.

[DEFAULT] Derive loading feedback da operação real.

Não crie `isLoading` paralelo se o router já fornece a informação correta.

UI semantics pertencem a ui-states/loading.

## Pending Fetcher

Fetcher possui lifecycle próprio.

[HARD RULE] Não use navigation pending state para representar operação independente de fetcher, nem o inverso.

Cada operação precisa refletir sua própria lifecycle.

## Parallel Loader Execution

React Router pode executar loaders relevantes em paralelo.

[DEFAULT] Não serialize loaders artificialmente sem dependência real.

Quando loader B depende de A, reavalie:

```text
route design
shared parent loader
data contract
```

antes de criar waterfall manual.

## Loader Waterfalls

[SITUATIONAL] Nested data requirements podem produzir decisões de loading/data architecture.

Não otimize por suposição; meça quando performance for a preocupação.

Performance pertence a `performance/`.

## Revalidation Control

[SITUATIONAL] Customize revalidation somente quando o comportamento padrão produz trabalho incorreto/desnecessário comprovado.

[HARD RULE] Não introduza `shouldRevalidate` ou data strategy avançada apenas para micro-otimizar sem evidência.

## Advanced Data Strategy

[HARD RULE] APIs low-level que alteram execução padrão de loaders/actions exigem necessidade concreta e testes correspondentes.

Preserve o fluxo padrão quando ele resolve o caso.

## Error Flow

Loaders/actions podem produzir failures tratadas pelo route error boundary apropriado.

Consulte `route-errors.md`.

[HARD RULE] Form validation error comum não deve ser transformado automaticamente em route error boundary.

## Common Bug Patterns

Evite:

- loader/action em projeto Declarative sem migration;
- raw fetch em loader ignorando Repository;
- loader + query duplicando mesmo recurso;
- action + invalidation + local state reconciliando tudo;
- fetcher como global store;
- navigation pending para fetcher independente;
- `useSubmit` sem necessidade;
- advanced dataStrategy prematuramente;
- error boundary para validação normal de form.

## Responsibility Boundaries

Esta referência é dona de:

- loader;
- action;
- React Router Form/useSubmit;
- fetchers;
- route revalidation;
- navigation/fetcher pending no Data/Framework mode.

Outras responsabilidades:

- HTTP/Repository → architecture/data-access;
- server-state ownership → architecture/state-placement;
- forms → forms references;
- UI loading/error semantics → ui-states;
- route errors → `route-errors.md`.
