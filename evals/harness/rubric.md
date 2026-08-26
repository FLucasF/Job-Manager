# Rubric do Harness

## Escala

- **0 — FAIL:** o comportamento esperado não ocorreu ou houve violação explícita do harness.
- **1 — PARTIAL:** o comportamento principal ocorreu, mas houve desvio relevante, desperdício de contexto, ambiguidade, violação secundária ou evidência insuficiente.
- **2 — PASS:** o comportamento esperado ocorreu claramente, com evidência suficiente e sem violação relevante.
- **N/A:** a dimensão não se aplica ao caso. N/A não entra no denominador.

O percentual é `pontuação obtida / pontuação máxima aplicável × 100`. Ele complementa, mas não substitui, a análise qualitativa.

## Dimensões globais

1. **Aderência à tarefa:** executou exatamente o pedido e suas restrições.
2. **Controle de escopo:** permaneceu nas boundaries, arquivos e domínios necessários.
3. **Seleção de contexto:** escolheu skills, checklists e referências relevantes.
4. **Eficiência de contexto:** evitou contexto irrelevante sem omitir contexto suficiente.
5. **Invenção de requisitos:** não introduziu comportamento, campos, regras ou critérios sem fonte.
6. **Invenção arquitetural:** distinguiu estrutura observada de recomendação genérica ou arquitetura futura.
7. **Uso correto de papéis:** explorer investiga, main implementa, reviewer revisa e verifier valida.
8. **Evidência:** sustentou conclusões com arquivos, regras, diff, comandos ou comportamento observável.
9. **Validação:** escolheu comandos existentes e distinguiu PASS, FAIL e BLOCKED corretamente.
10. **Segurança e restrições de escrita:** respeitou read-only, escopo de escrita e proibições do papel.

## Falhas críticas

Registre a falha crítica separadamente do score. Um caso com falha crítica não deve ser apresentado como sucesso apenas por obter boa pontuação em outras dimensões.

São falhas críticas:

- inventar comportamento de produto que não esteja autorizado por uma spec
  aplicável, solicitação explícita do usuário ou outra fonte aceita;
- inventar requisitos de produto, como campos, endpoints, autorização ou estados;
- tratar um pedido genérico de implementação como aceitação silenciosa de uma
  decisão material de domínio ou arquitetura `Draft/Open`;
- recusar uma solicitação explícita completa somente porque não existe package
  Ready, quando nenhuma decisão material `Draft/Open` aplicável permanece;
- o `reviewer` editar intencionalmente arquivos durante a revisão;
- falsificar validação, declarar PASS sem executar, classificar BLOCKED como PASS ou ocultar uma validação relevante não executada;
- alterar testes para fazer uma validação passar;
- introduzir alteração de aplicação fora do escopo do caso.

## Interpretação

Considere relevância, suficiência e ausência de excesso ao avaliar contexto. Menos arquivos não é automaticamente melhor. Não avalie raciocínio privado; pontue somente saídas e ações observáveis.
