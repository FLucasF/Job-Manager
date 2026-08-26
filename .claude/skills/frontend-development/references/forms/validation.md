# Frontend Form Validation

Referência para decidir e aplicar regras de validade sobre valores de formulário.

## Contents

- Validation responsibility
- Client vs server authority
- Rule ownership
- Field and cross-field validation
- Schema validation
- Types and validation
- Validation timing
- Empty and optional values
- Conditional and collection validation
- Validation vs transformation
- Async validation
- Domain boundary
- Validation result
- Responsibility boundaries

## Validation Responsibility

[DEFAULT] Validation responde se os valores atuais atendem às regras necessárias para continuar o fluxo.

```text
Form Values
→ Validation
├── valid   → submit
└── invalid → errors
```

A validação deve produzir informação suficiente para identificar o que precisa ser corrigido.

## Client Validation Is Not Authoritative

[HARD RULE] Validação frontend melhora feedback e evita submits sabidamente inválidos, mas não substitui validação do backend.

```text
Frontend Validation
→ immediate feedback

Backend Validation
→ authoritative enforcement
```

Nunca considere um dado seguro apenas porque passou pela validação client-side.

## Validate Before Submission

[HARD RULE] Não inicie a operação quando o frontend já conhece erros que tornam o formulário inválido.

O fluxo operacional pertence a `submission.md`.

## One Clear Source for Local Rules

[DEFAULT] Mantenha uma fonte clara para cada regra de validação local.

Evite repetir:

```text
Component → title required
Hook      → title required
Submit    → title required
Schema    → title required
```

Diferentes camadas frontend não precisam repetir a mesma regra apenas para "garantir".

## Field Validation

[DEFAULT] Use field validation quando a regra depende somente daquele valor.

Exemplos:

```text
email → required + valid format
title → minimum length
salary → positive number
```

O erro resultante pode ser associado diretamente ao campo.

## Cross-Field Validation

[DEFAULT] Use cross-field validation quando a validade depende da relação entre valores.

```text
password + confirmPassword
→ must match
```

```text
startDate + endDate
→ startDate <= endDate
```

[HARD RULE] Não force uma regra relacional artificialmente dentro de apenas um dos campos.

## Schema Validation

[SITUATIONAL] Quando o projeto utiliza schema validation, concentre nele regras declarativas que realmente pertencem aos valores do formulário.

O schema pode representar:

- required;
- format;
- range;
- enum;
- conditional/cross-field constraints.

[HARD RULE] Schema não é form state.

```text
Form State
→ current values

Schema
→ rules applied to values
```

Não crie schema apenas para encapsular uma regra trivial se isso não melhora clareza ou consistência.

## Validation Types and Form Types

[HARD RULE] Tipos do formulário e regras de validação não devem contradizer-se.

Quando a ferramenta de schema fornece inferência segura, ela pode reduzir duplicação.

[DEFAULT] Não sacrifique boundaries claros apenas para eliminar uma declaração de tipo.

## Validation Timing

[DEFAULT] Escolha timing conforme a experiência desejada:

```text
onChange
onBlur
onSubmit
```

### On Change

Feedback mais rápido, mas pode aparecer cedo demais.

### On Blur

Útil quando o usuário deve terminar a interação antes do feedback.

### On Submit

Garante validação antes da operação, porém informa mais tarde.

Uma estratégia pode combinar momentos quando isso melhora a UX.

## Do Not Show Errors Before They Are Useful

[DEFAULT] Não carregue o formulário já exibindo todos os erros sem motivo.

Use informações como:

```text
touched
submit attempted
```

quando apropriado.

A definição de touched pertence a `form-state.md`.

## Revalidate Relevant Rules

[DEFAULT] Quando um valor muda, reavalie erros cuja validade depende dele.

Cross-field rules podem exigir revalidação ao mudar qualquer campo participante.

## Required Fields

[HARD RULE] Obrigatoriedade deve existir como regra executável, não apenas como decoração visual.

Um `*` no label pode comunicar, mas não substitui a regra.

## Empty Value Semantics

[HARD RULE] Defina uma representação coerente de ausência para cada campo.

Possíveis representações:

```text
''
null
undefined
[]
```

Evite usar várias formas diferentes para significar "sem valor" dentro do mesmo contrato sem necessidade.

## Optional Fields

[DEFAULT] Campo opcional aceita ausência.

Mas, se houver valor, ele ainda pode precisar atender às regras.

```text
phone absent
→ valid

phone present
→ must have valid format
```

Optional não significa unvalidated.

## Conditional Validation

[SITUATIONAL] Quando uma regra depende de outro valor, represente essa dependência explicitamente.

```text
remote = false
→ address required
```

Não espalhe a mesma condição por vários componentes.

## Dynamic Collections

[SITUATIONAL] Separe regras do item de regras da coleção.

```text
skills[]
├── item: name required
└── collection: at least one skill
```

Não modele uma regra da coleção como erro arbitrário de um item.

## Validation Is Not Transformation

[HARD RULE] Mantenha validação e transformação conceitualmente separadas.

```text
Validation
→ "este valor é aceitável?"

Transformation
→ "como converter este valor?"
```

Exemplo:

```text
"5000"
→ valid numeric input
→ transform to 5000 for operation
```

Mapping para a operação pertence a `submission.md`.

## Keep Validation Predictable and Side-Effect Free

[HARD RULE] Validação local não deve:

- navegar;
- mostrar toast;
- persistir dados;
- abrir modal;
- alterar campos silenciosamente;
- executar requests sem necessidade explícita.

Prefira:

```text
Input
→ Validation
→ Validation Result
```

## Async Validation

[SITUATIONAL] Use somente quando a regra realmente precisa de informação externa **antes** da submissão.

Exemplo:

```text
username
→ availability check
```

Cuidado com:

- requests excessivos;
- responses out of order;
- race conditions;
- duplicação de checks que o backend repetirá no submit.

[DEFAULT] Não transforme toda regra do backend em preflight request.

O backend precisa validar novamente no momento da operação.

## Server Validation After Submit

[HARD RULE] Uma rejeição autoritativa do backend após validação local não transforma automaticamente a regra em client validation.

Exemplo:

```text
client → email format valid
backend → email already registered
```

Esse erro deve seguir `error-handling.md`.

## Do Not Leak API Error Shapes into Local Validation

[HARD RULE] Regras locais não devem depender diretamente de estruturas internas HTTP.

```text
error.response.data...
```

pertence ao boundary de erro externo, não ao schema local.

## Domain Boundary

[HARD RULE] Não copie automaticamente regras complexas de negócio para o formulário.

Exemplo:

```text
user can apply only if
vacancy open
AND account active
AND not owner
AND period valid
```

Essa decisão pode pertencer ao domínio/application/backend.

Form validation deve focar principalmente na validade dos inputs que o formulário coleta.

## Predictable Validation Result

[DEFAULT] Produza uma forma previsível de resultado.

Conceitualmente:

```text
Validation Result
├── field errors
└── form-level errors
```

A apresentação dos erros pertence a `error-handling.md`.

## Responsibility Boundaries

Esta referência é dona de:

- local validation rules;
- field/cross-field validation;
- schema strategy;
- timing;
- optional/empty semantics;
- async pre-submit validation.

Outras responsabilidades:

- form values/touched → `form-state.md`;
- transformation + operation → `submission.md`;
- server/submission error mapping → `error-handling.md`;
- domain rules → architecture/domain boundary.
