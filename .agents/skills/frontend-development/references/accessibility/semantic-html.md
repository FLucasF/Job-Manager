# Frontend Semantic HTML

Referência para escolher estrutura e elementos HTML que representem corretamente o conteúdo e a interação.

## Contents

- Native semantics first
- Button vs link
- Headings
- Landmarks
- Sectioning
- Lists
- Tables
- Images
- Form controls
- Interactive nesting
- Cards
- DOM order
- Reusable components
- Responsibility boundaries

## Native Semantics First

[HARD RULE] Prefira o elemento HTML nativo que já representa a responsabilidade desejada.

Prefira:

```tsx
<button type="button">
  Save
</button>
```

a:

```tsx
<div onClick={handleSave}>
  Save
</div>
```

[HARD RULE] Não substitua semântica nativa por um elemento genérico + JavaScript/ARIA sem necessidade.

HTML nativo já fornece parte importante de:

- semantics;
- keyboard behavior;
- focus behavior;
- form behavior;
- browser behavior.

ARIA complementar pertence a `aria.md`.

## Button vs Link

[HARD RULE] Use:

```text
button
→ executa uma ação
```

```text
link
→ navega para um destino
```

Exemplos:

```tsx
<button type="button" onClick={openDialog}>
  Edit
</button>
```

```tsx
<a href="/vacancies/123">
  View vacancy
</a>
```

Não use button como substituto de navegação quando existe um destino real.

Não use link apenas para executar uma ação local.

## Generic Elements

[DEFAULT] Use `div` e `span` quando não existe uma semântica mais específica.

Eles não são incorretos.

[HARD RULE] Não transforme `div`, `span`, `p` ou `li` em controles interativos quando um elemento nativo adequado existe.

## Headings Represent Structure

[HARD RULE] Headings representam a hierarquia do conteúdo, não o tamanho visual.

```text
h1
└── h2
    ├── h3
    └── h3
```

Prefira:

```tsx
<h1 className="text-3xl font-bold">
  Vacancies
</h1>
```

quando esse conteúdo é o título principal.

Não escolha `h4` apenas porque o estilo visual parece adequado.

## Page Heading

[DEFAULT] Uma página deve possuir um heading principal que identifique seu conteúdo quando isso fizer sentido para a estrutura.

Seções internas usam níveis coerentes com a hierarquia real.

## Landmarks

[DEFAULT] Use landmarks/elementos estruturais quando representam regiões significativas.

Exemplos:

```text
header
nav
main
aside
footer
```

### `main`

[HARD RULE] Use `main` para o conteúdo principal da página.

Não crie múltiplos conteúdos principais concorrentes sem uma necessidade estrutural real.

### `nav`

[DEFAULT] Use `nav` para grupos relevantes de navegação.

Não coloque qualquer grupo de links em `nav` apenas porque contém anchors.

## `section`

[SITUATIONAL] Use `section` para uma divisão temática significativa.

```tsx
<section>
  <h2>Recent applications</h2>
  <ApplicationList />
</section>
```

[HARD RULE] Não use `section` como substituto estilístico de `div`.

## `article`

[SITUATIONAL] Use `article` quando o conteúdo representa uma unidade independente de informação.

Um card visual não é automaticamente um `article`.

## Lists Should Be Lists

[HARD RULE] Quando itens formam semanticamente uma lista, use `ul`/`ol` + `li`.

```tsx
<ul>
  {vacancies.map(vacancy => (
    <li key={vacancy.id}>
      <VacancyCard vacancy={vacancy} />
    </li>
  ))}
</ul>
```

Use:

```text
ul
→ ordem sem significado

ol
→ ordem com significado
```

## Tables Are for Tabular Data

[HARD RULE] Use `table` quando existe relação real entre linhas e colunas.

Não use tabela para layout.

Quando usar tabela, preserve a estrutura adequada:

```text
table
├── thead
│   └── th
└── tbody
    └── td
```

## Text Styling Is Not Semantics

[HARD RULE] Tipografia não substitui elementos semânticos.

Use `strong` e `em` somente quando existe significado de importância/ênfase.

Styling visual permanece responsabilidade do CSS/Tailwind.

## Images

[DEFAULT] Imagens informativas precisam de alternativa textual coerente com sua função.

Imagens decorativas não devem adicionar informação redundante.

[HARD RULE] Não use nome de arquivo como texto alternativo automático.

ARIA/accessible naming detalhado pertence a `aria.md`.

## Form Controls

[HARD RULE] Use controles nativos adequados quando representam a entrada necessária:

```text
input
textarea
select
button
```

Não recrie checkbox, radio, button ou input com elementos genéricos sem necessidade.

Detalhes de labels, instructions e errors pertencem a `form-accessibility.md`.

## Do Not Nest Interactive Elements

[HARD RULE] Não aninhe controles interativos incompatíveis.

Evite:

```tsx
<button>
  Open vacancy

  <button>
    Delete
  </button>
</button>
```

e:

```tsx
<a href="/vacancies/123">
  Vacancy
  <button>Favorite</button>
</a>
```

Estruture ações independentes como controles independentes.

## Cards Are Not Automatically Interactive

[HARD RULE] Não transforme um card inteiro em button/link quando o card possui múltiplas ações independentes.

```text
VacancyCard
├── title → navigation
├── favorite → action
└── delete → action
```

Preserve a semântica individual das ações.

## Clickable Area

[DEFAULT] Quando precisar aumentar a área clicável, aumente/estilize a área do elemento semântico responsável.

Não coloque `onClick` no container genérico só para ampliar o target.

## DOM Order

[HARD RULE] Estrutura semântica e ordem lógica não devem depender de CSS.

Evite:

```text
visual order
≠
reading / interaction order
```

quando isso prejudica compreensão ou navegação.

Detalhes de focus order pertencem a `keyboard-focus.md`.

## Reusable Components Must Preserve Semantics

[HARD RULE] Abstrações não devem apagar a responsabilidade semântica do elemento.

Evite:

```tsx
function Button(props) {
  return <div {...props} />
}
```

quando o componente representa um button.

### Polymorphic Components

[SITUATIONAL] Componentes polimórficos devem preservar a semântica do elemento efetivamente renderizado.

```tsx
<Action as="a" href="/vacancies">
  Vacancies
</Action>
```

e:

```tsx
<Action as="button" onClick={createVacancy}>
  Create vacancy
</Action>
```

representam responsabilidades diferentes.

[HARD RULE] Reutilização visual não justifica unificar semânticas incompatíveis.

## Responsibility Boundaries

Esta referência é dona de:

- element choice;
- document structure;
- button vs link;
- headings;
- landmarks;
- lists/tables;
- DOM semantic order;
- native controls.

Outras responsabilidades:

- ARIA/name/state/relationships → `aria.md`;
- keyboard/focus behavior → `keyboard-focus.md`;
- form labels/errors/instructions → `form-accessibility.md`;
- routing semantics de navegação → architecture/routing.
