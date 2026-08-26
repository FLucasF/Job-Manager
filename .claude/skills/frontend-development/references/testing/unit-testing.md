# Frontend Unit Testing

Referência para testes de comportamento pequeno, isolado e determinístico.

## Contents

- Unit test responsibility
- Public contracts
- Scenario design
- Strong unit candidates
- Runtime edges
- Components and hooks
- Test data
- Non-determinism
- Mocks
- Parameterized and snapshot tests
- Regression tests
- Responsibility boundaries

## Unit Test Responsibility

[HARD RULE] Use unit tests quando uma unidade pequena possui comportamento próprio validável de forma isolada.

```text
input
→ unit
→ output
```

Bons candidatos:

- pure functions;
- domain/capability rules;
- formatters;
- mappers;
- reducers;
- validators;
- parsers;
- transformations;
- state machines.

[HARD RULE] Não crie unit test apenas porque existe um arquivo, função, componente ou hook.

## Prefer Pure Logic

[DEFAULT] Lógica pura é o candidato mais forte para unit testing.

```ts
function canApplyToVacancy(
  vacancy: Vacancy,
  user: User,
): boolean {
  return vacancy.status === 'OPEN' &&
    vacancy.ownerId !== user.id
}
```

Esse comportamento não precisa de React, DOM, router, provider ou HTTP.

## Test Public Contracts

[HARD RULE] Valide inputs, outputs e efeitos externos que fazem parte do contrato.

Evite assertions sobre:

- helper privado;
- variável temporária;
- branch interna;
- sequência de implementação;
- estado interno.

Refatorações internas não deveriam quebrar o teste quando o contrato permanece igual.

## Keep Unit Tests Isolated

[HARD RULE] Unit tests não devem depender de infraestrutura externa real.

Evite:

- network;
- backend;
- database;
- filesystem externo;
- full app bootstrap;
- external services.

Se várias partes da aplicação forem necessárias para obter confiança, reavalie o nível e considere integration testing.

## Behaviorally Focused Scenarios

[DEFAULT] Cada teste deve representar um cenário coerente.

```text
closed vacancy
→ application not allowed
```

Não combine regras independentes apenas para diminuir a quantidade de testes.

Múltiplas assertions são adequadas quando representam o mesmo resultado conceitual.

## Test Names

[HARD RULE] O nome deve descrever a regra protegida.

Prefira:

```text
should return false when vacancy is closed
```

a:

```text
works correctly
```

## Arrange, Act, Assert

[DEFAULT] Deixe contexto, ação e resultado fáceis de identificar.

Comentários formais `Arrange/Act/Assert` não são necessários quando o teste já é legível.

## Behaviorally Important Cases

[HARD RULE] Priorize estados que alteram o resultado.

Considere quando fazem parte do runtime real:

- boundary values;
- null/undefined;
- empty collection;
- invalid external value;
- fallback;
- duplicate value.

Não invente entradas impossíveis apenas para coverage.

## Boundary Values

[DEFAULT] Teste os pontos onde a regra muda.

```text
minimum = 18

17 → invalid
18 → valid
19 → valid
```

## Nullability and Missing Values

[DEFAULT] Teste `null`, `undefined` ou ausência de campos somente quando podem ocorrer em runtime.

Não teste possibilidades puramente teóricas excluídas pelo contrato real.

## Pure Transformations

[DEFAULT] Formatters, mappers, normalizers, serializers, parsers e builders são bons candidatos quando adicionam regra própria.

Exemplos:

```text
API null → frontend undefined
"5000" → 5000
remote=true → workModel=REMOTE
vacancyRoute("123") → "/vacancies/123"
```

[HARD RULE] Não teste a biblioteca de URL, data, array ou schema em si.

Teste sua transformação.

## Business and Validation Rules

[DEFAULT] Regras puras de domínio, capability e validação podem ser testadas diretamente.

```text
OPEN + authorized → true
CLOSED → false
OPEN + owner → false
```

Schema/validator merece teste próprio quando possui:

- conditional validation;
- cross-field rule;
- complex refinement;
- normalization.

Não re-teste comportamento básico da biblioteca de validação.

## Reducers and State Machines

[DEFAULT] Teste transições públicas:

```text
state + action
→ next state
```

Para state machine:

```text
idle → submitting → success
```

ou:

```text
idle → submitting → error → submitting
```

Não renderize React para testar reducer puro.

## Error Transformations

