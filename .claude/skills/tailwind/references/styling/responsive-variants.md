# Tailwind Responsive and Variants

Referência de decisões, armadilhas e padrões para responsividade, state variants, media queries, attribute selectors e custom variants com Tailwind.

## Contents

- Variant strategy
- Mobile-first responsive design
- Breakpoint ranges
- Arbitrary and custom breakpoints
- Container queries
- Named and size containers
- Interaction and form states
- Structural selectors
- `has-*`
- Parent state with `group`
- Sibling state with `peer`
- Implicit ancestor state with `in-*`
- Pseudo-elements
- Dark mode
- Motion, contrast and forced colors
- Pointer and environment variants
- `supports-*` and `starting:`
- ARIA and data variants
- Direction and open state
- Child and descendant variants
- Arbitrary and custom variants
- Variant composition
- Responsibility boundaries

## Variant Strategy

[HARD RULE] Use variants para aplicar uma utility quando uma condição real é verdadeira.

A utility base e a mudança condicional devem permanecer explícitas:

```html
<button class="bg-sky-500 hover:bg-sky-700">
  Save
</button>
```

[DEFAULT] Quando CSS, HTML ou atributos da plataforma já expõem o estado, prefira variants a duplicar classes via branches de template ou estado JavaScript.

Estados típicos:

- hover;
- focus;
- checked;
- disabled;
- invalid;
- open;
- ARIA attributes;
- data attributes.

[HARD RULE] Não invente estado apenas para facilitar styling.

Evite:

- ARIA falso;
- disabled falso;
- data attributes desconectados do estado real do componente.

Styling deve observar o contrato real da interface.

## Mobile-First Responsive Design

[HARD RULE] Tailwind é mobile-first.

Classes sem breakpoint representam o baseline menor.

```html
<img class="w-16 md:w-32 lg:w-48" src="/img/photo.jpg" alt="" />
```

Conceitualmente:

```text
base → menor viewport
md   → md e maiores
lg   → lg e maiores
```

[HARD RULE] Não trate `sm:` como “mobile”.

Use o estilo sem prefixo para o baseline e adicione mudanças conforme o espaço aumenta.

[DEFAULT] Não empilhe breakpoints quando a estratégia mobile-first permite expressar o mesmo layout de forma mais simples.

## Breakpoint Ranges

Use `max-*` quando uma regra realmente deve valer abaixo de determinado breakpoint.

Use um mínimo combinado com `max-*` quando a regra pertence somente a uma faixa.

```html
<div class="md:max-lg:flex">
  ...
</div>
```

Conceitualmente:

```text
md <= viewport < lg
```

[DEFAULT] Use ranges apenas quando o comportamento realmente pertence a um intervalo.

Não use ranges para reconstruir uma estratégia desktop-first desnecessariamente.

## Arbitrary and Custom Breakpoints

[SITUATIONAL] Use `min-[...]` ou `max-[...]` para breakpoints pontuais que não justificam um token reutilizável.

```html
<div class="min-[475px]:grid">
  ...
</div>
```

[DEFAULT] Se o mesmo breakpoint se repete ou representa uma regra de design, transforme-o em `--breakpoint-*` no theme.

Ao estender a escala existente, mantenha unidades consistentes.

Customização detalhada de breakpoints pertence a `theme-customization.md`.

## Container Queries

[DEFAULT] Use container queries quando um componente deve responder ao espaço disponível no próprio container, não à largura total da página.

```html
<div class="@container">
  <div class="flex flex-col @md:flex-row">
    ...
  </div>
</div>
```

A distinção é:

```text
viewport breakpoint
→ responde à página/viewport

container query
→ responde ao espaço do componente
```

Container queries também seguem abordagem mobile-first.

[DEFAULT] Para componentes reutilizáveis que podem aparecer em contextos diferentes, considere container queries antes de amarrar o comportamento ao viewport.

## Container Query Ranges

Use `@max-*` quando uma regra deve existir abaixo de um container size.

Combine mínimo e máximo quando a regra pertence apenas a uma faixa:

```html
<div class="@container">
  <div class="@sm:@max-md:flex-col">
    ...
  </div>
</div>
```

