---
name: frontend-development
description: Implementa, altera, corrige e revisa frontend React com TypeScript, incluindo arquitetura, formulários, estados de UI, acessibilidade, segurança, React Router, performance, Tailwind e testes frontend. Use quando a tarefa envolver código, comportamento, styling, estrutura, tipagem, navegação, segurança, performance ou revisão do frontend.
---

# Frontend Development

Trabalhe exclusivamente no frontend quando a tarefa não exigir mudanças em outras aplicações.

## Workflow

Antes de alterar código:

1. Leia a especificação da feature correspondente.
2. Inspecione a implementação existente.
3. Identifique componentes, tipos, padrões e testes reutilizáveis.
4. Identifique quais domínios da tarefa exigem referência.
5. Consulte somente os arquivos diretamente relacionados.
6. Implemente preservando os padrões existentes do projeto.
7. Valide a mudança antes de concluir.

## Reference Loading Rules

[HARD RULE] Não leia todas as referências por padrão.

[HARD RULE] Não use `README.md` como router intermediário. Os arquivos necessários estão ligados diretamente neste `SKILL.md`.

[DEFAULT] Carregue a menor quantidade de referências capaz de orientar corretamente a tarefa.

Uma tarefa pode exigir mais de um domínio. Nesse caso, carregue somente os arquivos diretamente envolvidos de cada domínio.

Referências relacionadas dentro de um arquivo não devem ser carregadas automaticamente. Siga uma referência adicional somente quando a tarefa realmente exigir aquela responsabilidade.

### Review Strategy

[DEFAULT] Em tarefas de revisão, comece pelo `review-checklist.md` do domínio relevante.

Se o checklist identificar um problema, consulte somente a referência detalhada relacionada ao item.

[HARD RULE] Não carregue todas as referências detalhadas apenas para executar uma revisão geral.

---

## Architecture

- `app/`, feature-first structure, `shared/`, file placement e feature public API:
  [project-structure.md](references/architecture/project-structure.md)

- Components/hooks/model/repository responsibilities, dependency direction e necessidade de camadas:
  [layered-architecture.md](references/architecture/layered-architecture.md)

- Local, Context, server, form, URL, global e derived state ownership:
  [state-placement.md](references/architecture/state-placement.md)

- Repository, HTTP client, external contracts, mapping e transport boundaries:
  [data-access.md](references/architecture/data-access.md)

- Routes, path/search params, URL state, navigation, redirects, not-found e route protection:
  [routing.md](references/architecture/routing.md)

- Revisão consolidada de arquitetura:
  [review-checklist.md](references/architecture/review-checklist.md)

[HARD RULE] Não carregue todas as referências de architecture por padrão.

## Forms

- Draft editável, initial/default values, reset, dirty/touched, conditional fields e collections:
  [form-state.md](references/forms/form-state.md)

- Field/cross-field rules, schema, timing, optional values e async validation:
  [validation.md](references/forms/validation.md)

- Input mapping, pending, duplicate prevention, success/failure, create/update e retry:
  [submission.md](references/forms/submission.md)

- Field/form/server/submission errors, normalization, lifecycle e mensagens:
  [error-handling.md](references/forms/error-handling.md)

- Revisão consolidada de formulários:
  [review-checklist.md](references/forms/review-checklist.md)

[HARD RULE] Não carregue todas as referências de forms por padrão.

## UI States

- Pending, initial/background loading, refetch, spinner, skeleton e progress:
  [loading.md](references/ui-states/loading.md)

- Success sem conteúdo, collection empty, first-use e no-results:
  [empty.md](references/ui-states/empty.md)

- Falhas de página/seção/ação, partial failure, retry e recovery:
  [error.md](references/ui-states/error.md)

- Interação indisponível, capability semantics, pending conflicts e disabled controls:
  [disabled.md](references/ui-states/disabled.md)

- Revisão consolidada de UI states:
  [review-checklist.md](references/ui-states/review-checklist.md)

## Accessibility

- Native elements, button vs link, headings, landmarks, lists, tables e DOM semantic order:
  [semantic-html.md](references/accessibility/semantic-html.md)

- ARIA, accessible names/descriptions, semantic states, relationships, IDs e live regions:
  [aria.md](references/accessibility/aria.md)

- Keyboard operability, tab order, focus visibility, dialogs e programmatic focus:
  [keyboard-focus.md](references/accessibility/keyboard-focus.md)

- Labels, instructions, groups, validation feedback, field errors e form accessibility:
  [form-accessibility.md](references/accessibility/form-accessibility.md)

- Revisão consolidada de acessibilidade:
  [review-checklist.md](references/accessibility/review-checklist.md)

[HARD RULE] Não carregue todas as referências de accessibility por padrão.

## Security

Use estas referências para riscos específicos do frontend/browser. Autenticação e autorização reais continuam sendo responsabilidades do backend.

