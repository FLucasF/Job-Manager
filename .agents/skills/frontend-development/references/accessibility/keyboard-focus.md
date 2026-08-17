# Frontend Keyboard and Focus Accessibility

Referência para operabilidade por teclado, ordem de foco e mudanças programáticas de foco.

## Contents

- Keyboard operability
- Focus order and visibility
- Programmatic focus
- Dialogs and temporary UI
- Custom widgets
- Shortcuts
- Hidden/dynamic content
- Async updates and routing
- Forms
- Responsibility boundaries

## Keyboard Operability

[HARD RULE] Interações essenciais disponíveis por pointer precisam de uma alternativa de teclado apropriada ao padrão.

Não dependa exclusivamente de:

- click;
- hover;
- pointer drag;

quando existe uma interação equivalente necessária.

## Prefer Native Keyboard Behavior

[HARD RULE] Prefira elementos nativos que já implementam o comportamento esperado.

Prefira:

```tsx
<button type="button">
  Save
</button>
```

a um `div` com `tabIndex`, handlers e role recriados manualmente.

A escolha do elemento pertence a `semantic-html.md`.

## Do Not Reimplement Native Interaction

[HARD RULE] Não implemente manualmente Enter/Space/focus para simular um controle que já existe na plataforma.

Custom interaction só se justifica quando o padrão realmente não pode ser representado adequadamente por um controle nativo.

## Logical Tab Order

[HARD RULE] Tab order deve seguir sequência lógica e previsível.

[DEFAULT] DOM order deve refletir reading/interaction order quando possível.

Não use CSS para produzir ordem visual incompatível com a interação sem motivo forte.

## Avoid Positive `tabIndex`

[HARD RULE] Não use `tabIndex={1}`, `2`, `3` para construir uma ordem manual.

Use:

```text
tabIndex={0}
→ participa da ordem natural quando um custom control realmente precisa

tabIndex={-1}
→ pode receber foco programático sem entrar na sequência normal
```

[HARD RULE] Não adicione conteúdo estático à tab order sem uma necessidade de interação/navegação.

## Focus Must Be Visible

[HARD RULE] O elemento focado precisa ser perceptível.

Não remova outline/focus indicator sem alternativa equivalente.

[DEFAULT] O estilo de foco deve corresponder ao elemento que realmente recebe o foco.

## Programmatic Focus

[HARD RULE] Não mova foco apenas porque algum state mudou.

Use focus programático quando existe uma transição de contexto relevante, por exemplo:

- dialog opens/closes;
- invalid form submission;
- focused item is removed;
- route/content boundary changes de forma que contexto se perderia.

## Focus Effects Need Clear Triggers

[HARD RULE] Effects que chamam `.focus()` precisam corresponder a uma transição intencional.

Evite:

```text
render
→ effect
→ focus()
```

em toda atualização.

Prefira lógica associada a:

```text
closed → open
item exists → removed
submit valid → invalid result
```

## Dialog Opening

[HARD RULE] Ao abrir um modal, mova foco para dentro do novo contexto.

Escolha o destino com intenção.

Possibilidades:

- relevant heading/container;
- first meaningful field;
- primary safe action;
- least destructive action.

[DEFAULT] Não foque automaticamente uma ação destrutiva sem necessidade.

## Modal Focus Containment

[HARD RULE] Enquanto um modal está ativo, teclado não deve acessar controles que ficaram indisponíveis atrás dele.

Esse comportamento não é substituído por `role="dialog"`.

A semântica ARIA pertence a `aria.md`.

## Avoid Keyboard Traps

[HARD RULE] Fora de contexts temporariamente contidos por padrão, o usuário deve conseguir entrar e sair de uma região por teclado.

Nunca crie foco sem mecanismo esperado de saída.

## Restore Focus After Temporary UI

[HARD RULE] Ao fechar dialog/popover/context temporário, devolva foco para um destino lógico quando necessário.

Frequentemente:

```text
trigger
→ open
→ interaction
→ close
→ trigger
```

Se o trigger foi removido, escolha outro destino válido.

[HARD RULE] Não tente focar elemento que não existe mais.

## Disclosures

