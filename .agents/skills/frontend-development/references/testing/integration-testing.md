# Frontend Integration Testing

Referência para testes que validam colaboração real entre partes do frontend.

## Contents

- Integration responsibility
- Boundary selection
- Real internal collaboration
- Public UI
- Forms and UI states
- Routing
- Test infrastructure
- Server state
- External contracts
- Async boundary
- Accessibility
- Test data and quality
- Responsibility boundaries

## Integration Responsibility

[HARD RULE] Use integration tests quando a confiança depende de múltiplas partes do frontend funcionando juntas.

Exemplos:

```text
Page + Components
Form + Validation + Submission
Component + Hook
Hook + Repository
Router + Page
Query + UI States
Mutation + UI Reconciliation
Feature + External Boundary
```

[HARD RULE] Não transforme integration testing em vários unit tests conectados artificialmente por mocks.

## Define the Boundary Explicitly

[HARD RULE] Antes de escrever o teste, determine o que está dentro e onde o teste termina.

Exemplo amplo:

```text
Page
→ Components
→ Hooks
→ Repository
→ HTTP Client
→ controlled network boundary
```

Exemplo menor:

```text
Reusable Component
→ Interaction
→ provided callback
```

Ambos podem ser integração.

O boundary deve seguir o comportamento, não a estrutura de pastas.

## Prefer Real Internal Collaboration

[HARD RULE] Dentro do boundary escolhido, use implementações reais das partes que participam da colaboração.

Isso pode incluir:

- components;
- hooks;
- validation;
- form logic;
- routing;
- repositories;
- mappers;
- context;
- state transitions.

Evite mockar exatamente as partes cuja integração você quer proteger.

## Mock External Boundaries

[DEFAULT] Controle dependências externas no boundary adequado.

Quando o objetivo inclui UI + data access, network-level mocking costuma preservar melhor a integração:

```text
Component
→ Hook
→ Repository
→ HTTP Client
→ Mock Server
```

Não é obrigatório terminar na rede; escolha o contrato correto para o cenário.

Detalhes de mock pertencem a `mocking.md`.

## Frontend Integration Is Not E2E

[HARD RULE] Um teste frontend pode usar DOM semelhante ao browser e grande parte da aplicação sem backend real.

```text
Browser-like DOM
→ React application
→ Feature
→ Controlled external boundary
```

Isso continua sendo frontend integration.

Se exige browser real + backend + database/ambiente, use a skill `quality-assurance`.

## Do Not Require a Real Backend

[HARD RULE] Não torne integration tests dependentes de:

- backend local;
- shared remote server;
- internet;
- real database;
- external auth;
- third-party API.

Controle essas boundaries quando não fazem parte do comportamento frontend protegido.

## Render the Smallest Meaningful Boundary

[HARD RULE] Renderize o menor boundary que ainda reproduz a colaboração relevante.

Para criação de vaga:

```text
CreateVacancyPage
→ VacancyForm
→ Validation
→ Mutation
```

pode ser suficiente.

Não use toda a aplicação se uma feature menor protege o mesmo risco.

Mas também não reduza para um input isolado quando o risco está no fluxo completo do formulário.

## Page and Feature Boundaries

[DEFAULT] Pages e features frequentemente são bons boundaries porque coordenam várias responsabilidades.

Uma page pode envolver:

- route params;
- query;
- UI states;
- navigation;
- feature components.

Uma feature pode envolver:

- search;
- filters;
- query;
- results;
- state transitions.

Teste o conjunto quando a colaboração entre essas partes é o risco.

## Test Through the Public UI

[HARD RULE] Para comportamento de interface, interaja como usuário/consumidor.

Prefira:

```text
render
→ find control
→ interact
→ observe result
```

Evite chamar diretamente:

- `handleClick`;
- `handleSubmit`;
- `handleChange`;
- callback interno;
- função interna de hook.

Essas chamadas podem ignorar event behavior, validation, focus, disabled state e component collaboration.

## Query Elements by Meaning

[DEFAULT] Prefira:

- role + accessible name;
- label;
- visible text.

Use `data-testid` como fallback quando não existe identificação semântica estável.

Não use CSS class ou DOM nesting como primeira estratégia de query.

## Forms as Integrated Flows

[DEFAULT] Formulários são bons candidatos quando o risco envolve:

```text
fields
→ validation
→ submission
→ pending
→ server result
→ UI feedback
```

Teste o fluxo, não cada callback interno.

Não replique no integration test todas as regras puras já bem protegidas por unit tests.

Regras funcionais pertencem às referências de forms.

## UI State Transitions

[DEFAULT] Integration testing é útil para transições observáveis:

```text
loading → success
loading → error → retry → success
invalid → corrected → submitting → success
```

Teste apenas estados que representam comportamento ou risco real.

Semântica de loading/empty/error/disabled pertence a `ui-states/`.

