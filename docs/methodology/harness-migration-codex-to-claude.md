# Migração do harness — Codex para Claude Code

**Status:** Accepted (registro de migração)

Este documento registra a migração do harness do Job Manager do Codex para o
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

## Capacidades novas ainda não exploradas

O Claude Code oferece mecanismos sem equivalente no harness anterior. Nenhum foi
adotado nesta migração; são registrados como opções, não como decisões:

- comandos de barra em `.claude/commands/*.md`, que poderiam materializar
  `Specify`, `Design`, `Tasks` e `Validate` como entradas explícitas;
- hooks em `.claude/settings.json`, que poderiam tornar executável um gate hoje
  apenas textual, como bloquear a transição `Draft → Ready` sem aprovação;
- `CLAUDE.md` adicionais por diretório em `apps/backend/` e `apps/frontend/`.

## Pendências herdadas, não resolvidas por esta migração

- `npm run build` falha por arquivos ausentes importados em
  `apps/frontend/src/App.tsx`;
- `apps/backend` não possui migrations Flyway, e `contextLoads` depende de banco
  configurado;
- `docs/architecture/` permanece `Draft`, com 8 decisões `ARCH-OPEN` e 9
  `DOMAIN-OPEN` abertas;
- `specs/` não contém nenhum package.

Enquanto os dois primeiros persistirem, o `verifier` reportará `BLOCKED` na
primeira tarefa real, em qualquer agente.
