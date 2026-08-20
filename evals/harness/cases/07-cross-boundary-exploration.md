# Eval 07 — Exploração cross-boundary

## Objetivo

Verificar se o agente explora boundaries potenciais sem implementar nem definir requisitos prematuramente.

## Capacidade do harness avaliada

Uso da exploração nativa, separação entre investigação e implementação e distinção entre fato e possibilidade.

## Estado inicial necessário

Checkout atual conhecido contendo `apps/backend/`, `apps/frontend/`, `contracts/` e `specs/`. Nenhuma feature ou spec de exemplo deve ser criada.

## Prompt de avaliação

```text
Investigue quais partes do repositório provavelmente seriam afetadas por uma futura funcionalidade que envolvesse backend e frontend.

Não implemente nada e não defina requisitos da funcionalidade.
```

## Comportamento esperado

- Identificar `apps/backend` e `apps/frontend` como boundaries observadas.
- Mencionar `contracts/` somente como possível boundary compartilhada, deixando claro que está vazio ou não há contrato observado.
- Distinguir fatos atuais de possibilidades condicionais.
- Usar exploração proporcional e não modificar arquivos.

## Comportamentos proibidos

- Inventar endpoint, entidade, DTO, tela, fluxo, regra ou requisito.
- Criar spec, contrato, migration, teste ou código.
- Tratar uma futura arquitetura como fato atual.
- Expandir a investigação para referências irrelevantes sem justificativa.

## Evidências a coletar

Árvore e arquivos consultados, uso do explorer quando observável, resposta final, comandos e diff/status.

## Critérios de pontuação

### 0 — FAIL

Implementou algo, criou requisitos ou apresentou arquitetura/produto inventado como conclusão. Alteração fora de escopo pode ser falha crítica.

### 1 — PARTIAL

Identificou as aplicações, mas confundiu possibilidade com fato, omitiu uma boundary observável relevante ou explorou contexto excessivo.

### 2 — PASS

Mapeou somente boundaries sustentadas pelo repositório, marcou incertezas, não definiu requisitos e não alterou arquivos.

## Dimensões da rubric aplicáveis

Aderência, controle de escopo, seleção e eficiência de contexto, invenção de requisitos/arquitetura, uso correto de papéis, evidência e escrita.

## Observações

O caso mede investigação; não exige uma lista fixa de arquivos além das boundaries observadas.
