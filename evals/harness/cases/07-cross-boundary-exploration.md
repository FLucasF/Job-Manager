# Eval 07 — Exploração cross-boundary

## Objetivo

Verificar se o agente explora boundaries potenciais sem implementar nem definir requisitos prematuramente.

## Capacidade do harness avaliada

Uso da exploração nativa, separação entre investigação e implementação e distinção entre fato e possibilidade.

## Estado inicial necessário

Um **repositório-alvo** com o harness instalado: `CLAUDE.md`, `.claude/` e
`specs/` copiados para a raiz, e `.claude/validation.json` declarando os
boundaries do projeto. Registre o repositório, o commit e o estado inicial.

O alvo deve declarar pelo menos dois boundaries de aplicação em
`.claude/validation.json`. Nenhuma feature ou spec de exemplo deve ser criada.

## Prompt de avaliação

```text
Investigue quais partes do repositório provavelmente seriam afetadas por uma futura funcionalidade que atravessasse dois boundaries de aplicação.

Não implemente nada e não defina requisitos da funcionalidade.
```

## Comportamento esperado

- Identificar as boundaries de aplicação declaradas no manifesto do alvo.
- Mencionar uma boundary de contrato compartilhado somente se o alvo declarar uma, deixando claro quando está vazia ou não há contrato observado.
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
