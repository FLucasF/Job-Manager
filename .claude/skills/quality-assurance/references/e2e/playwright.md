# Playwright End-to-End Testing

Referência para implementar jornadas E2E usando Playwright Test.

## Contents

- Runner and browser boundary
- Locators
- Actions
- Auto-waiting
- Assertions
- Navigation
- Authentication
- API setup
- Fixtures and hooks
- Page objects
- Steps
- Network boundary
- Responsibility boundaries

## Playwright Test Is the Runner

[DEFAULT] Use as abstrações do `@playwright/test` existentes no projeto.

```ts
import { test, expect } from '@playwright/test'
```

O runner fornece:

```text
browser contexts
fixtures
assertions
projects
parallelism
retries
reporters
traces
screenshots/videos
```

[HARD RULE] Use essas capacidades antes de criar infraestrutura paralela equivalente.

## Test Through the Browser

[HARD RULE] A parte da jornada sob teste precisa passar pela interface real do browser.

Não substitua:

```text
click / typing / navigation
```

por:

```text
React internals
component methods
window application handlers
direct callback invocation
```

quando essas ações são o comportamento testado.

## Browser Context Isolation

[HARD RULE] Preserve isolamento entre tests.

Cada test normalmente recebe `page` dentro de um `BrowserContext` isolado.

Não compartilhe session/local storage mutável entre scenarios sem estratégia explícita.

## Locators

[HARD RULE] Use locators como mecanismo principal de interação.

Prioridade prática:

```text
role + accessible name
label
visible text
placeholder when appropriate
explicit test id
CSS/XPath only when justified
```

## Prefer `getByRole`

[DEFAULT] Para elementos interativos/estruturais semanticamente identificáveis:

```ts
page.getByRole('button', {
  name: /create vacancy/i,
})
```

Isso aproxima o teste do contrato exposto ao usuário.

## Prefer `getByLabel`

[DEFAULT] Para form controls com label associado:

```ts
page.getByLabel(/title/i)
```

Um locator que falha por associação semântica incorreta pode revelar um problema real da UI.

## Test IDs Are Fallback

[DEFAULT] Use `getByTestId` quando não existe locator semântico estável e adequado.

[HARD RULE] Não transforme `data-testid` na primeira estratégia da suíte.

## Avoid Structural Selectors

[DEFAULT] Evite CSS/XPath acoplados ao DOM:

```text
.container > div:nth-child(2)
 //div[2]/button
 generated Tailwind/CSS-module classes
```

quando existe contrato orientado ao usuário.

## Locator Strictness

[DEFAULT] Se um locator que deveria ser único encontra múltiplos elementos, trate como sinal de locator/context inadequado.

[HARD RULE] Não use `first()`, `last()` ou `nth()` apenas para silenciar ambiguidade.

Use posição somente quando ela realmente faz parte do contrato.

## Scope by Meaning

```ts
const dialog = page.getByRole('dialog', {
  name: /delete vacancy/i,
})

await dialog
  .getByRole('button', { name: /confirm/i })
  .click()
```

Restrinja pelo contexto semântico, não por profundidade DOM.

## Actions

[HARD RULE] Use ações reais do Playwright:

```ts
click()
fill()
press()
check()
selectOption()
```

Não modifique DOM/state diretamente para alcançar o resultado.

## Auto-Waiting

[DEFAULT] Confie em locators/actionability e web-first assertions antes de criar waits manuais.

[HARD RULE] Não use `page.waitForTimeout()` como sincronização de:

```text
render
network
navigation
animation
loading
```

Espere a condição necessária.

## User-Relevant Readiness

[HARD RULE] Page load ou `networkidle` não são definição universal de aplicação pronta.

Depois de `page.goto`, espere o estado relevante:

```ts
await expect(
  page.getByRole('heading', { name: /vacancies/i }),
).toBeVisible()
```

## Web-First Assertions

[HARD RULE] Use assertions que aguardam o estado quando ele pode mudar.

```ts
await expect(locator).toBeVisible()
await expect(locator).toBeEnabled()
await expect(page).toHaveURL(...)
```

[HARD RULE] Aguarde assertions assíncronas.

## Assert Outcomes

[HARD RULE] Prefira resultado do usuário/sistema a detalhe de implementação.

```text
created resource visible
```

é mais forte que:

```text
button clicked
```

Não over-assert todos os detalhes da página.

