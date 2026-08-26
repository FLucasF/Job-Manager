# Frontend ARIA

Referência para semântica complementar, nomes acessíveis, relações, estados e mensagens dinâmicas.

## Contents

- Native HTML before ARIA
- Accessible name and description
- ARIA states
- Hidden and decorative content
- Live regions and status
- Dialog/widget semantics
- Relationships and IDs
- ARIA as derived state
- Responsibility boundaries

## Native HTML Before ARIA

[HARD RULE] Considere HTML semântico antes de adicionar ARIA.

Prefira:

```tsx
<button type="button">
  Save
</button>
```

a:

```tsx
<div role="button">
  Save
</div>
```

ARIA complementa semântica.

Ela não substitui:

- keyboard behavior;
- focus behavior;
- native interaction;
- form behavior.

A escolha do elemento pertence a `semantic-html.md`.

## Do Not Add Redundant Roles

[HARD RULE] Não adicione role que apenas repete a semântica nativa.

Evite:

```tsx
<button role="button">
  Save
</button>
```

Mais ARIA não significa mais acessibilidade.

## Accessible Name

[HARD RULE] Controles interativos precisam de nome acessível compreensível.

Quando texto visível já nomeia o controle:

```tsx
<button>
  Delete vacancy
</button>
```

não adicione outro nome sem necessidade.

## Prefer Visible Labels

[DEFAULT] Prefira texto visível que também forneça o nome acessível.

Quando o controle é icon-only, uma alternativa explícita pode ser necessária:

```tsx
<button aria-label="Close dialog">
  <CloseIcon aria-hidden="true" />
</button>
```

[HARD RULE] O nome acessível deve representar a mesma ação comunicada visualmente.

## `aria-label`

[SITUATIONAL] Use quando um elemento precisa de nome acessível e não há conteúdo visível adequado para fornecê-lo.

Evite:

```tsx
<button aria-label="Save">
  Save
</button>
```

quando o texto visível já resolve.

## `aria-labelledby`

[SITUATIONAL] Use quando outro conteúdo visível já identifica o elemento.

```tsx
<h2 id="delete-title">
  Delete vacancy
</h2>

<div
  role="dialog"
  aria-labelledby="delete-title"
>
  ...
</div>
```

## Accessible Description

`aria-describedby` associa informação complementar.

```tsx
<input
  id="password"
  aria-describedby="password-help"
/>

<p id="password-help">
  Use at least 8 characters.
</p>
```

[HARD RULE] Name e description têm responsabilidades diferentes:

```text
name
→ identifica

description
→ complementa
```

Não use descrição longa como substituto de identificação clara.

## ARIA State Must Reflect Real State

[HARD RULE] Estado ARIA deve ser derivado do mesmo estado real que controla a interface.

```tsx
<button
  aria-expanded={isOpen}
  onClick={toggle}
>
  Filters
</button>
```

Nunca mantenha:

```text
visual state = expanded
ARIA state = collapsed
```

## Do Not Duplicate State for ARIA

[HARD RULE] Não crie state React separado apenas para um atributo ARIA quando a informação já existe.

Evite:

```tsx
const [isOpen, setIsOpen] = useState(false)
const [ariaExpanded, setAriaExpanded] = useState(false)
```

Use a mesma fonte de verdade.

## State Semantics Are Distinct

[HARD RULE] Não trate estes conceitos como equivalentes:

```text
current
selected
checked
pressed
expanded
disabled
```

Use o atributo que representa a semântica real do padrão.

## `aria-expanded`

[DEFAULT] Use no controle que representa expansão/recolhimento quando essa informação não é fornecida nativamente.

Não use apenas porque algum conteúdo aparece/desaparece.

## `aria-controls`

[SITUATIONAL] Use quando expressar a relação controle → região controlada agrega informação útil.

Não adicione indiscriminadamente.

## `aria-current`

[DEFAULT] Use quando um item representa o atual dentro de navegação/progressão.

Exemplo:

```tsx
<a
  href="/vacancies"
  aria-current={isCurrent ? 'page' : undefined}
>
  Vacancies
</a>
```

## `aria-pressed`

[SITUATIONAL] Use em toggle buttons cujo estado pressed/unpressed permanece significativo após interação.

