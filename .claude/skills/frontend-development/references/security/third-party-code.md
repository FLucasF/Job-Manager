# Frontend Third-Party Code Security

Referência para avaliar scripts, SDKs, widgets, dependencies e recursos externos executados ou incorporados pelo frontend.

## Contents

- Trust boundary
- Adding dependencies
- Runtime scripts
- Analytics and tag managers
- Data exposure
- Isolation
- CSP and integrity
- SDK configuration
- Updates
- Responsibility boundaries

## Third-Party Code Is a Trust Boundary

[HARD RULE] Código terceiro executado na página pode ter acesso significativo ao contexto do usuário e da aplicação.

Dependendo da integração, ele pode observar ou modificar:

```text
DOM
page data
browser APIs
network activity available to JS
client storage
user interactions
```

Não trate um `<script>` externo como asset puramente visual.

## Do Not Add a Dependency by Default

[DEFAULT] Antes de adicionar package/SDK:

1. confirme que o projeto ainda não possui solução equivalente;
2. confirme que a responsabilidade justifica uma dependency;
3. avalie manutenção e escopo;
4. minimize capabilities e dados concedidos.

[HARD RULE] Não instale biblioteca de segurança, analytics ou widget apenas porque torna uma implementação curta.

Mudanças de dependency devem seguir o tooling/padrões existentes.

## Distinguish Build Dependency from Runtime Third Party

Uma dependency empacotada no bundle e um script carregado de servidor externo possuem riscos operacionais diferentes.

```text
bundled dependency
→ version controlled by lockfile/build

remote runtime script
→ code may change independently of your deploy
```

[DEFAULT] Trate scripts remotos com revisão adicional.

## External Runtime Scripts

[HARD RULE] Não carregue JavaScript de origem externa sem uma finalidade explícita e uma origin conhecida.

Evite:

```text
dynamic script src from user input
runtime script URL from search params
arbitrary plugin URL
```

## Analytics and Tag Managers

[HARD RULE] Analytics/tag code não deve receber todo o state/DOM por conveniência.

Defina um data contract mínimo:

```text
event name
approved properties
non-sensitive identifiers
```

Evite enviar:

```text
password
token
private form content
full user object
raw API response
```

Sensitive data rules pertencem a `sensitive-data.md`.

## Third-Party Data Layer

[DEFAULT] Quando analytics/tag manager precisa de dados, prefira uma camada de dados explícita/estruturada em vez de permitir scraping arbitrário de:

```text
DOM
URL params
inputs
global application state
```

Isso torna o contrato revisável.

## External UI Widgets

[SITUATIONAL] Widgets terceiros podem precisar alterar DOM ou interagir diretamente com a página.

Antes de integrar, avalie:

```text
what data does it receive?
what DOM access does it need?
can it run isolated?
what happens if vendor code changes?
```

## Isolation with Iframes

[SITUATIONAL] Quando o terceiro não precisa acessar o DOM principal, um iframe em origin separada pode reduzir seu acesso.

Avalie:

```text
sandbox
allowed capabilities
postMessage contract
origin validation
```

Detalhes de iframe/messaging pertencem a `browser-security.md`.

## Do Not Over-Permission Sandbox

[HARD RULE] Não adicione sandbox permissions em sequência até o widget funcionar.

Cada capability deve existir por uma necessidade conhecida.

## Content Security Policy

[DEFAULT] A integração deve funcionar dentro da CSP definida pelo sistema sempre que possível.

[HARD RULE] Não relaxe globalmente CSP para aceitar uma única library sem avaliar impacto.

Evite introduzir exigências de:

```text
unsafe-eval
arbitrary script origins
unrestricted inline script
```

sem decisão explícita.

CSP policy final pertence ao server/deployment boundary.

## Subresource Integrity

[SITUATIONAL] Recursos externos estáticos servidos por terceiros podem se beneficiar de mecanismos de integrity quando compatíveis com a estratégia de carregamento.

[HARD RULE] Não assuma que integrity resolve todos os riscos de third-party code.

Ele não substitui:

- origin review;
- least data exposure;
- CSP;
- sandboxing;
- dependency governance.

## SDK Credentials

[HARD RULE] Não coloque private vendor credentials no frontend.

Se uma SDK requer client key, confirme que ela é intencionalmente pública e restrita conforme contrato do provedor.

Sensitive configuration pertence a `sensitive-data.md`.

## Callback Data Is External Data

[HARD RULE] Payload retornado por widget/SDK deve ser tratado como input externo.

Não faça:

```text
SDK payload
→ innerHTML
→ navigation
→ privileged operation
```

sem validação apropriada.

## Dynamic Imports and Plugins

[HARD RULE] Não crie sistema de plugins que executa módulos arbitrários definidos por input remoto sem uma arquitetura de confiança explícita.

```text
remote URL
→ import()
```

é um security boundary, não apenas code splitting.

## Dependency Updates

[DEFAULT] Dependências devem permanecer atualizáveis.

Evite pinning informal através de scripts copiados manualmente sem provenance/versioning quando o projeto possui package management apropriado.

[HARD RULE] Não ignore security advisory conhecido apenas para evitar ajuste pequeno sem registrar/avaliar o risco.

A política de upgrade/CI pode pertencer ao tooling do projeto.

## Remove Unused Third-Party Code

[DEFAULT] Se SDK/script deixou de ser necessário, remova também:

```text
script include
permissions
CSP origin
env configuration
event forwarding
stored data hooks
```

Security surface deve acompanhar o uso real.

## Common Bug Patterns

Evite:

- script URL vindo de config não confiável;
- analytics recebendo form payload completo;
- vendor SDK com secret privado no bundle;
- `unsafe-eval` liberado globalmente por uma lib;
- `postMessage('*')` com widget sensível;
- iframe com permissões excessivas;
- plugin remoto arbitrário;
- package novo para função trivial;
- third-party code abandonado ainda carregando;
- assumptions de que vendor script não acessa DOM/data.

## Responsibility Boundaries

Esta referência é dona de:

- third-party scripts/SDKs/widgets;
- analytics/tag manager trust boundary;
- runtime external code;
- dependency security considerations no frontend.

Outras responsabilidades:

- browser isolation/postMessage/CSP → `browser-security.md`;
- client data exposure → `sensitive-data.md`;
- HTML/XSS sinks → `untrusted-content.md`;
- package tooling/version commands → project tooling.
