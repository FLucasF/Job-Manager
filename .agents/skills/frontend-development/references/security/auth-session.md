# Frontend Authentication and Session Security

Referência para decisões frontend relacionadas a sessão, estado autenticado, route protection e credenciais no browser.

## Contents

- Security boundary
- Authentication state
- Authorization
- Session credentials
- Browser storage
- Cookies
- Session expiry
- Logout
- Sensitive operations
- Route protection
- Error handling
- Responsibility boundaries

## Frontend Is Not the Authorization Boundary

[HARD RULE] O frontend pode controlar UX e navegação, mas não pode conceder autorização real.

```text
Frontend
→ hide/show actions
→ route access UX
→ capability presentation

Backend
→ authenticate requests
→ authorize operations/resources
```

Esconder um button ou bloquear uma rota não protege uma API.

## Authentication State Is Application State

[DEFAULT] O frontend pode representar estados como:

```text
unknown
authenticated
unauthenticated
expired
```

[HARD RULE] Não derive autenticação apenas da existência de dados visuais como:

```text
user object cached somewhere
role string in local state
route previously visited
```

Use a fonte de sessão definida pela arquitetura do sistema.

## Authorization Data Is Untrusted Client State

[HARD RULE] Roles, permissions e capability flags disponíveis no browser servem para UX; não são enforcement suficiente.

Mesmo que:

```text
user.role === 'ADMIN'
```

o backend ainda precisa validar a operação.

## Do Not Invent a New Session Storage Strategy

[HARD RULE] Não migre ou introduza estratégia de token/cookie incidentalmente numa tarefa frontend.

Se a aplicação já possui um contrato de autenticação:

```text
inspect
→ preserve unless task requires change
→ flag security concern when necessary
```

Mudanças de auth architecture exigem decisão explícita.

## Do Not Introduce Credential Storage in Web Storage

[HARD RULE] Não introduza `localStorage` ou `sessionStorage` como novo local para armazenar:

```text
session IDs
JWT access tokens
refresh tokens
authentication credentials
```

JavaScript executando na mesma origin pode acessar Web Storage.

Se o projeto já utiliza esse padrão, não faça migração silenciosa: sinalize o risco e siga o escopo da tarefa.

## HttpOnly Cookies

[DEFAULT] Quando a arquitetura usa cookies de sessão, credenciais que não precisam ser lidas pelo frontend devem permanecer inacessíveis ao JavaScript quando possível.

[HARD RULE] Frontend JavaScript não consegue criar ou ler um cookie `HttpOnly`.

Configuração de:

```text
HttpOnly
Secure
SameSite
cookie scope
```

é responsabilidade do servidor/deployment boundary.

Não tente "simular" essas proteções no React.

## Cookie-Based Sessions and CSRF

[SITUATIONAL] Se autenticação depende de cookies enviados automaticamente pelo browser, operações state-changing podem exigir proteção contra CSRF conforme a arquitetura backend.

[HARD RULE] Não remova token/header/flow anti-CSRF existente porque "o usuário já está autenticado".

A implementação da defesa precisa seguir o contrato do servidor.

## Session Expiry

[DEFAULT] Trate expiração/revogação como uma transição explícita.

```text
authenticated
→ session rejected/expired
→ clear client auth state
→ appropriate re-authentication UX
```

[HARD RULE] Não mantenha UI autenticada indefinidamente depois que a fonte de sessão informou que ela expirou.

## Concurrent Requests During Expiry

[SITUATIONAL] Múltiplas requests podem falhar simultaneamente por expiração.

Evite:

```text
5 requests fail
→ 5 logout flows
→ 5 toasts
→ 5 redirects
```

Centralize a reação quando a arquitetura possui um boundary apropriado para isso.

Data-access/global auth coordination deve possuir uma única responsabilidade clara.

## Logout

[HARD RULE] Logout deve seguir o mecanismo real de invalidação definido pelo sistema.

Evite tratar somente:

```text
remove user from React state
```

como logout completo quando existe sessão/token que precisa ser invalidado ou removido pelo mecanismo correto.

[DEFAULT] Depois do logout, dados client-side sensíveis associados à sessão não devem continuar sendo apresentados como se a sessão ainda estivesse válida.

## Cached Server Data After Logout

[SITUATIONAL] Se a aplicação possui cache client-side de dados privados, considere a política de limpeza/isolamento ao trocar de identidade.

[HARD RULE] Não permita que usuário B veja dados privados cacheados do usuário A após mudança de sessão.

A implementação depende da server-state library e arquitetura existentes.

## Authentication UI Errors

[DEFAULT] Mensagens de login não devem revelar detalhes desnecessários sobre credenciais/contas.

Não exponha:

```text
raw backend exception
token
stack trace
internal auth provider details
```

Error mapping segue os boundaries de forms/UI states.

## Sensitive Operations

[SITUATIONAL] Operações de maior risco podem exigir reauthentication ou confirmação adicional conforme requisito do produto/backend.

[HARD RULE] Não invente reauthentication apenas no frontend esperando que isso proteja a operação.

Enforcement precisa existir no backend.

## Protected Routes

[DEFAULT] Protected routes são úteis para UX:

```text
session unknown
→ wait/resolve

authenticated
→ render

unauthenticated
→ login/redirect
```

[HARD RULE] Protected route não é security enforcement da API.

Detalhes de route architecture pertencem a architecture/routing e react-router quando aplicável.

## Return/Intended Destination

[SITUATIONAL] Login pode preservar a rota pretendida.

[HARD RULE] Destinos derivados de URL/input precisam seguir as regras de redirect seguro de `browser-security.md`.

Não aceite destination externa arbitrária como `returnUrl`.

## Do Not Put Credentials in URLs

[HARD RULE] Não transporte tokens/sessões/segredos através de:

```text
query params
path params
URL fragments
```

sem um protocolo explicitamente projetado para isso.

URLs podem aparecer em histórico, logs, analytics, screenshots e compartilhamento.

## Client Configuration Is Observable

[HARD RULE] Não coloque secret necessário para autenticação no bundle frontend esperando que o usuário não consiga vê-lo.

Configuração exposta ao browser deve ser considerada pública ao usuário daquele client.

Detalhes pertencem a `sensitive-data.md`.

## Common Bug Patterns

Evite:

- considerar hidden button como autorização;
- route guard como proteção da API;
- introduzir JWT em localStorage por conveniência;
- apagar apenas React state no logout;
- deixar cache privado entre usuários;
- enviar tokens em query params;
- expor erro bruto de autenticação;
- múltiplos redirects concorrentes em session expiry;
- trocar auth architecture incidentalmente.

## Responsibility Boundaries

Esta referência é dona de:

- frontend auth/session state;
- browser credential handling decisions;
- session expiry/logout UX;
- frontend authorization boundary;
- protected-route security assumptions.

Outras responsabilidades:

- server authentication/authorization implementation → backend;
- route mechanics → architecture/react-router;
- CSRF/CSP/redirect/browser APIs → `browser-security.md`;
- client-visible secrets/storage/logging → `sensitive-data.md`.
