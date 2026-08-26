# Frontend Loading States

Referência de decisões e armadilhas para operações pendentes e feedback de carregamento.

## Contents

- State meaning
- Initial vs background loading
- Scope
- Feedback strategy
- Concurrent operations
- Interaction during pending
- Pagination, filtering and navigation
- Source of truth
- Forms and accessibility
- Responsibility boundaries

## State Meaning

[HARD RULE] Loading representa uma operação realmente pendente cujo resultado necessário ainda não é conhecido.

```text
pending
→ loading

success + no content
→ empty

failure
→ error
```

[HARD RULE] Não infira loading apenas porque `data` está ausente.

A ausência de dados também pode representar estado não inicializado, erro ou outra condição.

## Initial vs Background Loading

[HARD RULE] Diferencie primeiro carregamento de atualização posterior.

### Initial Loading

[DEFAULT] Quando ainda não existe conteúdo utilizável, feedback de loading pode substituir temporariamente a área dependente da operação.

```text
no previous data
+ request pending
→ initial loading
```

### Background Loading

[DEFAULT] Quando conteúdo utilizável já existe, preserve-o durante refetch quando continuar correto.

```text
existing content
+ refetch pending
→ preserve content
+ contextual loading feedback
```

[HARD RULE] Não apague conteúdo útil apenas porque uma atualização começou.

Se dados antigos permanecerem visíveis, não os apresente como se já representassem necessariamente o novo resultado quando essa distinção importar.

## Match Feedback to Scope

[HARD RULE] O feedback deve corresponder ao escopo real da operação.

```text
page dependency pending
→ page-level loading

section dependency pending
→ section-level loading

user action pending
→ action-level loading
```

[DEFAULT] Represente a operação no menor boundary que preserve uma interface coerente.

Não use loading global para operações pequenas e independentes.

## Keep Independent Operations Independent

[HARD RULE] Não controle operações independentes com um único `isLoading` genérico.

Uma interface pode ter simultaneamente:

```text
profile query
→ success

vacancies query
→ pending

save mutation
→ pending
```

Cada operação precisa de estado suficiente para representar seu próprio ciclo.

## Choose Feedback by Context

Use o feedback que corresponde ao tipo de espera:

- spinner;
- skeleton;
- progress indicator;
- inline pending state;
- button feedback.

### Spinner

[SITUATIONAL] Adequado principalmente para operações indeterminadas, pequenas ou localizadas.

Evite vários spinners simultâneos e spinner de página inteira para uma operação local.

### Skeleton

[SITUATIONAL] Use quando a estrutura aproximada do conteúdo esperado é conhecida.

[DEFAULT] Preserve espaço compatível com o conteúdo quando isso reduz layout shift sem inventar dimensões artificiais.

### Progress

[SITUATIONAL] Mostre progresso determinado somente quando ele é realmente conhecido.

[HARD RULE] Não apresente porcentagens falsas como progresso real.

## Do Not Present Results Before They Exist

[HARD RULE] Enquanto a operação estiver pendente, não conclua:

```text
"No items"
```

nem:

```text
"Unable to load"
```

Empty exige sucesso conhecido sem conteúdo. Error exige falha conhecida.

## Pending Does Not Mean Disable Everything

[HARD RULE] Uma operação pendente não torna toda a interface indisponível.

Bloqueie somente interações conflitantes.

```text
save pending
→ prevent duplicate save
→ preserve navigation and unrelated controls when safe
```

[HARD RULE] Não dependa da velocidade do usuário para evitar submissões ou mutations duplicadas.

Regras detalhadas de indisponibilidade pertencem a `disabled.md`.

## Preserve Safe Interaction

[DEFAULT] Conteúdo já carregado deve continuar utilizável durante operações em background quando isso não cria inconsistência.

Evite:

```text
any request pending
→ entire interface unavailable
```

## Avoid Loading Flicker

[DEFAULT] Se operações muito rápidas geram flicker recorrente, use uma estratégia que estabilize o feedback.

[HARD RULE] Não atrase conteúdo pronto apenas para completar animação ou atingir duração mínima decorativa.

## Pagination

[DEFAULT] Ao carregar uma página adicional, preserve os itens já disponíveis.

```text
existing items
+ next page pending
→ existing items
+ "loading more"
```

Não substitua toda a coleção por loading quando apenas um segmento adicional está sendo carregado.

## Filtering and Search

[DEFAULT] Durante nova busca/filtro, escolha conscientemente entre:

- preservar resultados anteriores enquanto o novo resultado é determinado;
- substituir a área por loading.

Se resultados anteriores permanecerem, deixe claro que a nova consulta ainda está pendente.

## Navigation

[SITUATIONAL] Em mudança de rota, aplique loading no boundary da rota/conteúdo que realmente depende da operação.

Não transforme toda navegação em bloqueio global.

Decisões de navegação pertencem à referência de routing.

## Use the Operation State as Source of Truth

[HARD RULE] Não crie `isLoading`, `isFetching` ou `isPending` paralelos quando a ferramenta responsável pela operação já fornece o estado necessário.

Evite fontes de verdade duplicadas.

Onde server state deve viver pertence às referências de architecture.

## Form Submission

[DEFAULT] Separe:

```text
form values
→ form state

submit pending
→ submission state
```

Não misture dados editáveis com o estado de execução da submissão.

Regras detalhadas pertencem às referências de forms.

## Current Operation Wins

[HARD RULE] Loading deve refletir o ciclo atual.

```text
pending → loading
success → content/empty
failure → error
```

Quando a operação deixa de estar pendente, o loading correspondente deixa de representar a interface.

## Accessibility Boundary

[DEFAULT] Loading precisa ser perceptível e compreensível sem depender exclusivamente de animação, cor ou movimento.

Semântica, announcements e focus management pertencem às referências de accessibility.

## Responsibility Boundaries

Esta referência cobre:

- pending;
- initial/background loading;
- page/section/action loading;
- spinner/skeleton/progress;
- concurrent operations;
- pending interaction;
- pagination/search/navigation loading.

Outras responsabilidades:

- success sem conteúdo → `empty.md`;
- falha conhecida → `error.md`;
- indisponibilidade de interação → `disabled.md`;
- submission → forms;
- server-state placement → architecture;
- announcements/focus → accessibility.
