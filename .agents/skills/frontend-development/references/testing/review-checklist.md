# Frontend Testing Review Checklist

Checklist operacional para revisão de testes frontend.

[DEFAULT] Use este arquivo primeiro em code review de testes.

[HARD RULE] Consulte uma referência detalhada somente quando um item exigir investigação.

## Strategy and Scope

- [ ] O nível de teste corresponde ao comportamento/risco protegido?
- [ ] Lógica pura usa unit test quando apropriado?
- [ ] Colaboração entre partes do frontend usa integration test quando necessário?
- [ ] Fluxos completos de sistema ficaram fora desta skill frontend?
- [ ] O menor boundary escolhido ainda reproduz o risco real?
- [ ] O mesmo cenário não está duplicado entre níveis sem justificativa?
- [ ] Coverage é usada como sinal, não como meta?
- [ ] Bug corrigido recebeu regression test no boundary adequado quando viável?

## Behavior and Contracts

- [ ] Testes verificam comportamento observável/contratos públicos?
- [ ] Detalhes internos não são asserted sem relevância comportamental?
- [ ] Componentes/hooks não recebem teste isolado apenas por existirem?
- [ ] Testes de UI interagem pela interface pública?
- [ ] Queries semânticas são preferidas quando disponíveis?
- [ ] `data-testid` permanece fallback?
- [ ] Framework/library behavior não está sendo re-testado?
- [ ] Nomes descrevem o comportamento protegido?
- [ ] Snapshots extensos não substituem assertions claras?
- [ ] Refatoração interna sem mudança de comportamento tende a preservar os testes?

## Unit Testing

- [ ] A unidade possui comportamento próprio?
- [ ] Pure logic é testada sem React/infrastructure?
- [ ] Boundary values e runtime nullability são cobertos somente quando reais?
- [ ] Transformations testam regra da aplicação, não a biblioteca?
- [ ] Wrappers triviais não recebem testes sem valor?
- [ ] Reducers/state machines são testados por transições públicas?
- [ ] Fixtures mutáveis não vazam entre testes?
- [ ] Unit test continua rápido e local?

## Integration Testing

- [ ] O boundary de integração está explícito?
- [ ] Partes internas relevantes usam implementação real?
- [ ] Backend/serviços externos reais não são necessários?
- [ ] O menor boundary significativo foi renderizado?
- [ ] Forms são exercitados como fluxo quando a colaboração importa?
- [ ] Routing usa router controlado real quando navigation/params fazem parte do comportamento?
- [ ] Server state é validado pelo resultado observável?
- [ ] UI state transitions são testadas apenas quando relevantes?
- [ ] Providers/caches/stores começam em estado conhecido?
- [ ] O teste continua frontend integration, não E2E?

## Mocking and Boundaries

- [ ] Cada mock possui razão clara relacionada ao boundary/determinismo?
- [ ] A própria unidade/colaboração testada não foi mockada?
- [ ] Integration preserva código interno relevante?
- [ ] External/network boundary é preferida quando adequada?
- [ ] Mock data e error shapes respeitam o contrato real?
- [ ] Mocks permanecem type-safe?
- [ ] Helpers de setup não escondem condições importantes?
- [ ] Defaults globais são neutros?
- [ ] Mocks/spies/handlers/globals são restaurados?
- [ ] Call assertions são usadas somente quando interação externa é parte do contrato?
- [ ] Call count/order só são verificados quando alteram comportamento?

## Async Behavior

- [ ] Resultados assíncronos são aguardados por comportamento observável?
- [ ] Não existem sleeps arbitrários?
- [ ] Assertions síncronas continuam síncronas?
- [ ] `waitFor` é usado apenas para condição eventualmente verdadeira?
- [ ] User actions não acontecem dentro de repeated wait callbacks?
- [ ] Pending é controlado deterministicamente quando precisa ser observado?
- [ ] User interactions que retornam Promise são aguardadas?
- [ ] Fake timers são usados somente quando tempo é comportamento?
- [ ] Timers reais são restaurados?
- [ ] Retries automáticos não escondem falhas esperadas?
- [ ] Concorrência/out-of-order/race são reproduzidos quando representam risco?
- [ ] Optimistic rollback é validado pelo resultado observável quando relevante?
- [ ] Timeout maior não está sendo usado como substituto de sincronização correta?

## Isolation and Test Data

- [ ] Cada teste roda independentemente da ordem?
- [ ] Caches/stores/fixtures/mocks não vazam?
- [ ] Dados deixam explícitas as propriedades que alteram o cenário?
- [ ] Time/randomness/environment são controlados somente quando necessário?
- [ ] Setup não é maior ou mais complexo que o boundary necessário?

## Suite Quality

- [ ] A suíte permanece rápida o suficiente para execução frequente?
- [ ] Falhas são determinísticas e reproduzíveis?
- [ ] O teste que falha indica aproximadamente qual comportamento regrediu?
- [ ] Não existem testes enormes cobrindo fluxos independentes?
- [ ] Não existem testes triviais sem comportamento real protegido?

## Escalation

Carregue somente a referência relacionada ao problema:

```text
nível / distribuição / coverage / regression
→ test-strategy.md

pure logic / isolated behavior / unit edge cases
→ unit-testing.md

components + hooks + routing + forms + data access
→ integration-testing.md

mocks / spies / fakes / network / runtime boundaries
→ mocking.md

waitFor / pending / timers / retry / races / concurrency
→ async-testing.md
```

[HARD RULE] Não carregue todas as referências de testing apenas para uma revisão geral.
