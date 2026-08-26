# Frontend State Placement

Referência para decidir onde cada estado deve viver e qual é sua fonte de verdade.

## Contents

- Placement principle
- Local state
- Lift state up
- Context
- Server state
- Form state
- URL state
- Global client state
- Derived state
- Mirrored state
- Ownership decision
- Responsibility boundaries

## Placement Principle

[HARD RULE] Mantenha estado no menor escopo que precisa conhecê-lo.

Escolha a ferramenta **depois** de identificar ownership e consumers.

```text
one component
→ local state

nearby components
→ lift to nearest common owner

subtree-wide dependency/state
→ Context/provider

remote source of truth
→ server state

temporary edit draft
→ form state

navigable/shareable state
→ URL

independent distant areas
→ consider global client state
```

## Local State

[DEFAULT] Use local state para informação que pertence a um componente ou boundary pequeno de UI.

Exemplos:

- local disclosure state;
- current step;
- selected local tab;
- temporary interaction state.

[HARD RULE] Não torne local UI state global apenas para centralizá-lo.

## Lift State Up

[DEFAULT] Se componentes próximos precisam do mesmo valor, mova-o somente até o ancestral comum necessário.

```text
VacancyFilters
      ↑
VacanciesPage
      ↓
VacancyList
```

[HARD RULE] Dois consumers próximos não justificam Context automaticamente.

## Context

[SITUATIONAL] Context é adequado quando uma subárvore precisa de uma dependência/estado compartilhado sem passar por muitos níveis irrelevantes.

Possíveis exemplos:

- theme;
- session data needed by a subtree;
- composition state;
- shared configuration.

[HARD RULE] Não use um `AppContext` genérico como store para tudo.

```text
user
vacancies
filters
modal
theme
loading
notifications
```

possuem ownerships diferentes.

A implementação do Context pertence às referências React/TSX.

## Server State

[HARD RULE] Quando a fonte de verdade é remota, trate o dado como server state.

Exemplos:

```text
vacancies
users
applications
remote profile
remote permissions
```

Server-state tooling pode possuir:

- loading/status;
- cache;
- refetch;
- synchronization;
- invalidation.

[HARD RULE] Não copie o resultado remoto para `useState`, Context ou global store apenas para "ter acesso" ao mesmo dado.

Acesso e Repository pertencem a `data-access.md`.

## Form State

[DEFAULT] Um draft temporário pode divergir legitimamente do dado persistido.

```text
server resource
→ initial form values
→ user draft
```

Isso não é duplicação indevida porque os dois valores representam estados conceitualmente diferentes.

Regras detalhadas de form state pertencem a `forms/form-state.md`.

## URL State

[DEFAULT] Quando o valor representa estado navegável, reproduzível ou compartilhável, considere a URL como owner.

Exemplos:

```text
?page=2
?status=open
?search=react
?sort=createdAt
```

[HARD RULE] Se o valor já está representado na URL, não mantenha uma cópia independente em React state.

Semântica de path/search params pertence a `routing.md`.

## Keep Ephemeral UI State Out of URL

[DEFAULT] Não coloque na URL estado sem significado navegável.

Exemplos normalmente locais:

```text
isTooltipOpen
isHovered
isDragging
temporary uncontrolled interaction
```

Routing não é store geral de UI.

## Global Client State

[SITUATIONAL] Considere estado global quando um valor client-side precisa ser compartilhado entre áreas independentes e nenhum owner menor representa corretamente a responsabilidade.

Antes, verifique se resolve com:

1. local state;
2. lifted state;
3. Context de subárvore;
4. server state;
5. URL state.

[HARD RULE] Complexidade local não é motivo suficiente para mover estado para store global.

## Complex Local State

[SITUATIONAL] Quando muitas transições locais se relacionam, mude a **modelagem**, não necessariamente o **escopo**.

Por exemplo, `useReducer` pode melhorar transições sem transformar o estado em global.

A implementação pertence às referências React/TSX.

## Derived State

[HARD RULE] Não armazene informação calculável a partir de fontes já disponíveis.

Evite:

```tsx
const [firstName, setFirstName] = useState('')
const [lastName, setLastName] = useState('')
const [fullName, setFullName] = useState('')
```

quando:

```tsx
const fullName = `${firstName} ${lastName}`
```

é suficiente.

Também derive filtros/seleções quando não possuem estado independente.

## Avoid Mirrored State

[HARD RULE] Não mantenha duas fontes de verdade para a mesma informação.

Exemplos problemáticos:

```text
URL + useState
query cache + global store
Context + local state
server state + mirrored local state
```

Estado adicional é válido somente quando representa **outra informação**, como um draft editável.

## State Ownership

[DEFAULT] Escolha ownership pela origem e responsabilidade:

```text
modal visibility
→ local component/boundary

subtree dependency
→ nearby provider

remote vacancies
→ server state

temporary form draft
→ form state

route filter
→ URL
```

[HARD RULE] Não escolha o local apenas pela facilidade de acesso.

## Prop Drilling Is Not Automatically a Problem

[DEFAULT] Passar props por alguns níveis relacionados à composição pode ser mais simples e explícito que Context/global state.

Considere outro mecanismo quando intermediários realmente não têm relação com o valor e o boundary da subárvore é claro.

## Responsibility Boundaries

Esta referência é dona de:

- state ownership;
- local/lifted/context/global placement;
- server/form/URL state classification;
- derived/mirrored state.

Outras responsabilidades:

- Context API → React/TSX;
- form draft behavior → forms;
- server access/cache operations → `data-access.md`;
- URL semantics → `routing.md`.
