# Tailwind Theme and Customization

Referência de decisões e sintaxe para theme variables, design tokens e customização CSS-first com Tailwind.

## Contents

- CSS-first configuration
- Theme variables and namespaces
- Theme vs ordinary CSS variables
- Extend, override and replace
- `@theme inline` and `static`
- Prefix and important
- Custom and functional utilities
- Custom variants and `@variant`
- Shared themes
- Legacy configuration
- Responsibility boundaries

## CSS-First Configuration

[DEFAULT] Para código novo, use a configuração CSS-first:

```css
@import "tailwindcss";
```

[HARD RULE] Não introduza configuração JavaScript ou APIs legadas quando `@theme`, CSS variables, `@utility`, `@custom-variant` ou `@variant` resolvem o problema.

## Theme Variables

[HARD RULE] Use `@theme` para design tokens que devem participar da API do Tailwind.

```css
@theme {
  --font-display: "Satoshi", sans-serif;
  --breakpoint-3xl: 120rem;
  --color-brand-500: oklch(0.72 0.11 178);
}
```

Esses tokens disponibilizam APIs correspondentes como `font-display`, `3xl:*` e `text-brand-500`.

[DEFAULT] Crie theme variables somente para decisões reutilizáveis do design system, não para valores pontuais.

## Theme Variable Namespaces

O namespace determina quais utilities ou variants o token gera.

```text
--color-*          → color utilities
--font-*           → font-family
--text-*           → font-size
--font-weight-*    → font-weight
--tracking-*       → letter-spacing
--leading-*        → line-height
--breakpoint-*     → responsive variants
--container-*      → container queries/sizing
--spacing-*        → spacing/sizing
--radius-*         → border radius
--aspect-*         → aspect ratio
--shadow-*         → box shadow
--inset-shadow-*   → inset shadow
--drop-shadow-*    → drop shadow
--blur-*           → blur
--ease-*           → easing
--animate-*        → animation
--perspective-*    → perspective
--zoom-*           → zoom
```

[HARD RULE] Use o namespace que corresponde ao papel semântico do token.

## Theme vs Ordinary CSS Variables

Use `@theme` quando a variável deve criar ou modificar APIs do Tailwind.

Use `:root` ou outro scope CSS normal quando a custom property pertence apenas à aplicação.

```css
@theme {
  --color-brand-500: oklch(0.62 0.18 250);
}

:root {
  --sidebar-width: 18rem;
}
```

[DEFAULT] Nem toda CSS variable deve virar theme token.

## Extend, Override and Replace

Adicionar novos tokens estende o theme:

```css
@theme {
  --font-script: "Great Vibes", cursive;
  --color-brand-500: oklch(0.62 0.18 250);
}
```

Redefinir um token altera seu contrato global:

```css
@theme {
  --breakpoint-sm: 30rem;
}
```

[HARD RULE] Não sobrescreva um token global para resolver um caso local.

[SITUATIONAL] Para substituir um namespace inteiro:

```css
@theme {
  --color-*: initial;
  --color-white: #fff;
  --color-brand: #243c5a;
  --color-surface: #f8fafc;
}
```

[SITUATIONAL] Para substituir todo o theme:

```css
@theme {
  --*: initial;
  --spacing: 0.25rem;
  --font-body: Inter, sans-serif;
  --color-brand: oklch(0.62 0.18 250);
}
```

[HARD RULE] Use `initial` somente quando o projeto realmente deseja assumir controle daquele namespace ou de todo o design system.

## Theme Variables in Custom CSS

[HARD RULE] Theme variables são CSS variables normais no CSS gerado.

```css
.card {
  color: var(--color-gray-900);
  border-radius: var(--radius-lg);
}
```

Não use `theme()` em código novo quando `var(--token)` resolve o acesso.

Quando uma utility aceita custom property diretamente, prefira a forma curta:

```html
<div class="bg-(--brand-background)"></div>
```

em vez de `bg-[var(--brand-background)]`.

## `@theme inline`

[SITUATIONAL] Use `@theme inline` quando um theme variable referencia outra CSS variable e o valor precisa ser incorporado corretamente na utility gerada.

```css
@theme inline {
  --font-sans: var(--font-inter);
}
```

Não use `inline` por padrão.

## `@theme static`

[SITUATIONAL] Use `@theme static` quando tokens precisam existir no CSS final mesmo sem utilities correspondentes detectadas no markup.

