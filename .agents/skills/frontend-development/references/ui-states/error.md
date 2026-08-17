# Frontend Error States

Referência de decisões e armadilhas para falhas conhecidas na interface.

## Contents

- State meaning
- Scope and partial failures
- Initial vs refresh failure
- Messaging
- Recovery and retry
- Preserve user work
- Persistent feedback
- Known conditions
- Lifecycle
- Error boundaries
- Accessibility
- Responsibility boundaries

## State Meaning

[HARD RULE] Error representa uma operação necessária que **falhou**.

```text
pending
→ loading

success + no content
→ empty

failure
→ error
```

[HARD RULE] Não apresente empty quando a ausência de conteúdo foi causada por falha.

## Match Error to Failure Scope

[HARD RULE] O estado visual deve corresponder ao escopo da operação que falhou.

```text
primary page dependency failed
→ page-level error

independent section failed
→ section-level error

user action failed
→ action-level error
```

[DEFAULT] Represente a falha no menor boundary que mantém a interface coerente.

Não transforme falha secundária em erro da página inteira.

## Partial Failures

[DEFAULT] Interfaces com múltiplas fontes podem ter sucesso parcial.

```text
profile → success
vacancies → error
notifications → success
```

[HARD RULE] Preserve boundaries independentes.

Uma falha localizada não deve produzir erros artificiais em áreas sem dependência real.

## Preserve Useful Content

[DEFAULT] Quando refresh falha e conteúdo anterior ainda é útil, preserve-o e indique a falha da atualização.

```text
existing content
→ refresh
→ failure
→ existing content + error feedback
```

Não remova conteúdo utilizável apenas porque uma atualização falhou.

Se conteúdo estiver desatualizado e isso importar, deixe essa condição clara.

## Initial vs Refresh Failure

### Initial Failure

Sem dados utilizáveis:

```text
initial request fails
→ error replaces dependent area
```

### Refresh Failure

Com conteúdo utilizável:

```text
refresh fails
→ preserve data
→ indicate update failure
```

[DEFAULT] Esses dois cenários não precisam produzir a mesma UI.

## User-Relevant Messages

[DEFAULT] Mensagens devem descrever a operação que o usuário entende.

Prefira:

```text
Unable to load vacancies.
Unable to save changes.
```

a:

```text
Something went wrong.
Request failed.
```

quando o contexto é conhecido.

## Do Not Expose Internal Errors

[HARD RULE] Não use detalhes de infraestrutura como mensagem principal.

Não exponha diretamente:

- stack trace;
- AxiosError;
- ECONNREFUSED;
- NullPointerException;
- database constraint;
- HTTP 500 como explicação final.

Esses detalhes pertencem a diagnóstico/observabilidade.

## Known vs Unknown Errors

[DEFAULT] Use feedback específico quando a condição é realmente conhecida.

```text
RESOURCE_NOT_FOUND
→ Vacancy not found.
```

Quando a causa não é conhecida, use fallback seguro.

[HARD RULE] Não invente uma causa específica para uma falha desconhecida.

## Recovery

[DEFAULT] Ofereça recuperação quando existe uma ação real que pode mudar o estado:

- retry;
- reload section;
- return;
- corrigir condição;
- reconnect.

Não apresente ação de recuperação que não pode realmente resolver ou repetir a operação.

## Retry Safety

[HARD RULE] Retry só é apropriado quando a operação pode ser repetida com segurança.

Tenha cuidado especial com mutations que produzem efeitos:

- create;
- payment;
- invitation;
- order;
- delete.

Uma resposta de erro não garante que o servidor não executou a operação.

[HARD RULE] Não transforme retry automático em default de mutations sem garantia adequada de repetição/idempotência.

## Preserve Retry Scope

[DEFAULT] Retry deve atuar no mesmo boundary da falha quando possível.

Falha em uma seção não deve reiniciar conteúdo independente.

## Preserve User Work

[HARD RULE] Falha de persistência não deve apagar automaticamente o trabalho do usuário.

```text
user edits
→ save fails
→ preserve input
```

Regras específicas de form errors/submission pertencem às referências de forms.

## Persistent Failures Need Persistent Feedback

[DEFAULT] Toast pode complementar, mas não deve ser a única representação quando a falha continua relevante.

Evite:

```text
section failed
→ toast disappears
→ unexplained blank area
```

Mantenha feedback na área afetada enquanto a condição persistir.

## Missing Resource and Permission

[DEFAULT] Diferencie erro inesperado de condições conhecidas como:

- resource not found;
- unauthorized/forbidden.

Não represente falta de permissão como empty e não revele conteúdo protegido.

Routing e access rules pertencem às referências responsáveis.

## Latest Operation Wins

[HARD RULE] O feedback deve representar a operação relevante mais recente.

```text
attempt 1 → error
attempt 2 → success
→ old error no longer represents UI
```

Remova feedback obsoleto quando a condição muda.

## Retry State

[HARD RULE] Durante retry, diferencie falha passada de operação atualmente pendente.

Não apresente error e pending de forma contraditória como se fossem o mesmo resultado atual.

## Avoid Contradictory States

[HARD RULE] Para a mesma operação, não mostre simultaneamente conclusões incompatíveis:

```text
"No vacancies found"
+
"Unable to load vacancies"
```

Determine se houve sucesso vazio ou falha.

## Proportional Feedback

[DEFAULT] A intensidade visual deve corresponder à importância da falha.

```text
optional widget failed
→ local feedback

primary page content unavailable
→ prominent error
```

## Preserve Navigation

[DEFAULT] Quando seguro, mantenha navegação e caminhos alternativos disponíveis.

Não transforme erro recuperável em interface sem saída.

## Error Boundaries

[SITUATIONAL] Error boundaries são para falhas inesperadas de renderização, não para substituir tratamento normal de erros esperados de API.

```text
request failure
→ operation error state

render failure
→ error boundary
```

Detalhes de implementação React pertencem às referências React.

## Error Is Not Disabled

[HARD RULE] Falha e indisponibilidade são condições diferentes.

Disabled não deve esconder silenciosamente um erro.

## Forms Boundary

[HARD RULE] `ui-states/error.md` trata falhas de página, seção ou operação.

Field errors, form-level errors, server validation e submission errors específicos pertencem às referências de forms.

## Accessibility Boundary

[DEFAULT] Error deve ser identificável e compreensível sem depender apenas de aparência.

Announcements, focus management e assistive technologies pertencem às referências de accessibility.

## Responsibility Boundaries

Esta referência cobre:

- page/section/action error;
- partial failure;
- refresh failure;
- mensagens;
- recovery/retry;
- stale error lifecycle;
- render error boundary distinction.

Outras responsabilidades:

- pending → `loading.md`;
- success sem conteúdo → `empty.md`;
- unavailable interaction → `disabled.md`;
- form errors → forms;
- routing/not-found → architecture;
- semantics/announcements/focus → accessibility.
