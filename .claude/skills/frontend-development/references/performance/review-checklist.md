# Frontend Performance Review Checklist

Checklist operacional para revisão de performance.

[DEFAULT] Use este arquivo primeiro em code review de performance.

[HARD RULE] Consulte somente a referência detalhada relacionada ao item que exigir investigação.

## Measurement

- [ ] Existe problema/risco de performance concreto?
- [ ] O fluxo afetado foi definido de forma observável?
- [ ] A comparação usa condições reproduzíveis?
- [ ] Production build foi usado quando números reais importam?
- [ ] React profiling foi usado antes de memoization manual?
- [ ] Browser/network profiling foi usado quando o custo pode estar fora do React?
- [ ] Existe baseline e comparação before/after?
- [ ] A mudança adicionada produziu benefício relevante?

## Rendering

- [ ] State está no menor boundary necessário?
- [ ] Não existe Effect → setState para valor derivável?
- [ ] Cálculo caro foi comprovado no hot path?
- [ ] React Compiler foi verificado antes de memoization manual em código novo?
- [ ] `memo` só existe onde rerender + custo justificam?
- [ ] `useMemo` não protege cálculo trivial/correctness?
- [ ] `useCallback` possui necessidade de identity real?
- [ ] Stable props não foram adicionadas indiscriminadamente?
- [ ] Large list usa estratégia proporcional ao volume real?
- [ ] Keys são estáveis e não causam remounts?

## Bundle and Loading

- [ ] Existe evidência de custo no bundle inicial?
- [ ] Código deferred realmente não é necessário no first useful path?
- [ ] `lazy()` está declarado em module scope?
- [ ] Suspense boundary substitui somente a área coerente?
- [ ] Route/framework lazy mechanism não foi duplicado?
- [ ] Custom chunking possui evidência no production build?
- [ ] Large dependency foi revisada antes de criar workaround?
- [ ] Preload/prefetch não anulam lazy loading?
- [ ] Dynamic imports não usam paths arbitrários?

## Data and Network

- [ ] Requests independentes não formam waterfall desnecessário?
- [ ] O mesmo recurso não é buscado por múltiplos owners?
- [ ] Server-state cache existente é usada antes de cache manual?
- [ ] Cache lifetime preserva correctness?
- [ ] Prefetch é limitado a destinos prováveis?
- [ ] Large collections possuem estratégia escalável?
- [ ] Cache key inclui inputs semanticamente relevantes?
- [ ] Background refetch preserva conteúdo utilizável?
- [ ] Polling/realtime frequency possui requisito?
- [ ] Mutation usa uma estratégia coerente de reconciliation?
- [ ] Debounce/optimistic update só existem quando UX suporta?

## Browser / Web Vitals

- [ ] LCP, INP e CLS foram usados como sinais, não hacks?
- [ ] Field e lab data não foram confundidos?
- [ ] Asset principal de LCP não está atrasado sem necessidade?
- [ ] Imagens reservam espaço e usam tamanho adequado?
- [ ] INP ruim foi diagnosticado antes de culpar React?
- [ ] Event handlers evitam trabalho síncrono pesado desnecessário?
- [ ] Async content evita layout shift inesperado?
- [ ] Fonts/assets carregados são realmente usados?
- [ ] Third-party code no critical path foi considerado?
- [ ] Performance change não removeu accessibility/UX necessária?

## Cross-Cutting Boundaries

- [ ] Performance não está sendo usada para justificar mudança arquitetural sem evidência?
- [ ] skill `react` (memo-stable-props.md) continua dono da mecânica de memo APIs?
- [ ] `architecture/data-access.md` continua dono do data-access boundary?
- [ ] UI loading permanece em ui-states?
- [ ] React Router continua dono de route APIs/lazy routes?
- [ ] Security/accessibility não foram sacrificadas pela otimização?

## Escalation

```text
measure / profile / baseline / before-after
→ measurement-profiling.md

rerenders / memo / useMemo / useCallback / Compiler / large lists
→ rendering-performance.md

bundle / lazy / Suspense / chunks / dependencies
→ bundle-loading.md

waterfalls / requests / cache / prefetch / pagination
→ data-network.md

LCP / INP / CLS / main thread / images / layout
→ browser-performance.md
```

[HARD RULE] Não carregue todas as referências de performance apenas para uma revisão geral.
