# React Router Navigation

Referência para links, active navigation, redirects e navegação imperativa com React Router.

## Contents

- Link vs action
- Link
- NavLink
- Programmatic navigation
- Redirect
- Replace vs push
- Relative navigation
- Navigation state
- External navigation
- Responsibility boundaries

## Navigation Should Preserve Semantics

[HARD RULE] Se a interação representa navegação para um destino, prefira a API declarativa de link.

Use:

```tsx
<Link to="/vacancies">
  Vacancies
</Link>
```

em vez de:

```tsx
<button onClick={() => navigate('/vacancies')}>
  Vacancies
</button>
```

quando existe um destino navegável real.

A decisão button-vs-link também pertence a accessibility/semantic-html.

## `<Link>`

[DEFAULT] Use `Link` para navegação interna que possui destino conhecido.

Benefícios incluem preservar o comportamento esperado de navegação client-side e semântica de link.

[HARD RULE] Não substitua links por `onClick + useNavigate` apenas para centralizar navigation code.

## `<NavLink>`

[SITUATIONAL] Use quando a UI precisa representar semanticamente/visualmente o link ativo.

Exemplos:

```text
sidebar
tabs implemented as navigation
main navigation
```

Não use `NavLink` se active state não é necessário.

## Programmatic Navigation

[SITUATIONAL] Use `useNavigate` quando navigation é consequência de lógica/ação, por exemplo:

```text
successful create
→ resource details

cancel wizard
→ previous/list route

session resolution
→ appropriate destination
```

[HARD RULE] Não use navegação imperativa onde um link resolve semanticamente a interação.

## Navigate After Operations

[DEFAULT] Navegação pós-operação deve acontecer no boundary que conhece o resultado e a UX.

Não coloque `navigate()` em:

```text
repository
pure model
shared HTTP client
```

O router não deve contaminar data-access internals.

## Redirect APIs

[SITUATIONAL] Em Data/Framework Mode, loaders/actions/middleware podem usar redirect APIs quando a decisão pertence àquele route data flow.

[HARD RULE] Não introduza loader/action apenas para poder usar `redirect()` em projeto Declarative Mode.

Preserve o mode existente.

## Client Redirect vs Rendered Navigation

Use redirect quando a localização atual não deve continuar representada.

Exemplos:

```text
unauthenticated protected route
legacy path
successful route action
```

Não use redirect para pequenas alterações de UI.

## History Entry: Push vs Replace

[DEFAULT] Preserve uma nova history entry quando o usuário deve poder voltar à localização anterior.

Use replacement quando a localização anterior não deve permanecer como etapa navegável útil.

Exemplos situacionais:

```text
temporary login redirect
canonicalization
post-redirect intermediate URL
```

[HARD RULE] Não aplique `replace` em toda navegação programática por padrão.

Pense no comportamento esperado do Back button.

## Back Navigation

[SITUATIONAL] `navigate(-1)` pode representar "voltar", mas depende de histórico real.

[HARD RULE] Não use history delta quando o produto exige um destino determinístico.

Exemplo:

```text
"Back to vacancies"
→ /vacancies
```

pode ser diferente de:

```text
navigate(-1)
```

se o usuário entrou por link externo.

## Relative Navigation

[SITUATIONAL] Relative links podem simplificar routes realmente hierárquicas.

[HARD RULE] Não use relative navigation quando ela torna o destino difícil de compreender ou depende acidentalmente da posição atual na tree.

Para destinos de domínio importantes, um route builder explícito pode ser mais claro.

## Route Builders

[DEFAULT] Quando paths dinâmicos são reutilizados, use o contract/builder já definido pelo projeto.

```ts
routes.vacancy.details(vacancyId)
```

Não duplique template strings em muitos consumers.

O design geral de route contracts pertence a architecture/routing.

## Navigation State

[SITUATIONAL] `location.state` pode carregar estado transitório associado à navegação.

[HARD RULE] Não use navigation state como substituto de URL para informação que precisa sobreviver a:

```text
reload
deep link
sharing
bookmark
```

[HARD RULE] Não trate `location.state` como armazenamento persistente ou security boundary.

## Passing Sensitive Data

[HARD RULE] Não coloque secrets/credentials em URL ou navigation state por conveniência.

Security rules pertencem a security/sensitive-data.

## External Navigation

[DEFAULT] React Router cuida principalmente de navegação da aplicação.

Links externos devem continuar explicitamente externos e seguir browser/security semantics.

Não force URL externa para dentro de route APIs internas sem necessidade.

## Navigation and Accessibility

[DEFAULT] Client-side route changes podem exigir focus/context handling dependendo da aplicação.

Não faça focus management genérico dentro de todo link/navigation helper.

Consulte accessibility/keyboard-focus.

## Common Bug Patterns

Evite:

- button + navigate para destino que deveria ser link;
- deep components navegando diretamente sem ownership;
- repository chamando navigate;
- `replace: true` por padrão;
- `navigate(-1)` para destino que precisa ser determinístico;
- location.state como source of truth compartilhável;
- paths duplicados em strings;
- loader/action introduzido só por redirect.

## Responsibility Boundaries

Esta referência é dona de:

- `Link`;
- `NavLink`;
- `useNavigate`;
- redirect mechanics;
- history semantics;
- relative navigation.

Outras responsabilidades:

- route semantics → architecture/routing;
- route tree → `route-configuration.md`;
- params/search → `params-search-params.md`;
- auth security → security/auth-session;
- focus after navigation → accessibility/keyboard-focus.