## Error Mapping Through the UI

[SITUATIONAL] Quando o mapping entre resposta externa e mensagem é parte do risco, exercite o mapper real.

```text
EMAIL_ALREADY_EXISTS
→ application mapping
→ "Email already registered"
```

Não mocke o mapper se ele é parte da colaboração protegida.

## Routing Integration

[DEFAULT] Quando route state ou navigation fazem parte do comportamento, use um router real/controlado de teste.

Exemplos:

```text
/vacancies/123
→ correct resource loads
```

```text
click link
→ route changes
```

```text
successful create
→ details route opens
```

[DEFAULT] Prefira observar o resultado de navegação a verificar apenas `navigate()` chamado, quando o router de teste representa o fluxo com custo razoável.

## Test Infrastructure

[DEFAULT] Configure somente providers necessários para reproduzir o boundary real.

Exemplos:

- router;
- query client;
- theme;
- localization;
- app context.

### Production-Like Composition

[HARD RULE] Use composição próxima da aplicação quando o provider faz parte da colaboração.

Não substitua provider real apenas para simplificar setup se isso remove comportamento importante.

### Reusable Render Helpers

[SITUATIONAL] Helpers podem encapsular infraestrutura repetida.

```ts
renderWithAppProviders(ui, {
  route: '/vacancies',
})
```

[HARD RULE] Helpers não devem esconder condições relevantes como usuário, permissions, network responses ou route state.

### Fresh Stateful Infrastructure

[HARD RULE] Recrie infraestrutura stateful por teste quando necessário.

Não compartilhe Query Client, store, cache ou outro estado mutável se isso puder vazar entre cenários.

## Server State Integration

[HARD RULE] Teste server state pelo resultado observável da feature, não por internals da biblioteca.

Prefira:

```text
mutation succeeds
→ updated content appears
```

a verificar detalhes internos de cache sem necessidade.

### Mutations

Teste quando relevante:

```text
user action
→ pending
→ request
→ success/failure
→ UI reconciliation
```

### Cache Updates

[DEFAULT] Valide o efeito na UI.

Não acople o teste a `invalidateQueries` se a implementação pode mudar para direct cache update sem alterar o contrato.

## Assert External Contracts Only When Relevant

[DEFAULT] Requests podem ser asserted quando method/path/body/params/header fazem parte do contrato importante.

Não verifique cada detalhe HTTP apenas porque está disponível.

## Async Integration Boundary

[DEFAULT] Controle respostas externas para reproduzir success, error, pending, retries ou ordering quando necessário.

Synchronization e concorrência pertencem a `async-testing.md`.

## Application Context and Capabilities

[SITUATIONAL] Quando user/permissions/feature state fazem parte do comportamento, configure esse contexto explicitamente.

Não esconda essas condições em helpers globais.

## Accessibility Boundary

[DEFAULT] Integration tests podem proteger comportamento acessível observável através de:

- semantic queries;
- keyboard interaction;
- focus outcome;
- accessible state.

Requisitos funcionais detalhados pertencem às referências de accessibility.

## Error Boundaries

[SITUATIONAL] Teste error boundary quando o comportamento protegido é uma falha de renderização.

Não use render error boundary para simular erro esperado de API.

## Test Data Must Express the Scenario

[DEFAULT] Use dados mínimos, realistas e explícitos.

Factories são úteis quando reduzem repetição, mas propriedades que alteram o comportamento devem permanecer visíveis no teste.

## Integration Test Quality

### Keep Each Test Focused

[HARD RULE] Não crie um único teste cobrindo vários fluxos independentes.

Prefira um comportamento coerente por cenário.

### Multiple Related Assertions

[DEFAULT] Várias assertions são adequadas quando representam o mesmo fluxo.

```text
successful create
→ pending visible
→ request correct
→ navigation occurs
```

### Meaningful Intermediate States

[DEFAULT] Verifique estado intermediário somente quando faz parte do contrato.

Exemplo relevante:

```text
pending → duplicate submit prevented
```

### Avoid Trivial Integration Tests

[DEFAULT] Composição estática sem comportamento pode não justificar teste dedicado.

### Determinism and Independence

[HARD RULE] Não dependa de real network, shared cache, real clock, external service ou execution order.

### Diagnosability

[DEFAULT] Quanto maior o boundary, mais específico deve ser o cenário e o nome do teste.

## Responsibility Boundaries

Esta referência cobre:

- integration boundary;
- real internal collaboration;
- public UI behavior;
- forms/routing/server-state integration;
- observable state transitions;
- provider composition.

Outras responsabilidades:

- escolha do nível → `test-strategy.md`;
- pure isolated behavior → `unit-testing.md`;
- mock boundaries → `mocking.md`;
- async synchronization/concurrency → `async-testing.md`;
- forms/UI/accessibility semantics → referências do domínio;
- revisão → `review-checklist.md`.
