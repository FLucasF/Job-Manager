# Tailwind Spacing and Sizing

Referência de decisões, armadilhas e padrões para spacing e sizing com Tailwind.

## Contents

- Spacing strategy
- Logical spacing
- Negative and auto margins
- Gap vs space between
- Sizing strategy
- Intrinsic sizing
- Flex and grid minimum sizes
- Viewport sizing
- Physical vs logical sizing
- Equal dimensions
- Aspect ratio
- Arbitrary values and tokens
- Responsibility boundaries

## Spacing Strategy

[DEFAULT] Use a escala de spacing do projeto antes de introduzir valores arbitrários.

Use padding quando o espaço pertence ao interior do componente.

Use margin quando o espaço pertence à relação externa entre elementos e não é responsabilidade do layout parent.

[DEFAULT] Para spacing estrutural entre items de flex ou grid, prefira `gap-*`.

[HARD RULE] Não use margin negativa para esconder um problema estrutural de layout.

Negative margins são apropriadas quando overlap ou deslocamento faz parte intencional da composição visual.

## Logical Spacing

[DEFAULT] Em interfaces direction-aware, prefira logical spacing quando a intenção for start/end em vez de left/right.

Inline:

- `ms-*` / `me-*`;
- `ps-*` / `pe-*`.

Block:

- `mbs-*` / `mbe-*`;
- `pbs-*` / `pbe-*`.

Exemplo:

```html
<div dir="rtl" class="ps-4 pe-8">
  ...
</div>
```

Isso evita branches específicos de LTR/RTL quando a relação espacial é lógica.

Use propriedades físicas quando left/right/top/bottom forem realmente parte do contrato visual.

## Auto and Negative Margins

Use auto margin quando ela representa um comportamento real do layout, como centralização ou ocupação do espaço restante.

```html
<main class="mx-auto max-w-4xl">
  ...
</main>
```

Em layouts direction-aware, prefira formas lógicas quando apropriado:

```html
<div class="ms-auto">
  ...
</div>
```

[SITUATIONAL] Use negative margins somente quando overlap ou offset é intencional.

```html
<div class="-mt-4">
  ...
</div>
```

[HARD RULE] Não use negative margin como compensação permanente para estrutura ou sizing incorretos.

## Gap vs Space Between

[DEFAULT] Use `gap-*` para spacing estrutural entre flex/grid items.

Use `space-x-*` ou `space-y-*` quando a intenção for especificamente aplicar spacing entre children através de margins.

`space-*` pode ser menos adequado quando houver:

- wrapping;
- grid;
- visual reordering;
- children dinâmicos.

Quando o problema é estrutura do layout, consulte `layout.md`.

## Sizing Strategy

[DEFAULT] Prefira constraints a hard sizes quando o conteúdo precisa permanecer fluido.

Padrões comuns:

- `w-full` + `max-w-*`;
- `min-h-*` em vez de `h-*` rígido;
- min/max constraints;
- intrinsic sizing;
- content-driven sizing.

Exemplo:

```html
<main class="mx-auto w-full max-w-4xl px-4">
  ...
</main>
```

[HARD RULE] Evite fixed heights sem necessidade.

Alturas rígidas podem quebrar com:

- conteúdo dinâmico;
- traduções;
- texto maior;
- mensagens de validação;
- responsive wrapping;
- zoom do usuário.

Quando uma região precisa limitar crescimento, considere `max-h-*` combinado com overflow intencional em vez de uma altura arbitrária.

## Intrinsic Sizing

Use intrinsic sizing quando o conteúdo deve participar diretamente da decisão de tamanho.

As formas relevantes incluem:

- `*-min` → `min-content`;
- `*-max` → `max-content`;
- `*-fit` → `fit-content`.

Exemplo:

```html
<div class="w-fit">
  ...
</div>
```

Não substitua intrinsic sizing por valores arbitrários apenas para obter um resultado semelhante em um conteúdo específico.

## Flex and Grid Minimum Sizes

[HARD RULE] Quando um flex/grid item com conteúdo longo não consegue encolher como esperado, verifique o intrinsic minimum size antes de esconder overflow.

Para o eixo inline, `min-w-0` é frequentemente necessário:

```html
<div class="flex gap-3">
  <img class="size-10 shrink-0" src="/img/avatar.jpg" alt="" />

  <div class="min-w-0">
    <p class="truncate">
      Very long account name...
    </p>
  </div>
</div>
```

Esse padrão é especialmente relevante para:

