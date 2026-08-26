# Frontend Sensitive Data Security

Referência para evitar exposição indevida de secrets, credentials, PII e dados privados através do bundle, storage, URL, logs e UI.

## Contents

- Client visibility model
- Environment variables
- Browser storage
- URLs
- Logs and telemetry
- Error messages
- Cached data
- Clipboard/downloads
- Forms
- Data minimization
- Responsibility boundaries

## Browser Code Is Observable

[HARD RULE] Tudo entregue ao browser deve ser considerado observável pelo usuário daquele client.

Isso inclui:

```text
JavaScript bundle
source maps when published
HTML
network requests
client configuration
runtime environment values
local/session storage
IndexedDB
DOM
```

Obfuscation não transforma client-side data em secret.

## Frontend Environment Variables Are Not Secrets

[HARD RULE] Não coloque secrets em variáveis que são expostas ao código cliente.

Em projetos Vite, valores intencionalmente expostos via `import.meta.env` entram no código executado pelo client.

[HARD RULE] Prefixar/configurar uma variável para exposição frontend é uma decisão de publicação, não um mecanismo de secret storage.

Exemplos que não devem ir para bundle:

```text
database password
private signing key
backend service secret
long-lived private credential
```

## Public Identifiers Are Different from Secrets

[DEFAULT] Nem toda key visível no frontend é necessariamente secreta.

Alguns serviços usam identificadores/client keys públicas que são protegidas por:

```text
origin restrictions
server-side authorization
quotas
scoped permissions
```

[HARD RULE] Não trate uma credencial como pública apenas porque uma SDK frontend precisa de uma string.

Verifique o contrato do provedor.

## Browser Storage

[HARD RULE] Não persista dados sensíveis no browser sem necessidade real.

Antes de usar:

```text
localStorage
sessionStorage
IndexedDB
```

pergunte:

```text
precisa sobreviver ao render?
precisa sobreviver à tab?
precisa sobreviver ao browser restart?
qual código na origin consegue ler isso?
```

Credential/session storage segue `auth-session.md`.

## Avoid PII Persistence by Convenience

[DEFAULT] Prefira manter dados privados somente pelo tempo necessário.

Evite cache/persistência permanente de:

```text
personal profile data
documents
private messages
sensitive form drafts
```

apenas para facilitar UX sem requisito explícito.

## URLs Are Observable

[HARD RULE] Não coloque dados sensíveis em:

```text
path
query params
URL fragment
```

sem necessidade/protocolo explícito.

URLs podem aparecer em:

- browser history;
- copy/paste;
- screenshots;
- analytics;
- referrer-related contexts;
- server/proxy logs;
- support reports.

Prefira IDs opacos e não sensíveis quando URL precisa identificar um recurso.

## Logging

[HARD RULE] Não adicione `console.log`/telemetry contendo:

```text
passwords
tokens
authorization headers
session identifiers
full sensitive API payloads
private documents
```

Logs de desenvolvimento podem acabar em produção ou screenshots.

## Debugging Production Failures

[DEFAULT] Registre identificadores diagnósticos mínimos em vez de payloads privados completos.

Exemplo:

```text
operation = createVacancy
requestId = ...
errorCode = ...
```

em vez de serializar todas as credenciais/user data.

## Analytics

[HARD RULE] Não envie dados para analytics apenas porque estão disponíveis no DOM/state.

Revise explicitamente:

```text
PII
search terms
form values
resource identifiers
URLs
error payloads
```

antes de instrumentar.

Third-party analytics pertence também a `third-party-code.md`.

## Error Messages

[HARD RULE] Não exponha detalhes internos que revelem secrets ou infraestrutura.

Evite mostrar ao usuário:

```text
Authorization header
raw token
stack trace
database details
private endpoint credentials
full backend exception
```

Error handling funcional pertence a forms/ui-states.

## Network Requests

[HARD RULE] Frontend não deve enviar dados sensíveis para um terceiro ou endpoint que não precisa deles.

Data minimization aplica-se também ao request payload.

Não replique objetos completos quando a operação precisa de poucos campos.

## Client Cache and Identity Changes

[SITUATIONAL] Caches client-side podem conter dados privados.

Ao trocar/logout de identidade, preserve isolamento adequado entre usuários.

Não reutilize cache privado de uma sessão anterior.

Auth lifecycle pertence a `auth-session.md`.

## Sensitive Form Drafts

[SITUATIONAL] Autosave/persistência de drafts pode melhorar UX, mas aumenta retenção no browser.

Antes de persistir:

```text
password
personal document number
financial data
private application answers
```

avalie se retenção local é realmente requisito.

Functional form state pertence a forms; este arquivo cobre risco de exposição.

## Password Fields

[HARD RULE] Password não deve ser copiada para:

```text
URL
logs
analytics
generic persisted state
error telemetry
```

Mantenha o valor somente onde a interação realmente precisa dele.

## Clipboard

[SITUATIONAL] Copiar informação sensível para clipboard deve ser consequência explícita de uma ação do usuário.

Não coloque secrets no clipboard automaticamente em background.

## Downloads and Generated Files

[SITUATIONAL] Quando frontend gera arquivo contendo dados privados:

- inclua somente o necessário;
- não esconda sensitive fields em metadata desnecessária;
- trate filename/content como dados potencialmente compartilháveis.

Autorização para obter os dados continua no backend.

## Source Maps

[SITUATIONAL] Source maps são uma decisão de observability/deployment.

[HARD RULE] Não considere "sem source map" uma proteção para secrets embutidos no bundle.

Se o secret foi enviado ao browser, ele já deve ser considerado exposto.

## Data Minimization

[DEFAULT] Mantenha e transmita somente o dado necessário para a responsabilidade atual.

```text
Need:
user display name

Avoid:
entire private user profile
```

quando o restante não é usado.

Isso reduz superfície de exposição e acoplamento.

## Common Bug Patterns

Evite:

- `VITE_*` com secret;
- token em query param;
- payload completo em console;
- persistir PII por conveniência;
- enviar form data para analytics;
- manter cache privado após logout;
- esconder secret no bundle por obfuscation;
- considerar source-map policy como secret protection;
- enviar objetos completos para terceiros sem necessidade.

## Responsibility Boundaries

Esta referência é dona de:

- client-visible configuration;
- browser data retention;
- URL/log/telemetry exposure;
- PII/client-side data minimization.

Outras responsabilidades:

- session credentials → `auth-session.md`;
- XSS/content injection → `untrusted-content.md`;
- external scripts/analytics SDKs → `third-party-code.md`;
- backend secret management → backend/infrastructure.