[DEFAULT] Unidades que traduzem falhas externas para contratos internos podem ter unit tests.

```text
EMAIL_ALREADY_EXISTS
→ { email: "Email already registered" }
```

Cubra known cases e fallback quando fazem parte do contrato.

Não teste toast, navigation ou rendering no mesmo unit test.

## Test Only Meaningful Units

[HARD RULE] Não teste wrappers triviais que apenas delegam sem adicionar comportamento.

```ts
function getVacancies() {
  return repository.findAll()
}
```

Teste isoladamente quando houver regra própria, como:

- mapping;
- header construction;
- normalization;
- error translation;
- conditional request;
- fallback.

Caso contrário, proteja no nível onde o comportamento aparece.

## Components Are Not Unit-Tested by Default

[HARD RULE] Não trate todo componente como unidade obrigatória.

Teste isoladamente quando existe:

- reusable public contract;
- complex local behavior;
- independent interaction;
- important edge cases.

[HARD RULE] Classifique pelo boundary exercitado, não pelo uso de `render()`.

Um teste com component + router + provider + query client + repository é integração.

## Hooks Are Not Unit-Tested by Default

[HARD RULE] Não crie teste isolado para todo custom hook.

Teste separadamente quando possuir contrato reutilizável e suficientemente independente, como:

- state machine;
- complex synchronization;
- public reusable API;
- complex transitions.

Evite testar `useEffect` count, state variables ou ordering interno.

## Do Not Test Type System or Framework Internals

[HARD RULE] Runtime tests não existem para provar regras exclusivamente TypeScript.

Não escreva teste de runtime para validar apenas que:

```text
wrong type does not compile
```

Da mesma forma, não teste `useState`, `useMemo` ou outras garantias do React.

## Test Data Should Express Intent

[DEFAULT] Dados devem destacar o que altera o cenário.

Factories são úteis quando reduzem repetição:

```ts
createVacancy({ status: 'CLOSED' })
```

Não esconda a condição importante dentro de fixture genérica.

### Mutable Fixtures

[HARD RULE] Não compartilhe objetos mutáveis entre testes quando um cenário pode alterar o próximo.

Crie estado novo por teste.

## Control Non-Deterministic Dependencies

[HARD RULE] Controle tempo, randomness ou outras dependências quando alteram o comportamento.

Use fake clock/random provider somente quando essa dependência pertence ao contrato testado.

Detalhes temporais pertencem a `async-testing.md`.

## Mock Only What Isolation Requires

[DEFAULT] Mocke apenas collaborators externos ao contrato da unidade.

[HARD RULE] Não mocke helpers internos ou a própria lógica que deveria ser protegida.

Detalhes pertencem a `mocking.md`.

### Prefer Outputs Over Calls

[DEFAULT] Prefira validar output/resultado.

Call assertions são adequadas quando a interação externa é parte do contrato da unidade.

## Parameterized Tests

[SITUATIONAL] Use testes parametrizados quando vários inputs exercitam a mesma regra.

Mantenha cada caso legível.

Evite tabelas enormes que escondem cenários conceitualmente diferentes.

## Snapshot Tests

[SITUATIONAL] Snapshots pequenos podem ser úteis para estruturas estáveis.

[HARD RULE] Não use snapshots extensos como substituto de assertions claras sobre comportamento.

## Mutation of Inputs

[SITUATIONAL] Quando pureza/imutabilidade faz parte do contrato e existe risco real de mutação acidental, teste preservação do input.

Não imponha isso a toda função.

## Regression Tests

[DEFAULT] Bugs em uma unidade devem receber um caso que reproduz a condição real quando viável.

Se o bug depende de colaboração entre partes, o regression test pode pertencer à integração.

## Unit Test Quality

[DEFAULT] Unit tests devem permanecer:

- rápidos;
- determinísticos;
- locais;
- fáceis de diagnosticar.

Se uma falha exige investigar router, network mock, query provider ou component tree, provavelmente o boundary deixou de ser unitário.

## Responsibility Boundaries

Esta referência cobre:

- small isolated behavior;
- pure logic;
- input/output contracts;
- transformations;
- domain rules;
- reducers/state machines;
- runtime edge cases.

Outras responsabilidades:

- escolha do nível → `test-strategy.md`;
- frontend collaboration → `integration-testing.md`;
- mock strategy → `mocking.md`;
- async/time → `async-testing.md`;
- revisão → `review-checklist.md`.
