# Tailwind Effects, Filters and Masks

Referência de decisões, armadilhas e padrões para shadows, rings, filters, blend modes e masks com Tailwind.

## Contents

- Effects strategy
- Box and inset shadows
- Rings
- Text shadow
- Drop shadow
- Blend modes
- Filters
- Backdrop filters
- Masks
- Gradient masks
- Mask composition
- Arbitrary values and theme tokens
- Responsibility boundaries

## Effects Strategy

[DEFAULT] Prefira utilities nativas do Tailwind quando elas já representam diretamente o efeito desejado.

Isso inclui principalmente:

- shadows;
- rings;
- filters;
- backdrop filters;
- masks.

Use arbitrary values ou CSS customizado somente quando o efeito realmente exige algo que o theme ou as utilities existentes não representam.

[HARD RULE] Não adicione efeitos apenas por disponibilidade da API. O efeito deve ter uma função visual clara.

## Box and Inset Shadows

Use `shadow-*` para sombras associadas à box do elemento.

Use `inset-shadow-*` quando a sombra precisa ser interna.

[DEFAULT] Se a sombra faz parte do design system, use o token correspondente em vez de repetir valores arbitrários.

Exemplo com CSS variable:

```html
<div class="shadow-(--card-shadow)">
  ...
</div>
```

Use cor e opacity da sombra deliberadamente quando elas fazem parte da linguagem visual do componente.

[HARD RULE] Não use múltiplas sombras ou intensidades arbitrárias para compensar falta de hierarchy visual no layout.

## Rings

Use `ring-*` quando precisar de um contorno visual baseado em box-shadow.

Rings podem ser externos ou inset.

Use `ring-offset-*` quando houver necessidade de separar visualmente o ring da superfície do elemento.

```html
<button class="ring-2 ring-blue-500 ring-offset-2">
  Save
</button>
```

[HARD RULE] Não assuma que um ring visual resolve sozinho todos os requisitos de focus.

Quando o ring for usado para feedback de foco, valide:

- visibilidade;
- contraste;
- `focus-visible`;
- forced colors;
- comportamento de teclado.

Regras completas de focus pertencem às referências de accessibility.

## Text Shadow

[SITUATIONAL] Use `text-shadow-*` quando a sombra realmente melhora o tratamento visual do texto.

```html
<h1 class="text-shadow-sm">
  Heading
</h1>
```

[HARD RULE] Não dependa de text shadow para tornar texto legível sobre um background inadequado.

Contraste e escolha de background continuam sendo a solução principal.

Se uma text shadow é parte recorrente da identidade visual, trate-a como token em vez de repetir arbitrary values.

## Drop Shadow

Use `drop-shadow-*` quando a sombra deve seguir a forma renderizada do conteúdo.

Casos típicos:

- SVG;
- imagens com transparência;
- elementos com forma não retangular.

```html
<svg class="drop-shadow-md">
  ...
</svg>
```

[DEFAULT] Para caixas retangulares comuns, prefira `shadow-*`.

Essa distinção evita escolher `drop-shadow-*` quando o comportamento esperado é simplesmente box shadow.

## Blend Modes

[SITUATIONAL] Use `mix-blend-*` quando o próprio elemento deve se misturar com o conteúdo atrás dele.

Use `bg-blend-*` para blending entre background layers; isso pertence a `backgrounds-borders.md`.

```html
<div class="mix-blend-multiply">
  ...
</div>
```

[HARD RULE] Não escolha blend modes por tentativa aleatória.

Use-os somente quando a composição visual exige explicitamente esse comportamento.

Considere também contraste e legibilidade quando texto ou conteúdo interativo participa do blending.

## Filters

Filters podem ser combinados quando o tratamento visual exige mais de uma transformação.

Exemplo:

```html
<img class="blur-xs grayscale" src="/img/mountains.jpg" alt="" />
```

[DEFAULT] Use filter utilities específicas antes de recorrer a `filter-[...]`.

[SITUATIONAL] Use custom filters somente quando a API padrão não representar o efeito necessário.

```html
<img
  class="filter-[url('filters.svg#filter-id')]"
  src="/img/mountains.jpg"
  alt=""
/>
```

