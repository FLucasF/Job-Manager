# End-to-End Test Scenarios

Referência para decidir quais comportamentos merecem E2E e como modelar jornadas com valor de QA.

## Contents

- E2E responsibility
- System boundary
- Scenario selection
- User intent and business language
- Happy and failure paths
- Authentication and authorization
- Validation coverage
- CRUD and multi-step journeys
- Setup vs journey
- Independence and determinism
- Observable outcomes
- Coverage portfolio
- Responsibility boundaries

## E2E Responsibility

[HARD RULE] Use E2E para validar jornadas importantes atravessando as fronteiras reais do sistema.

```text
User
→ Browser
→ Frontend
→ Backend
→ Persistence / controlled external boundaries
```

E2E fornece confiança de que o sistema funciona como um conjunto.

[HARD RULE] E2E não substitui unit ou integration testing.

## Prefer the Lowest Appropriate Test Level

[DEFAULT] Antes de criar um E2E, pergunte onde o risco realmente precisa ser protegido.

```text
pure logic
→ unit

frontend collaboration
→ frontend integration

backend collaboration
→ backend integration

complete user/system journey
→ E2E
```

[HARD RULE] Não transforme cada regra, component ou edge case em E2E.

## Define the System Boundary

[HARD RULE] Antes de automatizar, deixe claro o que é real no sistema sob teste.

Exemplo:

```text
inside
→ browser
→ frontend
→ backend
→ application database

outside / controlled boundary
→ email provider
→ payment gateway
→ external identity provider
→ third-party API
```

[DEFAULT] Serviços de terceiros não precisam ser reais para o teste ser E2E do sistema que a equipe controla.

## Test Critical User Journeys

[DEFAULT] Priorize fluxos cuja quebra afeta valor, risco ou operação essencial.

Bons candidatos:

- authentication;
- permission-sensitive operations;
- critical create/edit/delete flows;
- core business workflows;
- persistent state transitions;
- regressions que já quebraram integrações importantes.

Pergunta útil:

```text
Se esse fluxo quebrar,
o sistema perde uma capacidade importante?
```

## Start From User Intent

[DEFAULT] Modele o cenário a partir de uma intenção de negócio.

Prefira:

```text
recruiter can publish a remote vacancy
```

a:

```text
clicks submit and POSTs /vacancies
```

[HARD RULE] O nome do teste deve sobreviver a refactors técnicos.

## Clear Scenario Shape

[HARD RULE] Todo cenário deve possuir:

```text
known preconditions
→ clear user intent
→ meaningful actions
→ observable outcome
```

Uma forma útil:

```text
Given
→ authenticated recruiter
→ vacancy does not exist

When
→ recruiter creates vacancy

Then
→ vacancy becomes available
```

Se o objetivo não cabe em uma frase clara, o teste pode estar grande demais.

## Happy Paths

[DEFAULT] Critical journeys devem possuir cobertura do caminho principal quando E2E é o nível apropriado.

Exemplo:

```text
authenticate
→ create vacancy
→ creation succeeds
→ vacancy can be found again
```

## Validate Persistent Outcomes

[DEFAULT] Quando uma ação deve persistir estado, valide a consequência observável.

```text
create
→ resource can be reopened

edit
→ changed value survives reload/revisit

delete
→ resource is no longer available
```

[HARD RULE] Não pare na primeira success notification quando existe um outcome persistente mais forte.

## Prefer User/System Outcomes

[HARD RULE] A principal assertion deve representar resultado observável.

Prefira:

```text
created vacancy appears in list
```

a:

```text
POST returned 201
```

Request/status pode ajudar em diagnóstico, mas não substitui o resultado da jornada quando o objetivo é E2E.

## Failure Paths

[DEFAULT] Falhas críticas podem justificar E2E próprios.

Exemplos:

- invalid authentication;
- insufficient permission;
- resource unavailable during workflow;
- backend rejection que precisa ser corretamente apresentado;
- destructive operation denied.

Teste a integração da falha, não todas as combinações internas de validação.

## Validation Coverage

[HARD RULE] Não crie um E2E para cada regra de validation.

Um cenário representativo pode provar:

```text
invalid input
→ submission prevented
→ feedback visible
```

As regras individuais pertencem a níveis menores.

## Authentication Journeys

[DEFAULT] Login, logout, protected access e session-expiry podem justificar E2E quando representam contratos importantes.

[HARD RULE] Se login é o comportamento testado, execute login pela UI.

Quando login é apenas precondition, use setup eficiente conforme `test-data.md` e `playwright.md`.

## Authorization Journeys

[DEFAULT] Operações sensíveis podem ter cenário representativo por role/capability relevante.

Valide, quando necessário:

```text
UI behavior
+
operation actually cannot succeed
```

[HARD RULE] Button escondido não prova authorization do sistema.

## Role Coverage

[SITUATIONAL] Cubra papéis diferentes quando suas jornadas realmente diferem.

Não multiplique toda a suíte por todos os roles se apenas poucas capacidades mudam.

