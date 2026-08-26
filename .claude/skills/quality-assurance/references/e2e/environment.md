# End-to-End Test Environment

Referência para configurar e controlar o ambiente em que a suíte E2E executa.

## Contents

- Environment responsibility
- System under test
- Production safety
- Configuration and base URLs
- Service lifecycle and readiness
- Database strategy
- External services
- Secrets
- Browser/projects
- Workers and sharding
- CI
- Timezone and artifacts
- Responsibility boundaries

## Environment Responsibility

[HARD RULE] A suíte E2E precisa executar contra uma versão e configuração conhecidas do sistema.

Controle explicitamente:

```text
application version
frontend/backend configuration
base URLs
database strategy
external dependencies
feature flags
authentication configuration
browser/runtime
```

E2E não deve depender de ambiente "provavelmente pronto".

## System Under Test

[DEFAULT] Defina quais serviços fazem parte do sistema real exercitado.

Exemplo:

```text
browser
→ frontend
→ backend
→ database
```

Serviços externos podem ser:

```text
sandbox
fake
stubbed at external boundary
```

conforme o contrato.

Scenario boundary pertence a `test-scenarios.md`.

## Avoid Production as Primary E2E Environment

[HARD RULE] A suíte principal que cria, altera e exclui dados não deve usar produção como ambiente padrão.

Smoke checks de produção, quando existirem, devem ser:

```text
limited
non-destructive
explicit
```

e tratados como responsabilidade distinta.

## Environment Configuration Outside Tests

[HARD RULE] Não espalhe nos cenários:

```text
frontend URL
backend URL
credentials
CI-specific paths
global timeouts
browser config
```

Use config/environment boundaries existentes.

## `baseURL`

[DEFAULT] Configure `baseURL` quando os tests navegam na mesma aplicação.

Então:

```ts
await page.goto('/vacancies')
```

em vez de hard-code de host em cada teste.

[HARD RULE] Não assuma uma porta/host se o projeto já possui configuração E2E.

## Playwright Configuration

[DEFAULT] Centralize runner config em `playwright.config.ts` quando essa é a estrutura do projeto.

Bons exemplos:

- testDir;
- projects;
- retries;
- workers;
- reporter;
- baseURL;
- trace policy;
- webServer.

[HARD RULE] Não mova scenario-specific behavior para global config apenas porque pode ser configurado lá.

## Service Lifecycle

[HARD RULE] Antes da suíte iniciar, os serviços necessários precisam estar realmente disponíveis.

Possíveis estratégias:

```text
Playwright webServer
docker compose
CI services
disposable environment
deployed preview
external orchestration
```

Use a estratégia já adotada pelo projeto.

## `webServer`

[SITUATIONAL] `webServer` é adequado quando Playwright pode gerenciar o lifecycle de um servidor local.

[HARD RULE] Não force database/backend/broker/fakes inteiros para dentro de `webServer` se existe orchestration mais apropriada.

## Readiness

[HARD RULE] "Process started" não significa "application ready".

O environment precisa de uma condição confiável de readiness.

Não corrija startup race adicionando sleep arbitrário nos tests.

## Local Server Reuse

[DEFAULT] Reutilizar servidor local pode ser conveniência de desenvolvimento.

Na CI, prefira ambiente pertencente à execução atual e com estado conhecido.

## Database Strategy

[HARD RULE] O ambiente deve definir como a persistência é isolada/resetada.

Exemplos:

```text
disposable DB
schema per worker
database per worker
reset before run
unique data in controlled shared DB
```

Test-level data ownership pertence a `test-data.md`.

## External Services

[HARD RULE] Integrações capazes de gerar efeitos reais devem usar boundaries de teste.

Exemplos:

```text
email sandbox
payment sandbox
fake SMS provider
test webhook receiver
controlled OAuth tenant
```

Nunca permita que E2E acione produção por configuração ausente.

## Feature Flags

[SITUATIONAL] Se comportamento depende de feature flags, o ambiente deve tornar seu estado determinístico.

[HARD RULE] Não deixe tests dependerem de rollout remoto mutável sem controle.

Projects separados podem ser úteis somente quando flags representam configurações realmente relevantes.

## Secrets and Credentials

