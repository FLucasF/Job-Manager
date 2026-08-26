# Quality Assurance E2E Review Checklist

Checklist operacional para revisar uma suíte ou mudança E2E.

[DEFAULT] Use este arquivo primeiro em revisão de QA/E2E.

[HARD RULE] Consulte somente a referência detalhada relacionada ao item que exigir investigação.

## Scenario Value

- [ ] O teste protege uma jornada/risco que realmente merece E2E?
- [ ] O system boundary está claro?
- [ ] Nome usa linguagem de negócio?
- [ ] Precondition, intent, action e outcome estão claros?
- [ ] O cenário não replica dezenas de regras melhor cobertas abaixo?
- [ ] Happy/failure/permission coverage é proporcional ao risco?
- [ ] O teste não virou uma jornada gigante com capacidades não relacionadas?
- [ ] O outcome final é observável e relevante?
- [ ] O cenário não depende de outro teste?

## Test Data

- [ ] Cada test possui seus recursos mutáveis?
- [ ] Dados que alteram comportamento estão explícitos?
- [ ] Factories usam defaults neutros/válidos?
- [ ] Dados únicos suportam parallel/retry/shard?
- [ ] API/DB setup não bypassa a jornada?
- [ ] Usuário/role usa least privilege?
- [ ] Não existem PII/credentials reais?
- [ ] External notifications/payments apontam para sandbox/fake?
- [ ] Cleanup é explícito e remove somente dados próprios?
- [ ] Retry começa em estado válido?

## Environment

- [ ] Application version/configuration são conhecidas?
- [ ] Suíte principal não executa destructive flows em produção?
- [ ] URLs/credentials/config não estão hard-coded nos tests?
- [ ] Services possuem readiness confiável?
- [ ] Database isolation/reset strategy está clara?
- [ ] External services são controlados?
- [ ] Projects/browsers representam riscos reais?
- [ ] Workers não escondem problemas de isolamento?
- [ ] Serial/sharding não introduzem dependência de ordem?
- [ ] CI preserva artifacts suficientes para diagnóstico?
- [ ] Timezone/locale são controlados quando relevantes?

## Playwright

- [ ] Test usa Playwright Test e browser real?
- [ ] Locators priorizam role/name/label?
- [ ] `data-testid` é fallback?
- [ ] CSS/XPath não estão acoplados ao DOM sem necessidade?
- [ ] `first`/`nth` não silenciam locator ambíguo?
- [ ] Actions usam APIs reais do Playwright?
- [ ] Não existem chamadas diretas a internals do frontend?
- [ ] Auto-waiting/web-first assertions substituem sleeps?
- [ ] Page load/networkidle não são readiness universal?
- [ ] Assertions aguardam outcomes relevantes?
- [ ] UI login só ocorre quando login é parte da jornada?
- [ ] `storageState` sensível não é versionado?
- [ ] Fixtures/hooks permanecem explícitos e com scope correto?
- [ ] Page Objects adicionam linguagem/capability, não apenas DOM wrappers?
- [ ] Mocking não remove o próprio backend sem intenção explícita?

## Failure Diagnosis

- [ ] Falha foi classificada como product/test/data/environment?
- [ ] Retry não está escondendo flakiness?
- [ ] Timeout não está sendo usado como sincronização?
- [ ] Trace/report foi considerado antes de workaround?
- [ ] Screenshots/videos são diagnósticos, não assertions?
- [ ] Setup/cleanup failures preservam classificação correta?
- [ ] CI-only failures consideram environment/resource differences?
- [ ] `test.only` é bloqueado em CI?
- [ ] Skips/quarantine possuem razão e ownership?
- [ ] Expected behavior não foi alterado apenas para deixar o test verde?

## Escalation

```text
what to automate / journey / coverage / outcomes
→ test-scenarios.md

factories / setup / users / isolation / cleanup
→ test-data.md

services / config / DB strategy / projects / CI / workers
→ environment.md

locators / actions / assertions / auth / fixtures / page objects
→ playwright.md

retry / timeout / traces / flakiness / quarantine / diagnosis
→ failure-diagnosis.md
```

[HARD RULE] Não carregue todas as referências de QA apenas para uma revisão geral.
