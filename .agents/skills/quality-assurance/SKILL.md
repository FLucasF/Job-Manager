---
name: quality-assurance
description: Planeja, implementa, executa, diagnostica e revisa testes end-to-end automatizados com Playwright, incluindo jornadas críticas, dados isolados, ambiente E2E, autenticação, paralelismo e análise de falhas. Use quando a tarefa envolver QA, E2E, Playwright, acceptance/regression tests no browser, criação ou revisão de cenários automatizados, investigação de testes flaky ou configuração da suíte E2E.
---

# Quality Assurance

Atue como QA focado em confiança end-to-end do sistema através de testes automatizados no browser.

[HARD RULE] Esta skill é responsável por E2E. Unit e integration tests devem seguir as skills/referências responsáveis por esses níveis.

## Workflow

Antes de criar ou alterar um teste:

1. Leia a spec, acceptance criteria ou comportamento esperado da feature.
2. Inspecione a implementação e a suíte E2E existentes.
3. Determine se o risco realmente exige E2E.
4. Defina preconditions, user intent e observable outcome.
5. Identifique quais referências são necessárias.
6. Prepare dados e ambiente de forma isolada e reproduzível.
7. Implemente a journey com Playwright.
8. Execute o menor conjunto relevante de tests usando comandos existentes.
9. Se falhar, diagnostique antes de alterar retry, timeout ou expectativa.
10. Execute validações relacionadas antes de concluir.

## QA Principles

[HARD RULE] Teste comportamento e outcomes, não detalhes internos de implementação.

[HARD RULE] Não faça um teste passar alterando a expectativa quando o produto viola a spec.

[HARD RULE] Não normalize flakiness. Identifique e corrija a fonte de instabilidade.

[HARD RULE] Não use E2E para substituir cobertura que pertence melhor a unit/integration.

[DEFAULT] Priorize poucas jornadas críticas, independentes, determinísticas e diagnosticáveis.

## Reference Loading Rules

[HARD RULE] Não leia todas as referências por padrão.

[DEFAULT] Carregue somente a menor combinação necessária à tarefa.

Uma tarefa pode cruzar mais de um domínio. Exemplos:

```text
create new E2E journey
→ test-scenarios.md
→ test-data.md
→ playwright.md

CI failure only
→ failure-diagnosis.md
→ environment.md

auth-related scenario
→ test-scenarios.md
→ test-data.md
→ playwright.md
```

Referências relacionadas dentro de um arquivo não devem ser carregadas automaticamente.

### Review Strategy

[DEFAULT] Em revisão de QA/E2E, comece por:
[review-checklist.md](references/review-checklist.md)

Se um item falhar ou permanecer ambíguo, carregue somente a referência detalhada correspondente.

[HARD RULE] Não carregue todas as referências detalhadas apenas para executar review.

---

## Test Scenarios

- Seleção do nível E2E, system boundary, critical journeys, happy/failure paths, auth/authorization, coverage e observable outcomes:
  [test-scenarios.md](references/test-scenarios.md)

## Test Data

- Preconditions, factories/builders, API/DB setup, users/roles, uniqueness, parallel isolation, cleanup e retry-safe data:
  [test-data.md](references/test-data.md)

## Environment

- Application/services lifecycle, readiness, base URLs, database strategy, external sandboxes, projects, browsers, workers, sharding e CI:
  [environment.md](references/environment.md)

## Playwright

- Locators, actions, auto-waiting, assertions, navigation, authentication, API setup, fixtures, hooks e Page Objects:
  [playwright.md](references/playwright.md)

## Failure Diagnosis

- Product-vs-test classification, flakiness, retries, timeouts, trace, screenshots/videos, reports, CI-only failures e quarantine:
  [failure-diagnosis.md](references/failure-diagnosis.md)

## Review

- Revisão consolidada da suíte E2E:
  [review-checklist.md](references/review-checklist.md)

---

## Scenario Rules

[HARD RULE] O comportamento sob teste deve atravessar a UI/browser.

Preconditions fora do objetivo podem usar APIs/helpers controlados.

[HARD RULE] API setup não pode substituir a journey que o cenário pretende validar.

[HARD RULE] Cenários devem executar independentemente e não depender de ordem.

[DEFAULT] Use nomes que descrevem capacidades do usuário/sistema.

## Data Rules

[HARD RULE] Cada test deve possuir ou receber explicitamente o estado mutável necessário.

[HARD RULE] Não use dados pessoais, credentials, pagamentos ou endpoints reais de produção.

[DEFAULT] Dados devem ser únicos/rastreáveis quando execução paralela ou compartilhada pode gerar colisão.

## Playwright Rules

[DEFAULT] Prefira locators baseados em role, accessible name e label.

[HARD RULE] Não use `page.waitForTimeout()` como mecanismo de sincronização.

[DEFAULT] Use web-first assertions e espere condições observáveis.

[HARD RULE] Não aumente retries/timeouts apenas para fazer a suíte ficar verde.

## Environment Rules

[HARD RULE] Não execute destructive E2E contra produção como estratégia padrão.

[HARD RULE] Não desabilite paralelismo ou use serial mode apenas para esconder dependência de dados.

[DEFAULT] Preserve configuração existente do projeto antes de introduzir nova infraestrutura de test runner.

## Failure Handling

Quando um E2E falhar:

```text
failure
→ inspect assertion/action
→ inspect trace/report/artifacts
→ classify:
   product
   test
   data
   environment
→ fix responsible boundary
→ rerun scenario
→ rerun related coverage when necessary
```

[HARD RULE] Não altere expected result sem evidência de que o comportamento esperado mudou.

## Scope Boundaries

```text
quality-assurance
→ automated E2E
→ browser journeys
→ test environment/data
→ Playwright
→ E2E failure diagnosis

frontend-development/testing
→ frontend unit/integration

backend testing skill/references
→ backend unit/integration

security/performance/accessibility skills
→ specialized non-E2E review
```

E2E pode exercitar security, accessibility ou performance-sensitive flows, mas não substitui as referências especializadas desses domínios.

## Finalization

Antes de concluir:

1. confirme que o scenario protege o comportamento esperado;
2. confirme que setup não bypassa a capability sob teste;
3. confirme independência e isolamento de dados;
4. execute o test/scenario relacionado;
5. investigue qualquer retry/flakiness em vez de mascará-lo;
6. execute a suíte relacionada quando a mudança puder afetar outros journeys;
7. preserve artifacts úteis quando houver falha.

[HARD RULE] Não invente comandos, portas, URLs, credentials, services ou scripts. Use a configuração e os comandos existentes no repositório.
