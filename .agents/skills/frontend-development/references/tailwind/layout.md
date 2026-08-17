# Tailwind Layout

Referência de decisões e armadilhas para layout com Tailwind.

## Contents

- Layout selection
- Display and visibility
- Specialized layout tools
- Media layout
- Positioning and stacking
- Flexbox
- Grid
- Gap
- Alignment
- Overflow and overscroll
- Logical properties
- Visual ordering
- Custom values
- Responsibility boundaries

## Layout Selection

[DEFAULT] Use flex quando a relação principal entre os elementos for unidimensional.

Exemplos típicos:

- toolbars;
- navigation rows;
- form actions;
- stacks;
- media objects.

[DEFAULT] Use grid quando rows e columns fizerem parte simultaneamente da estrutura.

Exemplos típicos:

- dashboards;
- card matrices;
- page shells;
- composições responsivas bidimensionais.

[HARD RULE] Não escolha flex ou grid por hábito. Escolha o modelo que representa a relação espacial da interface.

[HARD RULE] Não use `absolute` como mecanismo padrão de layout estrutural.

## Display and Visibility

Use `hidden` quando o elemento realmente deve sair do layout.

Use `invisible` quando ele deve permanecer ocupando espaço.

[SITUATIONAL] Use `contents` somente quando remover o box visual do elemento for intencional. Considere efeitos sobre semântica e accessibility antes de adotá-lo.

[SITUATIONAL] Use `flow-root` quando precisar explicitamente de um novo block formatting context, por exemplo para conter floats.

## Specialized Layout Tools

[SITUATIONAL] Use multi-column layout quando o conteúdo deve fluir automaticamente entre colunas.

Use grid quando rows e columns precisam de estrutura explícita.

[SITUATIONAL] Use `break-before-*`, `break-after-*` e `break-inside-*` somente em layouts paginados ou multi-column que realmente dependem de fragmentação.

[SITUATIONAL] Use floats principalmente quando conteúdo inline precisa envolver mídia.

[HARD RULE] Não use floats como substituto de flexbox ou grid para layout estrutural.

## Media Layout

[DEFAULT] Use `object-cover` quando preencher a área for mais importante do que preservar a imagem inteira.

[DEFAULT] Use `object-contain` quando todo o conteúdo visual precisar permanecer visível.

Quando `object-cover` puder recortar uma região relevante, defina a focal point com `object-*` ou um valor customizado.

```html
<img
  class="h-48 w-96 object-cover object-top"
  src="/img/photo.jpg"
  alt=""
/>
```

## Positioning and Stacking

Use `relative` quando um elemento no fluxo precisar funcionar como containing block para descendants posicionados.

Use `absolute` para elementos que realmente precisam sair do fluxo, como:

- badges;
- decorations;
- overlays;
- anchored controls.

Use `fixed` quando o posicionamento precisa acompanhar o viewport ou containing block aplicável.

Use `sticky` somente considerando também o scroll container e os limites do ancestor.

[HARD RULE] Não aumente `z-*` indefinidamente para resolver conflitos visuais.

Antes de aumentar z-index, verifique:

- stacking contexts;
- `position`;
- `isolation`;
- transforms;
- opacity;
- boundary do overlay.

[SITUATIONAL] Use `isolate` quando um componente precisa criar explicitamente seu próprio stacking context.

## Flexbox

[DEFAULT] Use `gap-*` para spacing estrutural entre flex items.

Use `shrink-0` quando um item não deve ser comprimido.

```html
<div class="flex gap-3">
  <img class="size-10 shrink-0" src="/img/avatar.jpg" alt="" />
  <div>...</div>
</div>
```

Quando conteúdo longo dentro de um flex item não estiver encolhendo como esperado, verifique também `min-w-0` na referência de spacing/sizing antes de esconder overflow.

Use `flex-1`, `flex-auto`, `flex-initial` e `flex-none` de acordo com a intenção de grow/shrink, não apenas para “fazer caber”.

[HARD RULE] Não use `flex-row-reverse` ou `flex-col-reverse` para corrigir uma ordem semântica incorreta no DOM.

## Grid

[DEFAULT] Use grid quando a estrutura depende simultaneamente de rows e columns.

[SITUATIONAL] Use `subgrid` quando um nested grid precisa compartilhar tracks do parent.