```css
@theme static {
  --color-primary: var(--color-blue-500);
  --color-secondary: var(--color-slate-700);
}
```

Útil principalmente para design systems ou consumidores externos de CSS variables.

## Prefix

[SITUATIONAL] Use `prefix()` somente quando Tailwind precisa evitar colisões com CSS existente.

```css
@import "tailwindcss" prefix(tw);
```

```html
<div class="tw:flex tw:bg-red-500 tw:hover:bg-red-600"></div>
```

Theme variables continuam sendo declaradas normalmente; o Tailwind aplica o prefixo à API gerada.

## Important

[SITUATIONAL] Para uma utility específica:

```html
<div class="bg-red-500!"></div>
```

Use somente diante de conflito real de especificidade.

[SITUATIONAL] Para integração com CSS legado de alta especificidade:

```css
@import "tailwindcss" important;
```

[HARD RULE] Não use important, local ou global, como estratégia padrão. Verifique cascade, specificity e ownership do CSS conflitante primeiro.

## Custom Utilities

[DEFAULT] Use `@utility` quando existe uma abstração reutilizável que merece participar da API do projeto.

```css
@utility content-auto {
  content-visibility: auto;
}
```

Custom utilities funcionam com variants normalmente.

[HARD RULE] Não crie custom utility quando uma utility nativa ou arbitrary value pontual já expressa a regra claramente.

[SITUATIONAL] Nesting é aceitável quando a utility realmente precisa de selectors relacionados.

```css
@utility scrollbar-hidden {
  &::-webkit-scrollbar {
    display: none;
  }
}
```

## Functional Utilities

[SITUATIONAL] Use functional utilities quando existe uma família reutilizável de utilities parametrizadas.

```css
@utility tab-* {
  tab-size: --value(integer);
}
```

Também podem resolver tokens:

```css
@theme {
  --tab-size-github: 8;
}

@utility tab-* {
  tab-size: --value(--tab-size-*, integer, [integer]);
}
```

[HARD RULE] Não crie functional utilities para substituir arbitrary values de uso único.

## Custom Variants

[DEFAULT] Use `@custom-variant` quando uma condição reutilizável não é coberta pelas variants existentes.

```css
@custom-variant theme-midnight (&:where([data-theme="midnight"] *));
```

```html
<button class="theme-midnight:bg-black">Save</button>
```

Para condições complexas, use bloco e `@slot`:

```css
@custom-variant any-hover {
  @media (any-hover: hover) {
    &:hover {
      @slot;
    }
  }
}
```

[HARD RULE] Não registre uma custom variant para um selector pontual que uma arbitrary variant simples resolve.

## `@variant`

[SITUATIONAL] Use `@variant` quando custom CSS precisa reutilizar uma variant do Tailwind.

```css
.card {
  background: white;

  @variant dark {
    background: black;
  }
}
```

[DEFAULT] Não mova styling comum para custom CSS apenas para usar `@variant`; prefira utilities quando elas já representam o caso.

## Shared Themes

[SITUATIONAL] Tokens compartilhados podem viver em um arquivo CSS próprio:

```css
/* packages/brand/theme.css */
@theme {
  --color-brand-500: oklch(0.62 0.18 250);
  --font-brand: Inter, sans-serif;
}
```

```css
@import "tailwindcss";
@import "../brand/theme.css";
```

[HARD RULE] Compartilhe somente tokens realmente comuns; decisões específicas de uma feature não pertencem ao theme compartilhado.

## Avoid Legacy Configuration

[HARD RULE] Para código novo, prefira:

```text
@theme
@utility
@custom-variant
@variant
CSS variables
```

Evite `tailwind.config.js`, plugins customizados ou `theme()` quando a API CSS atual já resolve o problema.

Use caminhos legados somente quando uma dependência concreta exigir isso.

## Responsibility Boundaries

Esta referência cobre:

- theme variables e namespaces;
- design tokens;
- extend/override/replace;
- `@theme inline` e `static`;
- prefix e important;
- custom/functional utilities;
- custom variants e `@variant`;
- shared themes.

Outras responsabilidades:

- uso de responsive/state/arbitrary variants → `responsive-variants.md`;
- consumo de tokens de spacing/sizing → `spacing-sizing.md`;
- consumo de tokens tipográficos → `typography.md`;
- backgrounds/borders → `backgrounds-borders.md`;
- effects → `effects-filters-masks.md`;
- animation/easing/perspective → `transforms-transitions.md`;
- instalação/build tools → `tooling-integrations.md`.
