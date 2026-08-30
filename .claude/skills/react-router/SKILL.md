---
name: react-router
description: React Router idioms and APIs: mode selection, data router, route configuration, navigation, params and search params, and route errors. Use as the routing overlay when the affected boundary uses React Router. Load together with the concern skill that owns the decision. Do not use for other routing libraries.
---

# React Router

Routing overlay for the `react-router` technology. It carries only idioms and APIs.

The concern skill owns the decision: frontend-development. Load it for the rule and load
this skill for the mechanism. When the two appear to disagree, the rule wins and
the disagreement is reported.

`CLAUDE.md` governs the spec gate, RPI workflow, architecture authority,
security, validation and completion. This skill authorizes no technology,
dependency, requirement or architecture.

## Reference Routing

[HARD RULE] Antes de usar APIs específicas, identifique se o projeto utiliza Declarative, Data ou Framework Mode.

- Mode atual, compatibilidade de APIs e boundary de migração:
  [mode-selection.md](references/routing/mode-selection.md)

- Route trees, nested/layout/index routes, dynamic segments e `Outlet`:
  [route-configuration.md](references/routing/route-configuration.md)

- `Link`, `NavLink`, `useNavigate`, redirects e history semantics:
  [navigation.md](references/routing/navigation.md)

- `useParams`, `useSearchParams`, `useLocation`, parsing e serialization de URL:
  [params-search-params.md](references/routing/params-search-params.md)

- Loaders, actions, `<Form>`, fetchers, pending e revalidation em Data/Framework Mode:
  [data-router.md](references/routing/data-router.md)

- Route error boundaries, `useRouteError`, loader/action failures e not-found:
  [route-errors.md](references/routing/route-errors.md)

- Revisão consolidada de React Router:
  [review-checklist.md](references/routing/review-checklist.md)

[HARD RULE] `architecture/routing.md` decide o contrato de URL/navegação; estas referências apenas orientam sua implementação com React Router.

[HARD RULE] Não carregue todas as referências de react-router por padrão.