Use explicit template values quando a estrutura realmente exige tracks específicos:

```html
<div class="grid grid-cols-[16rem_1fr] gap-6">
  ...
</div>
```

[SITUATIONAL] Use `grid-flow-dense` somente quando preencher gaps visuais com itens posteriores for desejado.

[HARD RULE] Antes de usar `grid-flow-dense`, considere se a ordem visual poderá divergir da ordem do DOM de forma problemática.

## Gap

[DEFAULT] Prefira `gap-*` quando o spacing representa a relação estrutural entre items de flex ou grid.

```html
<div class="flex gap-4">
  ...
</div>
```

Não substitua automaticamente `gap` por margins nos children.

Margin e padding gerais pertencem à responsabilidade de spacing/sizing.

## Alignment

Escolha `justify-*`, `items-*`, `self-*`, `content-*` e `place-*` pelo eixo e pelo nível de responsabilidade corretos.

Uma distinção importante:

- `content-*` distribui tracks/lines quando há espaço extra;
- `items-*` alinha items dentro das tracks ou do container;
- `self-*` sobrescreve o alinhamento de um item;
- `place-*` combina propriedades de alinhamento dos dois eixos.

[DEFAULT] Considere variants `*-safe` quando center/end alignment puder gerar overflow indesejado.

Exemplos:

- `justify-center-safe`;
- `items-center-safe`;
- `place-items-center-safe`;
- `self-center-safe`.

Use `*-safe` quando o fallback seguro fizer parte do comportamento esperado, não como regra universal.

## Overflow and Overscroll

[HARD RULE] Não use `overflow-hidden` apenas para esconder um problema de sizing ou layout.

Antes de clipar, determine se o comportamento correto é:

- wrap;
- resize;
- shrink;
- scroll;
- clip.

Use `overflow-auto` quando scrolling deve aparecer somente quando necessário.

Use `overflow-clip` quando clipping é intencional e não deve criar o mesmo tipo de scroll container que `overflow-hidden`.

[SITUATIONAL] Use `overscroll-contain` quando um scroll container não deve propagar scroll para o ancestor ao atingir seu limite.

[SITUATIONAL] Use `overscroll-none` quando também for necessário bloquear comportamento de overscroll/bounce suportado pela plataforma.

## Logical Properties

[DEFAULT] Para interfaces direction-aware, prefira logical properties quando elas expressam corretamente a intenção.

Positioning:

- `inset-s-*` → inline-start;
- `inset-e-*` → inline-end;
- `inset-bs-*` → block-start;
- `inset-be-*` → block-end.

Floats:

- `float-start`;
- `float-end`.

Exemplo:

```html
<div dir="rtl" class="relative">
  <div class="absolute inset-s-0 top-0">
    ...
  </div>
</div>
```

Use propriedades físicas quando a dimensão ou lado físico for realmente parte do contrato.

## Visual Ordering

[HARD RULE] Utilities que alteram ordem visual não alteram automaticamente a ordem semântica do DOM.

Antes de usar:

- `order-*`;
- `flex-row-reverse`;
- `flex-col-reverse`;
- `grid-flow-dense`;

considere:

- reading order;
- keyboard navigation;
- focus order;
- content meaning.

Quando a ordem semântica importa, corrija a estrutura do DOM em vez de depender apenas de visual reordering.

## Custom Values

[DEFAULT] Use arbitrary values para regras pontuais que não representam um token reutilizável.

```html
<div class="grid-cols-[18rem_1fr]"></div>
```

Use CSS variables quando o valor já pertence a uma custom property com responsabilidade clara.

```html
<div class="gap-(--layout-gap)"></div>
```

Se o mesmo valor se repete como parte do design system, trate-o como token de theme em vez de repetir arbitrary values.

## Responsibility Boundaries

Esta referência cobre decisões de:

- display e visibility;
- flexbox e grid;
- positioning e stacking;
- overflow e overscroll;
- object fit/position;
- gap;
- alignment;
- logical layout properties;
- visual ordering.

Outras responsabilidades:

- width, height, min/max sizing, margin, padding e aspect ratio → spacing/sizing;
- breakpoints, container queries e state variants → responsive/variants;
- scrollbar styling e scroll snapping → interactivity;
- theme tokens e customização da API → theme/customization;
- requisitos semânticos de reading order, focus e visibility → accessibility.