- truncation;
- long text;
- nested flex items;
- grid children;
- overflow handling.

[HARD RULE] Não use `overflow-hidden` como primeiro conserto quando o problema real é intrinsic min-width.

Para nested flex layouts com scrolling interno, `min-h-0` pode ser necessário para permitir que um child encolha no eixo de bloco:

```html
<div class="flex min-h-0 flex-1 flex-col">
  <div class="min-h-0 flex-1 overflow-y-auto">
    ...
  </div>
</div>
```

Não introduza alturas arbitrárias para contornar esse comportamento.

## Viewport Sizing

[DEFAULT] Use viewport units deliberadamente em interfaces fullscreen, especialmente em mobile.

`dvh`/`dvw` acompanham a viewport dinâmica.

`svh`/`svw` representam a menor viewport.

`lvh`/`lvw` representam a maior viewport.

Para um shell mobile que deve acompanhar a área visível:

```html
<main class="min-h-dvh">
  ...
</main>
```

[HARD RULE] Não use `h-screen` automaticamente para layouts mobile sem considerar a UI dinâmica do browser.

Escolha `sv*`, `lv*` ou `dv*` de acordo com o comportamento que a interface realmente precisa.

## Physical vs Logical Sizing

[DEFAULT] Use physical sizing quando width/height físicos fazem parte do contrato:

- `w-*`;
- `h-*`;
- `min-w-*` / `max-w-*`;
- `min-h-*` / `max-h-*`.

Use logical sizing quando o tamanho deve acompanhar writing mode:

- `inline-*`;
- `min-inline-*` / `max-inline-*`;
- `block-*`;
- `min-block-*` / `max-block-*`.

Exemplo:

```html
<div class="inline-full max-inline-3xl">
  ...
</div>
```

[HARD RULE] Não converta toda a aplicação para logical sizing por regra absoluta. A escolha deve representar a semântica espacial do componente.

## Equal Dimensions

[DEFAULT] Use `size-*` quando width e height representam o mesmo contrato.

```html
<img class="size-10 rounded-full" src="/img/avatar.jpg" alt="" />
```

Isso comunica melhor a intenção que repetir `w-*` e `h-*`.

Não use `size-*` quando as duas dimensões precisam evoluir independentemente.

## Aspect Ratio

Use `aspect-*` quando a proporção faz parte do contrato do componente, especialmente para mídia e placeholders.

```html
<img
  class="aspect-3/2 object-cover"
  src="/img/photo.jpg"
  alt=""
/>
```

Use `aspect-square` ou `aspect-video` quando esses contratos correspondem à intenção.

[SITUATIONAL] Use arbitrary aspect ratios para proporções realmente pontuais.

Se a proporção se repete como parte do design system, mova-a para um token `--aspect-*`.

## Spacing Scale vs Container Scale

Sizing pode usar tanto valores derivados da escala de spacing quanto tokens de container.

Conceitualmente:

```text
w-64
→ spacing scale

w-md
→ container scale
```

[DEFAULT] Use container values quando a dimensão representa uma constraint de conteúdo ou container.

Use spacing values quando a dimensão participa da escala geral de spacing/sizing.

Customização dessas escalas pertence a `theme-customization.md`.

## Arbitrary Values and CSS Variables

[DEFAULT] Use arbitrary values para exceções pontuais, não como substituto do design system.

```html
<div class="max-w-[72ch]"></div>
```

Se o valor se repete ou possui significado semântico no projeto, transforme-o em token.

Quando o valor já existe em uma CSS custom property, prefira a forma de custom property suportada pela utility:

```html
<div class="w-(--sidebar-width)"></div>
```

Evite repetir o mesmo arbitrary value em múltiplos componentes.

## Responsibility Boundaries

Esta referência cobre decisões de:

- margin e padding;
- logical spacing;
- auto e negative margins;
- `space-*`;
- width e height;
- min/max sizing;
- intrinsic sizing;
- viewport sizing;
- logical sizing;
- `size-*`;
- aspect ratio;
- sizing em flex/grid;
- uso de spacing/container scales.

Outras responsabilidades:

- flex, grid, gap, positioning, alignment e overflow → `layout.md`;
- breakpoints e container queries → `responsive-variants.md`;
- `--spacing`, `--container-*`, `--aspect-*` e outros tokens → `theme-customization.md`;
- font size e line-height → `typography.md`;
- requisitos relacionados a zoom, clipping e leitura → accessibility references.
