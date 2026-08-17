# E2E Failure Diagnosis and Flakiness

Referência para investigar falhas, flakiness, retries, timeouts e artifacts da suíte E2E.

## Contents

- Failure classification
- Flakiness
- Retry policy
- Timeout failures
- Trace and screenshots
- Video and reports
- Logs and network evidence
- Quarantine and skips
- CI-only failures
- Fixing tests vs product
- Responsibility boundaries

## Failure Diagnosis Is Part of QA

[HARD RULE] Um teste falhando deve produzir informação suficiente para distinguir:

```text
product defect
test defect
test-data defect
environment defect
external dependency defect
```

Não "conserte" o test antes de identificar qual categoria falhou.

## Reproduce the Failure

[DEFAULT] Comece pelo menor comando/configuração já existente capaz de reproduzir o cenário.

Preserve:

```text
same test
same project/browser
same relevant environment
same data conditions
```

Não invente scripts se o repositório já possui comandos.

## Flakiness Is a Defect

[HARD RULE] Não aceite:

```text
E2E is flaky by nature
```

como justificativa final.

E2E possui mais fontes de variação, mas a suíte deve controlá-las.

## Common Flakiness Sources

Investigue primeiro:

```text
arbitrary sleeps
fragile locators
shared mutable data
test order
environment readiness
race conditions
uncontrolled time
external service instability
incorrect async assertion
resource collision
```

## Retry Is Not the Fix

[HARD RULE] Aumentar retries não substitui corrigir a causa.

Retries podem ajudar a:

```text
classify intermittent failures
collect artifacts
reduce temporary CI interruption
```

mas um teste que só passa no retry continua sinalizando instabilidade.

## Retry Result Is Evidence

Quando:

```text
first run fails
retry passes
```

trate como flaky signal, não como sucesso equivalente a first-pass.

Investigue se a frequência/criticidade justificar.

## Retry-Aware State

[HARD RULE] Cada tentativa precisa começar de estado válido.

Se retry reutiliza:

```text
half-created resource
logged-out session
consumed token
modified fixture
```

o retry deixa de testar a mesma condição.

Consulte `test-data.md`.

## Timeouts Are Safety Boundaries

[HARD RULE] Timeout não é mecanismo de sincronização.

Não aumente global timeout para corrigir um cenário que espera a condição errada.

## Investigate Timeout Failures

Pergunte:

```text
element never appeared?
locator is wrong?
app failed?
request failed?
environment not ready?
operation legitimately slow?
```

Aumente timeout somente quando a operação realmente possui duração maior esperada e comprovada.

## Avoid Sleeps

[HARD RULE] `waitForTimeout` arbitrário é uma fonte clássica de flakiness/lentidão.

Substitua por condição observável conforme `playwright.md`.

## Trace

[DEFAULT] Trace é uma das principais evidências para falhas Playwright porque pode mostrar:

```text
actions
DOM snapshots
network activity
console
timing
assertion context
```

Prefira configurar tracing através do Playwright Test/config existente.

[HARD RULE] Não grave trace pesado de todas as execuções sem necessidade/política.

## Trace on Retry/Failure

[DEFAULT] Uma política como trace na primeira retry/failure pode equilibrar custo e diagnóstico.

Preserve a configuração existente quando ela já resolve.

## Screenshots

[DEFAULT] Screenshot é artifact diagnóstico, não assertion.

Use quando ajuda a entender o estado visual da falha.

[HARD RULE] Não capture manualmente screenshot após cada action apenas para "ter evidência".

## Video

[SITUATIONAL] Video pode ajudar em:

```text
animation/timing
multi-step visual flow
browser-specific behavior
```

Mas é evidência secundária e mais pesada.

Não habilite gravação permanente sem necessidade.

## Reports

[DEFAULT] CI deve preservar um report navegável/diagnosticável quando a suíte falha.

O report deve permitir localizar:

```text
test
project
attempt/retry
error
attachments
```

## Console and Page Errors

[SITUATIONAL] Browser console/page errors podem ajudar a explicar falhas.

Não transforme todo console warning em failure sem policy explícita.

## Network Evidence

[SITUATIONAL] Inspecione network quando o resultado depende de request:

```text
request never started
request failed
response unexpected
CORS/network issue
backend returned failure
```

[HARD RULE] Não substitua outcome assertion por network assertion só porque network é mais fácil de diagnosticar.

## Application Logs

[SITUATIONAL] Backend/frontend logs podem ser necessários para distinguir produto vs environment.

Mantenha correlação útil por run/test/resource IDs quando a infraestrutura suporta.

## Setup Failure

[HARD RULE] Falha em precondition/setup deve aparecer como setup failure, não como uma assertion do usuário muitos passos depois.

Exemplo:

```text
API could not create prerequisite
```

deve falhar antes de:

```text
expected vacancy not visible
```

## Cleanup Failure

[DEFAULT] Cleanup failure precisa ser visível.

[HARD RULE] Se journey já falhou, cleanup não deve substituir/apagar a falha original.

## CI-Only Failures

Quando só falha em CI, compare:

```text
browser/runtime version
CPU/memory
workers
timezone/locale
network
service readiness
environment config
parallel data collisions
```

[HARD RULE] Não conclua que "CI é lento" antes de identificar a diferença relevante.

## Browser-Specific Failure

[SITUATIONAL] Se apenas um browser falha:

1. confirme que esse browser faz parte do support contract;
2. reproduza no project correspondente;
3. verifique diferença real de browser vs test timing/locator.

Não delete project apenas para deixar a suíte verde.

## Quarantine

[SITUATIONAL] Um cenário pode ser temporariamente quarantined quando bloquear pipeline sem correção imediata.

[HARD RULE] Quarantine precisa ter:

```text
reason
owner
tracking issue or resolution path
```

Não transforme `skip` em arquivo morto permanente.

## `test.skip`

[SITUATIONAL] Use somente quando existe razão concreta/documentada.

Não use para esconder bug ou environment não resolvido.

## `test.only`

[HARD RULE] `test.only` não deve chegar à CI.

Use `forbidOnly`/equivalente quando configurado no projeto.

## Update Test or Product?

[HARD RULE] Não altere expected behavior apenas para fazer o teste passar.

Pergunte:

```text
spec changed?
product is wrong?
test is wrong?
environment/data is wrong?
```

Se a spec mudou, atualize test para o novo contract.

Se produto viola spec, reporte/corrija o produto conforme escopo; não normalize o bug no test.

## Fix the Smallest Responsible Boundary

Exemplos:

```text
fragile locator
→ fix test locator

shared user collision
→ fix test data

backend not ready
→ fix environment readiness

incorrect product result
→ product defect
```

Não aplique workaround distante.

## Diagnostic Steps

[DEFAULT] Uma investigação típica:

```text
1. identify failing expectation/action
2. inspect trace/report
3. classify product/test/data/environment
4. reproduce with same project
5. fix responsible boundary
6. rerun failing scenario
7. rerun related suite when needed
```

## Responsibility Boundaries

Esta referência é dona de:

- flaky test diagnosis;
- retry/timeout policy;
- trace/screenshots/videos/reports;
- quarantine/skips;
- product-vs-test failure classification.

Outras responsabilidades:

- scenario design → `test-scenarios.md`;
- data/setup lifecycle → `test-data.md`;
- runtime/CI readiness → `environment.md`;
- locator/action/assertion mechanics → `playwright.md`.
