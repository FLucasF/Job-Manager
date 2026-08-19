---
name: quality-assurance
description: Planeja, implementa, executa, diagnostica e revisa E2E com Playwright e jornadas completas no browser somente conforme uma spec aplicável em specs/. Use para testes de aceitação ou regressão no browser, configuração e diagnóstico da suíte E2E e investigação de testes browser flaky. Não use para revisão manual sem browser ou testes unitários e de integração de frontend ou backend.
---

# Quality Assurance

Atue como QA focado em confiança end-to-end do sistema através de testes automatizados no browser.

[HARD RULE] Esta skill é responsável por E2E. Unit e integration tests devem seguir as skills/referências responsáveis por esses níveis.

## Workflow

1. Identifique a capability, feature ou bug e localize a spec correspondente em `specs/` pelo caminho, nome ou identificador informado.
2. Leia a spec completa antes de criar ou alterar testes.
3. Extraia objetivo, escopo, comportamento esperado, critérios de aceite, regras de negócio, estados e falhas, restrições técnicas e impactos em frontend, backend e E2E.
4. Identifique quais critérios de aceite exigem browser e transforme-os em jornadas observáveis.
5. Distinga as precondições de setup das interações browser que a jornada valida.
6. Verifique a infraestrutura E2E e inspecione a implementação e a suíte existentes.
7. Identifique os boundaries afetados e carregue somente as references necessárias.
8. Prepare dados isolados conforme as regras da spec.
9. Implemente somente jornadas justificadas por critérios de aceite.
10. Execute os cenários relacionados usando comandos existentes.
11. Em falhas, preserve traces, screenshots e relatórios disponíveis e diagnostique antes de alterar retry, timeout ou expectativa.
12. Confira cada jornada contra seu critério de aceite antes de concluir.

## Spec Gate

[HARD RULE] Trate `specs/` como a fonte oficial de requisitos, comportamento, critérios de aceite e escopo. Não invente um formato de spec; trabalhe com o formato versionado existente.

Siga esta precedência:

1. restrições do sistema e requisitos críticos de segurança;
2. spec vigente em `specs/`;
3. código e testes existentes, somente como contexto técnico;
4. references desta skill;
5. convenções genéricas da ferramenta;
6. pedido informal do usuário, quando não contradizer a spec.

[HARD RULE] Sem spec válida, não altere código nem testes, não crie jornada provisória e não infira requisitos do pedido ou do comportamento atual. Informe o bloqueio e solicite o caminho, identificador ou conteúdo da spec. Permita somente diagnóstico documental ou análise do estado atual, sem implementar correções.

[HARD RULE] Se a spec omitir uma decisão que altere a jornada, liste a informação ausente e os cenários, dados ou assertions afetados e aguarde esclarecimento ou atualização da spec.

[HARD RULE] Se houver mais de uma spec candidata, liste-as e solicite o identificador correto; não escolha apenas pela proximidade do nome.

[HARD RULE] Se o pedido contradizer a spec, informe o conflito e solicite a atualização da spec. Não implemente o pedido informal enquanto a spec vigente não o autorizar.

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

[HARD RULE] Se a infraestrutura necessária não existir, não invente comandos, URLs, portas, credenciais ou serviços e não instale dependências automaticamente. Bloqueie a implementação E2E e informe exatamente qual pré-requisito exigido pela spec não está disponível.

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

[HARD RULE] API, banco ou helper podem preparar apenas o estado inicial quando isso não substituir a interação browser que a spec exige validar.

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

Antes de concluir:

1. relacione cada scenario ao critério de aceite que ele protege;
2. confirme que setup não bypassa a capability sob teste;
3. confirme independência e isolamento de dados;
4. execute o test/scenario relacionado;
5. investigue qualquer retry/flakiness em vez de mascará-lo;
6. execute a suíte relacionada quando a mudança puder afetar outros journeys;
7. preserve artifacts úteis quando houver falha;
8. não conclua com critério browser não coberto ou não verificável; registre a lacuna ou solicite que a spec defina um resultado observável.

[HARD RULE] Não invente comandos, portas, URLs, credentials, services ou scripts. Use a configuração e os comandos existentes no repositório.
