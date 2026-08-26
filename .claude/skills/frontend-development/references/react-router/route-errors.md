# React Router Route Errors

Referência para route-level error boundaries, loader/action failures e not-found behavior no React Router.

## Contents

- Error ownership
- Route error boundaries
- Render errors
- Loader/action errors
- 404 resource errors
- Route not found
- Validation errors
- Error scope
- Unknown errors
- Security
- Responsibility boundaries

## Route Error Boundary Responsibility

[DEFAULT] Route error boundary impede que uma falha no route subtree resulte em uma página vazia ou destrua áreas maiores que o necessário.

Pode capturar, conforme mode/configuração:

```text
route rendering errors
loader failures
action failures
route module failures
```

[HARD RULE] Não use route error boundary como controle de fluxo genérico.

## Use the Closest Meaningful Boundary

[DEFAULT] Coloque boundaries onde existe uma unidade coerente de recuperação.

Conceitualmente:

```text
root
└── vacancies
    └── vacancy details
```

Uma falha em details pode não precisar substituir a aplicação inteira.

[HARD RULE] Não crie boundary em toda pequena route sem uma experiência de recuperação distinta.

## Data/Framework Route Errors

Em Data/Framework Mode, route APIs podem propagar erros para o boundary correspondente.

Use APIs como `useRouteError` somente no contexto apropriado do error boundary.

[HARD RULE] Trate o valor capturado como `unknown` até fazer narrowing seguro.

Não presuma:

```ts
error.message
```

sem validar a forma do erro.

## Unexpected Render Errors

[DEFAULT] Bugs inesperados devem produzir fallback seguro e compreensível.

Evite mostrar:

```text
stack trace
raw exception
internal request details
```

ao usuário.

Logging/observability pode registrar informação adequada em outro boundary.

## Loader Resource Not Found

[SITUATIONAL] Se uma route válida exige um recurso que não existe, o loader/data flow pode produzir um 404 apropriado para o route boundary.

Conceitualmente:

```text
/vacancies/123
→ route exists
→ resource 123 missing
→ resource not found state
```

Isso é diferente de route inexistente.

## Route Not Found

`/unknown-route` representa URL que não corresponde à route tree.

[HARD RULE] Não use o mesmo mecanismo conceitual para:

```text
route missing
```

e:

```text
resource missing
```

mesmo que a UI final possa compartilhar componentes.

Architecture/routing define essa distinção.

## Validation Errors Are Not Route Crashes

[HARD RULE] Não envie validation errors normais para error boundary apenas porque action/loader consegue lançar erros.

Exemplo:

```text
email already registered
field required
invalid date relation
```

deve seguir o form/action data flow apropriado.

Route error boundary é principalmente para failure que impede o route boundary de continuar normalmente.

## Expected Operation Errors

[SITUATIONAL] Uma action pode falhar de forma esperada sem representar crash da route.

Modele o resultado conforme:

```text
form/action data
normalized operation error
route error
```

de acordo com a responsabilidade.

Não transforme toda resposta HTTP não-2xx em UI global de erro.

## Error Scope

[DEFAULT] O fallback deve substituir somente o menor subtree coerente.

Exemplo:

```text
sidebar still valid
+
details route fails
→ details error boundary
```

quando a arquitetura permite.

## Preserve Recovery Context

Quando recovery existe, ofereça ação real:

```text
retry
navigate to list
reload resource
go to safe route
```

[HARD RULE] Não mostre botão Retry se a operação não é realmente repetível naquele boundary.

UI error/recovery semantics pertencem a ui-states/error.

## Unknown Errors

[HARD RULE] Unknown error deve usar fallback seguro.

Não invente causa específica.

Exemplo:

```text
Unable to load this page.
```

é melhor que afirmar:

```text
The server is offline.
```

sem saber a causa.

## Security and Error Sanitization

[HARD RULE] Não exponha:

```text
stack
server internals
tokens
private URLs
SQL details
raw sensitive response
```

em route error UI.

Security rules pertencem a security/sensitive-data.

## Error Logging

[SITUATIONAL] Observability pode registrar erros inesperados.

[HARD RULE] O error boundary não deve enviar payload sensível completo para telemetry por padrão.

Use a logging strategy do projeto.

## Navigation from Error State

[SITUATIONAL] Um fallback pode oferecer Link/navigation para destino seguro.

Prefira link semântico quando o usuário escolhe o destino.

Não navegue automaticamente para longe de todo erro antes que o usuário consiga compreender a falha, salvo quando o fluxo realmente exige redirect.

## Common Bug Patterns

Evite:

- error boundary como `if/else`;
- field validation lançada para route boundary;
- acessar `error.message` sem narrowing;
- root error substituindo app inteira sem necessidade;
- resource-not-found tratado como unknown route;
- stack trace na UI;
- retry sem operação segura;
- auto-redirect escondendo falha;
- telemetry com raw sensitive error.

## Responsibility Boundaries

Esta referência é dona de:

- React Router route error boundaries;
- loader/action/render failure routing;
- `useRouteError`;
- route-vs-resource error implementation.

Outras responsabilidades:

- generic error UX → ui-states/error;
- form errors → forms/error-handling;
- route semantics/not-found architecture → architecture/routing;
- sensitive error data → security/sensitive-data.
