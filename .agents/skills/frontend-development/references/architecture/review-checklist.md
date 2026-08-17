# Frontend Architecture Review Checklist

Checklist operacional para revisão arquitetural do frontend.

[DEFAULT] Use este arquivo primeiro em revisão de arquitetura.

[HARD RULE] Consulte somente a referência detalhada relacionada ao item que exigir investigação.

## Contents

- Project Structure
- Layered Architecture
- State Placement
- Data Access
- Routing
- Cross-Cutting Boundaries
- Escalation

## Project Structure

- [ ] Código específico permanece na feature correspondente?
- [ ] `app/` contém apenas composição/configuração global?
- [ ] `shared/` é independente de features?
- [ ] Código não foi movido para `shared/` por antecipação?
- [ ] Features não possuem diretórios/camadas vazios apenas por simetria?
- [ ] Public API da feature existe somente quando estabiliza um boundary real?
- [ ] Consumers externos não dependem de internals profundos sem necessidade?
- [ ] Movimentação de arquivos preservou imports e dependency boundaries?

## Layered Architecture

- [ ] Components estão focados em presentation/interaction?
- [ ] Hooks contêm apenas comportamento que realmente precisa de React?
- [ ] Pure logic permanece fora de hooks quando possível?
- [ ] Model permanece independente de React, presentation e infrastructure?
- [ ] Repository não depende de components/hooks?
- [ ] Dependências seguem a direção das responsabilidades?
- [ ] Nenhuma camada foi criada apenas para repassar chamadas?
- [ ] "Pular camada" não fez outra responsabilidade cair no lugar errado?
- [ ] `shared/` continua lower-level em relação às features?

## State Placement

- [ ] Estado está no menor scope necessário?
- [ ] Shared local state foi elevado apenas até o owner comum necessário?
- [ ] Context não virou store global genérica?
- [ ] Server state permanece na camada de server-state/cache?
- [ ] Remote data não foi espelhado em `useState`/Context/store sem responsabilidade diferente?
- [ ] Form draft está separado do recurso persistido?
- [ ] URL é fonte de verdade para state representado nela?
- [ ] Derived values são calculados em vez de armazenados?
- [ ] Global client state só existe quando áreas independentes realmente precisam?
- [ ] Existe uma única fonte de verdade por informação?

## Data Access

- [ ] Components não conhecem raw HTTP/endpoints?
- [ ] React hooks usam o Repository quando esse é o boundary adotado?
- [ ] Repository concentra detalhes da fonte externa?
- [ ] HTTP client compartilhado não foi duplicado entre features?
- [ ] External DTOs não vazam desnecessariamente para presentation?
- [ ] Mapping existe somente quando há diferença real de contrato?
- [ ] Repository não executa navigation, toast, modal ou React state updates?
- [ ] Cache/server-state policy permanece fora do Repository quando depende da biblioteca React?
- [ ] Repository não virou container de domain/UI logic?

## Routing

- [ ] Cada rota representa localização navegável significativa?
- [ ] Paths representam recursos/áreas, não nomes de componentes?
- [ ] Path params representam identidade/hierarquia?
- [ ] Search params representam view/query state apropriado?
- [ ] Valores na URL não estão duplicados em React state?
- [ ] Route params são tratados como external input?
- [ ] Declarative link é usado quando a interação é um link real?
- [ ] Programmatic navigation aparece somente quando a navegação é consequência de uma operação?
- [ ] Repository/model/shared permanecem independentes do router?
- [ ] Missing route e missing resource estão separados?
- [ ] Nested routes representam hierarquia real de navegação?
- [ ] Authentication e authorization permanecem distintas?
- [ ] Frontend route protection não é tratada como segurança do backend?
- [ ] Redirect destination é seguro quando deriva de input?
- [ ] Route-based lazy loading existe somente com benefício concreto?

## Cross-Cutting Boundaries

- [ ] Project structure não está sendo usado para decidir behavior?
- [ ] Layering não está sendo usado como motivo para criar abstrações vazias?
- [ ] State ownership não está sendo decidido apenas pela ferramenta disponível?
- [ ] Routing não virou owner de state/domain/data access?
- [ ] Data access não controla UI?
- [ ] Architecture references apontam para forms/UI states/React apenas quando a responsabilidade realmente cruza o boundary?

## Escalation

```text
app / features / shared / file placement / public API
→ project-structure.md

components / hooks / model / repository responsibilities
dependency direction / layer necessity
→ layered-architecture.md

local / Context / server / form / URL / global / derived state
→ state-placement.md

Repository / HTTP / DTO mapping / transport boundary
→ data-access.md

routes / params / URL / navigation / redirects / protected routes
→ routing.md
```

[HARD RULE] Não carregue todas as referências de architecture apenas para uma revisão geral.