## CRUD Journeys

[DEFAULT] Modele CRUD como capacidades, não como tradução automática de endpoints.

Exemplo:

```text
recruiter creates vacancy
recruiter edits own vacancy
recruiter deletes own vacancy
```

[HARD RULE] Não crie um mega-teste que faz create → edit → delete só para reduzir quantidade de testes.

Cada cenário deve ser independentemente valioso.

## Avoid Giant Journeys

[HARD RULE] Evite um único teste que faça muitas capacidades não relacionadas:

```text
register
→ login
→ create
→ search
→ edit
→ delete
→ logout
```

Uma falha intermediária reduz diagnóstico e cobertura restante.

## Multi-Step Flows

[DEFAULT] Fluxos multi-step podem permanecer em um cenário quando todas as etapas pertencem à mesma intenção.

Exemplo:

```text
complete job application
→ personal data
→ professional data
→ review
→ submit
```

Não junte jornadas diferentes apenas porque o usuário poderia executá-las em sequência.

## Search, Filter and Pagination

[SITUATIONAL] Automatize quando o comportamento é relevante para a jornada.

Use dados controlados para provar:

```text
expected item appears
unexpected item does not
page/filter transition is preserved
```

Evite assertions sobre contagens globais do ambiente.

## File Upload and Download

[SITUATIONAL] Teste quando file flow faz parte do produto.

Valide o resultado relevante:

```text
upload accepted
→ file associated with resource

download
→ expected artifact is produced
```

Dados de arquivos pertencem a `test-data.md`.

## Responsive and Cross-Browser Coverage

[SITUATIONAL] Repita cenários em browsers/viewports adicionais quando há risco concreto.

[HARD RULE] Não faça automaticamente:

```text
all tests
× all browsers
× all viewports
× all roles
```

Coverage adicional precisa representar risco.

## Accessibility in E2E

[DEFAULT] Locators semânticos e keyboard journeys podem revelar problemas reais de acessibilidade.

[SITUATIONAL] Automatize uma jornada específica de teclado quando ela representa risco relevante.

E2E não substitui revisão/testes dedicados de accessibility.

## Setup Is Not the Journey

[HARD RULE] Não atravesse a UI inteira para preparar preconditions que não fazem parte do comportamento testado.

Para testar edição:

```text
setup
→ create vacancy via controlled API/helper

journey
→ open vacancy
→ edit through UI
→ verify outcome
```

## Do Not Bypass the Behavior Under Test

[HARD RULE] Setup eficiente não pode substituir justamente a capacidade testada.

Se o objetivo é:

```text
recruiter creates vacancy through UI
```

não faça:

```text
API creates vacancy
→ UI only verifies it exists
```

Isso testa outra capacidade.

## Test Independence

[HARD RULE] Nenhum cenário depende do resultado de outro.

Nunca:

```text
test A creates
test B edits A's resource
test C deletes B's resource
```

Cada cenário prepara seu estado necessário.

## Parallel-Safe by Design

[DEFAULT] Cenários devem ser concebidos para execução paralela mesmo que a CI atual use poucos workers.

Evite dependência de:

- global counts;
- shared mutable users;
- fixed unique values;
- execution order.

Dados pertencem a `test-data.md`.

## Determinism

[HARD RULE] Sob mesmo code + environment + controlled data, o cenário deve produzir o mesmo resultado.

Flakiness não é uma propriedade aceitável de E2E.

Diagnóstico pertence a `failure-diagnosis.md`.

## Observable Final State

[HARD RULE] Termine o cenário quando existe evidência de que a capacidade concluiu corretamente.

Exemplos:

- route expected;
- persisted value visible;
- resource exists/does not exist;
- authenticated state established;
- operation rejected with expected user-visible result.

## Stable Assertions

[DEFAULT] Prefira contratos observáveis:

```text
role
accessible name
label
visible business content
URL
business outcome
```

Mecânica de locators/assertions pertence a `playwright.md`.

## Scenario Portfolio

[DEFAULT] Mantenha um portfólio pequeno e intencional:

```text
critical happy paths
critical failure paths
permission-sensitive flows
high-value regressions
selected browser/device risks
```

[HARD RULE] Não automatize low-value flows apenas para aumentar quantidade de E2E.

## Smoke vs Regression E2E

[SITUATIONAL] Smoke pode ser um subset rápido de capacidades essenciais.

Regression E2E pode proteger falhas historicamente relevantes.

Não confunda smoke de produção não destrutivo com a suíte principal que cria/modifica dados.

## Responsibility Boundaries

Esta referência é dona de:

- seleção de cenários;
- definição do boundary E2E;
- jornada e business intent;
- portfolio/coverage E2E;
- observable outcomes.

Outras responsabilidades:

- test data/setup/cleanup → `test-data.md`;
- runtime/CI/services → `environment.md`;
- Playwright implementation → `playwright.md`;
- retries/traces/flakiness → `failure-diagnosis.md`.
