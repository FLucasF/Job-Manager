# Frontend Form Accessibility

Referência para identificação, agrupamento, instruções, erros e feedback acessível em formulários.

## Contents

- Accessible field identity
- Labels and supporting text
- Required and optional fields
- Native controls
- Groups
- Validation feedback
- Field and form errors
- Invalid submission
- Dynamic feedback
- Pending and success
- Reusable fields and IDs
- Conditional and multi-step forms
- Responsibility boundaries

## Every Control Needs an Accessible Name

[HARD RULE] Todo controle precisa de identificação acessível clara.

[DEFAULT] Prefira label visível associado ao controle.

```tsx
<label htmlFor="email">
  Email
</label>

<input
  id="email"
  type="email"
/>
```

[HARD RULE] Não dependa apenas de:

- placeholder;
- icon;
- visual position;
- color;

para identificar um campo.

## Prefer Visible Labels

[HARD RULE] Placeholder não substitui label.

```text
label
→ identifica o campo

placeholder
→ exemplo/dica temporária
```

Quando o design exige outra estratégia, preserve um nome acessível real conforme `aria.md`.

## Associate Labels Correctly

[HARD RULE] Labels visuais precisam de relação semântica com seus controls.

Quando separados:

```tsx
<label htmlFor="name">
  Name
</label>

<input
  id="name"
  name="name"
/>
```

Não use apenas proximidade visual.

## Do Not Duplicate Accessible Names

[DEFAULT] Se o label já fornece o nome correto, não adicione `aria-label` diferente sem necessidade.

Evite criar duas nomenclaturas concorrentes para o mesmo campo.

## Instructions vs Labels

[HARD RULE] Diferencie:

```text
label
→ o que é este campo?

instruction
→ como devo preenchê-lo?
```

Exemplo:

```tsx
<label htmlFor="password">
  Password
</label>

<p id="password-help">
  Use at least 8 characters.
</p>

<input
  id="password"
  type="password"
  aria-describedby="password-help"
/>
```

[DEFAULT] Associe supporting text quando ele é importante para preencher corretamente.

## Required Fields

[HARD RULE] Required não pode depender apenas de `*`, cor ou posição.

Quando a semântica nativa é adequada, use `required`.

Se houver indicador visual `*`, forneça contexto suficiente para seu significado.

## Optional Fields

[DEFAULT] Quando a opcionalidade não é óbvia, comunique-a de forma compreensível.

Exemplo:

```text
Phone (optional)
```

Não dependa de uma tentativa de submit para o usuário descobrir.

## Appropriate Native Inputs

[HARD RULE] Use controles/tipos nativos adequados quando representam o dado/interação.

Exemplos:

```text
email input
password input
checkbox
radio
select
textarea
```

Não recrie controles nativos sem necessidade.

Escolha semântica geral pertence a `semantic-html.md`.

## Group Related Controls

[DEFAULT] Quando controles compartilham uma pergunta/contexto necessário, agrupe-os semanticamente.

```tsx
<fieldset>
  <legend>Work model</legend>

  ...
</fieldset>
```

Bons casos:

- radio group;
- related checkboxes;
- grouped questions;
- form sections cujo group label é necessário.

[HARD RULE] Não use `fieldset` apenas como container visual.

## Radio Groups

[HARD RULE] Cada opção precisa de label e o grupo precisa de contexto compreensível.

```text
Receive notifications?

○ Yes
○ No
```

“Sim/Não” isolados não comunicam qual decisão representam.

## Checkbox Labels

[HARD RULE] O label deve descrever claramente a escolha representada.

A associação não deve depender apenas do layout.

## Validation Logic vs Accessible Feedback

[HARD RULE] Separe:

```text
forms/validation.md
→ decide se o valor é válido

form-accessibility.md
→ garante que o usuário perceba e compreenda o resultado
```

Este arquivo não define min length, formats ou cross-field domain rules.

## Invalid Fields Must Be Identifiable

[HARD RULE] Estado inválido não pode depender somente de borda/cor.

Quando apropriado à estratégia:

```tsx
<input
  aria-invalid={Boolean(error)}
  aria-describedby={
    error ? 'email-error' : undefined
  }
/>
```

A semântica ARIA específica pertence a `aria.md`; aqui o foco é a relação form control ↔ feedback.

## Associate Field Errors

[HARD RULE] Erro pertencente a um campo deve permanecer relacionado ao control.

```tsx
<label htmlFor="email">
  Email
</label>

<input
  id="email"
  aria-invalid={Boolean(error)}
  aria-describedby={
    error ? 'email-error' : undefined
  }
/>

{error && (
  <p id="email-error">
    Enter a valid email address.
  </p>
)}
```

[HARD RULE] Não use toast como único feedback para erro que precisa ser corrigido em um campo.

## Error Messages

[DEFAULT] Quando a correção é conhecida, use mensagem compreensível e acionável.

Prefira:

```text
Enter a valid email address.
```

