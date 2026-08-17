# Tailwind Backgrounds and Borders

Referência de decisões, armadilhas e padrões para backgrounds, borders e outlines com Tailwind.

## Contents

- Background strategy
- Background images
- Gradients
- Background sizing and positioning
- Background attachment
- Background clip and blend
- Border strategy
- Logical borders
- Border radius
- Logical radius
- Outlines and focus
- Table borders
- Arbitrary values and theme tokens
- Responsibility boundaries

## Background Strategy

[DEFAULT] Use cores e outros valores do theme antes de introduzir arbitrary values.

Quando uma cor representa uma decisão reutilizável do design system, use o token correspondente em vez de repetir um valor literal.

Use opacity modifiers somente quando a transparência fizer parte do estado visual esperado.

```html
<div class="bg-surface/80">
  ...
</div>
```

Se um valor não existe no theme e é realmente pontual, arbitrary values são aceitáveis.

## Background Images

Use background images quando a propriedade `background-image` é realmente parte da composição visual.

Para valores pontuais:

```html
<div class="bg-[url(/img/mountains.jpg)]">
  ...
</div>
```

Quando a imagem já existe como CSS variable, use a forma de custom property suportada:

```html
<div class="bg-(image:--hero-image)">
  ...
</div>
```

[DEFAULT] Para gradients, prefira as utilities específicas de gradient em vez de construir manualmente uma imagem arbitrária equivalente.

## Gradients

Tailwind oferece APIs específicas para linear, radial e conic gradients.

Exemplo linear:

```html
<div class="bg-linear-to-r from-indigo-500 via-purple-500 to-pink-500">
  ...
</div>
```

Gradient stops podem incluir posições explícitas quando a composição exigir:

```html
<div class="bg-linear-to-r from-indigo-500 from-10% to-emerald-500 to-90%">
  ...
</div>
```

[SITUATIONAL] Use ângulos, radial ou conic gradients quando eles fazem parte intencional do design.

[DEFAULT] Se cores ou outros valores de gradient se repetem como identidade visual, trate-os como tokens em vez de duplicar arbitrary values.

## Background Sizing and Positioning

[DEFAULT] Use `bg-cover` quando preencher toda a área for mais importante do que preservar toda a imagem.

Use `bg-contain` quando preservar a imagem inteira for mais importante.

Quando cropping causado por `bg-cover` importa, defina deliberadamente a posição do background.

```html
<div class="bg-[url(/img/mountains.jpg)] bg-cover bg-center">
  ...
</div>
```

Use custom background size ou position apenas quando as utilities padrão não representam o design necessário.

```html
<div class="bg-position-[center_top_1rem]">
  ...
</div>
```

Evite valores arbitrários repetidos; transforme valores recorrentes em tokens ou CSS variables.

## Background Repeat

Escolha repeat behavior pela natureza do asset.

Use `bg-no-repeat` quando a imagem representa uma composição única.

Use repeat variants quando o asset foi projetado para tile ou repetição em um eixo.

[HARD RULE] Não tente corrigir uma imagem inadequada para o layout apenas alterando repeat/size/position aleatoriamente.

## Background Attachment

[SITUATIONAL] Use `bg-fixed` somente quando o background realmente precisa permanecer fixo em relação ao viewport.

[HARD RULE] Não adote `bg-fixed` apenas como efeito decorativo sem considerar comportamento em dispositivos móveis e custo de rendering.

Use `bg-local` ou `bg-scroll` quando o background deve acompanhar o scroll container ou o comportamento normal da página.

## Background Clip

Use `bg-clip-*` quando a box usada para pintar o background fizer parte da intenção visual.

`bg-clip-text` pode ser usado para preencher texto com um background:

```html
<h1 class="bg-linear-to-r from-pink-500 to-violet-500 bg-clip-text text-transparent">
  Gradient heading
</h1>
```

[HARD RULE] Quando o texto contém informação essencial, preserve contraste e fallback adequados.

Não use text gradients de forma que a legibilidade dependa de um efeito frágil.

## Background Origin

[SITUATIONAL] Use `bg-origin-*` quando a origem da background image precisa ser explicitamente border-box, padding-box ou content-box.

Essa decisão é relevante principalmente quando borders e padding participam da composição da imagem.

## Background Blend

[SITUATIONAL] Use `bg-blend-*` quando múltiplas background layers ou background color precisam se combinar.

```html
<div class="bg-blue-500 bg-[url(/img/mountains.jpg)] bg-blend-multiply">
  ...
</div>
```

