# Frontend Routing Architecture

Referência para URLs, route boundaries, navigation, parâmetros e controle de acesso no frontend.

## Contents

- Routing responsibility
- Route configuration
- Route boundaries and naming
- Path and search parameters
- URL as source of truth
- Navigation
- Route builders
- Feature/page boundaries
- External input
- Not found
- Nested routes
- Authentication and authorization
- Protected routes and redirects
- Intended destination
- Route-based code splitting
- Responsibility boundaries

## Routing Responsibility

[DEFAULT] Routing relaciona URLs a localizações navegáveis significativas da aplicação.

```text
URL
→ Router
→ Route
→ Page
→ Feature
```

[HARD RULE] Router não deve concentrar regras de negócio da feature.

## Route Configuration

[DEFAULT] Mantenha composição global do router próxima de `app/`.

```text
src/
└── app/
    └── router/
```

O router global pode conhecer:

- available routes;
- layout composition;
- route entry pages;
- redirects;
- route guards/access boundaries;
- not-found fallback.

Feature-specific behavior permanece na feature.

## Routes Represent Navigation Boundaries

[HARD RULE] Crie rota quando existe uma localização navegável independente.

Bons exemplos:

```text
/vacancies
/vacancies/:vacancyId
/users
/users/:userId
```

Não crie rota apenas para:

- tooltip;
- hover;
- loading;
- accordion;
- modal puramente temporário;
- qualquer pequena mudança visual.

[SITUATIONAL] Um modal pode ser route-driven se o produto realmente exige deep-link/back-navigation para aquele estado. A decisão depende de significado navegável, não do componente usado para renderizar.

## Route Naming

[DEFAULT] Caminhos devem representar recursos/áreas, não nomes de componentes ou ações de renderização.

Prefira:

```text
/vacancies
/vacancies/:vacancyId
```

Evite:

```text
/showVacancyScreen
/openVacancyComponent
```

[DEFAULT] Mantenha segmentos estáveis mesmo quando arquivos/componentes são reorganizados.

URL é contrato de navegação, não espelho da estrutura física.

## Path Parameters

[DEFAULT] Use path params para identidade/hierarquia essencial da localização.

```text
/vacancies/:vacancyId
/users/:userId
```

[HARD RULE] Não use path params para estado opcional de visualização quando search params expressam melhor a semântica.

Evite:

```text
/vacancies/open/page/2/sort/date
```

para filtros/paginação.

## Search Parameters

[DEFAULT] Use search params para estado navegável que modifica a visão sem mudar o recurso principal.

Exemplos:

```text
/vacancies?status=open
/vacancies?page=2
/vacancies?search=react&sort=createdAt
```

Bons casos:

- filters;
- pagination;
- sorting;
- search;
- shareable tab/view option.

## URL as Source of Truth

[HARD RULE] Quando um valor está representado na URL, derive a interface da URL.

Evite:

```text
?page=2
+
local page = 3
```

A classificação geral de URL state pertence a `state-placement.md`.

## Keep Non-Navigable State Out of URL

[DEFAULT] Não use search params como store genérico de UI.

Normalmente permaneçam fora da URL:

```text
isTooltipOpen
isHovered
isDragging
temporary interaction state
```

## Route Parameters Are External Input

[HARD RULE] Path/search params vêm de entrada externa e não são confiáveis apenas porque o TypeScript espera outro formato.

Parse/normalize/validate quando necessário antes de usar em operações.

Exemplo:

```text
?page=abc
→ invalid/default handling
```

```text
/vacancies/unknown
→ identifier/resource handling
```

Não confunda validação sintática do parâmetro com existência do recurso.

## Navigation by Intent

[DEFAULT] Navegue quando a ação representa mudança real de localização.

```text
select vacancy
→ /vacancies/123
```

Não navegue para representar qualquer mudança interna de UI.

## Prefer Declarative Links

[DEFAULT] Quando algo é semanticamente um link, use a API declarativa do router.

Isso preserva melhor o contrato esperado de navegação.

Não transforme links normais em `onClick + navigate()` sem necessidade.

## Programmatic Navigation

[SITUATIONAL] Use quando a navegação é consequência de uma operação:

```text
login success
→ dashboard

create success
→ resource details

delete success
→ list
```

[HARD RULE] Repository não executa navegação.

A camada de coordenação/interação reage ao resultado e decide a próxima localização.

## Route Strings and Builders

[DEFAULT] Evite espalhar paths reutilizados por muitos consumers.

Quando uma rota é reutilizada, considere um builder/contract:

```ts
const routes = {
  vacancies: {
    list: '/vacancies',
    details(id: string) {
      return `/vacancies/${id}`
    },
  },
}
```

[SITUATIONAL] Uma rota usada uma única vez não exige abstração global.