[HARD RULE] Credenciais de E2E pertencem ao secret/config management do ambiente.

Não versione:

- production credentials;
- real customer accounts;
- reusable authenticated states;
- private tokens.

Use identidades próprias de teste.

## Browser Installation

[DEFAULT] CI precisa possuir browser binaries/dependencies compatíveis com a versão instalada do Playwright.

[HARD RULE] Não invente comandos de instalação; use package manager/scripts/CI configuration do projeto.

## Projects

[DEFAULT] Use Playwright projects para configurações significativamente diferentes.

Exemplos:

```text
chromium
webkit regression
mobile-specific risk
authenticated setup dependency
```

[HARD RULE] Não multiplique toda a suíte por browser × viewport × role × flag sem justificativa de risco.

## Browser Coverage

[DEFAULT] Escolha browsers com base em suporte/risco do produto.

Cobertura adicional pode ser aplicada somente a scenarios específicos quando isso reduz custo sem perder confiança.

## Workers

[DEFAULT] Configure workers conforme capacidade do ambiente e estratégia de dados.

Playwright pode executar arquivos em paralelo; therefore tests/data devem ser independentes.

[HARD RULE] Não use `workers: 1` como primeira correção para colisões que deveriam ser resolvidas por isolamento.

[SITUATIONAL] CI pode usar menos workers para estabilidade/resource constraints.

## Serial Mode

[HARD RULE] Não use serial execution para encadear scenarios dependentes.

Se Test B depende do recurso criado pelo Test A, corrija os scenarios/data.

## Sharding

[SITUATIONAL] Use sharding quando a suíte já é independente e o tempo de CI justifica distribuição entre jobs.

[HARD RULE] Não habilite sharding antes de data/environment estarem preparados para execução distribuída.

Reports dos shards precisam ser agregados conforme a infraestrutura escolhida.

## Retries

Environment pode definir uma política de retries, especialmente em CI.

[HARD RULE] Retry não transforma ambiente instável em ambiente confiável.

A investigação pertence a `failure-diagnosis.md`.

## CI Execution

[DEFAULT] Execute E2E frequentemente o suficiente para fornecer feedback útil ao projeto, tipicamente em fluxos de integração definidos pela equipe.

[HARD RULE] Não assuma GitHub Actions, Docker ou um provider específico sem inspecionar o repositório.

## `forbidOnly`

[DEFAULT] Em CI, bloqueie `test.only` através da configuração existente/Playwright quando apropriado.

Isso evita uma pipeline verde executando apenas um teste esquecido.

## Artifacts

[DEFAULT] CI deve preservar artifacts suficientes para diagnosticar falhas:

```text
test report
trace when configured
screenshots/videos when policy requires
logs when available
```

Não retenha artifacts pesados indefinidamente sem necessidade.

Detalhes de diagnóstico pertencem a `failure-diagnosis.md`.

## Timezone and Locale

[SITUATIONAL] Se a feature depende de timezone/locale, o environment precisa definir valores conhecidos ou fornecer uma strategy explícita.

Não dependa do timezone da máquina de CI por acidente.

## Clock Control

[SITUATIONAL] Cenários sensíveis ao tempo podem exigir clock control, data relativa ou ambiente previsível.

Não use sleeps para esperar relógio real avançar quando existe estratégia melhor.

## Environment Parity

[DEFAULT] Local e CI devem exercitar o mesmo comportamento do sistema, mesmo que provisioning seja diferente.

Evite:

```text
local → real backend
CI → mocked backend
```

quando ambos são chamados da mesma suíte E2E sem intenção explícita.

## Failure Must Be Diagnosable

[HARD RULE] Diferencie falhas de provisioning/readiness de falhas do produto.

Um backend que não iniciou não deve aparecer apenas como:

```text
button not found
```

quando é possível detectar/reportar environment failure antes.

## Responsibility Boundaries

Esta referência é dona de:

- environment configuration;
- service lifecycle/readiness;
- CI/runtime/browser setup;
- projects/workers/sharding;
- external sandboxes;
- environment-level database strategy.

Outras responsabilidades:

- scenario intent → `test-scenarios.md`;
- scenario data → `test-data.md`;
- Playwright test implementation → `playwright.md`;
- retries/artifact analysis → `failure-diagnosis.md`.
