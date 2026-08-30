# Frontend Testing Strategy

Referência para decidir o que testar, em qual nível e como distribuir cobertura no frontend.

## Contents

- Testing strategy
- Test levels
- Decision guide
- Classify by behavior
- Public contracts
- Scenario selection
- Coverage distribution
- Regression tests
- Determinism
- Responsibility boundaries

## Testing Strategy

[HARD RULE] Teste comportamento observável e contratos relevantes, não a estrutura interna da implementação.

Prefira proteger:

```text
input
interaction
visible result
external effect
business rule result
```

Evite acoplamento desnecessário a:

```text
private functions
internal hook structure
render count
temporary state
internal call order
component decomposition
```

Uma refatoração interna que preserve comportamento não deveria exigir reescrever grande parte da suíte.

## Choose the Smallest Test That Provides Confidence

[HARD RULE] Use o menor boundary capaz de reproduzir corretamente o risco que precisa ser protegido.

```text
pure isolated behavior
→ unit

frontend collaboration
→ integration

complete system journey
→ E2E
```

O objetivo não é escolher sempre o menor teste possível.

O objetivo é escolher o menor teste que ainda representa o comportamento real.

## Frontend Testing Levels

Esta skill cobre principalmente:

```text
Unit Testing
Integration Testing
```

[HARD RULE] Fluxos que exigem browser real + frontend + backend/ambiente real pertencem à skill `quality-assurance`.

Frontend integration pode executar grande parte da aplicação React com a fronteira externa controlada sem se tornar E2E.

## Decision Guide

### Pure Logic

Pergunte:

```text
Posso validar isso como input → output
sem React nem infraestrutura da aplicação?
```

Se sim:

```text
→ unit test
```

Exemplos:

- mapper;
- formatter;
- validator;
- domain/capability rule;
- reducer;
- parser;
- transformation.

### Frontend Collaboration

Pergunte:

```text
A confiança depende de várias partes do frontend
funcionando juntas?
```

Se sim:

```text
→ integration test
```

Exemplos:

- form + validation + submission;
- page + routing;
- query + UI states;
- component + hook + repository;
- mutation + error recovery;
- feature + controlled HTTP boundary.

### Complete System Flow

Pergunte:

```text
O risco só pode ser validado atravessando
o sistema real ou ambiente equivalente?
```

Se sim:

```text
→ E2E
```

Use a skill `quality-assurance`.

## Classify Tests by Behavior, Not File Type

[HARD RULE] Não classifique o teste pelo arquivo testado.

Evite regras como:

```text
component → component test
hook → hook test
repository → repository test
```

O nível depende do boundary exercitado.

### Components

[DEFAULT] Não crie teste isolado para cada componente.

Um componente simples pode ser protegido pelo integration test da feature.

Teste isoladamente quando houver contrato próprio relevante, interação independente ou edge cases importantes.

### Hooks

[DEFAULT] Não teste cada custom hook isoladamente.

Considere teste próprio quando o hook possui:

- API reutilizável;
- transições complexas;
- sincronização relevante;
- comportamento difícil de exercer pelos consumidores.

### Repositories and Adapters

[DEFAULT] Não crie teste unitário apenas porque existe uma camada repository.

Delegação trivial pode não justificar teste isolado.

Teste quando houver comportamento próprio, como:

- request construction;
- mapping;
- normalization;
- conditional behavior;
- error translation.

Também pode ser exercitado por integration testing.

## Keep Pure Logic Independently Testable

[DEFAULT] Quando uma regra não depende de React, teste-a diretamente.

Prefira:

```text
calculateTotal(items)
→ unit test
```

a renderizar um componente apenas para alcançar a função.

## Test Through Public Contracts

[HARD RULE] Interaja pelo contrato que consumidores ou usuários realmente utilizam.

Prefira:

- input/output público;
- user interaction;
- visible result;
- route change;
- external effect relevante.

Evite depender de:

- helpers privados;
- variáveis temporárias;
- estado interno;
- DOM estrutural sem significado;
- callback interno quando o resultado pode ser observado.

## Do Not Test Framework Behavior

[HARD RULE] Não teste comportamento já garantido por React, JavaScript, browser ou biblioteca externa.

Exemplos normalmente desnecessários:

```text
useState updates state
Array.filter filters values
React renders children
native button receives click
```

Teste apenas a regra/configuração/integração que sua aplicação acrescenta.

## Select Behaviorally Distinct Scenarios

[HARD RULE] Cubra cenários que mudam comportamento relevante.

Dependendo da feature:

- success;
- validation failure;
- server failure;
- empty result;
- pending;
- permission restriction;
- retry;
- duplicate interaction;
- boundary condition.

Isso não significa testar todas as combinações possíveis.

## Important Branches and Edge Cases

[DEFAULT] Teste branches quando mudam o contrato observável.

```text
OPEN → Apply available
CLOSED → Apply unavailable
```

Considere edge cases quando são plausíveis ou historicamente problemáticos.

Não crie casos apenas porque existe uma branch sintática.

## Distribute Scenarios Across Levels

[HARD RULE] Não replique automaticamente o mesmo cenário em unit, integration e E2E.

Exemplo:

```text
Unit
→ canApplyToVacancy rules

Integration
→ Apply button availability + interaction

E2E
→ critical application journey
```

Cada nível deve proteger um risco diferente ou adicionar confiança real.

## Test Pyramid Is Guidance, Not a Quota

[DEFAULT] Não force porcentagens ou quantidade fixa de testes por nível.

Use a distribuição que protege melhor os riscos do produto com custo sustentável.

## Coverage Is a Signal, Not the Goal

[HARD RULE] Não escreva testes sem valor apenas para aumentar coverage.

Use cobertura para encontrar áreas potencialmente não exercitadas.

Depois avalie se existe comportamento ou risco que merece proteção.

## Regression Tests

[DEFAULT] Ao corrigir um bug, adicione um teste que reproduza a falha no boundary mais apropriado quando viável.

```text
bug
→ failing regression test
→ fix
→ passing test
```

O teste deve falhar antes da correção pelo mesmo motivo do bug real.

## Determinism and Independence

[HARD RULE] Todo nível de teste deve ser previsível e independente.

Evite dependência implícita de:

- execution order;
- shared mutable state;
- real external services;
- uncontrolled randomness;
- uncontrolled time.

O controle específico dessas dependências pertence a `mocking.md` e `async-testing.md`.

## Typical Feature Strategy

Uma feature pode ter:

```text
Unit
├── capability rule
├── response mapper
└── form transformation

Integration
├── list states
├── search/filter
├── create flow
├── validation behavior
└── error recovery

E2E
└── critical system journey
```

[DEFAULT] Nem toda feature precisa dos três níveis.

## Responsibility Boundaries

Esta referência decide:

```text
what to test
which level protects it
how scenarios are distributed
```

Outras responsabilidades:

- comportamento isolado → `unit-testing.md`;
- colaboração frontend → `integration-testing.md`;
- dependency replacement → `mocking.md`;
- synchronization/time/concurrency → `async-testing.md`;
- revisão consolidada → `review-checklist.md`.

Regras funcionais pertencem às referências de forms, UI states, accessibility ou architecture.

## Stack Mechanism

The stack-specific mechanisms for this concern live in the overlay skill for the
technology in use, when one exists. This reference states the rule; the overlay
states how the stack expresses it. When no overlay exists, the rule still applies
and the mechanism comes from general knowledge of that technology, declared as
such.
