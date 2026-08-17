# Frontend Form Error Handling

Referência para classificar, normalizar e apresentar falhas relacionadas a formulários.

## Contents

- Error categories
- Field and form-level errors
- Client vs server validation errors
- Submission errors
- Error mapping
- Error lifecycle
- Message placement
- Known and unknown errors
- Mapper boundaries
- Accessibility boundary
- Responsibility boundaries

## Error Categories

[HARD RULE] Diferencie erros pela origem e responsabilidade.

```text
Field Error
Form-Level Error
Server Validation Error
Submission Error
```

[HARD RULE] Não transforme todas as falhas em uma mensagem global genérica.

## Field Errors

[DEFAULT] Use field error quando o problema pertence claramente a um campo.

```text
email
→ "Enter a valid email address."
```

Mantenha a mensagem associada ao campo correspondente.

A regra que produz client validation error pertence a `validation.md`.

## Form-Level Errors

[DEFAULT] Use form-level error quando o problema depende do formulário como um todo ou não pertence naturalmente a um único campo.

Exemplo:

```text
startDate + endDate
→ incompatible values
```

[HARD RULE] Não force esse erro para um campo arbitrário apenas para conseguir exibi-lo.

## Client vs Server Validation Errors

Client validation:

```text
current values
→ local validation
→ field/form error
```

Server validation:

```text
valid local form
→ submit
→ authoritative rejection
→ normalize/map
→ field/form error when appropriate
```

[HARD RULE] A estrutura interna da API não deve vazar diretamente para componentes.

Evite:

```tsx
<p>{error.response.data.errors[0].message}</p>
```

espalhado pela UI.

## Map Server Errors Explicitly

[DEFAULT] Normalize erros externos para uma representação previsível.

```ts
interface FormErrors {
  email?: string
  password?: string
  form?: string
}
```

Exemplo:

```ts
function mapCreateUserError(
  error: ApiError,
): FormErrors {
  if (error.code === 'EMAIL_ALREADY_EXISTS') {
    return {
      email: 'Email already registered',
    }
  }

  return {
    form: 'Unable to create user',
  }
}
```

[HARD RULE] Não modele o formulário diretamente em torno de `AxiosError`, status internals ou response shape específico.

## Not Every Server Error Is a Field Error

[HARD RULE] Não associe artificialmente falhas gerais a campos.

Exemplos:

```text
503 Service Unavailable
network failure
request timeout
resource state conflict
```

Quando não existe campo responsável, use form-level/submission feedback adequado.

## Submission Errors

[DEFAULT] Use submission error para falha da operação que não representa regra específica de um campo.

```text
Valid Form
→ Submit
→ Operation Fails
→ Submission Error
```

A preservação do draft e retry pertencem a `submission.md`.

## Error Ownership

[HARD RULE] Cada erro deve possuir origem e responsável claros.

```text
field rule
→ field error

cross-field rule
→ form-level error

backend validation
→ mapped field/form error

network/infrastructure
→ submission error
```

Não represente a mesma falha simultaneamente em várias categorias.

## Avoid Duplicate Messages

[HARD RULE] Não mostre o mesmo problema ao mesmo tempo como:

```text
field error
+ form error
+ toast
```

sem necessidade real.

Escolha o canal que melhor preserva contexto e capacidade de correção.

## Field Error vs Toast

[HARD RULE] Não use toast como único feedback para erro que exige correção de um campo.

Erros de campo precisam continuar relacionáveis ao controle correspondente.

## Submission Error vs Transient Feedback

[SITUATIONAL] Feedback global/transitório pode complementar uma falha geral.

Mas, se o problema continuar relevante, não dependa apenas de uma mensagem que desaparece.

## Error Lifecycle

[DEFAULT] Um erro deve permanecer somente enquanto ainda representa a condição atual.

Exemplo:

```text
email = old@example.com
→ server says already registered

user changes email
→ old server field error is stale
```

Reavalie ou limpe o erro quando a informação responsável mudar.

[HARD RULE] Não limpe indiscriminadamente todos os erros a cada interação; considere sua origem.

## Resubmission

[DEFAULT] Ao iniciar nova tentativa, feedback que pertencia exclusivamente à tentativa anterior deixa de representar o resultado atual.

Field/client errors continuam seguindo suas próprias regras de validação.

## Known vs Unknown Errors

[DEFAULT] Quando a causa é conhecida e mapeada, apresente feedback específico.

```text
EMAIL_ALREADY_EXISTS
→ "Email already registered"
```

Quando não é conhecida, use fallback seguro.

[HARD RULE] Não invente explicação específica para falha desconhecida.

## Do Not Expose Internal Errors

[HARD RULE] Não apresente como mensagem ao usuário:

- stack trace;
- AxiosError;
- SQL constraint;
- ECONNREFUSED;
- NullPointerException;
- detalhes internos de infraestrutura.

Esses dados podem existir em logging/observability, não na mensagem do formulário.

## Messages Should Be Actionable

[DEFAULT] Quando souber a correção, diga o que o usuário precisa ajustar.

Prefira:

```text
Enter a valid email address.
```

a:

```text
Invalid value.
```

Não invente ação quando a causa real é desconhecida.

## Error Mappers Are Pure Transformations

[HARD RULE] Error mapper transforma contrato externo em erro normalizado.

Ele não deve:

- navigate;
- show toast;
- open modal;
- mutate React state;
- execute request.

```text
External Error
→ Mapper
→ Normalized Error
```

Presentation decide como exibir.

## Validation Error vs Submission Error

[HARD RULE] Mantenha a distinção:

```text
Validation Error
→ values do not satisfy rules

Submission Error
→ operation could not complete
```

Um formulário pode estar localmente válido e ainda falhar ao submeter.

## Accessibility Boundary

[DEFAULT] Erro de campo precisa manter relação compreensível com seu controle.

Detalhes de:

- accessible association;
- announcement;
- focus management;

pertencem às referências de accessibility.

## Responsibility Boundaries

Esta referência é dona de:

- error classification;
- server error normalization;
- field/form/submission placement;
- stale error lifecycle;
- known/unknown fallback;
- pure error mapping.

Outras responsabilidades:

- regras locais → `validation.md`;
- draft/reset/retry → `submission.md` e `form-state.md`;
- UI-state error genérico → UI states;
- accessible mechanics → accessibility.
