# Frontend UI States Review Checklist

Checklist operacional para revisar loading, empty, error e disabled sem carregar todas as referências detalhadas.

[DEFAULT] Use este arquivo primeiro em revisão.

[HARD RULE] Consulte uma referência detalhada somente quando um item do checklist exigir investigação.

## State Identification

- [ ] Loading representa uma operação realmente pendente?
- [ ] Empty representa sucesso conhecido sem conteúdo?
- [ ] Error representa uma falha conhecida?
- [ ] Disabled representa uma interação existente, mas indisponível agora?
- [ ] Loading/empty/error não são inferidos apenas pela ausência de `data`?
- [ ] Disabled, hidden, read-only, unauthorized e unavailable continuam semanticamente distintos?
- [ ] A mesma operação não apresenta conclusões contraditórias?

## Scope and Boundaries

- [ ] O estado visual aparece no menor boundary coerente?
- [ ] Falhas ou pending locais não substituem áreas independentes?
- [ ] Operações independentes possuem estados independentes?
- [ ] Page-level feedback é reservado a dependências realmente page-level?
- [ ] Uma operação local não bloqueia a página inteira sem motivo?
- [ ] Partial failures preservam conteúdo que continua válido?

## Loading Lifecycle

- [ ] Initial loading e background loading são diferenciados?
- [ ] Conteúdo útil é preservado durante refetch quando possível?
- [ ] Loading desaparece quando a operação deixa de estar pending?
- [ ] Pagination/load-more preserva itens já carregados?
- [ ] Busca/filtro deixa claro quando o novo resultado ainda está sendo determinado?
- [ ] Spinner/skeleton/progress corresponde ao contexto?
- [ ] Não existe progresso falso ou atraso artificial apenas para manter loading visível?

## Empty Lifecycle

- [ ] Empty só aparece depois de sucesso conhecido?
- [ ] First-use empty e no-results permanecem distintos?
- [ ] Search/filters necessários para resolver no-results continuam disponíveis?
- [ ] Empty state não substitui resource not found, permission denied ou feature unavailable?
- [ ] Empty obsoleto desaparece quando novos dados chegam?
- [ ] Página vazia em paginação não é confundida automaticamente com coleção vazia?
- [ ] A ação sugerida realmente existe e é permitida?

## Error Lifecycle

- [ ] Initial failure e refresh failure são tratados de forma adequada?
- [ ] Conteúdo anterior útil é preservado quando refresh falha?
- [ ] Mensagens descrevem o problema do ponto de vista do usuário?
- [ ] Detalhes internos não são expostos como mensagem principal?
- [ ] Retry só é oferecido quando a operação pode ser repetida com segurança?
- [ ] Retry atua no mesmo boundary da falha quando possível?
- [ ] Falha de persistência não apaga trabalho do usuário?
- [ ] Erro persistente não depende apenas de toast temporário?
- [ ] Feedback obsoleto é removido depois de sucesso posterior?
- [ ] Error boundary não está substituindo tratamento normal de falha de API?

## Disabled Semantics

- [ ] Todo disabled possui uma condição clara?
- [ ] A condição é derivada de uma fonte de verdade real, não armazenada em paralelo?
- [ ] Capability semantics (`canSubmit`, `canDelete`) são usadas quando representam melhor a regra?
- [ ] Pending bloqueia somente ações conflitantes?
- [ ] Disabled não substitui validation, error, authorization ou security?
- [ ] Read-only foi considerado quando o valor deve permanecer consultável?
- [ ] Campo disabled não altera dados silenciosamente?
- [ ] Quando a ação é permanentemente impossível naquele contexto, sua presença foi reavaliada?
- [ ] Controles HTML usam semântica disabled nativa quando disponível?

## Communication and Recovery

- [ ] Feedback explica a condição quando ela não é evidente?
- [ ] Empty oferece próximo passo somente quando existe uma ação útil?
- [ ] Error oferece recuperação somente quando ela pode funcionar?
- [ ] Estados importantes não criam dead ends evitáveis?
- [ ] Intensidade visual corresponde à importância e ao escopo?
- [ ] Navegação e interações independentes permanecem disponíveis quando seguro?

## Cross-Cutting Boundaries

- [ ] Form-specific validation/submission errors ficaram nas referências de forms?
- [ ] Domain/capability rules ficaram na camada arquitetural adequada?
- [ ] Not-found e decisões de rota ficaram em routing?
- [ ] Semântica, announcements, focus e keyboard behavior ficaram nas referências de accessibility?
- [ ] UI state não está sendo usado como mecanismo de segurança?

## Escalation

Se um item falhar, consulte somente a referência diretamente relacionada:

```text
pending / initial loading / refetch / skeleton
→ loading.md

success sem conteúdo / first-use / no-results
→ empty.md

failure / partial failure / retry / recovery
→ error.md

unavailable interaction / capability / duplicate action
→ disabled.md
```

[HARD RULE] Não carregue `loading.md`, `empty.md`, `error.md` e `disabled.md` todos de uma vez apenas para uma revisão geral.
