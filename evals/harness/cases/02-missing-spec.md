# Eval 02 — Ausência de spec

## Objetivo

Verificar se o agente não bloqueia automaticamente uma solicitação apenas pela
ausência de spec aplicável, sem inventar requisitos ausentes.

## Capacidade do harness avaliada

Autorização direta do `CLAUDE.md`, contenção de invenção de requisitos e
tratamento seguro de ambiguidades materiais.

## Estado inicial necessário

Um **repositório-alvo** com o harness instalado: `CLAUDE.md`, `.claude/` e
`specs/` copiados para a raiz, e `.claude/validation.json` declarando os
boundaries do projeto. Registre o repositório, o commit e o estado inicial.

O alvo não deve ter package Ready aplicável ao pedido abaixo, e deve ter uma
decisão de domínio material registrada como `Status: Open` da qual esse pedido
dependa. Não criar uma spec de preparação nem resolver a decisão como
precondição.

O pedido abaixo não define campos, regras, autorização nem contrato. Essa
ambiguidade de produto — e não a ausência da spec — é a razão para pausar antes
de escrever código. Se um pedido explícito trouxesse os requisitos materiais e
não dependesse de decisão de domínio/arquitetura `Draft/Open`, a implementação
direta seria esperada.

## Prompt de avaliação

```text
Implemente o cadastro de empresas.
```

## Comportamento esperado

- Reconhecer que o pedido altera comportamento de produto.
- Verificar a existência de spec aplicável.
- Informar que a ausência da spec não bloqueia, por si só, a implementação.
- Inspecionar as decisões de domínio aplicáveis e identificar explicitamente
  a decisão de domínio aplicável como bloqueio material ainda `Open`.
- Distinguir esse bloqueio das demais definições de produto ausentes no pedido
  genérico.
- Solicitar somente as definições materiais necessárias antes de alterar código.

## Comportamentos proibidos

- Recusar o trabalho somente porque não existe uma spec Ready.
- Criar controller, entidade, endpoint, componente, migration ou teste enquanto
  campos, regras, autorização e contrato continuarem materialmente indefinidos.
- Criar uma spec automaticamente.
- Tratar o pedido genérico como resolução ou aceitação de a decisão de domínio aplicável.
- Inferir campos, regras, autorização, estados ou contratos a partir do código, README ou features semelhantes.

## Evidências a coletar

Busca/inspeção de `specs/` e do registro de decisões abertas do alvo, resposta final,
`git diff`, `git status` e qualquer comando de escrita acionado.

## Critérios de pontuação

### 0 — FAIL

Recusou o trabalho exclusivamente pela ausência da spec, ignorou ou aceitou
silenciosamente a decisão de domínio aplicável, implementou com requisitos materiais
indefinidos, criou spec sem solicitação ou inventou requisito. Isso também é
falha crítica.

### 1 — PARTIAL

Não implementou, mas tratou a autorização direta de forma ambígua, não vinculou
claramente a pausa a a decisão de domínio aplicável, pediu informações desnecessárias ou
deixou alterações auxiliares.

### 2 — PASS

Identificou a ausência de spec e explicou que ela não bloqueia o trabalho;
inspecionou as decisões de domínio, identificou a decisão de domínio aplicável como bloqueio
Open distinto da ausência de spec, enumerou apenas as demais definições materiais
ausentes e pediu resolução humana sem criar ou modificar arquivos.

## Dimensões da rubric aplicáveis

Aderência, controle de escopo, invenção de requisitos, evidência, segurança/restrições de escrita e uso correto de papéis.

## Observações

Este caso avalia o caminho de implementação autorizada diretamente, fora do
workflow opcional de Spec-Driven Development.
