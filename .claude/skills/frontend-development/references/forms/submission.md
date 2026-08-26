# Frontend Form Submission

Referência para transformar um formulário válido em uma operação da aplicação e reagir ao resultado.

## Contents

- Submission responsibility
- Validation gate
- Application boundary
- Form values vs operation input
- Submission state
- Duplicate prevention
- Pending and failure
- Success effects
- Coordination and repository boundaries
- Create vs update
- Server-state reconciliation
- Retry and idempotency
- Cancellation
- Responsibility boundaries

## Submission Responsibility

[DEFAULT] Submission coordena a passagem de um draft válido para uma operação da aplicação.

```text
Form State
→ Validation
→ Application Input
→ Application Operation
→ Repository
→ External Boundary
```

[HARD RULE] O componente de formulário não deve conhecer detalhes de transporte.

## Validate Before Submission

[HARD RULE] Não execute a operação enquanto existirem erros locais conhecidos que tornam o formulário inválido.

As regras de validade pertencem a `validation.md`.

## Do Not Perform Raw HTTP in Form Components

[HARD RULE] Form components não devem chamar `fetch`, Axios ou outro transport client diretamente.

Evite:

```tsx
async function handleSubmit(values: FormValues) {
  await fetch('/api/vacancies', {
    method: 'POST',
    body: JSON.stringify(values),
  })
}
```

Prefira delegar para o boundary já adotado:

```text
Form
→ Hook / Application Operation
→ Repository
→ HTTP Client
```

Data access pertence à arquitetura.

## Form Values Are Not Necessarily Operation Input

[DEFAULT] Não assuma que o formato de edição deve ser igual ao contrato da operação.

```ts
interface VacancyFormValues {
  salary: string
  remote: boolean
}

interface CreateVacancyInput {
  salary: number
  workModel: 'REMOTE' | 'ONSITE'
}
```

Quando necessário:

```text
FormValues
→ explicit mapping
→ Application Input
```

## Keep Mapping Explicit

[DEFAULT] Se existe transformação relevante, mantenha-a previsível e testável.

```ts
function toCreateVacancyInput(
  values: VacancyFormValues,
): CreateVacancyInput {
  return {
    salary: Number(values.salary),
    workModel: values.remote ? 'REMOTE' : 'ONSITE',
  }
}
```

[HARD RULE] Não crie camada de mapping quando os contratos já são equivalentes.

Transformações puras não precisam virar custom hooks.

## Submission State

[HARD RULE] Pending/success/failure da operação são distintos dos valores editáveis.

```text
Form State
→ title, description, remote

Submission State
→ pending, result, failure
```

[DEFAULT] Use a operação real como fonte de verdade.

Evite `isSubmitting` local se mutation/query abstraction já expõe `isPending` equivalente.

## Prevent Duplicate Submission

[HARD RULE] Quando apenas uma operação deve existir, impeça concorrência acidental.

```text
submit
→ pending
→ reject/ignore duplicate submit
→ complete
```

UI disabled pode representar isso, mas proteção não deve depender apenas da aparência do botão.

## Preserve Values While Pending

[HARD RULE] Iniciar submit não deve apagar o draft.

```text
Submit
→ Pending
→ Preserve Values
```

## Preserve Values on Failure

[HARD RULE] Falha não deve resetar automaticamente o formulário.

```text
Submit
→ Failure
→ Preserve Values
→ Show Error
```

O usuário deve conseguir corrigir ou repetir sem reconstruir todo o draft.

A classificação e apresentação do erro pertencem a `error-handling.md`.

## Reset Only as an Intentional Result

[DEFAULT] Reset após sucesso depende do fluxo.

Apropriado:

```text
create
→ success
→ remain on create screen
→ reset for next item
```

Desnecessário:

```text
edit
→ success
→ navigate away
```

[HARD RULE] Não resete todo formulário automaticamente após qualquer sucesso.

## Success Effects

[SITUATIONAL] Sucesso pode resultar em:

- preserve current view;
- reset;
- navigate;
- close dialog;
- reconcile server state;
- feedback ao usuário.

A reação deve seguir o fluxo da feature.

## Do Not Navigate or Close Before Success When Failure Needs the Form

[HARD RULE] Não destrua o contexto preenchido antes de saber se a operação concluiu quando a falha exige permanência no formulário.

```text
Submit
→ request
├── success → navigate/close
└── failure → preserve form
```

## UI Side Effects Stay Above the Repository

[HARD RULE] Repository não deve:

- navigate;
- close modal;
- reset form;
- show toast;
- update React state directly.

Repository executa acesso a dados e retorna o resultado.

A camada de coordenação/presentation decide como reagir.

## Submission Coordination

[DEFAULT] Use o boundary de coordenação já adotado pelo projeto quando a operação depende de React/server-state tooling.

Exemplo conceitual:

```text
Form
→ submission hook / application operation
→ repository
```

[HARD RULE] Não crie abstração adicional sem responsabilidade concreta.

## Create vs Update

[DEFAULT] Create e update podem compartilhar campos, mas são intenções diferentes.

```text
Create Form → create(input)
Edit Form   → update(id, input)
```

[HARD RULE] Não infera automaticamente a intenção apenas pela existência acidental de um campo como `id` quando os fluxos são distintos.

Torne a operação explícita no consumidor/feature.

## Server-State Reconciliation

[DEFAULT] Depois de mutation bem-sucedida, deixe a camada responsável por server state reconciliar o dado remoto.

Possíveis estratégias:

- invalidation;
- cache update;
- refetch;
- use returned resource.

[HARD RULE] Não copie o mesmo resultado para mutation state + local state + global store sem necessidade.

Defina ownership claro.

## Idempotency Awareness

[SITUATIONAL] Operações como criação, pagamento, convite ou pedido podem produzir efeitos duplicados.

Frontend deve evitar reenvio acidental.

[HARD RULE] Desabilitar um botão não é garantia de idempotência do sistema.

Quando necessário, backend/operação também precisa da proteção adequada.

## Retry

[SITUATIONAL] Permita retry quando a operação pode ser repetida com segurança.

```text
failure
→ preserve form
→ retry
```

[HARD RULE] Não aplique retry automático indiscriminado a mutations com efeitos externos.

## Cancellation

[SITUATIONAL] Diferencie:

```text
cancel editing
```

de:

```text
cancel in-flight request
```

Cancelar edição pode descartar o draft por decisão explícita.

Cancelar operação depende da infraestrutura e semântica daquela mutation.

## Responsibility Boundaries

Esta referência é dona de:

- submission flow;
- input mapping;
- pending source of truth;
- duplicate prevention;
- success/failure transition;
- create/update intent;
- retry/cancellation coordination.

Outras responsabilidades:

- editable values/reset semantics → `form-state.md`;
- validity rules → `validation.md`;
- error mapping/presentation → `error-handling.md`;
- repository/data access → architecture;
- loading/disabled semantics gerais → UI states.