- Untrusted HTML, XSS-sensitive sinks, sanitization, dynamic URLs e executable content:
  [untrusted-content.md](references/security/untrusted-content.md)

- Frontend auth state, session credentials, logout, expiry e authorization boundary:
  [auth-session.md](references/security/auth-session.md)

- CORS, CSRF awareness, CSP, redirects, `postMessage`, windows e iframes:
  [browser-security.md](references/security/browser-security.md)

- Client-visible env, browser storage, URLs, logs, telemetry, PII e data minimization:
  [sensitive-data.md](references/security/sensitive-data.md)

- Third-party scripts, analytics, SDKs, widgets, dependencies e isolation:
  [third-party-code.md](references/security/third-party-code.md)

- Revisão consolidada de segurança frontend:
  [review-checklist.md](references/security/review-checklist.md)

[HARD RULE] Não carregue todas as referências de security por padrão.

[HARD RULE] Não altere autenticação, autorização, cookie policy, CSP ou backend security architecture incidentalmente; sinalize riscos fora do escopo e preserve o boundary responsável.

## TypeScript

- Type safety, `any`, assertions, object modeling, `keyof` e dynamic access:
  [type-safety.md](references/typescript/type-safety.md)

- Inferência, contextual typing, generics e constraints:
  [inference-generics.md](references/typescript/inference-generics.md)

- `null`, `undefined`, optional chaining e narrowing:
  [nullability.md](references/typescript/nullability.md)

- Imports, exports, `.d.ts`, typings e module resolution:
  [modules-imports.md](references/typescript/modules-imports.md)

- `tsconfig.json`, strictness, `target`, `lib`, module options e compiler plugins:
  [compiler-config.md](references/typescript/compiler-config.md)

- Revisão TypeScript:
  [review-checklist.md](references/typescript/review-checklist.md)

[HARD RULE] Regras específicas de React/TSX pertencem a `references/react-tsx/`, não a `references/typescript/`.

## React + TypeScript

- Props, native wrappers, optionality, callback contracts e hook-derived prop coupling:
  [props.md](references/react-tsx/props.md)

- `children`, `React.ReactNode` e conteúdo renderizável:
  [children.md](references/react-tsx/children.md)

- Event handlers e callbacks públicos:
  [events.md](references/react-tsx/events.md)

- DOM refs, React 19 ref props e compatibilidade com `forwardRef`:
  [refs.md](references/react-tsx/refs.md)

- Design e tipagem de custom hooks:
  [custom-hooks.md](references/react-tsx/custom-hooks.md)

- Context, providers, consumer hooks e `use()`:
  [context.md](references/react-tsx/context.md)

- Effects, external synchronization, dependencies, cleanup e Effect Events:
  [effects-synchronization.md](references/react-tsx/effects-synchronization.md)

- Componentes genéricos e relações entre props:
  [generic-components.md](references/react-tsx/generic-components.md)

- Render Props, render functions e slots:
  [render-props-slots.md](references/react-tsx/render-props-slots.md)

- Estado local com actions tipadas e `useReducer`:
  [use-reducer.md](references/react-tsx/use-reducer.md)

- Stale closures, dependency arrays e callbacks:
  [stale-callbacks.md](references/react-tsx/stale-callbacks.md)

- `React.memo`, memoization e estabilidade de props:
  [memo-stable-props.md](references/react-tsx/memo-stable-props.md)

- APIs tipadas de componentes de design system:
  [design-system-components.md](references/react-tsx/design-system-components.md)

- Revisão React + TypeScript:
  [review-checklist.md](references/react-tsx/review-checklist.md)

[HARD RULE] Mecânica geral da linguagem TypeScript pertence a `references/typescript/`; esta pasta cobre decisões específicas da combinação React + TypeScript.

## React Router

[HARD RULE] Antes de usar APIs específicas, identifique se o projeto utiliza Declarative, Data ou Framework Mode.

- Mode atual, compatibilidade de APIs e boundary de migração:
  [mode-selection.md](references/react-router/mode-selection.md)

- Route trees, nested/layout/index routes, dynamic segments e `Outlet`:
  [route-configuration.md](references/react-router/route-configuration.md)

- `Link`, `NavLink`, `useNavigate`, redirects e history semantics:
  [navigation.md](references/react-router/navigation.md)

- `useParams`, `useSearchParams`, `useLocation`, parsing e serialization de URL:
  [params-search-params.md](references/react-router/params-search-params.md)

- Loaders, actions, `<Form>`, fetchers, pending e revalidation em Data/Framework Mode:
  [data-router.md](references/react-router/data-router.md)

- Route error boundaries, `useRouteError`, loader/action failures e not-found:
  [route-errors.md](references/react-router/route-errors.md)

