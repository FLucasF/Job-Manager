# Frontend Disabled States

Referência de decisões e armadilhas para ações e controles indisponíveis.

## Contents

- State meaning
- Disabled vs other states
- Capability modeling
- Derived state
- Pending actions
- Scope
- Explainability
- Forms
- Failure recovery
- Native semantics and security
- Responsibility boundaries

## State Meaning

[HARD RULE] Disabled representa uma interação que existe, mas não pode ser executada no estado atual.

Disabled não significa automaticamente:

- loading;
- read-only;
- hidden;
- unauthorized;
- feature unavailable;
- error.

[HARD RULE] Use disabled somente quando a ação ainda faz sentido naquele contexto.

Se a ação não existe conceitualmente ali, reavalie se deveria estar visível.

## Disabled vs Hidden

```text
disabled
→ ação existe, mas não pode ser executada agora

hidden
→ ação não faz parte da interface nesse contexto
```

A decisão depende das regras e experiência do produto.

## Disabled vs Read-Only

Use read-only quando o valor deve continuar perceptível, selecionável ou consultável, mas não editável.

Use disabled quando o controle não está disponível para interação.

[HARD RULE] Não use disabled apenas como styling para impedir edição de informação que deveria continuar sendo consultada normalmente.

## Disabled vs Loading

Loading descreve uma operação pendente. Disabled descreve indisponibilidade da interação.

Eles podem coexistir:

```text
save pending
→ loading feedback
+ prevent duplicate save
```

A fonte do estado continua sendo a operação pendente.

## Disabled vs Unauthorized / Unavailable

[HARD RULE] Falta de permissão ou feature indisponível não deve virar automaticamente um controle disabled.

Considere se a ação deve:

- permanecer visível e indisponível;
- ser escondida;
- explicar a restrição;
- ser substituída por outra ação.

Não use disabled como resposta genérica para qualquer indisponibilidade.

## Model Availability from Meaningful Conditions

[HARD RULE] Todo disabled deve ter uma condição real e clara.

Prefira:

```tsx
<Button disabled={!canSubmit}>
  Save
</Button>
```

Quando a condição é complexa e possui significado próprio, expresse esse significado:

```ts
const canSubmit =
  formIsValid &&
  !isPending &&
  hasRequiredItems
```

Não crie abstrações para condições triviais.

## Prefer Capability Semantics

[DEFAULT] Quando a condição representa uma capacidade real, modele-a como capacidade.

Prefira:

```ts
const canDelete = ...
```

a:

```ts
const shouldDisableDeleteButton = ...
```

A regra decide se a ação pode acontecer; a UI decide representar isso como disabled.

## Do Not Store Derived Disabled State

[HARD RULE] Não crie uma segunda fonte de verdade para algo derivável.

Evite:

```tsx
const [disabled, setDisabled] = useState(false)
const canSubmit = formState.isValid
```

quando:

```ts
const isDisabled = !canSubmit
```

é suficiente.

## Keep Domain Rule Separate from UI Representation

[HARD RULE] O componente não deve recriar regra de domínio apenas para calcular `disabled`.

```text
domain/application rule
→ canApply

UI representation
→ disabled={!canApply}
```

Placement de regras pertence às referências de architecture.

## Reflect the Current Condition

[HARD RULE] O controle deve acompanhar o estado atual.

```text
form invalid → disabled
form becomes valid → available
```

Não mantenha indisponibilidade baseada em estado obsoleto.

### Async Conditions

[SITUATIONAL] Quando capacidade depende de dados ainda desconhecidos, não assuma conclusões definitivas antes da resolução.

Loading dessa informação pertence a `loading.md`.

## Pending and Duplicate Execution

[HARD RULE] Quando múltiplas execuções conflitam, impeça nova execução enquanto a primeira está pendente.

```text
submit
→ pending
→ prevent duplicate submit
```

Disabled pode representar isso na UI, mas a lógica responsável pela operação também deve evitar conflitos quando necessário.

## Disable the Smallest Necessary Scope

[HARD RULE] Restrinja somente as interações conflitantes.

Evite:

```text
one action pending
→ whole page disabled
```

quando navigation e controles independentes continuam seguros.

## Keep Disabled Understandable

[DEFAULT] Quando a razão não é evidente, forneça contexto suficiente para o usuário entender como a ação pode se tornar disponível.

Não deixe uma ação importante permanentemente disabled sem:

- causa compreensível;
- caminho de resolução, quando existe.

Se não há forma de disponibilizar a ação naquele contexto, reavalie se ela deveria permanecer visível.

## Multiple Preconditions

[SITUATIONAL] Uma capacidade pode depender de várias condições:

```ts
const canPublish =
  isValid &&
  hasItems &&
  !isPending
```

Se explicar a indisponibilidade, apresente informação útil ao usuário, não a expressão técnica interna.

## Form Submission

[DEFAULT] Submit pode estar disabled quando a submissão não pode ser iniciada, por exemplo:

- formulário conhecido como inválido;
- submission pending;
- dependência obrigatória indisponível.

[HARD RULE] Disabled não substitui validação.

O usuário ainda precisa entender o que deve corrigir.

## Conditional Fields

[SITUATIONAL] Quando um campo deixa de ser aplicável, não assuma automaticamente que deve ficar disabled.

Dependendo da regra, pode:

- hide;
- disable;
- clear;
- preserve.

Comportamento dos valores pertence às referências de forms.

[HARD RULE] Desabilitar visualmente um campo não deve limpar seu valor silenciosamente sem regra explícita.

## After Failure

[SITUATIONAL] Uma falha não implica indisponibilidade permanente.

```text
request fails
→ retry is valid
→ action may become available again
```

Error/recovery pertence a `error.md`.

## Disabled Is Not Security

[HARD RULE] Nunca dependa de disabled para autorização, segurança ou validade da operação.

Disabled é comportamento de UI. As camadas responsáveis continuam validando a operação.

## Prefer Native Semantics

[HARD RULE] Quando HTML possui estado disabled nativo, prefira-o.

```tsx
<button disabled={isPending}>
  Save
</button>
```

Não simule disabled apenas visualmente.

Semântica, comportamento, feedback visual e keyboard interaction devem permanecer coerentes.

## Accessibility Boundary

[DEFAULT] Não dependa apenas de cor, hover ou aparência para comunicar indisponibilidade.

Detalhes de semântica, foco e teclado pertencem às referências de accessibility.

## Responsibility Boundaries

Esta referência cobre:

- unavailable interaction;
- disabled vs hidden/read-only;
- capability semantics;
- derived disabled state;
- pending conflicts;
- scope de bloqueio;
- explicação da indisponibilidade.

Outras responsabilidades:

- pending/loading → `loading.md`;
- failures → `error.md`;
- validation/form state → forms;
- domain rules → architecture;
- authorization/security → camada responsável;
- semantics/keyboard/focus → accessibility.
