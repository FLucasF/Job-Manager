# Frontend Form State

Referência para modelar o estado temporário de edição de formulários.

## Contents

- Form state responsibility
- Single source of truth
- Initial values
- Server state vs form state
- Reset
- Create and edit
- Dirty and touched
- Controlled and uncontrolled inputs
- Derived values
- Conditional fields
- Dynamic collections
- Responsibility boundaries

## Form State Responsibility

[HARD RULE] Form state representa o draft temporário que o usuário está criando ou editando antes da persistência.

```text
Persisted Data
→ Initial Values
→ Form State
→ User Editing
→ Submission
```

Form state pode divergir dos dados persistidos durante a edição.

[HARD RULE] Não trate form state como fonte persistente da aplicação.

## Single Source of Truth

[HARD RULE] Cada valor editável deve possuir uma única fonte de verdade dentro do formulário.

Evite manter o mesmo campo simultaneamente em:

```text
useState
+
form library state
```

quando ambos representam exatamente o mesmo valor.

Prefira uma única estratégia de ownership para cada campo.

## Initial Values

[DEFAULT] Defina valores iniciais explicitamente.

Criação:

```ts
const defaultValues = {
  title: '',
  description: '',
  remote: false,
}
```

Edição:

```ts
const initialValues = {
  title: vacancy.title,
  description: vacancy.description,
  remote: vacancy.remote,
}
```

Os valores iniciais representam o ponto de partida do draft.

### Stable Initialization

[DEFAULT] Não recrie valores iniciais sem necessidade quando a estratégia de formulário depende de sua identidade ou inicialização.

[HARD RULE] Não use mudança contínua de `defaultValues` como mecanismo de sincronização com outras fontes.

## Server State vs Form State

[HARD RULE] Dados carregados do backend e draft editável são responsabilidades diferentes.

```text
Server State
→ persisted resource

Form State
→ user draft
```

Depois que o usuário começa a editar, um refetch não deve sobrescrever automaticamente suas alterações.

[HARD RULE] Não sincronize continuamente form state com server state por Effect.

Quando um novo recurso realmente deve substituir o draft atual, faça uma transição explícita de inicialização/reset.

## Reset

[DEFAULT] `reset` representa uma mudança intencional para um novo estado inicial.

Exemplos:

```text
successful create + stay on form
→ reset for next item

cancel editing
→ reset/discard intentionally

different resource selected
→ reset with new initial values
```

[HARD RULE] Não use reset como mecanismo permanente de sincronização.

Uma operação falhar, começar ou refazer fetch não implica reset automaticamente.

## Create and Edit

[DEFAULT] Create e edit podem compartilhar o mesmo formulário quando campos e comportamento realmente são os mesmos.

```text
Create
→ default values

Edit
→ existing values
```

Separe implementações quando regras, campos ou fluxo divergirem de forma relevante.

A operação de submit de create vs update pertence a `submission.md`.

## Dirty State

Dirty indica diferença entre valor atual e valor inicial.

```text
initial
→ user changes value
→ dirty
```

[DEFAULT] Use a informação fornecida pela estratégia de formulário quando ela já existe.

Não mantenha dirty state manual em paralelo.

## Touched State

Touched indica que o usuário interagiu com um campo.

```text
focus / interaction
→ touched
```

[HARD RULE] Não trate `dirty` e `touched` como equivalentes.

Exemplo:

```text
user focuses and leaves unchanged
→ touched = true
→ dirty = false
```

Validation timing pertence a `validation.md`.

## Controlled and Uncontrolled Inputs

[SITUATIONAL] Use a estratégia compatível com a biblioteca e componentes adotados pelo projeto.

Controlled:

```tsx
<input
  value={title}
  onChange={event => setTitle(event.target.value)}
/>
```

Uncontrolled delega o valor ao elemento/form library até a leitura necessária.

[HARD RULE] Não misture controlled e uncontrolled para o mesmo campo sem necessidade concreta.

## Do Not Mirror Derived Values

[HARD RULE] Não armazene como estado independente um valor que pode ser derivado de outros campos.

Evite manter:

```text
firstName
lastName
fullName
```

quando:

```ts
const fullName = `${firstName} ${lastName}`
```

representa corretamente o valor.

Armazene somente informação que possui estado independente.

## Conditional Fields

[SITUATIONAL] Quando um campo deixa de ser aplicável, defina explicitamente o destino de seu valor.

Possibilidades:

```text
preserve
clear
exclude from submission
```

[HARD RULE] Não deixe esse comportamento acontecer por acidente devido a mount/unmount.

A validação condicional pertence a `validation.md`.

## Dynamic Collections

[SITUATIONAL] Coleções editáveis devem permanecer estruturadas como uma única responsabilidade do formulário.

```ts
skills: [
  { name: 'React', level: 'advanced' },
  { name: 'TypeScript', level: 'advanced' },
]
```

Evite criar estados independentes desconectados para itens que pertencem à mesma coleção lógica.

## Keep Unrelated State Out of Form State

[HARD RULE] Form state deve representar valores que fazem parte da edição.

Não coloque nele apenas porque estão na mesma tela:

```text
isModalOpen
query cache
navigation state
permissions
toast visibility
```

Da mesma forma, `pending`, `success` e falha da operação pertencem ao submission state, não aos valores do formulário.

## Responsibility Boundaries

Esta referência é dona de:

- editable values;
- initial/default values;
- reset;
- dirty/touched;
- controlled/uncontrolled ownership;
- conditional value retention;
- dynamic collections.

Outras responsabilidades:

- regras de validade → `validation.md`;
- execução da operação → `submission.md`;
- representação de erros → `error-handling.md`;
- server-state placement → architecture;
- Effect synchronization → React/TSX references.
