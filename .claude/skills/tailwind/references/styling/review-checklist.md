# Tailwind Review Checklist

Checklist operacional para revisão de código Tailwind.

Use esta referência durante code review, refactors ou validações de implementação.

[DEFAULT] Comece por este checklist e consulte uma referência detalhada somente quando um item exigir investigação adicional.

[HARD RULE] Não carregue todas as referências Tailwind por padrão.

## Contents

- Layout
- Spacing and sizing
- Typography
- Backgrounds and borders
- Effects, filters and masks
- Transforms and motion
- Interactivity
- Responsive and variants
- Theme and customization
- Tooling and integrations
- Cross-cutting review
- Escalation

## Layout

- [ ] Flex foi usado para relações predominantemente unidimensionais?
- [ ] Grid foi usado quando rows e columns fazem parte da estrutura?
- [ ] `absolute` está sendo usado apenas quando o elemento realmente precisa sair do fluxo?
- [ ] `gap-*` foi preferido para spacing estrutural entre items de flex/grid?
- [ ] `overflow-hidden` não está apenas escondendo um problema de layout?
- [ ] `z-*` não está sendo aumentado indefinidamente para contornar stacking contexts?
- [ ] `order-*`, reverse ou `grid-flow-dense` não criam divergência problemática entre ordem visual e DOM?
- [ ] Logical positioning foi considerado quando direction/writing-mode importa?
- [ ] `object-cover` vs `object-contain` corresponde ao comportamento esperado da mídia?

Se houver dúvida estrutural, consulte `layout.md`.

## Spacing and Sizing

- [ ] Spacing estrutural está no parent quando deveria estar, em vez de margins distribuídas pelos children?
- [ ] Valores da escala do projeto foram preferidos a arbitrary values repetidos?
- [ ] Logical spacing foi usado quando start/end representa melhor a intenção que left/right?
- [ ] Negative margins representam overlap intencional e não correção de layout incorreto?
- [ ] Fixed width/height realmente faz parte do contrato do componente?
- [ ] `min-w-0` foi considerado em flex/grid items que precisam encolher ou truncar?
- [ ] `min-h-0` foi considerado em nested flex/grid com scrolling interno?
- [ ] `h-screen` não foi usado automaticamente em um layout mobile que deveria considerar `dvh`/`svh`/`lvh`?
- [ ] `size-*` foi usado quando width e height têm o mesmo contrato?
- [ ] Aspect ratios recorrentes foram tratados como tokens quando apropriado?

Se houver problema de dimensions ou shrink/scroll, consulte `spacing-sizing.md`.

## Typography

- [ ] Styling visual não está substituindo semântica HTML?
- [ ] Font size e line height formam um estilo consistente?
- [ ] Valores tipográficos recorrentes vêm do theme em vez de arbitrary values duplicados?
- [ ] `tabular-nums` foi considerado para métricas, timers, tabelas ou valores financeiros?
- [ ] `text-balance` / `text-pretty` são usados apenas onde melhoram a composição?
- [ ] `truncate` ou `line-clamp-*` não escondem conteúdo essencial sem alternativa?
- [ ] Strings longas usam uma estratégia adequada de wrapping antes de hacks de layout?
- [ ] `break-all` não está sendo usado como solução padrão para body text?
- [ ] `hyphens-auto` possui idioma (`lang`) adequado?
- [ ] Generated content não carrega informação essencial?

Se houver decisão tipográfica específica, consulte `typography.md`.

## Backgrounds and Borders

- [ ] Cores e radius recorrentes vêm do theme?
- [ ] Gradients usam APIs específicas quando não há necessidade de um valor arbitrário complexo?
- [ ] `bg-cover` vs `bg-contain` corresponde ao tratamento esperado da imagem?
- [ ] `bg-fixed` foi usado com uma necessidade real?
- [ ] `bg-clip-text` preserva legibilidade e contraste adequados?
- [ ] Logical borders/radius foram considerados em interfaces direction-aware?
- [ ] Border width, color e style estão explícitos quando a decisão visual exige isso?
- [ ] `outline-none` não removeu foco visível sem substituição?
- [ ] `outline-hidden` e `outline-none` não foram tratados como equivalentes?
- [ ] Table border spacing é usado apenas com o modo de border adequado?

