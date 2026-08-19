# Frontend Test Mocking

Referência para escolher boundaries de mocks, preservar contratos e controlar dependências em testes frontend.

## Contents

- Mocking strategy
- Test-level boundaries
- Real internal code
- External boundaries
- Contract fidelity
- Scenario setup
- Mock lifecycle
- Spy, stub, fake and mock
- Runtime boundaries
- Module mocking
- External services
- Mock assertions
- Refactoring stability
- Responsibility boundaries

## Mocking Strategy

[HARD RULE] Use mocking para controlar dependências **fora** do behavior boundary relevante do teste.

```text
System Under Test
→ Dependency Boundary
→ Controlled Replacement
```

Não mocke apenas porque uma dependência pode ser substituída.

Cada mock deve existir por isolamento, determinismo ou controle de cenário.

## Mock the Boundary, Not the Implementation

[HARD RULE] Prefira substituir contratos externos ao comportamento testado.

Em integração:

```text
Component
→ Hook
→ Repository
→ HTTP Client
→ Mocked Network Boundary
```

Evite:

```text
Component
→ Mocked Hook
→ Mocked Repository
→ Mocked HTTP Client
```

quando justamente essa colaboração deveria ser protegida.

## Do Not Mock What You Are Testing

[HARD RULE] Não substitua uma parte que pertence ao contrato protegido.

Pergunte:

```text
Esta dependência está dentro ou fora
do behavior boundary deste teste?
```

Mocking deve seguir essa resposta.

## Mocking Depends on Test Level

### Unit

```text
small unit
→ mock only dependencies required for isolation
```

### Integration

```text
frontend collaboration
→ keep internals real
→ control external boundary
```

### E2E

Mocks do próprio sistema devem ser minimizados quando o objetivo é validar o fluxo completo.

E2E pertence à skill `quality-assurance`.

## Prefer Real Internal Code

[HARD RULE] Não mocke funções puras, helpers, validators, mappers, feature components ou custom hooks apenas para simplificar setup quando eles fazem parte do comportamento.

Teste resultados públicos, não chamadas internas.

## Choose Boundaries by Responsibility

[HARD RULE] A organização física em arquivos/pastas não define automaticamente um mock boundary.

Considere:

- responsibility;
- externality;
- cost;
- determinism;
- contract stability;
- behavior protected.

### Repository and Hook Boundaries

[SITUATIONAL] Mockar repository/hook é válido quando esse contrato é explicitamente o limite do teste.

Se o objetivo inclui UI → hook → repository → HTTP, mantenha-os reais e controle uma boundary posterior.

[HARD RULE] Setup mais fácil não é justificativa suficiente para remover colaboração importante.

### Component Boundaries

[SITUATIONAL] Mocke child components apenas quando estão realmente fora do comportamento, por exemplo devido a tecnologia externa pesada ou subsystem independente.

Não mocke componente interno apenas para reduzir a árvore.

## Prefer External Boundaries

[DEFAULT] Bons candidatos:

- backend APIs;
- third-party APIs;
- analytics;
- external auth;
- payment provider;
- browser API indisponível;
- external SDK.

### Network-Level Mocking

[DEFAULT] Para integração de UI + data access, prefira controlar a rede quando isso preserva mais comportamento real.

```text
UI
→ Hook
→ Repository
→ HTTP Client
→ Mock Server
```

## Mock Contracts Must Match Reality

[HARD RULE] O mock deve respeitar o contrato real relevante.

Mocks incompatíveis podem criar estados impossíveis em produção.

### Preserve Type Safety

[HARD RULE] Não use `as any` como padrão para montar mocks quando existe alternativa tipada.

Mudanças de contrato devem, quando possível, gerar feedback também na suíte.

### Third-Party Contracts

[DEFAULT] Reproduza apenas a parte do contrato externo que a aplicação realmente consome.

Não replique a biblioteca inteira.

## Mock Scenarios, Not Implementation Details

[HARD RULE] Configure estados compreensíveis:

- success;
- empty;
- validation failure;
- server failure;
- unauthorized;
- pending;
- unknown error.

Evite configurar mocks em termos de branch interna ou helper específico.

## Error Shapes Must Be Realistic

[HARD RULE] Se a aplicação decide comportamento com base em status/code/body/field errors, o mock deve refletir essa estrutura.

Evite `throw new Error("whatever")` quando a aplicação recebe um contrato de erro específico.

## Pending Scenarios

[SITUATIONAL] Quando pending precisa ser observado, controle a resolução de forma determinística.

Detalhes pertencem a `async-testing.md`.

## Keep Mock Data Minimal but Realistic

[DEFAULT] Forneça somente dados relevantes, sem violar o contrato.

Factories podem reduzir repetição:

```ts
createVacancy({
  id: '1',
  status: 'OPEN',
})
```

Não construa factories complexas antes de existir repetição real.

## Keep Scenario Setup Explicit

[HARD RULE] O teste deve deixar claro qual comportamento externo está configurado.

Prefira:

```ts
server.use(vacancyListErrorHandler())
```

a:

```text
setupEverything()
```

quando o helper esconde network, permissions, current user, time ou flags.