[HARD RULE] Route builder apenas constrói caminho.

Não deve:

- ler React state;
- executar navigation;
- buscar dados;
- conter regra de negócio.

## Feature Route Ownership

[DEFAULT] Router global conhece a existência da rota; feature conhece comportamento do domínio.

```text
/vacancies/:vacancyId
→ VacancyDetailsPage
→ vacancies feature
```

Não mova regra de `vacancies` para o router porque a rota aponta para essa feature.

## Page Boundary

[DEFAULT] Page pode conectar route context à feature.

Ela pode:

- ler route params;
- compor feature components;
- representar page-level loading/error/not-found;
- iniciar operações necessárias para aquela localização.

[HARD RULE] Page não deve se tornar container para toda regra da feature.

Quando possível, interprete detalhes específicos do router no boundary da page e passe dados/ids necessários aos componentes internos.

## Keep Router Dependencies Near the Boundary

[DEFAULT] Componentes profundamente internos não precisam conhecer router APIs se seu contrato pode receber:

```text
id
callback
navigation intent
```

[HARD RULE] Model, Repository e `shared/` não devem depender do router.

Hooks/components específicos podem depender quando routing é parte real de sua responsabilidade, mas mantenha esse acoplamento no menor boundary possível.

## Missing Route vs Missing Resource

[HARD RULE] Diferencie:

```text
/unknown
→ route does not exist
```

de:

```text
/vacancies/999
→ route exists, resource may not
```

Router fallback cuida do primeiro.

A feature/page trata o segundo conforme o resultado de data access.

## Not Found Route

[DEFAULT] Defina fallback para URL que não corresponde a nenhuma rota conhecida.

Não use esse fallback como substituto para resource-not-found dentro de uma rota válida.

## Nested Routes

[SITUATIONAL] Use nesting quando existe hierarquia real de navegação ou layout.

```text
/settings
/settings/profile
/settings/security
```

[HARD RULE] Não derive nesting da estrutura de diretórios.

URL hierarchy segue navegação do usuário, não organização física do código.

## Authentication vs Authorization

[HARD RULE] Mantenha a distinção:

```text
Authentication
→ who is the user?

Authorization
→ may this user access the resource/action?
```

Uma rota pode exigir apenas autenticação ou também uma permission/role.

## Protected Routes

[DEFAULT] Route protection decide se uma localização pode ser apresentada/navegada no frontend.

```text
route requested
→ access condition
├── allowed → render
└── denied  → redirect/appropriate access UI
```

[HARD RULE] Frontend route protection não é mecanismo de segurança suficiente.

Backend/API continua responsável por autorização dos recursos protegidos.

## Redirects

[DEFAULT] Use redirect quando a localização atual não deve continuar representada.

Exemplos:

```text
unauthenticated
→ /login

legacy route
→ current route

successful create
→ new resource
```

Não use redirect para qualquer mudança interna de estado.

## Preserve Intended Destination

[SITUATIONAL] Em auth flows, pode ser útil preservar a localização pretendida:

```text
/vacancies/create
→ /login
→ auth success
→ /vacancies/create
```

Faça somente quando compatível com a política de segurança e UX da aplicação.

[HARD RULE] Não aceite um destino externo/arbitrário sem validação quando ele pode originar open redirect ou navegação insegura.

## Route-Based Code Splitting

[SITUATIONAL] Rotas são boundaries naturais para lazy loading quando a área é grande e não precisa fazer parte do bundle inicial.

Use quando existe benefício concreto.

[HARD RULE] Não adicione lazy boundary a toda rota pequena apenas por padrão.

Preserve loading/error handling compatível com o boundary criado.

## Routing and Server State

[DEFAULT] A URL identifica/localiza; server-state/data access busca e possui o recurso remoto.

Evite mover fetching/Repository implementation para o router apenas porque route params determinam o recurso.

```text
route param
→ page/feature
→ server-state hook
→ repository
```

## Router-Centric Architecture

[HARD RULE] Não organize toda a aplicação ao redor de callbacks/configuração do router.

Routing é um boundary de navegação dentro da arquitetura, não o dono de:

- domain rules;
- repositories;
- application state inteiro;
- form logic;
- UI components compartilhados.

## Responsibility Boundaries

Esta referência é dona de:

- route/URL semantics;
- path/search params;
- navigation/redirect;
- route/page boundaries;
- route access;
- not-found routing;
- route-based lazy loading.

Outras responsabilidades:

- URL state ownership → `state-placement.md`;
- feature/file placement → `project-structure.md`;
- external data access → `data-access.md`;
- domain dependency direction → `layered-architecture.md`;
- page UI states → UI states;
- authentication data source → relevant application/data-access boundaries.
