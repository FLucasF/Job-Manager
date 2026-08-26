# Frontend Data and Network Performance

Referência para reduzir waterfalls, requests duplicadas e custo de transferência sem quebrar data ownership.

## Contents

- Measure network first
- Request waterfalls
- Parallel independent work
- Duplicate requests
- Server-state cache
- Prefetch
- Overfetching
- Pagination
- Background refetch
- Mutations
- Payload and serialization
- Responsibility boundaries

## Measure the Network Path

[HARD RULE] Antes de alterar caching/fetching, identifique o comportamento real:

```text
which requests start?
when do they start?
which depend on others?
which are duplicated?
how large are responses?
which responses block useful UI?
```

Não otimize apenas contando hooks.

## Request Waterfalls

Waterfall existe quando uma request começa tarde porque depende ou espera trabalho anterior.

Exemplo:

```text
render page
→ fetch user
→ render child
→ fetch vacancies
```

pode ser mais lento que iniciar dados independentes em paralelo.

[HARD RULE] Não paralelize requests que possuem dependência real.

## Start Independent Work Together

[DEFAULT] Quando dois dados são necessários ao mesmo boundary e independentes:

```text
A ─────→
B ─────→
```

é preferível a:

```text
A ─────→
        B ─────→
```

se a arquitetura permite iniciar ambos no mesmo momento.

## Avoid Fetch-on-Render Waterfalls

[DEFAULT] Se a stack oferece route/server-state orchestration capaz de iniciar requests antes ou em paralelo, prefira esse boundary quando o problema foi medido.

[HARD RULE] Não migre toda a data architecture apenas para eliminar um pequeno waterfall local.

## Duplicate Requests

[HARD RULE] Não mantenha múltiplos mechanisms buscando o mesmo recurso sem ownership explícito.

Exemplo problemático:

```text
route loader
+
query hook
+
useEffect fetch
```

para o mesmo dado.

Defina qual camada possui o remote state.

## Server-State Cache

[DEFAULT] Se o projeto usa uma server-state library, aproveite sua cache/deduplication lifecycle antes de criar cache manual.

[HARD RULE] Não copie cache remoto para Context/global/local state apenas para evitar request.

State ownership pertence a architecture/state-placement.

## Cache Is Not Always Faster

[SITUATIONAL] Cache reduz trabalho quando reuse é provável, mas introduz:

```text
staleness
invalidation
memory
coordination
```

Não aumente `staleTime`/TTL indiscriminadamente só para reduzir request count.

Correctness do dado vem antes.

## Prefetch

[SITUATIONAL] Prefetch pode melhorar próxima navegação quando:

```text
next destination is likely
data is cacheable/reusable
network cost is acceptable
```

[HARD RULE] Não faça prefetch de todas as páginas/list items.

Bandwidth também é recurso.

## Intent-Based Prefetch

[SITUATIONAL] Hover/focus/viewport/navigation intent pode ser um sinal útil, dependendo da library.

Não crie prefetch custom se router/server-state tooling já oferece mecanismo apropriado.

## Overfetching

[DEFAULT] Evite buscar campos/coleções muito maiores do que o consumidor precisa quando isso possui custo real e o contrato permite reduzir.

[HARD RULE] Não fragmente API em dezenas de requests pequenas apenas para evitar alguns campos não usados.

Compare roundtrips, payload e manutenção.

## Large Collections

Para coleções grandes, considere conforme requisito:

```text
server pagination
cursor pagination
incremental loading
virtualization
search/filter server-side
```

A escolha depende de volume, UX e backend.

[HARD RULE] Não carregue "todos os registros" esperando que frontend filtering sempre escale.

## Pagination and Filters

[DEFAULT] Quando paginação/filter está na URL, preserve a URL como source of truth.

Não crie cache keys que ignoram parâmetros que realmente alteram o resultado.

## Query Keys

[HARD RULE] Cache identity precisa incluir inputs que mudam semanticamente o dado.

Exemplo conceitual:

```text
vacancies + status=open
≠
vacancies + status=closed
```

A API exata depende da server-state library do projeto.

## Background Refetch

[DEFAULT] Background refresh deve preservar conteúdo utilizável quando possível.

Não substitua toda a página por loading state apenas porque refetch começou.

UX pertence a ui-states/loading.

## Refetch Frequency

[SITUATIONAL] Polling/refetch intervals devem corresponder à necessidade de freshness.

[HARD RULE] Não reduza interval arbitrariamente para "tempo real".

Requests frequentes podem aumentar:

```text
network
backend load
battery
main-thread work
rendering
```

## Real-Time Data

[SITUATIONAL] WebSocket/SSE/polling depende do contrato do produto.

Não introduza realtime transport somente para evitar uma request manual.

## Mutations

[DEFAULT] Depois de mutation, escolha uma estratégia de reconciliation coerente com o owner de server state:

```text
invalidate/refetch
update cache
use returned resource
```

[HARD RULE] Não faça todas ao mesmo tempo sem necessidade.

## Optimistic Updates

[SITUATIONAL] Use quando latency percebida importa e rollback/conflict semantics estão claras.

[HARD RULE] Não use optimistic update em operação cujo failure/reconciliation não está modelado.

Performance percebida não justifica estado incorreto.

## Request Cancellation

[SITUATIONAL] Cancelar request obsoleta pode reduzir trabalho para buscas/interações frequentes.

Exemplo:

```text
search "rea"
→ request A

search "react"
→ request B supersedes A
```

[HARD RULE] Mesmo com cancelamento, preserve latest-result-wins semantics.

## Debounce

[SITUATIONAL] Debounce pode reduzir requests durante input contínuo.

[HARD RULE] Não aplique debounce a todo evento.

Ele adiciona latency deliberada.

Escolha apenas quando comportamento do produto suporta esse atraso.

## Payload Compression and HTTP

Configuração de:

```text
HTTP compression
CDN
cache headers
server response optimization
```

pertence principalmente ao backend/deployment.

Frontend pode identificar o custo, mas não deve inventar server configuration em tarefa local.

## Third-Party Requests

[DEFAULT] Scripts/analytics/assets externos também competem por network/main thread.

Se aparecem no critical path, consulte security/third-party-code e `browser-performance.md`.

## Common Bug Patterns

Evite:

- fetch em Effect + query para mesmo dado;
- requests independentes serializadas;
- prefetch de tudo;
- staleTime infinito para esconder requests;
- polling agressivo sem requisito;
- cache key incompleta;
- invalidate + manual refetch + local copy;
- debounce universal;
- optimistic update sem rollback;
- carregar coleções ilimitadas no client.

## Responsibility Boundaries

Esta referência é dona de:

- request waterfalls;
- duplicate network work;
- cache/prefetch performance decisions;
- collection/network cost;
- mutation reconciliation sob perspectiva de performance.

Outras responsabilidades:

- Repository/HTTP architecture → architecture/data-access;
- state ownership → architecture/state-placement;
- React Router loaders → react-router/data-router;
- loading UX → ui-states;
- measurement → `measurement-profiling.md`.