## Global Defaults Must Stay Neutral

[DEFAULT] Defaults globais podem representar respostas comuns e neutras.

Estados especiais devem ser configurados no próprio cenário:

- error;
- empty;
- permission restriction;
- edge case.

[HARD RULE] Defaults não devem fazer testes passarem por acidente.

## Override per Test

[DEFAULT] Permita que cenários substituam explicitamente o comportamento default necessário.

Evite dependência da ordem dos testes para definir qual mock está ativo.

## Reset and Restore Modified State

[HARD RULE] Mocks, spies, handlers e globals modificados não podem vazar entre testes.

Restaure:

- module mocks;
- spies;
- browser globals;
- timers;
- storage/environment state;
- network handlers.

Cleanup precisa corresponder ao recurso alterado.

## Spy, Stub, Fake and Mock Responsibilities

[DEFAULT] Escolha a técnica pelo objetivo.

### Spy

Observe uma implementação existente quando a interação é relevante.

### Stub

Forneça uma resposta controlada simples.

### Fake

Use implementação simplificada porém funcional quando isso oferece um contrato estável.

### Mock

Use substituto configurável quando precisa controlar comportamento e/ou observar interação.

[HARD RULE] Não transforme distinções terminológicas em complexidade desnecessária; escolha a ferramenta que deixa o cenário mais claro.

## Avoid Complex Mock Implementations

[HARD RULE] Um mock não deve recriar grande parte do sistema real.

Se precisa reproduzir estado complexo, retries, cache e lógica de domínio, considere usar a implementação real e mover o boundary para fora.

## Browser and Runtime Boundaries

[SITUATIONAL] Mock/fake browser capabilities quando não existem no ambiente de teste ou quando precisam de controle determinístico.

Exemplos:

- clipboard;
- IntersectionObserver;
- ResizeObserver;
- storage;
- matchMedia;
- notifications.

### Storage

[DEFAULT] Preserve comportamento relevante de leitura/escrita sem compartilhar estado entre testes.

### Clock / Randomness

Controle apenas quando alteram o comportamento.

Tempo e timers pertencem a `async-testing.md`.

### Environment Configuration

[SITUATIONAL] Configure env/feature flags explicitamente quando fazem parte do cenário.

Restaure após o teste.

## Module Mocking

[SITUATIONAL] Use module mocking quando o módulo inteiro é uma boundary adequada.

[HARD RULE] Não use module mock como atalho para substituir várias partes internas da feature.

### Partial Mocks

[SITUATIONAL] Partial mock pode ser adequado quando apenas uma export precisa ser controlada.

Use com cuidado para não criar uma combinação impossível entre código real e substituto.

## Do Not Mock Core Infrastructure Without Reason

[HARD RULE] Não mocke React, router, server-state library, form library ou design-system internals por padrão.

Quando o comportamento dessas integrações importa, use a composição real de teste.

## Heavy External UI Dependencies

[SITUATIONAL] Um componente externo pesado pode ser substituído quando a dependência está fora do behavior boundary e o runtime de teste não a suporta adequadamente.

Preserve o contrato público relevante.

## External Service Boundaries

[DEFAULT] Não envie analytics, logging externo ou outras integrações reais durante testes.

### Analytics

Quando evento faz parte do contrato, valide payload relevante.

### Logging

Não teste debug logs por padrão.

Suprima temporariamente output esperado somente quando necessário e restaure depois.

### Authentication and Permissions

Represente estados de usuário/permissão no boundary apropriado.

[HARD RULE] Não mocke a própria permission rule se ela faz parte do comportamento protegido.

## Assertions About Mocks

[HARD RULE] Uma assertion de mock não deve substituir o resultado final quando o comportamento pode ser observado.

Prefira:

```text
user action
→ external operation
→ visible result
```

a apenas:

```text
mock was called
```

### When Call Assertions Are Appropriate

[SITUATIONAL] Call assertions são válidas quando a própria interação externa é o resultado:

- analytics event;
- clipboard write;
- browser notification;
- download trigger;
- narrow unit dependency call.

### Call Count

Verifique quantidade apenas quando ela faz parte do contrato.

```text
double click
→ one submission
```

### Call Order

Verifique ordem apenas quando altera comportamento.

## Sequential Responses

[SITUATIONAL] Use respostas sequenciais para tentativas explícitas:

```text
attempt 1 → error
retry → success
```

Detalhes de retry/order pertencem a `async-testing.md`.

## Mocks Should Survive Internal Refactoring

[HARD RULE] Prefira boundaries estáveis.

Se renomear helper, mover lógica de hook ou dividir componente quebra dezenas de mocks sem mudança de comportamento, a estratégia está acoplada demais à implementação.

## Responsibility Boundaries

Esta referência cobre:

- mock boundary;
- contract fidelity;
- network/external replacement;
- spies/stubs/fakes;
- lifecycle;
- mock assertions;
- runtime boundaries.

Outras responsabilidades:

- nível de teste → `test-strategy.md`;
- unit isolation → `unit-testing.md`;
- integration collaboration → `integration-testing.md`;
- pending/timers/retries/races → `async-testing.md`;
- revisão → `review-checklist.md`.
