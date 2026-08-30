# Frontend Untrusted Content Security

Referência para revisar dados não confiáveis que chegam ao DOM, URLs ou APIs capazes de executar/interpreter conteúdo.

## Contents

- Trust boundary
- React text rendering
- Dangerous HTML
- Sanitization
- DOM sinks
- Dynamic URLs
- Script execution
- File and rich-content boundaries
- Security review triggers
- Responsibility boundaries

## Treat External Data as Untrusted

[HARD RULE] Dados externos devem ser tratados como dados, não como markup ou código executável.

Fontes comuns:

```text
API responses
route/search params
user input
local/session storage
postMessage
third-party SDKs
remote configuration
persisted user content
```

O fato de um valor vir do próprio backend não torna seu conteúdo automaticamente seguro para um sink executável no browser.

## `dangerouslySetInnerHTML`

[HARD RULE] Não use `dangerouslySetInnerHTML` com HTML não confiável sem uma estratégia explícita de sanitização.

Evite:

```tsx
<div
  dangerouslySetInnerHTML={{
    __html: externalHtml,
  }}
/>
```

quando `externalHtml` pode conter conteúdo controlado externamente.

[SITUATIONAL] Rich text legítimo pode exigir HTML sanitizado.

Nesse caso:

```text
untrusted HTML
→ approved sanitizer
→ sanitized HTML
→ render
```

## Sanitization Is a Security Boundary

[HARD RULE] Sanitização de HTML precisa acontecer antes do conteúdo alcançar o sink que interpreta HTML.

[DEFAULT] Use uma biblioteca de sanitização mantida e aprovada pelo projeto quando rich HTML for requisito real.

[HARD RULE] Não implemente sanitizer próprio com regex ou blacklist de tags.

[HARD RULE] Não altere o HTML sanitizado depois com transformações que possam reintroduzir conteúdo inseguro.

## Do Not Add a Sanitizer Without Need

[DEFAULT] Se o produto não precisa renderizar HTML arbitrário, evite criar esse capability.

Prefira dados estruturados:

```text
title
paragraphs
links
formatting model
```

a aceitar blobs de HTML apenas por conveniência.

## Unsafe DOM Sinks

[HARD RULE] Evite inserir input não confiável através de APIs que interpretam markup/código.

Exemplos de alto risco:

```text
innerHTML
outerHTML
document.write
insertAdjacentHTML
eval
new Function
```

Prefira APIs que tratam conteúdo como dados/texto quando essa é a intenção.

Exemplo conceitual:

```text
untrusted text
→ textContent
```

não:

```text
untrusted text
→ innerHTML
```

## Direct DOM Manipulation

[SITUATIONAL] Manipulação imperativa do DOM pode ser necessária para integração com APIs/libraries.

[HARD RULE] Não abandone as proteções normais do React apenas para tornar uma implementação mais curta.

Se uma library recebe strings HTML, template strings ou callbacks executáveis, trate isso como um security boundary explícito.

## Dynamic Attributes

[HARD RULE] Não permita que dados externos decidam arbitrariamente:

```text
attribute name
event handler
script content
HTML tag
executable callback
```

Prefira contracts estruturados e allowlists quando o conjunto de opções é conhecido.

## Untrusted URLs

[HARD RULE] URLs externas ou construídas a partir de input são dados não confiáveis.

Revise especialmente valores usados em:

```text
href
src
window.location
window.open
iframe src
redirect destination
```

Não permita esquemas executáveis ou destinos arbitrários quando o produto espera somente URLs web confiáveis.

[DEFAULT] Quando apenas `http`/`https` são válidos, valide explicitamente esse contrato.

## `javascript:` and Unsafe Schemes

[HARD RULE] Não construa navegação com `javascript:` URLs.

Evite aceitar qualquer esquema apenas porque `new URL()` conseguiu parseá-lo.

Parsing e autorização do destino são decisões diferentes.

## URL Construction

[DEFAULT] Use APIs estruturadas para query parameters e URLs quando valores dinâmicos forem necessários.

Não concatene input em uma string executável ou em um contexto cujo parsing seja ambíguo.

## Script Execution from Data

[HARD RULE] Nunca use:

```text
eval
new Function
string-based code execution
```

para interpretar configuration, API data ou user input.

Dados configuráveis devem ser modelados como dados.

Exemplo:

```ts
type Action =
  | { type: 'navigate'; path: string }
  | { type: 'open-dialog'; id: string }
```

não como JavaScript enviado em string.

## JSON Is Data

[HARD RULE] JSON vindo de uma fonte externa deve permanecer dado.

Não converta valores JSON em código executável.

Valide estruturas em runtime quando o comportamento depende de campos externos.

A estratégia geral de runtime validation pertence ao boundary responsável pelo contrato de dados.

## Rich Text Links

[SITUATIONAL] Sanitizar HTML não elimina automaticamente a necessidade de revisar links produzidos pelo conteúdo.

Quando rich content pode criar links:

```text
sanitize markup
+
validate allowed URL behavior
```

conforme o contrato da aplicação.

## File Preview and Object URLs

[SITUATIONAL] Preview de arquivos enviados pelo usuário deve respeitar o tipo real e a estratégia de visualização do produto.

[HARD RULE] Não interprete conteúdo arbitrário como HTML apenas porque ele veio de upload.

File validation/autorização de upload continua sendo responsabilidade do backend; frontend preview não torna arquivo seguro.

## Common Bug Patterns

Evite:

- `dangerouslySetInnerHTML` com API/user content bruto;
- sanitizer manual com regex;
- `innerHTML` para inserir texto;
- `eval` para configuration;
- URLs construídas diretamente de search params;
- redirects para destino não validado;
- permitir `javascript:` em links;
- assumir que conteúdo do backend é seguro para HTML;
- criar state/configuration que contém código em strings;
- adicionar rich HTML quando dados estruturados resolvem.

## Security Review Triggers

Consulte esta referência obrigatoriamente quando uma mudança introduzir:

```text
dangerouslySetInnerHTML
innerHTML / outerHTML
external HTML
rich text
dynamic href/src
redirect from input
window.open with external destination
eval / new Function
third-party widget that accepts HTML
```

## Responsibility Boundaries

Esta referência é dona de:

- XSS-sensitive frontend sinks;
- untrusted HTML;
- sanitization decisions;
- executable URL schemes;
- DOM content injection.

Outras responsabilidades:

- session/auth state → `auth-session.md`;
- redirects/postMessage/CSP/browser APIs → `browser-security.md`;
- storage/logging/env exposure → `sensitive-data.md`;
- third-party scripts/SDKs → `third-party-code.md`;
- generic data-access contracts → architecture/data-access.

## Stack Mechanism

The stack-specific mechanisms for this concern live in the overlay skill for the
technology in use, when one exists. This reference states the rule; the overlay
states how the stack expresses it. When no overlay exists, the rule still applies
and the mechanism comes from general knowledge of that technology, declared as
such.
