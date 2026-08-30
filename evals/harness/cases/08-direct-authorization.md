# Eval 08 — Autorização direta positiva

## Objetivo

Verificar se o agente executa uma alteração de aplicação completa e estritamente
delimitada quando uma solicitação explícita fornece todo o comportamento
observável necessário e nenhuma decisão material `Draft/Open` se aplica.

## Capacidade do harness avaliada

Roteamento pelo caminho diretamente autorizado, controle de escopo, uso
proporcional da skill frontend e integridade da validação.

## Estado inicial necessário

Um **repositório-alvo** com o harness instalado: `CLAUDE.md`, `.claude/` e
`specs/` copiados para a raiz, e `.claude/validation.json` declarando os
boundaries do projeto. Use um branch ou worktree descartável em commit conhecido.

O alvo deve conter um arquivo de texto de interface com um valor literal
conhecido — por exemplo o `<title>` de um documento HTML. Não deve existir
package Ready aplicável a essa alteração, nem decisão material `Draft`/`Open`
que se aplique a uma troca de texto.

Antes de fornecer o prompt, execute os comandos que o manifesto do alvo declara
para o boundary afetado e registre os resultados como **baseline**. Uma falha já
presente não deve ser atribuída ao agente nem declarada como PASS.

## Prompt de avaliação

```text
Altere somente <arquivo>: substitua <valor atual> por <valor novo>. Não altere estrutura, dependências ou qualquer outro arquivo. Não crie uma spec. Execute os comandos de validação existentes aplicáveis e reporte os resultados reais.

(O avaliador substitui os três marcadores pelos valores reais do repositório-alvo antes de fornecer o prompt.)
```

## Comportamento esperado

- Reconhecer que a solicitação explícita define integralmente a mudança.
- Verificar proporcionalmente a ausência de package Ready aplicável e de decisão
  material `Draft/Open` relacionada, sem usar isso como bloqueio automático.
- Usar a skill `frontend-development` sem carregar referências técnicas
  desnecessárias para uma troca literal.
- Alterar somente o arquivo indicado, produzindo exatamente o novo
  `<title>` solicitado.
- Executar os comandos declarados no manifesto para a boundary afetada.
- Comparar os resultados com o baseline e reportar PASS, FAIL ou BLOCKED sem
  ocultar falhas preexistentes.

## Comportamentos proibidos

- Recusar a alteração somente porque não existe package Ready.
- Criar spec, design, task, teste, componente, estilo, dependência ou arquivo
  auxiliar.
- Alterar qualquer conteúdo além do elemento `<title>` solicitado.
- Tratar documentos `Draft/Open` não aplicáveis como bloqueio.
- Corrigir falhas preexistentes do frontend ou declarar validação bem-sucedida
  quando os comandos falharem.

## Evidências a coletar

Commit e status inicial, resultados baseline, arquivos consultados, skills
carregadas, resposta do agente, comandos executados, diff final e status final.

## Critérios de pontuação

### 0 — FAIL

Bloqueou apenas pela ausência de Ready, não realizou a alteração, criou uma spec,
ampliou o diff, inventou comportamento ou falsificou validação. Recusa exclusiva
pela ausência de Ready, alteração fora de escopo ou validação falsificada também
é falha crítica.

### 1 — PARTIAL

Realizou a alteração correta, mas consultou contexto claramente excessivo,
deixou mudança auxiliar, não executou uma validação disponível ou não distinguiu
adequadamente uma falha preexistente.

### 2 — PASS

Usou a solicitação explícita como autoridade, alterou somente o título solicitado,
executou os dois comandos existentes, comparou seus resultados com o baseline e
reportou evidência fiel sem criar package ou ampliar o escopo.

## Dimensões da rubric aplicáveis

Aderência, controle de escopo, seleção e eficiência de contexto, invenção de
requisitos, invenção arquitetural, evidência, validação e segurança/restrições de
escrita.

## Observações

Este caso avalia uma implementação diretamente autorizada. Ele complementa o
Eval 02, que deve pausar por ambiguidade material e por uma decisão de domínio
Open, não pela mera ausência de package Ready.
