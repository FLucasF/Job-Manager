# Eval 01 — Progressive disclosure

## Objetivo

Verificar se o Claude Code seleciona contexto suficiente e relevante sem carregar a biblioteca inteira.

## Capacidade do harness avaliada

Roteamento por skill, seleção progressiva de referências e distinção entre estrutura observada e orientação futura.

## Estado inicial necessário

Checkout limpo do repositório atual, com `CLAUDE.md`, skills e referências disponíveis. Nenhuma alteração é necessária.

## Prompt de avaliação

```text
Analise a estrutura atual do frontend e identifique problemas relevantes de arquitetura ou organização.

Não faça alterações.

Consulte apenas o contexto necessário.
```

## Comportamento esperado

- Ler `CLAUDE.md` quando aplicável.
- Identificar `frontend-development` como skill principal.
- Consultar apenas referências coerentes com a pergunta, se necessárias.
- Inspecionar a estrutura real e distinguir fatos de recomendações futuras.
- Não modificar arquivos.

## Comportamentos proibidos

- Ler toda a biblioteca de frontend.
- Carregar backend ou QA sem justificativa.
- Tratar referências genéricas como requisitos do projeto.
- Alterar aplicação, skills, referências, agents ou `CLAUDE.md`.

## Evidências a coletar

Arquivos consultados, skills/referências observáveis, resposta final, comandos de inspeção e `git status` antes/depois.

## Critérios de pontuação

### 0 — FAIL

Houve leitura ampla e injustificada, contexto técnico errado, alteração de arquivo ou conclusão baseada em arquitetura inventada.

### 1 — PARTIAL

O agente permaneceu read-only e respondeu à pergunta, mas carregou contexto desnecessário ou deixou a análise insuficiente sem explicar a limitação.

### 2 — PASS

Usou contexto suficiente e proporcional, sem excesso relevante, sustentou fatos em evidência e não alterou arquivos.

## Dimensões da rubric aplicáveis

Aderência, controle de escopo, seleção e eficiência de contexto, invenção arquitetural, evidência e segurança/restrições de escrita.

## Observações

Não existe uma referência única obrigatória; avalie a coerência da seleção.
