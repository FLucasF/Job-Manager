# Frontend Forms Review Checklist

Checklist operacional para revisão de formulários.

[DEFAULT] Use este arquivo primeiro em code review de forms.

[HARD RULE] Consulte somente a referência detalhada relacionada ao item que exigir investigação.

## Form State

- [ ] Cada campo possui uma única fonte de verdade?
- [ ] Form state representa somente o draft editável?
- [ ] Server state não é usado diretamente como draft?
- [ ] Valores iniciais são explícitos?
- [ ] Refetch não sobrescreve alterações do usuário?
- [ ] Reset representa uma transição intencional?
- [ ] Dirty e touched permanecem distintos?
- [ ] Valores derivados não são armazenados sem necessidade?
- [ ] Conditional fields têm regra explícita para preservar/limpar/excluir valor?
- [ ] Estado de UI/submission não foi colocado dentro dos valores?

## Validation

- [ ] Frontend validation é feedback, não autoridade final?
- [ ] Valores sabidamente inválidos não são submetidos?
- [ ] Cada regra local possui uma fonte clara?
- [ ] Field e cross-field validation estão separados corretamente?
- [ ] Schema e form state continuam responsabilidades diferentes?
- [ ] Tipos e regras de validação são coerentes?
- [ ] Errors aparecem apenas quando úteis?
- [ ] Empty/optional semantics são consistentes?
- [ ] Validation e transformation não foram misturadas?
- [ ] Async validation existe somente quando necessária?
- [ ] Regras complexas de domínio não foram copiadas para o formulário sem justificativa?

## Submission

- [ ] Form component não executa HTTP diretamente?
- [ ] FormValues são transformados quando o input da operação difere?
- [ ] Existe uma única fonte de verdade para pending?
- [ ] Submissão duplicada é evitada quando necessário?
- [ ] Draft permanece durante pending e failure?
- [ ] Reset ocorre somente como consequência intencional?
- [ ] Navigation/toast/modal/reset ficaram fora do Repository?
- [ ] Create e update permanecem intenções explícitas?
- [ ] Resultado da mutation não foi duplicado em estados paralelos?
- [ ] Retry só existe quando a operação pode ser repetida com segurança?

## Error Handling

- [ ] Field errors pertencem ao campo correto?
- [ ] Cross-form problems usam form-level error?
- [ ] Server validation errors são normalizados?
- [ ] Falhas gerais não são forçadas em campos?
- [ ] A mesma falha não aparece em vários canais sem necessidade?
- [ ] Error stale é limpo/reavaliado quando a condição muda?
- [ ] Erro conhecido tem mapping específico e erro desconhecido tem fallback seguro?
- [ ] Mensagens técnicas internas não são expostas?
- [ ] Error mappers permanecem puros?
- [ ] Field errors preservam associação acessível com seus controles?

## Cross-Cutting Boundaries

- [ ] Form state, validation, submission e errors possuem ownership distinto?
- [ ] Data access segue architecture?
- [ ] UI loading/error/disabled genérico segue ui-states?
- [ ] Accessibility mechanics seguem accessibility?
- [ ] Effects não estão sendo usados para sincronizar continuamente server state com form state?
- [ ] Não existem abstrações adicionais sem responsabilidade concreta?

## Escalation

```text
draft / defaults / reset / dirty / touched / conditional values
→ form-state.md

rules / schema / timing / optional / async validation
→ validation.md

mapping / pending / submit / create-update / retry
→ submission.md

field-form-server-submission errors / mapping / messages
→ error-handling.md
```

[HARD RULE] Não carregue todas as referências de forms apenas para uma revisão geral.