Não significa “esse button foi clicado”.

## `aria-selected`

[SITUATIONAL] Use em padrões que possuem conceito semântico de seleção.

Não substitui genericamente:

```text
active
current
expanded
hovered
```

## `aria-checked`

[SITUATIONAL] Use quando um widget customizado realmente implementa semântica compatível de checked.

[DEFAULT] Prefira checkbox/radio nativo quando possível.

## `aria-disabled` vs `disabled`

[HARD RULE] `aria-disabled` comunica indisponibilidade, mas não implementa o comportamento de `disabled`.

Quando um controle HTML nativo deve realmente ser disabled, prefira o atributo nativo.

A decisão funcional de disabled pertence a `ui-states/disabled.md`.

## Hidden Content

[HARD RULE] Semântica e interação precisam refletir a interface atual.

Não deixe conteúdo interativo:

```text
hidden from accessibility tree
+
still focusable/interactable
```

## `aria-hidden`

[SITUATIONAL] Use quando conteúdo realmente não deve ser exposto às tecnologias assistivas.

Caso comum:

```tsx
<button>
  <TrashIcon aria-hidden="true" />
  Delete
</button>
```

[HARD RULE] Não aplique `aria-hidden` a conteúdo que ainda contém interação/foco relevante.

## Decorative vs Informative Icons

[DEFAULT] Ícone decorativo não deve poluir o nome acessível.

[SITUATIONAL] Se um ícone é a única representação de informação relevante, forneça uma alternativa acessível adequada.

Não dependa apenas da forma visual.

## Status Messages

[SITUATIONAL] Mudanças dinâmicas importantes podem precisar ser percebidas sem mudança de foco.

Exemplos:

- item saved;
- results updated;
- operation failed;
- upload completed.

## Live Regions

[SITUATIONAL] Use live region quando conteúdo novo precisa ser anunciado sem mover foco.

```tsx
<div aria-live="polite">
  {message}
</div>
```

[DEFAULT] Prefira anúncio não interruptivo para atualizações não urgentes.

[HARD RULE] Não transforme grandes regiões, listas ou a página inteira em live region.

Mensagens devem ser pequenas e específicas.

## Do Not Move Focus Just to Announce

[DEFAULT] Se status/live region comunica adequadamente uma atualização, não mova foco apenas para gerar anúncio.

Focus management pertence a `keyboard-focus.md`.

## Dialog Semantics

[SITUATIONAL] Dialog customizado precisa de semântica apropriada e nome acessível.

Semântica do dialog não implementa focus management.

Teclado, contenção/restauração de foco pertencem a `keyboard-focus.md`.

## Custom Widgets

[HARD RULE] Adicionar um `role` não implementa um widget.

Um widget customizado pode exigir coerência entre:

```text
role
state
properties
relationships
keyboard behavior
focus behavior
```

ARIA deste arquivo cobre a parte semântica.

Keyboard/focus pertence a `keyboard-focus.md`.

[DEFAULT] Prefira elemento/padrão nativo quando ele evita essa complexidade.

## Relationships Must Reference Real Elements

[HARD RULE] Relações como:

```text
aria-labelledby
aria-describedby
aria-controls
```

devem apontar para elementos realmente existentes quando aplicáveis.

Não mantenha referência para elemento que deixou de ser renderizado.

## Unique IDs

[HARD RULE] IDs usados em relações semânticas precisam ser únicos na página.

Componentes reutilizáveis não devem gerar colisões.

Prefira uma estratégia estável/confiável de IDs em vez de strings manuais frágeis.

## ARIA Does Not Replace Visible UX

[HARD RULE] Informação necessária para todos os usuários não deve existir apenas em uma camada ARIA escondida.

Acessibilidade complementa uma interface compreensível; não cria uma experiência paralela.

## Responsibility Boundaries

Esta referência é dona de:

- roles/ARIA attributes;
- accessible name/description;
- ARIA states;
- relationships;
- live regions/status;
- semantic side of custom widgets.

Outras responsabilidades:

- element choice → `semantic-html.md`;
- keyboard/focus → `keyboard-focus.md`;
- field/error associations em forms → `form-accessibility.md`;
- functional UI state → ui-states.