a:

```text
Invalid.
```

Não invente uma correção quando a causa real não é conhecida.

## Error Timing

[DEFAULT] A acessibilidade deve refletir o estado real da validação.

Não marque/anuncie todos os campos como inválidos no carregamento inicial apenas porque são required.

A decisão funcional de timing pertence a `forms/validation.md`.

## Do Not Announce Every Keystroke

[HARD RULE] Não configure live feedback que repete erros a cada caractere quando isso cria ruído.

A comunicação deve acompanhar a estratégia real de validation timing.

## Form-Level Errors

[DEFAULT] Problemas que pertencem ao formulário como um todo devem aparecer em região compreensível no contexto do formulário.

Não os associe arbitrariamente a um campo específico.

## Error Summary

[SITUATIONAL] Em formulários longos ou com muitos erros, um resumo pode ajudar.

```text
There are 3 errors:
- Email is invalid
- Password is too short
- Start date is required
```

[HARD RULE] O summary não substitui os erros próximos aos campos correspondentes.

[SITUATIONAL] Links do summary podem levar ao campo relevante quando isso melhora navegação.

## Invalid Submission Focus

[DEFAULT] Depois de tentativa de submit inválida, considere focar:

- error summary;
- first invalid field;

quando isso reduz o esforço para localizar o problema.

[HARD RULE] Não mova foco em cada mudança de validação.

Focus mechanics pertencem a `keyboard-focus.md`.

## Submission Errors

[DEFAULT] Falha de submissão precisa permanecer perceptível enquanto ainda é relevante.

Não dependa exclusivamente de feedback transitório que desaparece rapidamente.

A classificação funcional do erro pertence a `forms/error-handling.md`.

## Dynamic Errors and Status

[SITUATIONAL] Erros/resultados que aparecem após operação podem precisar de comunicação dinâmica.

Use live/status strategy somente quando necessária.

Detalhes pertencem a `aria.md`.

## Preserve User Context on Failure

[DEFAULT] A camada acessível deve continuar coerente com o draft preservado após falha.

A decisão funcional de preservar/resetar form values pertence a `forms/submission.md`.

Não duplique essa lógica no componente de acessibilidade.

## Pending Submission

[DEFAULT] Quando submission pending altera disponibilidade ou contexto, a mudança deve ser compreensível.

Não dependa apenas de spinner visual ou button disabled sem contexto quando o usuário precisa entender o que está ocorrendo.

Semântica funcional de pending/disabled pertence a ui-states/forms submission.

## Success Feedback

[SITUATIONAL] Se sucesso não ficar evidente por navegação/mudança de contexto, considere feedback perceptível.

Evite anúncio redundante quando a nova interface já comunica claramente o resultado.

## Reusable Field Components

[HARD RULE] Abstrações como `TextField` precisam preservar:

```text
label
control
description
error
state
```

e suas relações semânticas.

Não esconda essa estrutura atrás de markup visual sem associação real.

## IDs in Reusable Fields

[HARD RULE] Relações por ID não podem colidir entre múltiplas instâncias.

Use estratégia confiável para gerar/reutilizar IDs estáveis.

Detalhes gerais de relações pertencem a `aria.md`.

## Custom Form Controls

[SITUATIONAL] Se um controle realmente precisa ser customizado, ele deve implementar todas as responsabilidades necessárias:

- semantics;
- accessible name;
- keyboard behavior;
- focus behavior;
- state.

[DEFAULT] Prefira controle nativo quando atende à necessidade.

## Form Sections

[DEFAULT] Formulários longos podem usar headings/grupos para tornar a estrutura compreensível.

A hierarquia de headings pertence a `semantic-html.md`.

## Conditional Fields

[DEFAULT] Quando campos aparecem/desaparecem, preserve contexto compreensível.

[HARD RULE] Não mova foco automaticamente para todo campo novo.

Se uma transição realmente exige orientação, siga `keyboard-focus.md`.

## Multi-Step Forms

[SITUATIONAL] Em forms multi-step, comunique de forma compreensível:

- current step;
- step title;
- progress quando relevante;
- validation state;
- navigation options.

Não dependa somente de aparência visual para indicar a etapa atual.

## Accessibility Is Not a Parallel UI

[HARD RULE] Não crie uma UI visual e outra completamente diferente para assistive technology.

A mesma interface deve oferecer:

- clear labels;
- clear instructions;
- clear errors;
- clear state.

ARIA complementa a interface existente.

## Responsibility Boundaries

Esta referência é dona de:

- form labels;
- supporting instructions;
- required/optional communication;
- groups;
- field/error relationships;
- error summary;
- accessible form feedback.

Outras responsabilidades:

- validation rules/timing → forms/validation;
- submit/reset/retry → forms/submission;
- error classification → forms/error-handling;
- generic ARIA/live regions → `aria.md`;
- focus mechanics → `keyboard-focus.md`;
- element choice → `semantic-html.md`.