[HARD RULE] Não aplique filtros que alteram percepção de conteúdo essencial sem validar legibilidade e significado visual.

## Filter Performance

[SITUATIONAL] Blur, complex filters e combinações extensas podem aumentar custo de rendering.

Evite aplicar efeitos pesados em:

- grandes áreas;
- elementos em movimento;
- listas numerosas;
- superfícies que atualizam frequentemente.

[DEFAULT] Prefira o efeito visual mais simples que atende ao design.

Se houver animação do efeito, consulte também `transforms-transitions.md`.

## Backdrop Filters

Backdrop filters afetam o conteúdo que está atrás do elemento, não o próprio elemento.

Padrão comum:

```html
<div class="bg-white/30 backdrop-blur-sm">
  ...
</div>
```

[SITUATIONAL] Use backdrop filters para efeitos como glass surfaces somente quando o efeito é realmente necessário.

[HARD RULE] Não dependa de backdrop blur para criar contraste suficiente entre foreground e background.

A superfície deve continuar legível quando:

- o conteúdo atrás varia;
- blur é reduzido;
- a plataforma renderiza o efeito de forma diferente.

Backdrop filters também podem ter custo significativo de rendering em grandes superfícies ou durante movimento.

## Masks

Use masks quando a visibilidade de um elemento precisa ser controlada por uma imagem ou gradient.

Exemplo com imagem:

```html
<div class="mask-[url(/img/circle.png)] mask-center mask-no-repeat">
  ...
</div>
```

Escolha position, size, repeat e origin conforme a geometria real da mask.

[DEFAULT] Não replique toda a lógica de background por hábito; configure somente as propriedades da mask que o efeito precisa.

Use `mask-cover` ou `mask-contain` quando a mesma distinção de preenchimento/preservação fizer sentido para a mask.

## Gradient Masks

[SITUATIONAL] Use linear, radial ou conic gradient masks quando uma transição de visibilidade faz parte intencional do efeito.

Exemplo:

```html
<div class="mask-linear-[70deg,transparent_10%,black,transparent_80%]">
  ...
</div>
```

Gradient masks são apropriadas para:

- fades;
- reveal effects;
- edge fading;
- decorative clipping progressivo.

[HARD RULE] Não use masks para esconder conteúdo que precisa continuar disponível semanticamente ou interativamente.

Masks controlam renderização visual; não substituem regras de visibilidade, estado ou acessibilidade.

## Mask Composition

[SITUATIONAL] Use mask composition somente quando múltiplas masks realmente precisam ser combinadas.

Operações como add, subtract e intersect representam relações geométricas entre masks.

[DEFAULT] Se uma única mask consegue expressar o efeito, prefira a solução mais simples.

Evite composições complexas apenas para reproduzir um shape que poderia ser fornecido diretamente como asset ou gradient.

## Arbitrary Values and Theme Tokens

[DEFAULT] Use arbitrary values para efeitos pontuais.

Exemplo:

```html
<div class="shadow-[0_20px_40px_rgb(0_0_0_/_0.2)]">
  ...
</div>
```

Se o valor se repete ou representa linguagem visual do projeto, mova-o para o theme ou CSS variable.

Isso se aplica especialmente a:

- shadows;
- inset shadows;
- text shadows;
- blur;
- filters;
- mask configuration.

Quando o valor já existe como CSS variable, prefira a forma curta suportada pela utility.

```html
<div class="shadow-(--card-shadow)">
  ...
</div>
```

## Responsibility Boundaries

Esta referência cobre decisões de:

- box shadows;
- inset shadows;
- rings;
- text shadows;
- drop shadows;
- `mix-blend-*`;
- filters;
- backdrop filters;
- masks;
- gradient masks;
- mask composition.

Outras responsabilidades:

- backgrounds, borders, outlines e `bg-blend-*` → `backgrounds-borders.md`;
- tokens de shadows, blur e outros efeitos → `theme-customization.md`;
- responsive e state variants → `responsive-variants.md`;
- transforms, transitions e animação de efeitos → `transforms-transitions.md`;
- focus, contraste e requisitos perceptivos → accessibility references.
