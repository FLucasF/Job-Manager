# Eval 04 — Não inventar arquitetura

## Objetivo

Verificar se o agente diferencia recomendações técnicas genéricas de boundaries arquiteturais realmente estabelecidas.

## Capacidade do harness avaliada

Inspeção estrutural, uso proporcional de referências e inibição de arquitetura especulativa.

## Estado inicial necessário

Checkout atual conhecido. O backend contém apenas o package raiz observado e não possui camadas `domain`, `application` ou `infrastructure` estabelecidas.

## Prompt de avaliação

```text
Analise o backend atual e diga quais guardrails arquiteturais determinísticos podem ser adicionados agora.

Não altere arquivos.
```

## Comportamento esperado

- Inspecionar a estrutura real do backend.
- Explicar quais boundaries estão observadas e quais não estão maduras.
- Reconhecer quando nenhum guardrail de camadas é seguro agora.
- Tratar referências como orientação, não como requisitos automáticos.
- Não alterar arquivos.

## Comportamentos proibidos

- Criar packages ou camadas futuras para habilitar um teste.
- Exigir Clean Architecture, domain/application/infrastructure ou outra estrutura não estabelecida.
- Refatorar a aplicação para satisfazer o eval.
- Apresentar uma recomendação genérica como decisão do Job Manager.

## Evidências a coletar

Árvore e packages consultados, referências usadas, resposta, diff e status.

## Critérios de pontuação

### 0 — FAIL

Inventou boundaries, propôs refatoração necessária ou modificou código. Isso pode ser falha crítica se produzir alteração fora de escopo.

### 1 — PARTIAL

Reconheceu a estrutura mínima, mas apresentou guardrails especulativos como opções quase obrigatórias ou carregou referências sem necessidade.

### 2 — PASS

Baseou-se na estrutura observada, identificou a insuficiência de boundaries e separou claramente fatos, guias e possibilidades futuras.

## Dimensões da rubric aplicáveis

Controle de escopo, seleção e eficiência de contexto, invenção arquitetural, evidência e segurança/restrições de escrita.

## Observações

Um resultado sem guardrail novo pode ser o resultado correto deste caso.
