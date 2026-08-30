# Migração do harness — Codex para Claude Code

**Status:** Accepted (registro de migração)

Este documento registra a migração do harness do Codex para o
Claude Code. Ele é **descritivo**: não cria requisitos de produto, não altera o
contrato em [`CLAUDE.md`](../../CLAUDE.md) nem o contrato de packages em
[`specs/README.md`](../../specs/README.md).

O objetivo do registro é permitir que a avaliação do harness distinga o que é
propriedade do desenho e o que é propriedade do agente hospedeiro.

## Motivação

O conteúdo do harness — separação de autoridade, workflow de especificação,
progressive disclosure, papéis independentes e disciplina de validação — é
agnóstico ao agente. O cabeamento não era: descoberta de contrato, skills,
subagentes e controles de execução seguiam convenções específicas do Codex, que
o Claude Code não lê.

## Mapa de equivalência aplicado

| Componente | Antes (Codex) | Depois (Claude Code) |
| --- | --- | --- |
| Contrato de entrada | `AGENTS.md` | `CLAUDE.md` |
| Skills | `.agents/skills/*/SKILL.md` | `.claude/skills/*/SKILL.md` |
| Subagentes | `.codex/agents/*.toml` | `.claude/agents/*.md` |
| Controles de execução | `.codex/config.toml` | `.claude/settings.json` |
| Modelo do reviewer | `gpt-5.6-terra`, effort `high` | `opus` |
| Modelo do verifier | `gpt-5.6-luna`, effort `low` | `haiku` |

O conteúdo textual foi preservado. Os `SKILL.md` já possuíam frontmatter
compatível (`name` e `description`) e os links internos das skills já eram
relativos, então migraram sem alteração. As `developer_instructions` dos dois
agentes foram transpostas para o corpo dos arquivos Markdown correspondentes.

## Divergências conhecidas

Estas são perdas ou mudanças de fidelidade em relação ao harness anterior. Elas
devem ser consideradas ao interpretar qualquer resultado da suíte de avaliação.

### D-001 — Read-only do reviewer não é mais garantido por sandbox

O Codex aplicava `sandbox_mode = "read-only"` ao papel `reviewer`, uma garantia
de processo. O Claude Code não possui sandbox por subagente.

A restrição passou a ser aplicada pela allowlist de ferramentas do agente, que
exclui `Edit`, `Write` e `NotebookEdit`. `Bash` permanece disponível porque a
revisão depende de `git diff`, e o corpo do agente proíbe explicitamente seu uso
para escrita.

Consequência: a falha crítica "o reviewer editar intencionalmente arquivos
durante a revisão", registrada na [rubric](../../evals/harness/rubric.md),
depende agora de instrução mais um allowlist parcial, e não de isolamento.

### D-002 — Ausência de isolamento de rede

O Codex aplicava `sandbox_workspace_write.network_access = false`. O Claude Code
não oferece equivalente por processo.

A aproximação em `.claude/settings.json` nega `WebSearch`, `WebFetch`, `curl` e
`wget`. Um build (`mvnw.cmd test`, `npm run build`) continua podendo acessar a
rede pelo gerenciador de dependências.

Consequência: controle por política, não isolamento.

### D-003 — Ausência de política de ambiente

`shell_environment_policy.ignore_default_excludes = false` excluía
automaticamente variáveis de ambiente cujos nomes contêm `KEY`, `SECRET` ou
`TOKEN`. Não há equivalente.

A aproximação nega leitura de arquivos `.env` e `.env.*`. Variáveis de ambiente
do processo permanecem visíveis a comandos executados.

### D-004 — Reasoning effort não é configurável por agente

O Codex configurava `model_reasoning_effort` por agente. No Claude Code o
frontmatter do subagente seleciona o modelo, e o esforço é herdado da sessão. A
intenção original foi aproximada pela escolha de tier: `opus` para o reviewer,
`haiku` para o verifier.

### D-005 — A suíte de avaliação mudou de agente hospedeiro

[`evals/harness/`](../../evals/harness/README.md) foi escrita para medir o
comportamento observável do Codex. Após a migração, ela mede o comportamento do
Claude Code.

Os oito casos não foram executados antes da migração. Não existe, portanto,
baseline do Codex para comparação. Qualquer resultado futuro descreve o harness
sob o Claude Code e não deve ser apresentado como comparação entre agentes.

## Limite atual da generalização

O harness foi posteriormente separado em uma camada agnóstica de stack e overlays
por tecnologia. `CLAUDE.md`, o `verifier`, o `reviewer` e as três skills de
concern não contêm nenhuma menção a linguagem ou framework.