Se houver problema de background, border ou outline, consulte `backgrounds-borders.md`.

## Effects, Filters and Masks

- [ ] `shadow-*` foi usado para boxes e `drop-shadow-*` para formas/rendering que realmente justificam isso?
- [ ] Rings usados para foco continuam atendendo requisitos de visibilidade e contraste?
- [ ] Text shadow não está sendo usada para compensar contraste inadequado?
- [ ] Blend modes têm função visual clara?
- [ ] Filters e backdrop filters não estão sendo aplicados excessivamente em grandes áreas ou elementos animados?
- [ ] Backdrop blur não é a única razão pela qual o conteúdo permanece legível?
- [ ] Masks são usadas para rendering visual, não para esconder estado ou informação semântica?
- [ ] Composições complexas de masks são realmente necessárias?
- [ ] Effects recorrentes foram promovidos a tokens quando fazem parte do design system?

Se houver problema de shadow/filter/mask, consulte `effects-filters-masks.md`.

## Transforms and Motion

- [ ] Motion comunica mudança de estado, feedback, relação espacial ou progresso?
- [ ] Apenas propriedades necessárias estão sendo transicionadas?
- [ ] `transition-all` foi evitado quando uma transition específica comunica melhor a intenção?
- [ ] Duration/easing recorrentes vêm de decisões de motion consistentes?
- [ ] Delays não estão tornando interações rotineiras mais lentas sem motivo?
- [ ] Estado CSS/HTML observável foi preferido a estado JavaScript criado só para styling?
- [ ] `motion-safe:` / `motion-reduce:` foram considerados quando necessário?
- [ ] Transforms individuais foram preferidos a um `transform-[...]` opaco quando possível?
- [ ] `transform-gpu` foi usado por necessidade medida, não preventivamente?
- [ ] 3D/perspective foi usado apenas quando profundidade faz parte da interface?
- [ ] `zoom-*` e `scale-*` não foram tratados como sinônimos?

Se houver problema de transition, animation ou transform, consulte `transforms-transitions.md`.

## Interactivity

- [ ] Styling de interação corresponde à semântica e ao comportamento real do elemento?
- [ ] `appearance-none` foi usado somente quando o controle realmente precisa de customização?
- [ ] `cursor-*` reflete a affordance verdadeira?
- [ ] `pointer-events-none` não está sendo usado como substituto para `disabled` ou `inert`?
- [ ] `field-sizing-content` foi considerado antes de soluções JavaScript de auto-resize?
- [ ] Resize de conteúdo editável não foi bloqueado sem necessidade?
- [ ] Smooth scrolling considera reduced motion e contexto de navegação?
- [ ] Scrollbars escondidas continuam deixando a região descobrível e operável?
- [ ] Scroll snapping não dificulta scrolling natural?
- [ ] `snap-always` é realmente necessário?
- [ ] `touch-none` não bloqueia gestos esperados sem justificativa?
- [ ] `select-none` não foi aplicado a conteúdo que o usuário pode precisar copiar?
- [ ] `will-change` foi usado apenas para um problema de performance conhecido?

Se houver problema de interação/scroll/touch, consulte `interactivity.md`.

## Responsive and Variants

- [ ] O baseline sem prefixo representa corretamente o menor viewport?
- [ ] `sm:` não está sendo tratado como sinônimo de mobile?
- [ ] Breakpoints foram adicionados progressivamente em vez de reconstruir uma estratégia desktop-first?
- [ ] Ranges são usados somente quando o comportamento pertence de fato a uma faixa?
- [ ] Container queries foram consideradas quando o componente deve responder ao container, não ao viewport?
- [ ] Named containers existem apenas quando removem ambiguidade real?
- [ ] Estado nativo foi preferido a duplicação em JavaScript?
- [ ] `group` observa o parent correto?
- [ ] O elemento `peer` aparece antes do elemento que reage a ele?
- [ ] `has-*` representa uma relação natural do DOM?
- [ ] ARIA variants observam ARIA real, não attributes inventados para styling?
- [ ] Data variants observam estado real do componente?
- [ ] Dark mode segue a estratégia real do projeto?
- [ ] Motion/contrast/forced-colors variants adaptam uma base já correta?
- [ ] Pointer variants adaptam a UX sem presumir uma categoria inteira de dispositivo?
- [ ] Arbitrary variants complexas não deveriam virar uma custom variant?
- [ ] Cadeias longas de variants indicam possível problema de estrutura ou estado?

