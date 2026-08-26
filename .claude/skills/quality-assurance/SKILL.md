---
name: quality-assurance
description: Planeja, implementa, executa, diagnostica e revisa E2E com Playwright e jornadas completas no browser conforme um package Ready aplicável em specs/ ou uma solicitação explícita do usuário. Use para testes de aceitação ou regressão no browser, configuração e diagnóstico da suíte E2E e investigação de testes browser flaky. Não use para revisão manual sem browser ou testes unitários e de integração de frontend ou backend.
---

# Quality Assurance

Use esta skill para confiança end-to-end por jornadas automatizadas no browser.
Unit e integration tests pertencem às skills dos respectivos boundaries.
`CLAUDE.md` governa o gate de specs, RPI, segurança e conclusão.

Quando existir package Ready aplicável, Research consome `spec.md`, `design.md` e
`tasks.md`. Sem ele, a solicitação explícita do usuário autoriza o trabalho e
define o escopo observável. Na workflow dirigida por package, a verificação
independente registra task completion, evidência de critérios, comandos realmente
executados, findings/deviations e verdict em `validation.md`; evidência ausente é
GAP, não PASS.

No caminho dirigido por package, o Plan local não redefine a jornada ou os
critérios já definidos. No caminho diretamente autorizado, ele pode definir
somente o desenho E2E local e a divisão do trabalho necessários ao pedido; não
pode criar comportamento observável, arquitetura transversal ou dependências
sem autoridade.

Não infira comportamento ausente a partir da aplicação, de exemplos ou material
Draft. Se a jornada depender de decisão material de domínio ou arquitetura
`Draft/Open`, pare até sua aceitação humana no owner durável apropriado; a
solicitação de implementação não resolve essa decisão silenciosamente.

## Workflow

1. A partir da Research concluída, selecione somente critérios de aceite que
   exigem jornada completa no browser e defina outcomes observáveis.
2. Separe precondições de setup das interações que a jornada deve validar.
3. Confirme a infraestrutura E2E, inspecione somente a suíte e boundaries
   relacionados e carregue a menor combinação de referências.
4. Prepare dados isolados e implemente apenas jornadas justificadas pela spec ou
   solicitação explícita aplicável.
5. Execute comandos existentes. Em falhas, preserve traces, screenshots, vídeos
   e relatórios, classifique a causa e só então altere o boundary responsável.
6. Relacione cada cenário ao critério de aceite e confirme que o setup não
   bypassa a capability, com isolamento, determinismo e cobertura adequados.

## Infrastructure Gate

Antes de usar Playwright, confirme:

- dependência instalada;
- configuração do runner;
- scripts disponíveis;
- base URL;
- serviços necessários;
- banco ou sandbox;
- estratégia de autenticação;
- browsers e workers configurados.

Se a infraestrutura necessária não existir, informe o pré-requisito exato. Não
invente comandos, URLs, portas, credenciais ou serviços, nem instale dependências
automaticamente.

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
[review-checklist.md](references/e2e/review-checklist.md)

Se um item falhar ou permanecer ambíguo, carregue somente a referência detalhada correspondente.

[HARD RULE] Não carregue todas as referências detalhadas apenas para executar review.

---

## Test Scenarios

- Seleção do nível E2E, system boundary, critical journeys, happy/failure paths, auth/authorization, coverage e observable outcomes:
  [test-scenarios.md](references/e2e/test-scenarios.md)

## Test Data

- Preconditions, factories/builders, API/DB setup, users/roles, uniqueness, parallel isolation, cleanup e retry-safe data:
  [test-data.md](references/e2e/test-data.md)

## Environment

- Application/services lifecycle, readiness, base URLs, database strategy, external sandboxes, projects, browsers, workers, sharding e CI:
  [environment.md](references/e2e/environment.md)

## Playwright

- Locators, actions, auto-waiting, assertions, navigation, authentication, API setup, fixtures, hooks e Page Objects:
  [playwright.md](references/e2e/playwright.md)

## Failure Diagnosis

- Product-vs-test classification, flakiness, retries, timeouts, trace, screenshots/videos, reports, CI-only failures e quarantine:
  [failure-diagnosis.md](references/e2e/failure-diagnosis.md)

## Review

- Revisão consolidada da suíte E2E:
  [review-checklist.md](references/e2e/review-checklist.md)

---

## Scenario Rules

[HARD RULE] O comportamento sob teste deve atravessar a UI/browser.

Preconditions fora do objetivo podem usar APIs/helpers controlados.

[HARD RULE] API, banco ou helper podem preparar apenas o estado inicial quando isso não substituir a interação browser que a autoridade aplicável exige validar.

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
→ E2E e jornadas completas no browser
→ Playwright
→ ambiente, dados e diagnóstico da suíte E2E

frontend-development
→ unit e integration frontend
→ acessibilidade frontend
→ segurança do browser
→ performance frontend

backend-development
→ unit e integration backend
```

Use as references de acessibilidade, segurança e performance de `frontend-development` para esses domínios no frontend. E2E pode exercitar fluxos sensíveis a esses atributos, mas não substitui essas references.

[HARD RULE] Qualquer jornada completa no browser pertence a `quality-assurance`; testes unitários e de integração permanecem com a skill do boundary correspondente.

## Finalization

Siga os critérios de conclusão de `CLAUDE.md`. Confirme a ligação entre cenário
e critério de aceite, independência e isolamento dos dados, execução da cobertura
relacionada e preservação de artefatos úteis. Investigue flakiness em vez de
mascará-la.
