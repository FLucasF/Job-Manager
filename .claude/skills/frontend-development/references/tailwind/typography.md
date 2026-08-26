# Tailwind Typography

Referência de decisões, armadilhas e padrões para tipografia com Tailwind.

## Contents

- Typography strategy
- Theme tokens
- Font size and line height
- Font semantics
- Font features
- Numeric typography
- Text wrapping
- Truncation and line clamp
- Long words and identifiers
- Hyphenation
- White space and preformatted text
- Text decoration and transforms
- Lists and markers
- Generated content
- Arbitrary values and CSS variables
- Responsibility boundaries

## Typography Strategy

[DEFAULT] Use os tokens tipográficos do projeto antes de introduzir valores arbitrários.

Font family, font size, line height, weight, tracking e outras decisões recorrentes devem representar um sistema consistente, não valores isolados por componente.

[HARD RULE] Styling visual não substitui semântica HTML.

Exemplos:

- não use `font-bold` para substituir `<strong>` quando existe ênfase semântica;
- não use `italic` para substituir `<em>` quando existe ênfase semântica;
- não transforme visualmente o texto quando o valor real precisa mudar semanticamente.

## Theme Tokens

Famílias, escalas tipográficas e valores recorrentes devem ser configurados no theme quando representam decisões reutilizáveis.

Exemplo conceitual:

```css
@theme {
  --font-display: "Satoshi", sans-serif;
}
```

Depois:

```html
<h1 class="font-display">
  Heading
</h1>
```

Customização detalhada de tokens pertence a `theme-customization.md`.

## Font Size and Line Height

[DEFAULT] Trate font size e line height como uma decisão tipográfica conjunta quando eles formam um mesmo estilo de texto.

Tailwind permite expressar ambos em uma única utility:

```html
<p class="text-sm/6">
  Text
</p>
```

Use `leading-*` quando line height precisar variar independentemente do font size.

[HARD RULE] Não reduza line height apenas para “fazer o texto caber” quando isso prejudicar legibilidade ou causar clipping.

Valores tipográficos repetidos devem virar tokens em vez de arbitrary values duplicados.

## Font Semantics

[HARD RULE] Não use typography utilities para simular significado semântico ausente no HTML.

Exemplos:

```html
<strong class="font-semibold">Important</strong>
<em class="italic">Emphasis</em>
```

A classe controla apresentação; o elemento HTML comunica significado.

O mesmo princípio vale para:

- headings;
- links;
- labels;
- abbreviations;
- quotations;
- code;
- lists.

## Font Smoothing

[SITUATIONAL] Use font smoothing somente quando houver uma decisão visual clara.

Não aplique `antialiased` ou `subpixel-antialiased` por obrigação: o resultado varia conforme plataforma e rendering engine.

## Font Stretch and Variable Fonts

[SITUATIONAL] Use `font-stretch-*` somente quando a fonte realmente oferecer faces ou axes de largura compatíveis.

Não introduza stretch como substituto para escolher a fonte ou variante correta do design system.

Para valores recorrentes de variable fonts, prefira tokens ou CSS variables em vez de repetir arbitrary values.

## Numeric Typography

Use variants numéricas quando o alinhamento ou a forma dos números fizer parte do design.

[DEFAULT] Use `tabular-nums` quando valores precisam manter largura estável.

Casos típicos:

- tabelas;
- valores financeiros;
- timers;
- counters;
- métricas.

```html
<span class="tabular-nums">
  $1,250.00
</span>
```

Outras variants numéricas, como slashed zero ou fractions, devem ser usadas somente quando a fonte suporta o recurso e o conteúdo realmente se beneficia dele.

## OpenType Features

[SITUATIONAL] Use `font-features-*` quando uma feature OpenType específica fizer parte do design e não existir uma utility semântica mais adequada.

```html
<p class="font-features-['smcp']">
  Small caps
</p>
```

[DEFAULT] Para números, prefira as utilities de `font-variant-numeric` quando elas já representam o caso.

Não use OpenType features apenas porque estão disponíveis.

## Text Wrapping

[DEFAULT] Preserve wrapping natural para body text salvo quando o design exigir comportamento diferente.

Use `text-balance` principalmente em blocos curtos, como headings, quando uma distribuição mais equilibrada entre linhas melhora a composição.

```html
<h1 class="text-balance">
  A heading that can wrap across multiple lines
</h1>
```

Use `text-pretty` quando melhorar as quebras de linha de body copy fizer sentido.

[SITUATIONAL] Recursos modernos como `text-balance` e `text-pretty` devem ser usados considerando os browsers-alvo.

[HARD RULE] Não introduza JavaScript somente para reproduzir um comportamento tipográfico que CSS já resolve adequadamente.

## Truncation and Line Clamp

Use `truncate` quando o contrato visual exige uma única linha com ellipsis.

Antes de truncar, confirme que o container permite o comportamento de sizing necessário; em flex/grid, isso pode exigir `min-w-0` na referência de spacing/sizing.

[HARD RULE] Não use truncation para esconder conteúdo essencial sem uma forma adequada de acesso ao valor completo.

