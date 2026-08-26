# Frontend Security Review Checklist

Checklist operacional para revisão de segurança do frontend.

[DEFAULT] Use este arquivo primeiro em code review de security.

[HARD RULE] Consulte somente a referência detalhada relacionada ao item que exigir investigação.

## Untrusted Content

- [ ] Dados externos permanecem dados/texto quando HTML não é requisito?
- [ ] `dangerouslySetInnerHTML` possui justificativa e sanitização explícita?
- [ ] Não existe sanitizer manual baseado em regex/blacklist?
- [ ] `innerHTML`, `document.write`, `eval` ou `new Function` não recebem input externo?
- [ ] Dynamic `href`/`src`/redirect valida destinos e esquemas?
- [ ] `javascript:` URLs não são aceitas?
- [ ] Rich content não reintroduz markup inseguro depois da sanitização?
- [ ] SDK/library que recebe HTML foi tratada como security boundary?

## Authentication and Session

- [ ] Frontend authorization não está sendo tratada como enforcement real?
- [ ] Route protection não substitui autorização backend?
- [ ] Não foi introduzido token/session ID em localStorage/sessionStorage?
- [ ] Auth storage strategy existente não foi alterada incidentalmente?
- [ ] Session expiry atualiza a UI para estado coerente?
- [ ] Logout usa o mecanismo real definido pelo sistema?
- [ ] Cache privado não vaza entre identidades?
- [ ] Credentials não aparecem em URLs?
- [ ] Erros de auth não expõem tokens/internals?

## Browser Security

- [ ] CORS não está sendo "corrigido" pelo frontend?
- [ ] `mode: no-cors` não foi usado como workaround?
- [ ] Mecanismos CSRF existentes foram preservados?
- [ ] Input externo não escolhe arbitrariamente endpoint/method state-changing?
- [ ] CSP não foi enfraquecida por conveniência?
- [ ] Redirect/`returnUrl`/`next` valida destino?
- [ ] `postMessage` valida origin exata e payload?
- [ ] Mensagens externas permanecem dados, não HTML/código?
- [ ] Iframes possuem somente capabilities necessárias?
- [ ] Código não depende de desabilitar segurança do browser?

## Sensitive Data

- [ ] Nenhum secret foi colocado no bundle/env frontend?
- [ ] Web Storage contém somente dados que realmente precisam persistir?
- [ ] PII não é persistida por conveniência?
- [ ] URL não contém dados sensíveis?
- [ ] Console/log/telemetry não contém tokens/passwords/payload privado?
- [ ] Analytics recebe somente dados aprovados/minimizados?
- [ ] Error messages não expõem internals sensíveis?
- [ ] Passwords não são copiados para storage/log/analytics?
- [ ] Cache/drafts privados possuem retenção coerente?
- [ ] Obfuscation/source-map policy não é tratada como proteção de secret?

## Third-Party Code

- [ ] Nova dependency/SDK possui responsabilidade real?
- [ ] Runtime script vem de origem conhecida e fixa?
- [ ] Analytics/tag manager recebe data contract mínimo?
- [ ] Third-party widget poderia ser isolado quando não precisa do DOM principal?
- [ ] Sandbox/iframe permissions são mínimas?
- [ ] CSP não foi relaxada globalmente por uma library?
- [ ] Vendor client key é realmente pública quando aparece no frontend?
- [ ] Payload do SDK é validado como external input?
- [ ] Não existe plugin/import remoto arbitrário?
- [ ] Código terceiro não utilizado foi removido junto com permissões/configuração?

## Cross-Cutting Boundaries

- [ ] Security change não reescreveu auth/backend architecture sem escopo?
- [ ] Backend continua responsável por autenticação/autorização real?
- [ ] Frontend não tenta implementar headers server-only como `HttpOnly`?
- [ ] Security rules não duplicam generic data-access/routing/form responsibilities?
- [ ] Uma violação encontrada fora do escopo é sinalizada em vez de "corrigida" incidentalmente?

## Escalation

```text
HTML / XSS / dangerouslySetInnerHTML / DOM sinks / dynamic URLs
→ untrusted-content.md

session / tokens / auth state / logout / protected routes
→ auth-session.md

CORS / CSRF / CSP / redirects / postMessage / iframes
→ browser-security.md

env / bundle / storage / URL / logs / PII
→ sensitive-data.md

external scripts / analytics / SDKs / widgets / dependencies
→ third-party-code.md
```

[HARD RULE] Não carregue todas as referências de security apenas para uma revisão geral.