Não enumere ou escolha blend modes por tentativa; use o mode que corresponde ao efeito visual necessário.

Para blending do elemento com o conteúdo atrás dele, consulte `effects-filters-masks.md` para `mix-blend-*`.

## Border Strategy

[DEFAULT] Quando a cor da border faz parte do design, especifique-a explicitamente.

```html
<div class="border border-gray-200">
  ...
</div>
```

No setup atual, `border` define a largura; o Preflight fornece estilo sólido e a cor pode seguir `currentColor` quando não é sobrescrita.

[DEFAULT] Mantenha width, color e style semanticamente claros no markup quando mais de uma dessas decisões está sendo customizada.

Use side-specific borders somente quando o design realmente trata lados de forma diferente.

## Logical Borders

[DEFAULT] Em interfaces LTR/RTL ou writing-mode aware, prefira logical borders quando a intenção for start/end em vez de left/right.

Inline:

- `border-s-*`;
- `border-e-*`.

Block:

- `border-bs-*`;
- `border-be-*`.

Exemplo:

```html
<div class="border-s-4 border-indigo-500">
  ...
</div>
```

Isso acompanha inline-start conforme a direção da interface.

Use propriedades físicas quando top/right/bottom/left forem realmente parte do contrato visual.

## Border Radius

Use radius de forma consistente com o design system.

`rounded-full` é apropriado quando a intenção é uma pill ou shape circular e as dimensões permitem.

[SITUATIONAL] Use radius por lado ou corner quando o componente realmente possui uma geometria assimétrica.

[DEFAULT] Se um radius customizado se repete, registre-o como token `--radius-*`.

```html
<div class="rounded-(--card-radius)">
  ...
</div>
```

## Logical Border Radius

[DEFAULT] Para componentes direction-aware, prefira logical radius quando a intenção é start/end.

Formas relevantes incluem:

- `rounded-s-*`;
- `rounded-e-*`;
- `rounded-ss-*`;
- `rounded-se-*`;
- `rounded-es-*`;
- `rounded-ee-*`.

Exemplo:

```html
<div class="rounded-s-lg">
  ...
</div>
```

[HARD RULE] Não use corner físico apenas por hábito quando o componente precisa espelhar corretamente em RTL.

## Outlines and Focus

[HARD RULE] Não remova o outline de foco sem fornecer outro indicador de foco perceptível.

Evite:

```html
<button class="focus:outline-none">
  Save
</button>
```

sem uma estratégia alternativa de focus.

Prefira styling explícito quando o outline for usado como indicador:

```html
<button
  class="focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-blue-600"
>
  Save
</button>
```

### `outline-hidden` vs `outline-none`

`outline-hidden` é útil quando o outline padrão precisa ficar visualmente oculto, mas o comportamento apropriado em forced-colors deve ser preservado.

`outline-none` remove efetivamente o outline.

[HARD RULE] Não trate `outline-hidden` e `outline-none` como equivalentes.

Se qualquer um deles for usado no estado de foco, verifique se existe feedback perceptível apropriado.

Regras completas de focus pertencem às referências de accessibility.

## Table Borders

Use `border-collapse` quando as borders das cells devem colapsar.

Use `border-separate` quando cada cell precisa manter sua própria border box.

`border-spacing-*` depende de `border-separate`:

```html
<table class="border-separate border-spacing-2">
  ...
</table>
```

[SITUATIONAL] Controle spacing por eixo somente quando a tabela realmente exige valores diferentes horizontal e verticalmente.

## Arbitrary Values and Theme Tokens

[DEFAULT] Use arbitrary values somente para decisões pontuais.

Exemplo:

```html
<div class="rounded-[18px]">
  ...
</div>
```

Quando o mesmo valor se repete ou possui significado no design, mova-o para o theme.

Isso se aplica especialmente a:

- brand colors;
- surface colors;
- border colors;
- radius;
- background image tokens.

Quando um valor já existe como CSS variable, prefira a forma de custom property suportada pela utility.

## Responsibility Boundaries

Esta referência cobre decisões de:

- background color;
- background images;
- gradients;
- background size e position;
- background repeat;
- background attachment;
- background clip e origin;
- background blend mode;
- border width/color/style;
- logical borders;
- border radius;
- logical radius;
- outline;
- table border collapse/spacing.

Outras responsabilidades:

- shadows, rings, filters, masks e `mix-blend-*` → `effects-filters-masks.md`;
- `--color-*`, `--radius-*` e outros tokens → `theme-customization.md`;
- responsive e state variants → `responsive-variants.md`;
- focus behavior, forced colors e contraste → accessibility references.
