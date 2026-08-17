# Frontend Browser Security

Referência para boundaries de segurança impostos pelo browser: origin, CSRF awareness, redirects, CSP compatibility, messaging, windows e iframes.

## Contents

- Browser boundary
- CORS
- CSRF awareness
- CSP
- Redirects
- `window.open`
- `postMessage`
- Iframes
- External navigation
- Browser-controlled security
- Responsibility boundaries

## Browser Security Is a Boundary

[HARD RULE] Não trate políticas do browser como bugs que o frontend deve contornar.

Exemplos:

```text
same-origin policy
CORS
CSP
cookie restrictions
mixed-content restrictions
iframe sandbox
```

Quando uma política bloqueia algo, identifique qual boundary deveria permitir a operação de forma segura.

## CORS Is Not a Frontend Authorization Mechanism

[HARD RULE] Frontend não "corrige CORS".

Não resolva erros de CORS com:

```text
disable browser security
public proxy aleatório
mode: no-cors
copy credentials to another origin
```

CORS é configurado pelo servidor para controlar quais origins podem ler respostas através do browser.

[HARD RULE] CORS também não substitui autenticação/autorização backend.

## `no-cors` Is Not a General Fix

[HARD RULE] Não adicione `mode: 'no-cors'` para fazer uma request "funcionar".

Isso produz uma resposta limitada/opaque e não concede permissão de leitura da API.

Corrija o contrato entre origins no boundary responsável.

## CSRF Awareness

[SITUATIONAL] Aplicações cujas credenciais são enviadas automaticamente pelo browser, especialmente cookies, precisam considerar CSRF para operações state-changing.

[HARD RULE] Frontend não deve remover ou ignorar mecanismo anti-CSRF existente.

Possíveis mecanismos dependem do servidor:

```text
SameSite cookies
CSRF token
custom request header
origin verification
```

Não invente um mecanismo isolado apenas no client.

## Client-Side CSRF

[HARD RULE] Não permita que input controlado externamente escolha arbitrariamente:

```text
HTTP method
state-changing endpoint
request target
```

Exemplo de fontes perigosas:

```text
URL/search/hash
postMessage
window name
external configuration
```

Use mappings/predefined operations quando o conjunto de ações é conhecido.

## CSP Is Defense in Depth

[DEFAULT] Content Security Policy é uma proteção de browser configurada principalmente por response headers/deployment.

Frontend deve permanecer compatível com a política adotada.

[HARD RULE] Não enfraqueça CSP para acomodar uma implementação conveniente sem decisão explícita.

Revise especialmente introdução de:

```text
inline scripts
eval
dynamic external scripts
unsafe third-party code
```

## CSP Does Not Replace XSS-Safe Code

[HARD RULE] Não trate CSP como substituto para as regras de `untrusted-content.md`.

```text
safe rendering
+
CSP
```

é defense in depth.

## Redirect Destinations Are Untrusted Input

[HARD RULE] Parâmetros como:

```text
returnUrl
redirect
next
continue
destination
```

devem ser tratados como external input.

Evite:

```ts
window.location.href = searchParams.get('next')!
```

sem validar o destino.

## Prefer Internal Route Identifiers

[DEFAULT] Quando o produto precisa retornar para uma rota interna, prefira um contrato que aceite somente destinos locais/conhecidos.

Exemplo conceitual:

```text
next = vacancy-create
→ routes.vacancyCreate
```

pode ser mais seguro que aceitar URL arbitrária.

[SITUATIONAL] Quando URLs são necessárias, use allowlist/validation adequada ao contrato.

## External Links

[DEFAULT] Quando a aplicação navega para site externo, deixe esse boundary explícito.

Não construa destination externa a partir de fragmentos não confiáveis sem validação.

## `window.open`

[SITUATIONAL] Use somente quando abrir nova browsing context faz parte da UX.

[HARD RULE] Destination continua sujeita às regras de URL não confiável.

[DEFAULT] Quando uma nova aba não precisa controlar a origem que a abriu, preserve isolamento adequado (`noopener`/equivalente da API usada).

Não dependa de comportamento implícito sem verificar a API/elemento utilizado.

## `postMessage`

[HARD RULE] Ao enviar mensagens cross-origin, declare a origin esperada quando ela é conhecida.

Evite usar `"*"` por conveniência em mensagens sensíveis.

[HARD RULE] Ao receber:

```text
message event
→ verify exact origin
→ validate data shape
→ treat payload as data
```

Não use substring/`includes` para validar origin.

Evite:

```ts
if (event.origin.includes('example.com')) {
  // unsafe origin check
}
```

Prefira comparação com origin esperada.

## Never Evaluate Message Data

[HARD RULE] Payload de `postMessage` nunca deve ser executado como código ou inserido diretamente como HTML.

```text
message.data
→ validation
→ structured application action
```

não:

```text
message.data
→ eval / innerHTML
```

## Iframes

[SITUATIONAL] Iframes podem criar um boundary útil para conteúdo externo.

Quando conteúdo não confiável/third-party é embutido, avalie:

```text
separate origin
sandbox
allowed capabilities
communication contract
```

[HARD RULE] Não adicione permissões de sandbox indiscriminadamente apenas para fazer o widget funcionar.

Cada capability adicionada amplia o poder do conteúdo incorporado.

## Third-Party Frames

[SITUATIONAL] Prefira isolamento por iframe quando um terceiro não precisa de acesso direto ao DOM principal e a integração comporta esse modelo.

Detalhes de third-party code pertencem a `third-party-code.md`.

## Browser Storage Events and Cross-Tab Behavior

[SITUATIONAL] Recursos compartilhados entre tabs/origins podem introduzir comportamento concorrente.

Não use browser storage como canal de autenticação/coordenação sem compreender seu scope e ameaça.

Credential storage pertence a `auth-session.md`.

## Do Not Bypass Browser Warnings

[HARD RULE] Não introduza instruções/código que dependem de:

```text
disabling certificate validation
disabling browser security
ignoring mixed-content restrictions
turning off CSP
```

para a aplicação funcionar.

Ambiente local deve resolver certificados/origins/configuração adequadamente.

## Common Bug Patterns

Evite:

- `mode: no-cors` como correção de API;
- public proxy para contornar CORS;
- route guard como autorização;
- returnUrl externo não validado;
- `postMessage('*')` com conteúdo sensível;
- origin check por substring;
- `message.data` em `innerHTML`;
- CSP relaxada para aceitar `eval`;
- iframe sandbox com capabilities excessivas;
- desabilitar segurança do browser como setup normal.

## Responsibility Boundaries

Esta referência é dona de:

- CORS/CSRF awareness no client;
- CSP compatibility;
- redirect safety;
- `postMessage`;
- windows/iframes/browser boundaries.

Outras responsabilidades:

- XSS/HTML sinks → `untrusted-content.md`;
- auth/session credential choices → `auth-session.md`;
- third-party scripts/SDKs → `third-party-code.md`;
- routing semantics → architecture/routing;
- server headers/policies → backend/deployment.