Não crie ranges complexos se uma progressão mobile-first simples representar melhor o comportamento.

## Named and Size Containers

[SITUATIONAL] Nomeie containers quando existem containers aninhados e o nearest container não representa o boundary desejado.

```html
<div class="@container/main">
  <div class="@sm/main:flex-row">
    ...
  </div>
</div>
```

Use nomes somente quando removem ambiguidade real.

[SITUATIONAL] Use `@container-size` quando a query ou unidade depende também de block size.

```html
<div class="@container-size">
  <div class="h-[50cqb]">
    ...
  </div>
</div>
```

Container sizes reutilizáveis pertencem ao theme.

## Interaction and Form States

Use pseudo-class variants quando o estado pertence ao próprio elemento.

Prefira `focus-visible:` quando o feedback visual deve acompanhar foco relevante para interação por teclado.

[HARD RULE] Não remova focus indication sem fornecer uma alternativa perceptível adequada.

Para form controls, prefira estados nativos quando eles representam corretamente a regra:

- `disabled:`;
- `required:`;
- `invalid:`;
- `user-invalid:`;
- `checked:`;
- `indeterminate:`;
- `read-only:`;
- `autofill:`.

```html
<input
  type="email"
  required
  class="border-gray-300 invalid:border-pink-500 disabled:bg-gray-100"
/>
```

[HARD RULE] Não replique em JavaScript um estado nativo apenas para controlar classes.

## Structural Selectors

Use structural variants quando a regra realmente depende da posição ou estrutura do DOM.

Exemplos:

- `first:`;
- `last:`;
- `only:`;
- `odd:`;
- `even:`;
- `empty:`.

[SITUATIONAL] Use `nth-*` quando a posição específica faz parte do design.

[HARD RULE] Evite selectors posicionais complexos quando uma estrutura semântica ou classe explícita comunica melhor a intenção.

## `has-*`

Use `has-*` quando o elemento deve reagir a estado ou conteúdo de seus descendants e essa relação existe naturalmente no DOM.

```html
<label class="has-checked:bg-indigo-50">
  <input type="radio" />
  Google Pay
</label>
```

Também pode observar selectors específicos:

```html
<article class="has-[img]:grid">
  ...
</article>
```

[DEFAULT] Use `has-*` quando evita estado duplicado e mantém a relação estrutural clara.

Não use selectors `has-*` complexos quando o componente já possui um estado explícito mais fácil de compreender.

## Parent State with `group`

Use `group` quando um descendant precisa reagir ao estado de um parent específico.

```html
<a class="group">
  <span class="text-gray-500 group-hover:text-gray-900">
    Open
  </span>
</a>
```

[SITUATIONAL] Nomeie groups quando há parents aninhados e a origem do estado ficaria ambígua.

```html
<div class="group/card">
  <button class="group/edit">
    <span class="group-hover/edit:text-blue-600">
      Edit
    </span>
  </button>
</div>
```

[DEFAULT] Use `group` quando precisa de controle explícito sobre qual ancestor está sendo observado.

## Sibling State with `peer`

Use `peer` quando um elemento posterior precisa reagir ao estado de um sibling anterior.

```html
<label>
  <input type="email" class="peer" />

  <p class="invisible peer-invalid:visible">
    Invalid email
  </p>
</label>
```

[HARD RULE] O elemento marcado como `peer` precisa aparecer antes do elemento estilizado.

`peer` depende da relação de sibling subsequente.

[SITUATIONAL] Nomeie peers quando mais de um sibling pode ser observado.

Evite arbitrary peer selectors complexos se um estado explícito ou data attribute tornar a relação mais clara.

## Implicit Ancestor State with `in-*`

[SITUATIONAL] Use `in-*` quando o elemento deve reagir ao estado de qualquer ancestor compatível sem exigir uma marcação `group`.

[DEFAULT] Se é importante controlar exatamente qual parent fornece o estado, use `group` em vez de `in-*`.

Isso evita que um ancestor inesperado passe a afetar o componente.

## Pseudo-Elements