Use `line-clamp-*` quando truncamento multilinha fizer parte intencional do componente.

```html
<p class="line-clamp-3">
  Long description...
</p>
```

[HARD RULE] Não use line clamp para esconder conteúdo que o usuário precisa ler sem oferecer uma forma de expansão ou acesso completo.

## Long Words and Identifiers

Quando overflow for causado especificamente por URLs, identifiers ou strings sem pontos naturais de quebra, resolva o problema no texto antes de criar hacks de layout.

[DEFAULT] Use `wrap-break-word` quando palavras longas só devem quebrar quando necessário.

Use `wrap-anywhere` quando qualquer ponto puder ser considerado uma oportunidade válida de quebra.

```html
<p class="wrap-anywhere">
  VeryLongIdentifierWithoutNaturalBreakpoints
</p>
```

[SITUATIONAL] Use `break-all` apenas quando quebrar em qualquer caractere for realmente aceitável.

[HARD RULE] Não use `break-all` como solução padrão para body text.

## Hyphenation

[SITUATIONAL] Use hyphenation quando a língua e o design justificarem o comportamento.

Quando usar `hyphens-auto`, defina corretamente `lang` no conteúdo ou ancestor relevante.

```html
<p lang="pt" class="hyphens-auto">
  Texto longo...
</p>
```

[HARD RULE] Não dependa de hifenização automática sem idioma correto, pois os pontos de quebra dependem da língua.

## White Space and Preformatted Text

Escolha white-space behavior de acordo com o conteúdo:

- preservar spaces;
- preservar newlines;
- permitir wrapping;
- impedir wrapping.

Para conteúdo pré-formatado que ainda precisa quebrar linhas, `whitespace-pre-wrap` costuma representar melhor a intenção que uma combinação artificial de sizing/overflow.

```html
<pre class="whitespace-pre-wrap">
  Preserved text that can wrap
</pre>
```

[SITUATIONAL] Use `tab-*` principalmente em conteúdo pré-formatado ou code blocks quando a largura visual de tabs fizer parte da apresentação.

## Text Decoration and Links

Use decoration utilities para apresentação, não para criar semântica de link ou estado interativo.

[HARD RULE] Um elemento visualmente sublinhado não se torna um link; semântica e interação pertencem ao HTML/componente.

Quando a decoração fizer parte do design, ajuste estilo, espessura e offset de forma consistente com o sistema visual.

[DEFAULT] Prefira `decoration-from-font` quando a própria fonte deve controlar uma espessura de underline adequada.

## Text Transform

Use `uppercase`, `lowercase` ou `capitalize` apenas para transformação visual.

[HARD RULE] Não use text transform quando o valor real precisa ser normalizado, persistido ou enviado ao backend em outro formato.

Styling:

```html
<span class="uppercase">
  status
</span>
```

não altera o valor semântico do conteúdo.

## Lists and Markers

[HARD RULE] Não remova a semântica de uma lista apenas porque o design não precisa de markers visíveis.

`list-none` remove a apresentação dos markers; a estrutura `<ul>`/`<ol>` continua relevante quando o conteúdo é semanticamente uma lista.

[SITUATIONAL] Use custom marker images somente quando não prejudicarem legibilidade, contraste ou acessibilidade.

## Generated Content

Use `content-*` com `before:` e `after:` somente para conteúdo decorativo ou suplementar.

Exemplo:

```html
<a href="#" class="after:content-['_↗']">
  External link
</a>
```

[HARD RULE] Não use generated content para informação essencial que precisa existir semanticamente no DOM ou ser exposta de forma confiável a tecnologias assistivas.

Quando o conteúdo pertence aos dados reais da interface, renderize-o no markup.

## Arbitrary Values and CSS Variables

[DEFAULT] Use arbitrary values para exceções tipográficas pontuais, não como substituto da escala do projeto.

Exemplos possíveis:

```html
<p class="leading-[1.65]"></p>
<p class="tracking-[0.12em]"></p>
```

Se o valor se repete ou possui significado no design system, mova-o para o theme.

Quando um valor já existe em CSS custom property, prefira a forma curta suportada pela utility:

```html
<p class="leading-(--body-leading)"></p>
```

Evite repetir o mesmo arbitrary value em múltiplos componentes.

## Responsibility Boundaries

Esta referência cobre decisões de:

- font family;
- font size e line height;
- font weight/style;
- font smoothing/stretch;
- numeric variants;
- OpenType features;
- letter spacing;
- wrapping;
- truncation;
- line clamp;
- word breaking;
- hyphenation;
- white space;
- text decoration;
- text transform;
- lists;
- generated content;
- arbitrary typography values.

Outras responsabilidades:

- configuração de font, text, tracking e leading tokens → `theme-customization.md`;
- breakpoints e state variants → `responsive-variants.md`;
- text shadows → `effects-filters-masks.md`;
- width/min-width necessários para truncation → `spacing-sizing.md`;
- semântica, accessible names, readability e requisitos de tecnologias assistivas → accessibility references.
