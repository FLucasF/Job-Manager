# Evals do Harness

## Propósito

Esta suíte avalia o comportamento observável do Claude Code dentro deste harness: aderência ao contrato do repositório, seleção de contexto, controle de escopo, uso de papéis, disciplina de validação e separação entre fatos, orientação técnica e requisitos.

Ela não é um benchmark geral do modelo, não mede isoladamente conhecimento de
Java, React ou Spring e não avalia qualidade funcional de um produto. O
roteamento entre package Ready e solicitação explícita é avaliado; a estrutura
interna dos packages continua uma convenção documental, sem validador
automatizado nesta versão.

## Casos

Os oito casos em `cases/` usam prompts literais, precondições, evidências e a
escala comum definida em `rubric.md`. Eles avaliam progressive disclosure, os
caminhos bloqueado e positivo sem spec aplicável, escopo, não invenção
arquitetural, os papéis `reviewer` e `verifier` e exploração cross-boundary.

## Repositório-alvo

O harness é uma camada de governança, não uma aplicação. Alguns casos avaliam o
agente sobre o próprio harness (03 e 05); os demais precisam de código de
aplicação para governar.

Esses casos rodam contra um **repositório-alvo**: um projeto com o harness
instalado — `CLAUDE.md`, `.claude/` e `specs/` na raiz — e com
`.claude/validation.json` declarando seus boundaries e comandos. O alvo é
escolhido pelo avaliador e registrado junto com o commit, porque o resultado só é
comparável entre execuções que usem o mesmo alvo no mesmo estado.

Não use o repositório do harness como alvo: ele não tem boundaries de aplicação,
e forçar isso mede outra coisa.

## Modalidades de execução

A observabilidade depende de como o caso é executado, e isso muda quais campos do
`run-record.md` podem ser preenchidos:

- **Sessão de topo** (`claude` no terminal): o transcript fica em
  `~/.claude/projects/` e permite registrar arquivos consultados, skills e
  referências. É a modalidade canônica.
- **Subagente**: mede comportamento e custo, mas o transcript pode não ser
  recuperável. Nesse caso, arquivos consultados, skills e referências são
  `não observável` **por limite da modalidade**, e isso deve ser declarado no
  registro em vez de parecer omissão.

## Execução manual reproduzível

Para executar um caso:

1. registre o commit e o estado inicial;
2. prepare as precondições em um commit, branch ou worktree isolado;
3. forneça exatamente o prompt documentado;
4. registre a resposta e as ações observáveis do agente;
5. registre arquivos consultados, quando observável;
6. registre arquivos alterados, comandos executados, validações e subagentes utilizados, quando observável;
7. aplique a rubric sem solicitar ou inferir chain-of-thought;
8. salve o resultado usando `templates/run-record.md` e `templates/scorecard.md`.

Cada execução deve começar de um estado conhecido e não deve reutilizar alterações produzidas por outro caso. A automação de worktrees não faz parte desta versão.

Quando um dado não puder ser observado, registre `não observável`; não o infira.

## Isolamento e comparações futuras

Casos que exigem diff, alteração controlada ou tentativa de escrita devem usar
um worktree ou branch dedicado. A suíte foi escrita para permitir comparações
futuras entre configurações de harness, mas nenhuma dessas comparações é
executada aqui.

Não altere `CLAUDE.md`, skills, referências, agents ou guardrails apenas para melhorar uma pontuação hipotética. Primeiro execute e observe; somente evidência real pode justificar evolução do harness.

## Métricas futuras

Execuções futuras podem ser agregadas por taxa de sucesso por caso, média por dimensão, violações de escopo, invenção de requisitos ou arquitetura, uso correto de papéis, validação correta, contexto excessivo e falhas críticas. Não agregue tokens, custo ou outras métricas sem dados observáveis.

Um score maior mede propriedades do agente dentro deste harness; não prova que o software produzido seja funcionalmente melhor. Falhas críticas devem permanecer destacadas mesmo quando a pontuação numérica for alta.
