# Tailwind Interactivity

Referência de decisões, armadilhas e padrões para controles nativos, scrolling, pointer/touch behavior e outras interações com Tailwind.

## Contents

- Interaction strategy
- Native controls
- Color scheme and accent
- Cursor
- Field sizing
- Pointer events
- Resize
- Smooth scrolling
- Scrollbars
- Scroll offsets
- Scroll snapping
- Touch action
- Text selection
- Will change
- Modern platform features
- Responsibility boundaries

## Interaction Strategy

[HARD RULE] Styling de interação não substitui semântica ou comportamento real.

Classes como:

- `cursor-pointer`;
- `pointer-events-none`;
- `select-none`;
- `appearance-none`;

alteram apresentação ou comportamento CSS, mas não transformam automaticamente um elemento em:

- button;
- disabled control;
- inert region;
- accessible widget.

Use HTML, estado e atributos adequados para representar a interação real.

## Native Controls

[DEFAULT] Preserve a aparência e o comportamento nativos quando não houver necessidade real de customização.

Use `appearance-none` somente quando o controle precisa de aparência customizada.

```html
<select class="appearance-none">
  ...
</select>
```

[HARD RULE] Não remova native appearance apenas por hábito.

Ao customizar controles, considere fallback para modos de acessibilidade.

```html
<input
  type="checkbox"
  class="appearance-none forced-colors:appearance-auto"
/>
```

Regras completas de forms e accessibility pertencem às referências correspondentes.

## Color Scheme and Accent

Use `accent-*` quando a cor de accent de controles nativos deve acompanhar o design system.

Use `caret-*` quando a cor do caret precisa ser customizada.

[DEFAULT] Use tokens do theme para essas cores quando representam linguagem visual recorrente.

Use `scheme-*` para informar ao browser qual color scheme deve ser usado em UI e controles nativos.

`color-scheme` complementa o styling visual da aplicação; não substitui classes de background, text ou border.

## Cursor

[DEFAULT] Use o cursor para refletir comportamento real.

Exemplos típicos:

- pointer para controles acionáveis quando apropriado;
- progress/wait durante operações correspondentes;
- grab/grabbing em interação de arraste;
- resize cursors em handles de redimensionamento.

[HARD RULE] Não use `cursor-pointer` para fazer um elemento não interativo parecer um controle.

A affordance visual deve corresponder à semântica e ao comportamento implementado.

## Field Sizing

[SITUATIONAL] Use `field-sizing-content` quando um form control deve crescer de acordo com seu conteúdo.

```html
<textarea class="field-sizing-content">
  ...
</textarea>
```

Use `field-sizing-fixed` quando o sizing tradicional deve ser preservado.

[DEFAULT] Antes de criar JavaScript para auto-resize de inputs/textareas, verifique se a feature nativa atende aos browsers-alvo.

Não use uma solução JavaScript mais complexa apenas por hábito quando a plataforma já resolve o caso.

## Pointer Events

Use `pointer-events-none` quando um elemento realmente deve ignorar pointer events.

[HARD RULE] `pointer-events-none` não torna o elemento automaticamente:

- disabled;
- inert;
- unfocusable;
- hidden de tecnologias assistivas.

Use a semântica correta para o estado real.

Exemplo: um button desabilitado deve continuar sendo representado como disabled, não apenas receber `pointer-events-none`.

## Resize

Use resize controls quando redimensionamento manual faz parte da interação esperada.

[DEFAULT] Escolha o eixo permitido de acordo com o layout real.

Por exemplo, em textareas de formulários, `resize-y` frequentemente preserva melhor o layout horizontal que resize irrestrito.

[HARD RULE] Não desabilite resize de conteúdo editável sem necessidade quando isso pode prejudicar usuários que precisam de mais espaço para leitura/edição.

## Smooth Scrolling

[SITUATIONAL] Use `scroll-smooth` quando smooth scrolling melhora a navegação.

[HARD RULE] Não habilite smooth scrolling indiscriminadamente.

Considere:

- preferência de reduced motion;
- distância percorrida;
- contexto de navegação;
- feedback esperado.

Quando movimento precisa ser condicionado pela preferência do usuário, consulte `responsive-variants.md` e accessibility references.

## Scrollbars

[DEFAULT] Preserve scrollbars visíveis quando elas ajudam a comunicar que uma região é rolável.

`scrollbar-none` remove a representação visual, mas não remove a capacidade de scroll.

[HARD RULE] Se esconder a scrollbar, confirme que a região continua:

- descobrível;
- operável por mouse;
- operável por touch;
- operável por teclado quando aplicável.

Ao customizar thumb/track, mantenha contraste suficiente entre:

- thumb;
- track;
- superfície ao redor.

[SITUATIONAL] Use `scrollbar-gutter-stable` quando reservar espaço para a scrollbar evita layout shift.

## Scroll Offsets

Use scroll margin no item quando ele precisa de offset ao ser posicionado por scroll/snap.

Use scroll padding no container quando o conteúdo rolado deve respeitar uma área interna reservada.

Caso comum:

- sticky header;
- carousel padding;
- anchor navigation.

[DEFAULT] Em interfaces direction-aware, use logical scroll offsets quando a intenção é start/end.

Exemplos:

- `scroll-ms-*` / `scroll-me-*`;
- `scroll-mbs-*` / `scroll-mbe-*`;
- `scroll-ps-*` / `scroll-pe-*`;
- `scroll-pbs-*` / `scroll-pbe-*`.

## Scroll Snapping

Use scroll snapping quando parar em posições previsíveis faz parte do comportamento do componente.

Padrão básico:

```html
<div class="snap-x snap-mandatory overflow-x-auto">
  <article class="snap-center">
    ...
  </article>
</div>
```

[DEFAULT] Prefira `snap-proximity` quando snapping deve ajudar sem dominar a navegação.

Use `snap-mandatory` quando cada posição de snap faz parte do contrato da interface.

[SITUATIONAL] Use `snap-always` somente quando for realmente importante impedir que uma posição intermediária seja pulada.

[HARD RULE] Não use snapping excessivamente em conteúdo longo ou livre quando ele dificulta scrolling natural.

## Touch Action

Use `touch-*` para declarar quais gestos touch são permitidos pelo componente.

Exemplo de região horizontal:

```html
<div class="touch-pan-x overflow-x-auto">
  ...
</div>
```

Quando pinch zoom precisa permanecer disponível, preserve-o explicitamente quando necessário.

[HARD RULE] Não use `touch-none` sem uma razão concreta.

Ele pode bloquear gestos esperados pelo usuário.

[HARD RULE] Não desative zoom/pinch indiscriminadamente em conteúdo comum.

Touch behavior deve refletir a interação real, especialmente em carousels, canvases e gestos customizados.

## Text Selection

[DEFAULT] Preserve seleção de texto em conteúdo que o usuário pode querer copiar.

Use `select-none` apenas quando seleção acidental prejudica uma interação específica, como determinados handles ou controles de drag.

Use `select-all` quando selecionar todo o conteúdo é intencional, por exemplo em snippets curtos:

```html
<code class="select-all">
  npm install
</code>
```

[HARD RULE] Não aplique `select-none` globalmente a conteúdo textual comum.

## Will Change

[SITUATIONAL] Use `will-change-*` somente para problemas de performance conhecidos.

[HARD RULE] `will-change` é exceção, não otimização preventiva.

Uso excessivo pode aumentar custo de memória/composição e piorar performance.

Quando possível:

1. aplique antes da mudança que realmente se beneficia;
2. remova quando não for mais necessário;
3. volte ao comportamento automático.

Performance deve ser medida.

Para `transform-gpu`, consulte `transforms-transitions.md`.

## Modern Platform Features

Algumas APIs desta referência dependem de recursos relativamente modernos da plataforma, por exemplo:

- `field-sizing-content`;
- scrollbar styling;
- scrollbar gutter.

[DEFAULT] Quando compatibilidade for relevante, valide suporte nos browsers-alvo.

[DEFAULT] Não recrie uma feature nativa em JavaScript apenas por ser moderna; primeiro verifique se o suporte exigido permite usar a solução CSS.

## Responsibility Boundaries

Esta referência cobre decisões de:

- accent color;
- native control appearance;
- caret;
- color scheme;
- cursor;
- field sizing;
- pointer events;
- resize;
- scroll behavior;
- scrollbar styling;
- scroll margin/padding;
- scroll snapping;
- touch action;
- user selection;
- `will-change`.

Outras responsabilidades:

- overflow e overscroll → `layout.md`;
- width, height e sizing → `spacing-sizing.md`;
- breakpoints, state variants, reduced motion e pointer capability variants → `responsive-variants.md`;
- transforms, transition performance e `transform-gpu` → `transforms-transitions.md`;
- tokens de cores e outras customizações → `theme-customization.md`;
- semântica, teclado, foco, zoom e comportamento assistivo → accessibility references.
