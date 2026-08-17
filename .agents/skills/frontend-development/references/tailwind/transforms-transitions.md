# Tailwind Transforms, Transitions and Animation

Referência de decisões, armadilhas e padrões para transitions, animations e transforms com Tailwind.

## Contents

- Motion strategy
- Transition scope
- Duration, easing and delay
- Discrete transitions
- State-driven motion
- Animation
- Reduced motion
- Transform composition
- Transform origin
- Motion vs layout changes
- GPU and CPU transforms
- 3D transforms
- Perspective and backface
- Zoom vs scale
- Arbitrary values and theme tokens
- Responsibility boundaries

## Motion Strategy

[HARD RULE] Movimento deve comunicar alguma coisa.

Use motion para ajudar a representar:

- mudança de estado;
- relação espacial;
- feedback;
- entrada ou saída;
- progresso.

Evite motion sem função clara apenas por ornamentação.

[DEFAULT] Prefira o efeito mais simples que comunica a mudança necessária.

## Transition Scope

[DEFAULT] Anime somente as propriedades que realmente fazem parte da mudança visual.

Quando apenas transforms mudam:

```html
<button
  class="transition-transform duration-200 hover:-translate-y-1 hover:scale-105"
>
  Save
</button>
```

Isso comunica melhor a intenção que `transition-all`.

Quando somente cores mudam, prefira `transition-colors`.

Use `transition` ou uma property list explícita quando mais de uma família realmente precisa transicionar.

```html
<button class="transition-[opacity,scale]">
  Save
</button>
```

[HARD RULE] Evite `transition-all` como default.

Ele pode animar propriedades que não deveriam participar da transição e tornar mudanças futuras menos previsíveis.

## Duration, Easing and Delay

[DEFAULT] Duration e easing devem representar uma decisão de motion/UX, não valores escolhidos isoladamente por componente.

Se uma duração ou curva se repete como linguagem do produto, transforme-a em token.

[HARD RULE] Não adicione delays a interações rotineiras apenas para tornar a interface “mais animada”.

Delays podem aumentar a percepção de lentidão e retardar feedback importante.

Use arbitrary duration/easing somente quando o caso é realmente pontual.

## Discrete Transitions

[SITUATIONAL] Use `transition-discrete` quando propriedades discretas precisam participar de uma transition e a plataforma suporta o comportamento necessário.

Esse recurso pode ser combinado com `starting:` para estados de entrada.

[DEFAULT] Antes de usar transitions discretas, confirme que o comportamento visual não pode ser representado de forma mais simples com opacity, transform ou outro estado contínuo.

Detalhes de `starting:` e variants pertencem a `responsive-variants.md`.

## State-Driven Motion

[DEFAULT] Quando o estado já está representado por CSS, HTML ou atributos, use variants diretamente.

Exemplos de estado observável:

- `hover`;
- `focus`;
- `open`;
- `checked`;
- `data-*`;
- `aria-*`.

```html
<svg class="transition-transform group-open:rotate-180">
  ...
</svg>
```

[HARD RULE] Não crie estado JavaScript duplicado somente para aplicar uma classe visual que CSS e variants já conseguem derivar.

Use JavaScript quando a lógica de estado realmente pertence ao comportamento da aplicação.

## Animation

Use animações prontas somente quando o significado delas combina com a interface.

Exemplos típicos:

- `animate-spin` para processamento;
- `animate-pulse` para feedback temporário ou skeleton;
- `animate-ping` para destaque transitório.

[HARD RULE] Não use animação como único meio de comunicar informação essencial.

[SITUATIONAL] Para uma animation pontual, arbitrary values podem ser aceitáveis.

Quando uma animation é reutilizável, registre-a no theme com `--animate-*` e keyframes correspondentes em vez de repetir o shorthand.

Customização de animations pertence a `theme-customization.md`.

## Reduced Motion

[HARD RULE] Reduced motion faz parte do contrato de motion, não é um refinamento opcional.

Use `motion-safe:` ou `motion-reduce:` quando movimento puder causar desconforto ou não for essencial.

```html
<div class="transition-transform motion-reduce:transition-none">
  ...
</div>
```

```html
<svg class="motion-safe:animate-spin">
  ...
</svg>
```

Não presuma que toda animação deve continuar intacta quando o usuário prefere movimento reduzido.

Requisitos completos pertencem às referências de accessibility.

## Transform Composition

[DEFAULT] Prefira utilities individuais de transform quando Tailwind já representa cada parte da composição.

```html
<div class="translate-y-2 rotate-3 scale-95">
  ...
</div>
```

Isso é preferível a um `transform-[...]` grande e opaco quando a mesma composição pode ser expressa com utilities específicas.

Use `transform-[...]` somente quando a propriedade precisa de uma composição que as APIs individuais não representam adequadamente.