As tecnologias de um boundary não são declaradas em configuração: o agente as
determina a partir do repositório e carrega os overlays que existirem. Quando não
existe overlay, ele aplica conhecimento próprio apenas para idiomas e declara
isso. O harness degrada em vez de bloquear, e funciona em um repositório de
qualquer linguagem sem configuração prévia.

A separação está completa nos **artefatos de governança** e **incompleta nas
referências**. Essa distinção precisa ser declarada com precisão, porque uma
versão anterior deste documento afirmava mais do que a evidência sustentava.

O que está verificado, por comando:

```bash
grep -ciE "(java|spring|jpa|maven|mvnw|lombok|react|tsx|tailwind|typescript|vite|npm|node)"   CLAUDE.md .claude/agents/verifier.md .claude/agents/reviewer.md specs/README.md   .claude/skills/backend-development/SKILL.md .claude/skills/frontend-development/SKILL.md
```

Retorna zero em todos. Os contratos, os dois papéis e os roteadores das skills de
concern não conhecem nenhuma stack.

O que **não** está resolvido, medido nas referências de concern:

| Item | Backend | Frontend |
| --- | --- | --- |
| Arquivos com regra prescritiva stack-only | 16 de 52 | 1 de 39 |
| Code fences da stack | 9 `java` | 45 `tsx`, 34 `ts` |

Exemplos concretos de regra prescritiva, não de exemplo ilustrativo:

- `security/authentication.md` — *"Use Spring Security as the authentication boundary"*;
- `persistence/queries.md` — *"Use Spring Data derived query methods"*;
- `testing/controller-testing.md` — prescreve `@WebMvcTest` e `MockMvc`;
- `performance/rendering-performance.md` — mantém as seções `## useMemo`,
  `## useCallback`, `## startTransition`, `## useDeferredValue` e
  `## Compiler Directives`.

Uma invariante anterior — `grep "^## .*\(Spring\|JPA\|React\|...\)"` — retorna
vazio, mas prova muito menos do que a frase que sustentava: ela só enxerga
cabeçalhos que contenham aquelas palavras literais, e não vê `## useMemo` nem
`Use Spring Security` em prosa. Ela foi mantida como verificação de regressão
para o que já foi extraído, e não como prova de generalidade.

A afirmação sustentável hoje é: **a arquitetura do harness é independente de
stack, e a extração do conteúdo stack-only foi iniciada e não concluída.** As 17
seções nomeadas por tecnologia foram levantadas para overlays; as regras
prescritivas em prosa e os exemplos de código continuam nas referências de
concern.

Há dois pontos de acoplamento deliberados.
[`.claude/validation.json`](../../.claude/validation.json) declara comandos, que
não são descobríveis com segurança — nome de comando não se adivinha. E
[`.claude/settings.json`](../../.claude/settings.json)
precisa nomear comandos concretos porque regras de permissão não podem ler o
manifesto; sua allowlist cita `npm run build`, `npm run lint` e `mvnw.cmd test`
literalmente. Adotar uma nova stack exige atualizar os dois.

A afirmação sustentável é que a **arquitetura e o conteúdo stack-only** estão
separados, e que a separação é verificável por comando.

## Capacidades novas ainda não exploradas

O Claude Code oferece mecanismos sem equivalente no harness anterior. Nenhum foi
adotado nesta migração; são registrados como opções, não como decisões:

- comandos de barra em `.claude/commands/*.md`, que poderiam materializar
  `Specify`, `Design`, `Tasks` e `Validate` como entradas explícitas;
- hooks em `.claude/settings.json`, que poderiam tornar executável um gate hoje
  apenas textual, como bloquear a transição `Draft → Ready` sem aprovação;
- `CLAUDE.md` adicionais por diretório, quando um projeto-alvo tiver áreas com
  convenções próprias.

## Remoção da aplicação de exemplo

O harness nasceu dentro de uma aplicação de exemplo, que servia de sujeito para a
governança. Essa aplicação foi removida: `apps/`, os documentos de domínio e de
produto, a arquitetura específica dela e o diretório de contratos não fazem mais
parte deste repositório. O histórico permanece no git.

O que restou é o harness como artefato: contrato, skills, papéis, contrato de
packages, documentação e avaliação. A consequência prática é que os casos de
avaliação que precisam de código de aplicação passaram a exigir um
**repositório-alvo** com o harness instalado, registrado junto com o commit.
Nenhum package de especificação existe, e nenhum foi executado ponta a ponta sob
o harness — essa continua sendo a evidência que falta.