- Revisão consolidada de React Router:
  [review-checklist.md](references/react-router/review-checklist.md)

[HARD RULE] `architecture/routing.md` decide o contrato de URL/navegação; estas referências apenas orientam sua implementação com React Router.

[HARD RULE] Não carregue todas as referências de react-router por padrão.

## Performance

[HARD RULE] Não otimize por suposição. Meça o problema antes de introduzir otimizações.

- Measurement-first workflow, React/browser profiling, baseline e before/after validation:
  [measurement-profiling.md](references/performance/measurement-profiling.md)

- React rendering cost, state boundaries, React Compiler, memoization e large lists:
  [rendering-performance.md](references/performance/rendering-performance.md)

- Initial JavaScript, dynamic imports, `lazy`, Suspense, chunks e dependency cost:
  [bundle-loading.md](references/performance/bundle-loading.md)

- Request waterfalls, duplicate fetching, cache, prefetch, pagination e mutation reconciliation:
  [data-network.md](references/performance/data-network.md)

- Core Web Vitals (`LCP`, `INP`, `CLS`), main-thread work, images, fonts e layout:
  [browser-performance.md](references/performance/browser-performance.md)

- Revisão consolidada de performance:
  [review-checklist.md](references/performance/review-checklist.md)

[HARD RULE] Antes de recomendar memoization manual em código novo, verifique se React Compiler está habilitado no projeto.

[HARD RULE] Não carregue todas as referências de performance por padrão.

## Tailwind

- Flex, grid, positioning, stacking, overflow e layout:
  [layout.md](references/tailwind/layout.md)

- Spacing, dimensions, min/max sizing e viewport units:
  [spacing-sizing.md](references/tailwind/spacing-sizing.md)

- Typography, wrapping, truncation e font features:
  [typography.md](references/tailwind/typography.md)

- Backgrounds, gradients, borders, radius e outlines:
  [backgrounds-borders.md](references/tailwind/backgrounds-borders.md)

- Shadows, rings, filters, backdrop effects e masks:
  [effects-filters-masks.md](references/tailwind/effects-filters-masks.md)

- Transitions, animations, transforms, motion e perspective:
  [transforms-transitions.md](references/tailwind/transforms-transitions.md)

- Native controls, scrolling, pointer, touch e `will-change`:
  [interactivity.md](references/tailwind/interactivity.md)

- Breakpoints, container queries, states, ARIA/data variants e dark mode:
  [responsive-variants.md](references/tailwind/responsive-variants.md)

- `@theme`, tokens, custom utilities, custom variants, prefix e important:
  [theme-customization.md](references/tailwind/theme-customization.md)

- Vite, PostCSS, CLI, editor tooling e integrations:
  [tooling-integrations.md](references/tailwind/tooling-integrations.md)

- Revisão Tailwind:
  [review-checklist.md](references/tailwind/review-checklist.md)

## Frontend Testing

Use estas referências para unit e integration testing do frontend.

[HARD RULE] Fluxos E2E completos pertencem à skill geral `testing`.

- Escolha do nível, distribuição de cenários, coverage e regression strategy:
  [test-strategy.md](references/testing/test-strategy.md)

- Pure logic, domain rules, transformations, reducers e comportamento isolado:
  [unit-testing.md](references/testing/unit-testing.md)

- Components, hooks, forms, routing, server state e data access funcionando juntos:
  [integration-testing.md](references/testing/integration-testing.md)

- Mocks, spies, stubs, fakes, network mocking e dependency boundaries:
  [mocking.md](references/testing/mocking.md)

- Promises, `waitFor`, pending, timers, retries, concurrency e race conditions:
  [async-testing.md](references/testing/async-testing.md)

- Revisão consolidada de testes frontend:
  [review-checklist.md](references/testing/review-checklist.md)

[HARD RULE] Não carregue todas as referências de testing por padrão.

---

## Project Rules

[HARD RULE] Preserve type safety.

- Evite `any` quando existir alternativa segura.
- Respeite a configuração TypeScript existente.
- Reutilize tipos existentes antes de criar novos.
- Não duplique contratos provenientes da API sem necessidade.
- Preserve os padrões existentes do frontend.
- Reutilize componentes existentes antes de criar novos.
- Mantenha regras de domínio fora de componentes quando a arquitetura já define um boundary apropriado.
- Mantenha componentes desacoplados de detalhes HTTP quando o data-access existente fornece essa separação.
- Adicione ou atualize testes quando o comportamento protegido for alterado.

## Finalization

Antes de concluir:

1. confirme que a implementação atende à spec;
2. execute o typecheck configurado no projeto;
3. execute os testes relacionados à mudança;
4. execute o lint configurado no projeto;
5. corrija falhas encontradas e repita as validações afetadas.

[HARD RULE] Não invente comandos ou ferramentas. Use os scripts e configurações existentes no projeto.