Use pseudo-element variants para styling de partes da plataforma ou conteúdo suplementar:

- `before:`;
- `after:`;
- `placeholder:`;
- `file:`;
- `marker:`;
- `selection:`.

[HARD RULE] `before:` e `after:` não devem carregar informação essencial que precisa existir semanticamente no DOM.

Generated content pertence à apresentação.

## Dark Mode

Use `dark:` para styling condicionado à estratégia de dark mode do projeto.

```html
<div class="bg-white text-gray-900 dark:bg-gray-900 dark:text-white">
  ...
</div>
```

[DEFAULT] Se o projeto usa preferência do sistema, mantenha a variant baseada em `prefers-color-scheme`.

[SITUATIONAL] Se o usuário controla o tema manualmente, configure a variant para a fonte de estado escolhida, como classe ou data attribute.

Exemplo com data attribute:

```css
@custom-variant dark (&:where([data-theme=dark], [data-theme=dark] *));
```

[DEFAULT] JavaScript deve gerenciar a preferência/estado quando necessário; a aplicação visual deve continuar sendo feita pela variant.

## Motion Preferences

[HARD RULE] Use `motion-safe:` e `motion-reduce:` quando motion precisa respeitar `prefers-reduced-motion`.

```html
<button class="motion-safe:transition motion-safe:hover:-translate-y-0.5">
  Save
</button>
```

Não dependa de movimento como único meio de comunicar informação essencial.

Motion styling detalhado pertence a `transforms-transitions.md`; requisitos de acessibilidade pertencem às references de accessibility.

## Contrast and Forced Colors

Use `contrast-more:` ou `contrast-less:` quando uma adaptação específica à preferência de contraste é necessária.

[HARD RULE] Essas variants não substituem contraste adequado no estado normal.

Use `forced-colors:` quando a UI precisa se adaptar ao forced-colors mode.

Exemplo típico:

```html
<input
  type="radio"
  class="appearance-none forced-colors:appearance-auto"
/>
```

[HARD RULE] Não use forced-colors styling para compensar controles customizados que já são inacessíveis no baseline.

## Pointer Capability

[SITUATIONAL] Use variants de pointer quando a precisão do dispositivo de entrada realmente muda a UX.

Exemplo:

```html
<button class="p-2 pointer-coarse:p-4">
  Action
</button>
```

`pointer-*` considera o primary pointing device.

`any-pointer-*` considera qualquer pointing device conectado.

[DEFAULT] Use essas variants para adaptar affordance/tamanho de alvo, não para presumir uma categoria de dispositivo inteira.

## Environment Variants

[SITUATIONAL] Use orientation somente quando portrait/landscape é parte real do comportamento.

[DEFAULT] Se o layout pode responder melhor ao espaço disponível, prefira breakpoints ou container queries a orientation.

Use `print:` para styling específico de impressão.

[HARD RULE] Não esconda conteúdo essencial da versão impressa sem intenção funcional.

Use `noscript:` somente quando existe comportamento relevante para ausência de scripting.

## `supports-*`

Use `supports-[...]` quando o styling depende explicitamente do suporte a uma feature CSS.

```html
<div class="flex supports-[display:grid]:grid">
  ...
</div>
```

Use `not-supports-*` quando precisa de fallback específico.

[DEFAULT] Se a mesma feature query aparece repetidamente, considere uma custom variant em vez de repetir selectors arbitrários.

## `starting:`

[SITUATIONAL] Use `starting:` quando um elemento recém-renderizado ou que sai de `display: none` precisa de starting style para uma entry transition.

```html
<div
  popover
  class="opacity-100 starting:open:opacity-0"
>
  ...
</div>
```

[DEFAULT] Não crie estado JavaScript apenas para representar um starting style que CSS já consegue expressar.

Transitions detalhadas pertencem a `transforms-transitions.md`.

## ARIA Variants

Use `aria-*` quando o componente possui um ARIA attribute real que representa estado acessível.

Exemplo:

```html
<button
  aria-expanded="true"
  class="aria-expanded:bg-gray-100"
>
  Menu
</button>
```

[SITUATIONAL] Use valores arbitrários quando o atributo possui um valor específico, como `aria-sort`.

