# React Router Params and Search Params

Referência para ler, validar, normalizar e atualizar valores provenientes da URL usando React Router.

## Contents

- URL input boundary
- Route params
- Search params
- Parsing
- Defaults
- Serialization
- Updating search params
- Multiple values
- URL source of truth
- Location
- Responsibility boundaries

## Architecture Decides the URL Shape

[HARD RULE] Este arquivo não decide se um valor pertence ao path, search params ou state local.

Essa decisão pertence a `architecture/routing.md` e `architecture/state-placement.md`.

Aqui implementamos o contrato já escolhido.

## URL Values Are External Input

[HARD RULE] Valores lidos da URL são strings externas em runtime.

TypeScript não garante que:

```text
?page=abc
```

seja um número válido.

Nem que:

```text
/vacancies/unknown
```

referencie recurso existente.

Parse, normalize e validate quando necessário.

## Route Params

Use `useParams` para dynamic segments no boundary React apropriado.

Exemplo:

```tsx
const { vacancyId } = useParams()
```

[HARD RULE] Não faça assertion cega:

```ts
const vacancyId = useParams().vacancyId as string
```

quando a route/configuração não garante aquele valor no boundary atual.

Trate ausência/invalidity conforme o contract real.

## Keep Param Reading Near the Route Boundary

[DEFAULT] Leia route params em page/route-level component ou hook que realmente depende do router.

Passe valores normalizados para components/model mais internos.

Evite acoplar toda a feature ao `useParams`.

## Search Params

Use `useSearchParams` para valores da query string quando o contrato arquitetural os define como URL state.

```tsx
const [searchParams, setSearchParams] =
  useSearchParams()

const query = searchParams.get('q') ?? ''
```

## Search Params Are Strings

[HARD RULE] Não assuma tipos implícitos.

Exemplo:

```ts
const rawPage = searchParams.get('page')
const page = parsePositiveInteger(rawPage) ?? 1
```

Faça parsing explícito quando a aplicação precisa de:

```text
number
boolean
enum
date
array
```

## Defaults

[DEFAULT] Defina defaults no parsing/normalization boundary.

```text
missing page
→ page 1

missing sort
→ default sort
```

[HARD RULE] Não mantenha default em múltiplos lugares diferentes.

## Invalid Values

Defina comportamento previsível para URL inválida:

```text
fallback
normalize URL
show invalid/not-found state
```

conforme o contrato.

[HARD RULE] Não deixe `NaN`, enum desconhecido ou estrutura inválida propagar silenciosamente para a feature.

## URL as Source of Truth

[HARD RULE] Se filtro/página/search está representado em search params, derive o estado da URL.

Evite:

```text
searchParams.page = 2
+
useState(page = 3)
```

Não use Effect para sincronizar duas fontes de verdade.

## Updating Search Params

Use `setSearchParams` para alterar o URL state.

[DEFAULT] Preserve parâmetros não relacionados quando a ação altera somente uma parte, se esse é o contrato da tela.

Evite reconstruir a query inteira e apagar:

```text
sort
filters
page
search
```

acidentalmente.

## Reset Dependent Params Intentionally

[SITUATIONAL] Alterar um filtro pode exigir reset de paginação:

```text
status changes
→ page = 1
```

Faça isso como regra explícita do comportamento, não efeito colateral de serialização.

## Serialization

[DEFAULT] Centralize parsing/serialization quando a mesma estrutura de URL é usada em vários lugares.

Exemplo conceitual:

```text
parseVacancySearchParams(...)
serializeVacancySearchParams(...)
```

[HARD RULE] Não crie abstração genérica para query params se só existe um uso trivial.

## `createSearchParams`

[SITUATIONAL] Use APIs estruturadas de URL/SearchParams quando ajudam a construir valores corretamente, especialmente para múltiplos valores.

Não concatene query strings manualmente quando isso torna escaping/encoding frágil.

## Multiple Values

[SITUATIONAL] Quando um param aceita vários valores, escolha e preserve uma representação consistente.

Exemplo:

```text
?status=open&status=draft
```

ou outro formato definido pelo projeto.

[HARD RULE] Não suporte múltiplas serializações diferentes sem necessidade.

## Search Param Ordering

[DEFAULT] Não faça lógica de negócio depender da ordem textual de parâmetros quando a ordem não possui significado.

Compare valores normalizados, não strings completas de URL, quando apropriado.

## `useLocation`

Use `useLocation` quando a responsabilidade precisa do location object:

```text
pathname
search
hash
state
key
```

[HARD RULE] Não adicione Effect baseado em `location` apenas para espelhar URL em state React.

Derive os valores diretamente.

## Hash

[SITUATIONAL] Hash pode representar fragment navigation ou comportamento específico.

Não use fragment como storage alternativo para dados apenas para evitar search params.

Security-sensitive values não devem ir para URL sem protocolo explícito.

## Runtime Validation

[SITUATIONAL] Quando route/search input possui estrutura complexa ou afeta operações importantes, uma função/schema de parsing pode melhorar segurança e previsibilidade.

O objetivo é transformar:

```text
external strings
→ validated internal values
```

não duplicar form validation.

## Common Bug Patterns

Evite:

- `as string` sem garantia real;
- `Number(param)` sem tratar `NaN`;
- URL + useState como duas fontes;
- Effect para sincronizar search params;
- apagar query params não relacionados;
- múltiplos formatos para a mesma query;
- deep component chamando `useParams` sem necessidade;
- construir query string por concatenação frágil.

## Responsibility Boundaries

Esta referência é dona de:

- `useParams`;
- `useSearchParams`;
- `useLocation`;
- URL parsing/serialization;
- runtime normalization de route input.

Outras responsabilidades:

- path-vs-search decision → architecture/routing;
- state ownership → architecture/state-placement;
- navigation → `navigation.md`;
- security of redirect/external URLs → security/browser-security.