[DEFAULT] Abrir conteúdo expandido normalmente não exige mover foco; o trigger pode permanecer focado.

Só mova quando a interação realmente cria novo contexto.

## Custom Widgets

[SITUATIONAL] Menus, tabs, listboxes, comboboxes, trees e grids podem exigir padrões próprios de teclado.

[HARD RULE] Não invente atalhos/teclas diferentes do padrão esperado para o widget.

Role/ARIA semantics pertencem a `aria.md`.

## Enter and Space

[HARD RULE] Não assuma que todo controle customizado responde igualmente a Enter e Space.

Comportamento depende do elemento/padrão.

Prefira comportamento nativo ou o padrão estabelecido do widget.

## Escape

[DEFAULT] Contextos temporários que normalmente podem ser fechados podem responder a Escape quando o padrão adotado espera isso.

Não implemente Escape global para fechar qualquer estado da aplicação.

## `preventDefault()`

[HARD RULE] Não use `preventDefault()` indiscriminadamente em keyboard handlers.

Ele pode remover navegação/interaction nativa importante.

Use somente quando o componente substitui conscientemente aquele comportamento.

## Browser and OS Shortcuts

[HARD RULE] Não capture atalhos padrão sem razão forte.

Exemplos:

```text
Ctrl+C
Ctrl+V
Ctrl+F
Tab
Shift+Tab
```

## Custom Shortcuts

[SITUATIONAL] Se o produto oferece atalhos:

- documente-os;
- evite conflitos;
- preserve atalhos padrão;
- mantenha equivalente visível para ações essenciais.

[HARD RULE] Não torne shortcut oculto a única forma de completar um fluxo.

## Hover Is Not Enough

[HARD RULE] Informação ou ação essencial não pode depender exclusivamente de hover.

Se uma ação aparece em hover, usuários de teclado também precisam conseguir descobri-la/acessá-la quando apropriado.

## Hidden Content and Focus

[HARD RULE] Conteúdo fora da interface atual não deve continuar alcançável por teclado.

```text
visually hidden/inactive
+
focusable
```

sem intenção é um bug de interação.

## Conditional Removal

[DEFAULT] Se a ação do usuário remove o elemento focado, determine se um novo focus target é necessário para preservar contexto.

Possíveis destinos:

- next item;
- previous item;
- section/list heading;
- relevant primary action.

## Background Updates

[HARD RULE] Refetch/re-render não deve causar perda de foco sem necessidade.

[DEFAULT] Preserve a árvore/interação existente quando background update não muda o contexto.

Loading semantics pertencem a ui-states.

## Loading Indicators

[DEFAULT] Spinner/skeleton normalmente não precisam receber foco só porque apareceram.

Se uma atualização precisa ser anunciada, status/live region pode ser mais adequado.

Consulte `aria.md`.

## Route Changes

[SITUATIONAL] Após navegação client-side, avalie se o usuário precisa de orientação para o novo contexto.

Não aplique uma regra universal de focar `main`/`h1` em toda navegação sem considerar o comportamento real do router e da aplicação.

[DEFAULT] Se houver mudança significativa de contexto e o foco antigo não representa mais a localização atual, escolha um destino lógico e previsível.

## Form Validation

[DEFAULT] Após uma submissão inválida, pode ser útil focar:

```text
error summary
```

ou:

```text
first invalid field
```

quando isso ajuda o usuário a encontrar os problemas.

[HARD RULE] Não mova foco a cada alteração individual de validação.

Detalhes de formulário pertencem a `form-accessibility.md`.

## Server/Submission Errors

[DEFAULT] Se uma mensagem acessível comunica a falha e o contexto não mudou, não mova foco automaticamente.

Considere foco quando a correção exige localizar outro ponto ou o usuário perderia contexto.

## Responsibility Boundaries

Esta referência é dona de:

- keyboard operability;
- tab/focus order;
- focus visibility;
- programmatic focus;
- dialog focus lifecycle;
- keyboard side of custom widgets;
- shortcuts.

Outras responsabilidades:

- semantic elements → `semantic-html.md`;
- ARIA/widget semantics/live regions → `aria.md`;
- form-specific associations → `form-accessibility.md`;
- functional loading/disabled states → ui-states.
