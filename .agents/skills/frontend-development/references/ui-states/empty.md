# Frontend Empty States

Referência de decisões e armadilhas para resultados válidos sem conteúdo.

## Contents

- State meaning
- Scope
- First-use vs no-results
- Communication and actions
- Collections and resources
- Lifecycle
- Refresh and pagination
- Permissions and availability
- Accessibility
- Responsibility boundaries

## State Meaning

[HARD RULE] Empty representa **sucesso conhecido sem conteúdo**.

```text
pending
→ loading

success + no content
→ empty

failure
→ error
```

[HARD RULE] Não infira empty apenas porque `data` está ausente.

Só apresente empty depois que a ausência de conteúdo for conhecida.

## Match Empty State to Scope

[HARD RULE] O empty state deve corresponder ao escopo do conteúdo ausente.

```text
whole page has no primary content
→ page-level empty

one section has no content
→ section-level empty

collection has no items
→ collection empty

search/filter matches nothing
→ no-results
```

[DEFAULT] Preserve estrutura útil ao redor:

- navigation;
- page title;
- filters;
- search;
- primary actions que continuam válidas.

Não substitua toda a página quando apenas uma seção está vazia.

## First-Use vs No Results

[HARD RULE] Diferencie conteúdo que ainda não existe de conteúdo que não corresponde à busca/filtro atual.

### First-Use Empty

Use quando quantidade zero é um estado válido da coleção:

```text
No vacancies yet.
```

Pode explicar:

- o que a área contém;
- por que está vazia;
- próximo passo válido.

### No Results

Use quando conteúdo pode existir, mas nenhum item corresponde às condições atuais:

```text
No vacancies match your filters.
```

[HARD RULE] Não apresente mensagem de first-use quando filtros apenas eliminaram todos os resultados.

## Preserve Search and Filters

[DEFAULT] Em no-results, preserve os controles e condições que produziram o resultado.

Ações possíveis:

- clear filters;
- adjust filters;
- clear search;
- change search term.

[HARD RULE] Não limpe filtros automaticamente só porque a consulta retornou zero itens.

## Communicate the Situation

[DEFAULT] Prefira mensagens contextuais a mensagens genéricas.

Prefira:

```text
No applications have been received yet.
```

a:

```text
No data.
```

Quando necessário, ajude a responder:

- o que está ausente?
- por quê?
- o que pode ser feito agora?

Não precisa responder a tudo em todo empty state.

## Provide a Useful Next Action

[DEFAULT] Quando existir uma ação natural para sair do estado vazio, ofereça-a.

```text
No vacancies yet.
[Create vacancy]
```

[HARD RULE] Não invente ações que o usuário ou fluxo atual não suportam.

Se o usuário não pode criar, não ofereça “Create” só para preencher espaço.

## Preserve Controls That Resolve the State

[DEFAULT] Search e filters devem continuar disponíveis em no-results quando ajudam a sair daquele estado.

Controles que dependem de itens existentes podem deixar de ser aplicáveis:

```text
0 items
→ no bulk delete
→ no select all
```

Indisponibilidade pertence a `disabled.md`.

## Empty Collection vs Missing Resource

[HARD RULE] Uma coleção válida sem itens é diferente de um recurso inexistente.

```text
GET /vacancies
→ 200 []
→ empty collection
```

é diferente de:

```text
GET /vacancies/999
→ resource not found
```

Não apresente resource not found como “No vacancies yet”.

Routing/not-found pertence às referências de architecture.

## Transition Into and Out of Empty

[HARD RULE] Empty deve refletir o resultado válido mais recente.

Depois de remover o último item:

```text
1 item
→ delete
→ 0 items
→ empty
```

Depois de aplicar filtros:

```text
items exist
→ filter
→ 0 matches
→ no-results
```

Quando novos dados chegam:

```text
old success []
→ new success [items]
→ remove empty state
```

Não preserve empty obsoleto.

## Background Refresh

[HARD RULE] Durante refetch, não substitua conteúdo existente por empty antes de conhecer o novo resultado.

Preserve conteúdo útil ou feedback de loading apropriado enquanto o resultado ainda é desconhecido.

## Error Language

[HARD RULE] Empty não é falha.

Evite:

```text
Failed to find vacancies.
```

quando a operação terminou corretamente.

Da mesma forma, não use “No items” para esconder request que falhou.

## Pagination

[DEFAULT] Uma página paginada sem itens não prova que toda a coleção está vazia.

```text
page 1 + total 0
→ collection empty

later page + no items
→ page may be invalid/outdated
```

Ajuste a navegação quando necessário.

## Permissions and Feature Availability

[HARD RULE] Não use empty para representar silenciosamente:

- falta de permissão;
- feature indisponível;
- plano sem acesso;
- recurso inexistente.

Essas condições possuem significados próprios.

## Blank Forms

[HARD RULE] Formulário inicialmente sem valores não é UI empty state.

Isso pertence ao estado normal do formulário.

## Visual Intensity

[DEFAULT] Não transforme todo empty state em uma composição decorativa grande.

Use ilustração quando ajuda; uma mensagem simples é suficiente para estados pequenos.

## Accessibility Boundary

[DEFAULT] O estado deve ser compreensível por texto e estrutura semântica.

Não dependa apenas de ilustração, ícone ou cor para comunicar ausência.

## Responsibility Boundaries

Esta referência cobre:

- success sem conteúdo;
- first-use;
- no-results;
- collection/page/section empty;
- ações e recuperação;
- lifecycle de empty.

Outras responsabilidades:

- resultado ainda desconhecido → `loading.md`;
- falha → `error.md`;
- controles indisponíveis → `disabled.md`;
- resource not found/routing → architecture;
- forms → forms;
- semântica → accessibility.