Se houver problema de breakpoint/state/variant, consulte `responsive-variants.md`.

## Theme and Customization

- [ ] `@theme` contém apenas valores que devem participar da API do Tailwind?
- [ ] CSS variables comuns ficaram fora de `@theme` quando não precisam gerar utilities/variants?
- [ ] O namespace escolhido representa corretamente o papel do token?
- [ ] Tokens globais não foram sobrescritos para resolver casos locais?
- [ ] `initial` foi usado apenas quando há intenção real de substituir namespace/theme?
- [ ] `var(--token)` foi preferido a `theme()` em código novo?
- [ ] `@theme inline` é usado apenas quando a resolução de outra CSS variable exige isso?
- [ ] `@theme static` é usado apenas quando tokens precisam existir mesmo sem utilities detectadas?
- [ ] Prefix/important têm uma necessidade concreta?
- [ ] `@utility` representa uma abstração reutilizável real?
- [ ] Functional utilities representam uma família reutilizável, não um valor pontual?
- [ ] `@custom-variant` foi criada apenas para uma condição reutilizável?
- [ ] Shared themes contêm apenas tokens realmente compartilhados?
- [ ] Configuração legada foi evitada quando a API CSS-first resolve o caso?

Se houver problema de token/customização, consulte `theme-customization.md`.

## Tooling and Integrations

- [ ] O projeto possui um único caminho principal de build para Tailwind?
- [ ] Em Vite, `@tailwindcss/vite` foi preferido quando não há exigência diferente?
- [ ] PostCSS não foi adicionado apenas por hábito?
- [ ] CLI não duplica uma integração de build já existente?
- [ ] Prettier plugin é usado somente se o projeto realmente usa Prettier?
- [ ] IntelliSense não está sendo tratado como substituto de lint/typecheck/testes?
- [ ] Headless UI foi adicionada por necessidade de comportamento, não apenas porque Tailwind está presente?
- [ ] Heroicons não duplica outra biblioteca de ícones já adotada?
- [ ] `@tailwindcss/forms` não está sendo tratado como substituto de forms, validação ou accessibility?
- [ ] Plugins atuais usam registro CSS-first quando suportado?
- [ ] Cada dependência resolve uma responsabilidade que ainda não estava atendida?

Se houver dúvida de integração, consulte `tooling-integrations.md`.

## Cross-Cutting Review

- [ ] O código usa Tailwind para expressar intenção, não apenas para reproduzir CSS propriedade por propriedade?
- [ ] Não existem arbitrary values repetidos que deveriam virar tokens?
- [ ] Não existem tokens globais criados para exceções locais?
- [ ] Classes condicionais observam estado real?
- [ ] Não existe JavaScript criado apenas para comportamento que CSS/Tailwind já representa?
- [ ] Semântica HTML e accessibility continuam corretas independentemente do styling?
- [ ] Responsabilidades não estão duplicadas entre componentes, theme e custom utilities?
- [ ] Soluções complexas possuem uma justificativa clara em relação a uma alternativa mais simples?
- [ ] O código segue o padrão atual do projeto em vez de introduzir uma segunda convenção equivalente?

## Escalation

[DEFAULT] Este checklist detecta problemas; as referências detalhadas explicam as decisões.

Carregue somente a referência relacionada ao item que falhou:

```text
layout / flex / grid / overflow
→ layout.md

spacing / width / height / min-size / viewport units
→ spacing-sizing.md

typography / wrapping / truncation
→ typography.md

background / border / outline
→ backgrounds-borders.md

shadow / filter / mask
→ effects-filters-masks.md

transition / animation / transform
→ transforms-transitions.md

scroll / pointer / touch / native controls
→ interactivity.md

breakpoint / container query / state variant
→ responsive-variants.md

theme / token / custom utility / custom variant
→ theme-customization.md

Vite / PostCSS / CLI / plugins / editor tooling
→ tooling-integrations.md
```

[HARD RULE] Não carregue todas as referências Tailwind para executar uma revisão geral.

Use o checklist primeiro e aprofunde somente os pontos encontrados.