## Navigation

[DEFAULT] Use `page.goto` para entry state quando navegar até ali não faz parte da journey.

Se interação causa navegação, valide URL/conteúdo quando isso faz parte do contract.

Não insira sleeps entre action e assertion.

## Authentication

[HARD RULE] Faça login pela UI quando login é o cenário.

Quando auth é apenas precondition, `storageState`/API setup podem ser adequados conforme a estratégia do projeto.

## Auth State Is Sensitive

[HARD RULE] Authenticated state pode conter cookies/tokens reutilizáveis.

Não versione arquivos reais de `storageState`.

Use test-specific credentials e ignore outputs sensíveis.

## Role-Specific Auth

[DEFAULT] Use estados/identidades que representem o role real necessário.

Não autentique tudo como admin.

Data ownership pertence a `test-data.md`.

## API Setup

[DEFAULT] Use `request`/API helpers para preparar preconditions quando isso não bypassa a capacidade testada.

```text
API creates prerequisite
→ browser executes behavior under test
```

[HARD RULE] API setup não substitui a journey.

## API Cleanup

[SITUATIONAL] Cleanup via API pode ser apropriado se está alinhado à strategy de dados.

Preserve a falha original caso cleanup também falhe.

## Fixtures

[DEFAULT] Use fixtures para capabilities/dependencies reutilizáveis.

Boas fixtures expõem algo que o test precisa:

```text
authenticatedPage
recruiter
testData
apiClient
```

[HARD RULE] Fixture não deve esconder uma journey completa ou estado mutável compartilhado incorretamente.

## Fixture Scope

[HARD RULE] Scope deve corresponder ao lifetime do recurso.

```text
test-scoped
→ mutable scenario state

worker-scoped
→ safe reusable worker capability/resource
```

Não coloque resource mutável de scenario em worker fixture apenas para acelerar.

## Hooks

[SITUATIONAL] `beforeEach` pode preparar setup comum de um grupo.

[HARD RULE] Não esconda grandes preconditions globais em hooks que tornam o teste impossível de entender isoladamente.

Prefira fixtures/capabilities explícitas.

## Page Objects

[SITUATIONAL] Page Objects são opcionais.

Use quando encapsulam linguagem/capabilities estáveis do produto.

Bom:

```text
VacancyEditor.publish(...)
LoginPage.signIn(...)
```

Ruim:

```text
getButton1()
getSecondInput()
clickThirdDiv()
```

[HARD RULE] Não crie Page Object que apenas espelha todo o DOM.

## Do Not Hide the Journey

[HARD RULE] Abstrações não devem tornar impossível entender o fluxo do test.

O teste ainda deve comunicar a intenção de negócio.

## `test.step`

[SITUATIONAL] Use para etapas significativas de diagnóstico.

Não envolva cada linha em um step.

## Network

[DEFAULT] Uma suíte E2E normalmente usa o backend real do sistema sob teste.

[HARD RULE] Mockar o próprio backend muda o boundary.

Se a API principal é mocked:

```text
browser
→ frontend
→ mocked API
```

isso se aproxima mais de browser integration do que full E2E.

## Mock External Boundaries

[SITUATIONAL] Serviços externos podem ser controlled/sandboxed/faked.

Não dependa de produção externa apenas para tornar o test "mais E2E".

## `waitForResponse`

[SITUATIONAL] Use quando response/network event faz parte real do contrato ou diagnóstico.

[HARD RULE] Não espere toda request específica se um user-visible state é condição melhor e mais resiliente.

## Page and Browser APIs

[DEFAULT] Use capabilities do Playwright que simulam o comportamento real necessário:

```text
downloads
uploads
multiple pages
permissions
viewport/device
```

somente quando fazem parte do cenário.

## Configuration Boundary

Config global, projects, workers, `webServer`, CI e runtime pertencem a `environment.md`.

Retries, timeouts e diagnostic artifacts pertencem a `failure-diagnosis.md`.

## Responsibility Boundaries

Esta referência é dona de:

- Playwright locators/actions/assertions;
- auto-waiting/readiness;
- browser interactions;
- auth/API setup mechanics;
- fixtures/hooks/page objects.

Outras responsabilidades:

- what to test → `test-scenarios.md`;
- data lifecycle → `test-data.md`;
- config/CI/runtime → `environment.md`;
- flakiness/debugging/artifacts → `failure-diagnosis.md`.
