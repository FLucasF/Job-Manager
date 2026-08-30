# React Router Mode Selection

Referência para identificar o modo React Router usado pelo projeto antes de escolher APIs.

## Contents

- Inspect before implementing
- Declarative Mode
- Data Mode
- Framework Mode
- Mode capability model
- Existing project first
- Migration boundary
- Responsibility boundaries

## Inspect Before Implementing

[HARD RULE] Antes de recomendar ou usar uma API React Router, identifique como o projeto configura o router.

Procure por sinais como:

```text
<BrowserRouter>
<Routes>
<Route>

createBrowserRouter(...)
<RouterProvider>

routes.ts
route modules
@react-router/dev
```

[HARD RULE] Não misture APIs de modes diferentes apenas porque todas pertencem ao React Router.

## Declarative Mode

Use o modelo Declarative quando o projeto é configurado com um router declarativo dentro da árvore React.

Exemplo conceitual:

```tsx
<BrowserRouter>
  <Routes>
    <Route path="/" element={<Home />} />
  </Routes>
</BrowserRouter>
```

Esse mode cobre routing básico como:

```text
route matching
Link / NavLink
useNavigate
useLocation
useParams
useSearchParams
```

[HARD RULE] Não introduza loaders/actions/useFetcher em uma aplicação declarativa sem uma decisão explícita de migrar para Data/Framework mode.

## Data Mode

Data Mode usa um data router criado fora da renderização React.

Exemplo conceitual:

```tsx
const router = createBrowserRouter([
  {
    path: '/',
    Component: Root,
  },
])

<RouterProvider router={router} />
```

Além das capacidades declarativas, pode incluir:

```text
loader
action
Form
useFetcher
pending navigation
automatic revalidation
route error boundaries
```

[HARD RULE] Crie o data router uma vez no boundary da aplicação; não o mantenha como React state.

## Framework Mode

Framework Mode adiciona convenções e tooling de React Router sobre route modules.

Sinais comuns:

```text
@react-router/dev
routes.ts
route module files
react-router.config.ts
```

Pode incluir:

```text
route modules
automatic code splitting
loaders/actions
rendering strategies
framework-specific build/runtime APIs
```

[HARD RULE] Não aplique convenções de Framework Mode a um projeto Vite + React Router declarative/data apenas porque a documentação mostra essas APIs.

## Modes Are Additive, Not Interchangeable

Conceitualmente:

```text
Declarative
    ↓ adds data APIs
Data
    ↓ adds framework conventions/tooling
Framework
```

[HARD RULE] "Mais completo" não significa "melhor para todo projeto".

Preserve o mode já escolhido quando ele atende aos requisitos.

## Existing Project First

[DEFAULT] Em projeto existente:

```text
inspect current router
→ identify mode
→ use APIs available in that mode
```

Não reconfigure o router apenas para usar uma API mais nova ou diferente.

## Do Not Infer Mode from One Hook

APIs como:

```text
Link
useNavigate
useParams
useSearchParams
```

podem aparecer em mais de um mode.

Identifique o **top-level router setup**, não apenas imports locais.

## Package Imports

[DEFAULT] Preserve os imports e package conventions da versão instalada no projeto.

Não troque automaticamente:

```text
react-router-dom
↔ react-router
```

como refactor cosmético.

Verifique versão/configuração antes de alterar imports.

## Migration Boundary

[HARD RULE] Migrar:

```text
Declarative → Data
Data → Framework
```

é decisão arquitetural, não correção local.

Uma tarefa de:

```text
add route
fix navigation
read param
```

não autoriza essa migração por padrão.

## When to Escalate

Consulte esta referência quando:

- não estiver claro qual API usar;
- exemplos encontrados usam setups diferentes;
- tarefa sugere loader/action em `<BrowserRouter>`;
- projeto possui `createBrowserRouter`;
- projeto usa route modules;
- mudança implicaria trocar o top-level router.

## Responsibility Boundaries

Esta referência é dona de:

- identificação do React Router mode;
- compatibilidade de APIs por mode;
- boundary de migração entre modes.

Outras responsabilidades:

- estrutura de rotas → `route-configuration.md`;
- links/navigation → `navigation.md`;
- params/search params → `params-search-params.md`;
- loaders/actions/fetchers → `data-router.md`;
- route errors → `route-errors.md`;
- decisão arquitetural de URL → architecture/routing.
