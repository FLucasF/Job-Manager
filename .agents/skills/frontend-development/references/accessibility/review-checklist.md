# Frontend Accessibility Review Checklist

Checklist operacional para revisão de acessibilidade.

[DEFAULT] Use este arquivo primeiro em code review de accessibility.

[HARD RULE] Consulte somente a referência detalhada relacionada ao item que exigir investigação.

## Semantic HTML

- [ ] Elementos nativos representam corretamente conteúdo/interação?
- [ ] Buttons são ações e links são navegação?
- [ ] Elementos genéricos não recriam controles nativos sem necessidade?
- [ ] Headings refletem hierarquia, não styling?
- [ ] Landmarks são usados apenas quando estruturalmente relevantes?
- [ ] `section`/`article` possuem significado real?
- [ ] Listas e tabelas preservam estrutura semântica?
- [ ] Elementos interativos não estão aninhados incorretamente?
- [ ] Cards com múltiplas ações preservam controles independentes?
- [ ] DOM order continua coerente com leitura/interação?
- [ ] Component abstractions preservam a semântica nativa?

## ARIA

- [ ] HTML nativo foi considerado antes de ARIA?
- [ ] Não existem roles redundantes?
- [ ] Controles possuem nomes acessíveis claros?
- [ ] Visible text é usado como nome quando suficiente?
- [ ] Name e description não foram confundidos?
- [ ] ARIA states refletem exatamente o state real?
- [ ] Não existe state React duplicado apenas para ARIA?
- [ ] `current`, `selected`, `checked`, `pressed` e `expanded` não foram confundidos?
- [ ] `aria-disabled` não está sendo tratado como native `disabled`?
- [ ] Conteúdo interativo não foi escondido da accessibility tree?
- [ ] Ícones decorativos não poluem accessible names?
- [ ] Live regions são pequenas e usadas somente quando necessárias?
- [ ] ARIA relationships referenciam elementos reais e IDs únicos?
- [ ] Custom widget não foi considerado completo apenas por possuir `role`?

## Keyboard and Focus

- [ ] Todas as interações essenciais são operáveis por teclado?
- [ ] Native keyboard behavior é preservado quando disponível?
- [ ] Tab order segue sequência lógica?
- [ ] `tabIndex` positivo não é utilizado?
- [ ] Conteúdo estático não entra na tab order sem necessidade?
- [ ] Focus indicator permanece perceptível?
- [ ] Programmatic focus ocorre somente por transição relevante?
- [ ] Effects de foco possuem trigger explícito?
- [ ] Dialog recebe foco ao abrir e o contém enquanto modal?
- [ ] Focus retorna para destino lógico ao fechar temporary UI?
- [ ] Keyboard traps não existem fora de contexts esperados?
- [ ] Hidden/inactive content não permanece focável?
- [ ] Browser shortcuts não são sobrescritos sem necessidade?
- [ ] Essential actions não dependem exclusivamente de hover?
- [ ] Refetch/re-render preserva foco quando o contexto não mudou?

## Form Accessibility

- [ ] Todo control possui accessible name?
- [ ] Visible label é usado quando apropriado?
- [ ] Placeholder não substitui label?
- [ ] Label está semanticamente associado ao control?
- [ ] Supporting instructions estão associadas quando necessárias?
- [ ] Required/optional não dependem apenas de `*`, cor ou layout?
- [ ] Native inputs são usados quando atendem ao caso?
- [ ] Related controls possuem group context?
- [ ] Invalid state não depende somente de cor?
- [ ] Field errors estão associados ao control correspondente?
- [ ] Form-level error não foi forçado em campo arbitrário?
- [ ] Errors não são anunciados antes de serem relevantes?
- [ ] Validation não gera announcements/focus jumps em cada keystroke?
- [ ] Long forms usam error summary somente quando útil?
- [ ] Reusable field components preservam label/description/error/state?
- [ ] IDs de componentes reutilizáveis não colidem?
- [ ] Multi-step/conditional forms permanecem compreensíveis?

## Cross-Cutting Boundaries

- [ ] Semantic HTML decide elemento antes de ARIA?
- [ ] ARIA não está implementando keyboard behavior?
- [ ] Keyboard/focus não duplica semântica ARIA?
- [ ] Form accessibility não redefine regras funcionais de validation/submission?
- [ ] UI state semantics continuam em ui-states?
- [ ] Accessibility complementa a UI existente em vez de criar experiência paralela?

## Escalation

```text
elements / headings / landmarks / lists / tables / button-vs-link
→ semantic-html.md

ARIA / accessible name / descriptions / states / live regions / IDs
→ aria.md

keyboard / tab order / focus / dialogs / custom widget interaction
→ keyboard-focus.md

labels / instructions / required / errors / form feedback
→ form-accessibility.md
```

[HARD RULE] Não carregue todas as referências de accessibility apenas para uma revisão geral.
