# React Router Review Checklist

Checklist operacional para revisão de código React Router.

[DEFAULT] Use este arquivo primeiro em code review de React Router.

[HARD RULE] Consulte somente a referência detalhada relacionada ao item que exigir investigação.

## Mode

- [ ] O mode atual foi identificado pelo top-level router setup?
- [ ] APIs usadas são compatíveis com esse mode?
- [ ] Declarative/Data/Framework APIs não foram misturadas acidentalmente?
- [ ] Mudança local não introduziu migration de mode sem necessidade?
- [ ] Imports/package conventions da versão instalada foram preservados?

## Route Configuration

- [ ] Route tree implementa a URL architecture existente?
- [ ] Nesting representa layout/navigation hierarchy real?
- [ ] `Outlet` corresponde a parent/child routes reais?
- [ ] Index route representa child default de um parent?
- [ ] Dynamic/optional/splat segments possuem necessidade clara?
- [ ] Route component não absorveu domain/data-access logic?
- [ ] Components internos não dependem do router sem necessidade?
- [ ] Route change não usa remount por `key` como workaround de state?
- [ ] Lazy route boundary existe somente quando tem benefício real?

## Navigation

- [ ] Destinos navegáveis usam `Link`/`NavLink` quando apropriado?
- [ ] `useNavigate` é consequência de lógica, não substituto de link?
- [ ] Repository/model/shared não executam navigation?
- [ ] Push vs replace preserva comportamento esperado do Back button?
- [ ] `navigate(-1)` só é usado quando histórico real é o contrato?
- [ ] Relative navigation não esconde destino importante?
- [ ] Paths reutilizados usam route contract/builder existente?
- [ ] `location.state` não substitui URL state compartilhável/persistente?

## Params and Search Params

- [ ] Params/search params são tratados como external strings?
- [ ] Parsing/normalization lida com `null`, invalid number e enums desconhecidos?
- [ ] Assertions `as string` só existem quando realmente garantidas?
- [ ] URL continua source of truth para filtros/paginação nela representados?
- [ ] Não existe Effect espelhando URL em React state?
- [ ] Update de search params preserva valores não relacionados quando necessário?
- [ ] Serialização usada pela feature é consistente?
- [ ] Route hooks ficam próximos do router boundary quando possível?

## Data Router

- [ ] Loader/action/fetcher só são usados em Data/Framework mode?
- [ ] Loader/action respeitam Repository/data-access existente?
- [ ] Loader não duplica query/request para o mesmo resource?
- [ ] Existe owner clara quando React Router e outra server-state library coexistem?
- [ ] `<Form>`/`useSubmit`/fetcher correspondem ao UX real?
- [ ] Action não produz múltiplos mechanisms concorrentes de revalidation?
- [ ] Navigation pending e fetcher pending não foram confundidos?
- [ ] Advanced revalidation/data strategy só existe com necessidade comprovada?
- [ ] Validation normal não foi transformada em route error?

## Route Errors

- [ ] Error boundary cobre o menor route subtree coerente?
- [ ] Error boundary não é usado como controle de fluxo normal?
- [ ] `useRouteError()` sofre narrowing antes de acessar campos?
- [ ] Resource-not-found e unknown route permanecem distintos?
- [ ] Form validation não usa route error boundary?
- [ ] Unknown errors possuem fallback seguro?
- [ ] UI não expõe stack/internals/sensitive data?
- [ ] Retry/navigation de recovery corresponde a uma ação real?

## Cross-Cutting Boundaries

- [ ] `architecture/routing.md` continua dono das decisões de URL?
- [ ] React Router refs apenas implementam o contrato arquitetural?
- [ ] Data access continua no boundary de architecture?
- [ ] Form behavior continua em forms?
- [ ] UI loading/error continua em ui-states?
- [ ] Focus/accessibility continua em accessibility?
- [ ] Security de redirects/sensitive navigation continua em security?

## Escalation

```text
Declarative / Data / Framework / setup compatibility
→ mode-selection.md

Route / nested / layout / index / Outlet / lazy
→ route-configuration.md

Link / NavLink / navigate / redirect / history
→ navigation.md

useParams / useSearchParams / useLocation / parsing
→ params-search-params.md

loader / action / Form / fetcher / revalidation / pending
→ data-router.md

route error boundary / useRouteError / not-found
→ route-errors.md
```

[HARD RULE] Não carregue todas as referências de react-router apenas para uma revisão geral.