## Translate, Scale and Rotate

Use transforms para alterar visualmente posição, escala ou rotação sem redefinir a estrutura do layout.

[SITUATIONAL] Negative scale pode ser usado para mirroring quando isso faz parte intencional do design.

[HARD RULE] Não use mirroring visual como atalho quando o asset ou conteúdo precisa ser semanticamente diferente.

Percentage-based translate é útil quando o deslocamento depende do próprio tamanho do elemento.

Exemplo clássico:

```html
<div class="absolute left-1/2 -translate-x-1/2">
  Centered
</div>
```

Positioning estrutural pertence a `layout.md`.

## Transform Origin

Use `origin-*` quando o ponto de origem altera deliberadamente a percepção de scale ou rotation.

```html
<div class="origin-top-left rotate-12">
  ...
</div>
```

[SITUATIONAL] Use custom transform origin somente quando os pontos padrão não representam a geometria necessária.

Se o valor se repete, trate-o como token ou CSS variable.

## Motion vs Layout Changes

[DEFAULT] Quando o efeito é somente deslocamento ou scale visual, transforms costumam ser melhores que animar propriedades de layout repetidamente.

Prefira quando apropriado:

- translate;
- scale;
- rotate;
- opacity.

[HARD RULE] Não force transforms quando o layout realmente precisa mudar.

A escolha deve representar o comportamento real, não apenas otimizar uma animação artificialmente.

## GPU and CPU Transforms

[SITUATIONAL] Use `transform-gpu` quando houver uma razão concreta para promover/compor a transform de forma diferente.

[HARD RULE] Não aplique `transform-gpu` preventivamente em todos os elementos.

Performance deve ser medida, não presumida.

Use `transform-cpu` quando precisar retornar à composição normal.

Para otimizações relacionadas a `will-change`, consulte `interactivity.md`.

## 3D Transforms

[SITUATIONAL] Use transforms 3D somente quando profundidade faz parte real da interface.

Recursos relevantes incluem:

- `translate-z-*`;
- `scale-z-*`;
- `rotate-x-*`;
- `rotate-y-*`;
- `rotate-z-*`;
- `transform-3d`.

`transform-3d` é necessário quando descendants devem participar do mesmo espaço 3D.

```html
<div class="transform-3d">
  <div class="translate-z-12 rotate-y-45">
    ...
  </div>
</div>
```

[DEFAULT] Se uma transform 2D comunica o mesmo comportamento com menor complexidade, prefira 2D.

## Perspective and Backface

[SITUATIONAL] Use `perspective-*` no container de uma cena 3D quando profundidade precisa ser perceptível.

```html
<div class="perspective-normal">
  <div class="transform-3d rotate-y-45">
    ...
  </div>
</div>
```

Quanto menor a distância de perspective, mais pronunciado tende a ser o efeito.

Use `perspective-origin-*` quando o vanishing point da cena precisa ser controlado.

Use `backface-hidden` quando a face traseira de um elemento rotacionado não deve aparecer, como em card flips.

[HARD RULE] Não introduza perspective/backface apenas porque um elemento possui uma rotação simples.

## Zoom vs Scale

[HARD RULE] Não trate `zoom-*` e `scale-*` como sinônimos.

Use `scale-*` quando deseja uma transform visual.

Use `zoom-*` somente quando a propriedade CSS `zoom` é especificamente a ferramenta adequada ao comportamento desejado.

Se a intenção é animação visual de hover, entrada ou feedback, `scale-*` normalmente representa melhor o contrato.

## Arbitrary Values and Theme Tokens

[DEFAULT] Use arbitrary values para exceções pontuais.

Exemplos:

```html
<div class="rotate-[7deg]"></div>
<div class="duration-[450ms]"></div>
```

Se duration, easing, animation, perspective ou outro valor se repete como linguagem do produto, transforme-o em token.

Quando o valor já existe em CSS custom property, prefira a forma curta suportada pela utility.

Não duplique valores arbitrários recorrentes entre componentes.

## Responsibility Boundaries

Esta referência cobre decisões de:

- transition properties;
- duration;
- easing;
- delay;
- discrete transitions;
- CSS animation;
- translate;
- scale;
- rotate;
- skew;
- transform origin;
- transform composition;
- CPU/GPU transforms;
- 2D e 3D transforms;
- perspective;
- backface visibility;
- zoom;
- motion-specific guidance.

Outras responsabilidades:

- hover, focus, `starting:`, motion variants e outros estados → `responsive-variants.md`;
- `--animate-*`, `--ease-*`, `--perspective-*` e outros tokens → `theme-customization.md`;
- `will-change` e interaction-specific behavior → `interactivity.md`;
- positioning e layout estrutural → `layout.md`;
- reduced motion e feedback acessível → accessibility references.