[HARD RULE] Não adicione ARIA somente para obter uma variant de styling.

ARIA deve existir porque representa o contrato de acessibilidade do componente.

Variants também podem observar ARIA por `group-aria-*` e `peer-aria-*` quando a relação estrutural exige isso.

## Data Attribute Variants

Use `data-*` quando um componente expõe estado real através de data attributes.

```html
<div
  data-active
  class="data-active:border-purple-500"
>
  ...
</div>
```

Valores específicos também podem ser observados:

```html
<div
  data-size="large"
  class="data-[size=large]:p-8"
>
  ...
</div>
```

Isso é especialmente útil com componentes/headless libraries que já expõem estado via `data-*`.

[HARD RULE] Não crie data attributes desconectados do estado real apenas para facilitar styling.

## Direction and Open State

Use `rtl:` / `ltr:` quando realmente existe uma diferença que não pode ser expressa por logical properties.

[DEFAULT] Prefira logical properties quando elas eliminam branches direcionais.

Use `open:` para elementos que expõem estado aberto através da plataforma, como:

- `<details>`;
- `<dialog>`;
- popover.

```html
<details class="open:bg-gray-100">
  ...
</details>
```

[DEFAULT] Prefira o estado nativo `open` a criar um estado paralelo somente para styling.

## Child and Descendant Variants

Use `*:` quando todos os filhos diretos compartilham uma regra simples.

```html
<ul class="*:rounded-lg *:p-4">
  ...
</ul>
```

[DEFAULT] Se children individuais precisam sobrescrever frequentemente essa regra, prefira classes explícitas nos próprios elementos.

[SITUATIONAL] Use `**:` quando uma regra realmente precisa alcançar descendants.

[HARD RULE] Evite `**:` para aplicar grandes conjuntos de estilos indiscriminadamente em árvores complexas.

## Arbitrary Variants

[SITUATIONAL] Use arbitrary variants para selectors pontuais que não justificam uma variant reutilizável.

```html
<div class="[&.is-dragging]:cursor-grabbing">
  ...
</div>
```

[HARD RULE] Selectors arbitrários muito complexos tornam o markup difícil de entender.

Se o mesmo selector reaparece ou representa uma regra do projeto, registre uma custom variant.

## Custom Variants

[DEFAULT] Quando uma condição reutilizável não é coberta por uma variant existente, registre-a com `@custom-variant`.

```css
@custom-variant theme-midnight (&:where([data-theme="midnight"] *));
```

```html
<div class="theme-midnight:bg-black">
  ...
</div>
```

Criação e customização detalhada pertencem a `theme-customization.md`.

## Variant Composition

Variants podem ser empilhadas:

```html
<button class="dark:md:hover:bg-fuchsia-600">
  Save
</button>
```

[HARD RULE] Empilhe somente as condições necessárias.

Quando uma classe exige uma cadeia longa de variants para ser compreendida, reavalie se pode simplificar:

- estrutura do componente;
- representação de estado;
- regra de design;
- custom variant.

[DEFAULT] O objetivo não é minimizar o número de variants a qualquer custo, mas manter clara a condição que produz o estilo.

## Responsibility Boundaries

Esta referência cobre decisões de:

- viewport breakpoints;
- breakpoint ranges;
- container queries;
- pseudo-class variants;
- form state variants;
- structural variants;
- `has-*`;
- `group-*`;
- `peer-*`;
- `in-*`;
- pseudo-elements;
- dark mode;
- motion/contrast/forced-color variants;
- environment/media variants;
- `supports-*`;
- `starting:`;
- ARIA variants;
- data variants;
- direction/open states;
- child/descendant variants;
- arbitrary variants;
- custom variant routing.

Outras responsabilidades:

- criar breakpoints, container sizes e custom variants → `theme-customization.md`;
- interaction utilities e scrolling → `interactivity.md`;
- transitions e motion styling → `transforms-transitions.md`;
- layout e logical properties → `layout.md` / `spacing-sizing.md`;
- focus, ARIA semantics, contrast, motion e forced-colors requirements → accessibility references.
