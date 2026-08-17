# React Router Route Configuration

Referência para representar route trees, layouts, nesting e entry points usando React Router.

## Contents

- Architecture vs implementation
- Route configuration by mode
- Nested routes
- Layout routes
- Index routes
- Dynamic and optional segments
- Splats
- Outlet
- Route entry points
- Route identity
- Lazy route boundaries
- Responsibility boundaries

## Architecture vs Implementation

[HARD RULE] `architecture/routing.md` decide **se** algo deve ser rota e qual semântica de URL é apropriada.

Este arquivo decide **como representar essa decisão no React Router**.

Não redesenhe URLs apenas para facilitar a API da biblioteca.

## Declarative Route Configuration

Em Declarative Mode, routes podem ser declaradas com:

```tsx
<Routes>
  <Route path="/" element={<Root />}>
    <Route index element={<Home />} />
    <Route path="vacancies" element={<VacancyList />} />
  </Route>
</Routes>
```

[DEFAULT] Mantenha a configuração legível e próxima da composição do router definida pela arquitetura do projeto.

## Data Route Configuration

Em Data Mode, use route objects no router:

```tsx
const router = createBrowserRouter([
  {
    path: '/',
    Component: Root,
    children: [
      {
        index: true,
        Component: Home,
      },
      {
        path: 'vacancies',
        Component: VacancyList,
      },
    ],
  },
])
```

[HARD RULE] Não converta declarative routes em route objects sem necessidade funcional/arquitetural.

## Framework Route Configuration

Em Framework Mode, preserve as convenções de `routes.ts` e route modules já adotadas.

[HARD RULE] Não misture manualmente uma segunda árvore de `<Routes>` para representar as mesmas localizações sem uma razão explícita.

## Nested Routes

[DEFAULT] Use nesting quando existe hierarquia real de layout/navegação.

Exemplo:

```text
/vacancies
/vacancies/:vacancyId
```

pode compartilhar um layout de vacancies quando isso representa a UI real.

[HARD RULE] Não crie nesting apenas porque diretórios estão aninhados.

## `<Outlet>`

Quando uma route pai renderiza children aninhados, o ponto de renderização precisa permanecer explícito.

Exemplo:

```tsx
function VacanciesLayout() {
  return (
    <>
      <VacanciesNavigation />
      <Outlet />
    </>
  )
}
```

[HARD RULE] Não use Outlet como container genérico fora de uma relação real parent/child de routes.

## Layout Routes

[SITUATIONAL] Layout routes podem agrupar UI compartilhada sem necessariamente adicionar um segmento de URL.

Use quando existe:

```text
shared shell
shared navigation
shared route context
```

Não crie layout route apenas para reduzir algumas linhas de JSX.

## Index Routes

[DEFAULT] Use index route quando o parent path precisa de uma child default.

Conceitualmente:

```text
/settings
→ SettingsHome

/settings/profile
→ ProfileSettings
```

A index route representa o conteúdo padrão do parent.

## Dynamic Segments

Use dynamic segments quando a arquitetura definiu identidade variável:

```text
/vacancies/:vacancyId
```

Depois leia o valor usando APIs apropriadas ao mode.

[HARD RULE] Nomes de dynamic segments dentro do mesmo path devem ser claros e não ambíguos.

Semântica path-vs-search pertence a architecture/routing.

## Optional Segments

[SITUATIONAL] Use optional segments somente quando as duas formas de URL representam claramente a mesma route responsibility.

Evite optionalidade que torna a rota difícil de compreender ou cria múltiplos significados implícitos.

## Splats

[SITUATIONAL] Use splat/wildcard quando a rota realmente precisa capturar uma parte variável do path.

Não use `*` apenas para evitar modelar routes conhecidas explicitamente.

## Route Entry Component

[DEFAULT] O component associado à route é um boundary entre routing context e a feature.

Ele pode:

```text
read route input
compose page
connect route-specific behavior
```

[HARD RULE] Não mova toda lógica da feature para o route component.

## Keep Deep Components Router-Agnostic When Possible

[DEFAULT] Se um componente interno só precisa de:

```text
vacancyId
onClose
onSelect
```

passe esse contrato em vez de fazê-lo ler router state diretamente sem necessidade.

Isso reduz coupling ao router.

## Route Identity and Keys

[HARD RULE] Não force remounts usando `key={location.pathname}` ou equivalente como solução padrão para bugs de state.

Antes, verifique ownership/reset semantics do estado.

Route changes não devem destruir state local indiscriminadamente.

## Lazy Route Boundaries

[SITUATIONAL] Routes podem ser bons code-splitting boundaries.

Use lazy loading quando há benefício de bundle/loading real.

[HARD RULE] Não adicione lazy a cada route pequena apenas por convenção.

Performance strategy pertence a `performance/` quando adicionada ao projeto.

## Not Found Configuration

Defina o fallback conforme o mode e a estratégia arquitetural.

[HARD RULE] Route-not-found e resource-not-found continuam problemas diferentes.

A experiência de route errors pertence a `route-errors.md`.

## Common Bug Patterns

Evite:

- misturar `<Routes>` e route objects para a mesma árvore sem motivo;
- nesting baseado em pastas;
- Outlet sem parent/child real;
- wildcard para esconder route modeling;
- page component acumulando domínio/data access;
- deep component lendo router por conveniência;
- remount por `key` para corrigir state incorreto;
- migration de mode para adicionar uma route simples.

## Responsibility Boundaries

Esta referência é dona de:

- React Router route trees;
- `<Route>`, route objects e route modules;
- nested/layout/index routes;
- Outlet;
- implementation de dynamic/optional/splat segments.

Outras responsabilidades:

- URL semantics → architecture/routing;
- params parsing → `params-search-params.md`;
- navigation → `navigation.md`;
- data APIs → `data-router.md`;
- route failures → `route-errors.md`.
