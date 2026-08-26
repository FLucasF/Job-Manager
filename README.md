# Job Manager

## Abrindo o projeto no Claude Code

Abra como diretório de trabalho do Claude Code a pasta que contém este README. É
a partir dessa raiz que o Claude Code carrega o contrato `CLAUDE.md` como
memória de projeto e descobre as três skills locais em `.claude/skills/`, os
papéis especializados em `.claude/agents/` e as permissões em
`.claude/settings.json`.

Não abra o diretório pai como raiz operacional e não duplique nele esses
arquivos. A configuração é intencionalmente local ao projeto `job-manager`.

Alterações em `CLAUDE.md`, nas skills ou nos agentes são carregadas no início da
sessão. Abra uma nova sessão depois de alterá-las.

## Componentes do harness

| Caminho | Papel |
| --- | --- |
| `CLAUDE.md` | Contrato operacional: autoridade, workflows, gates, segurança e conclusão |
| `.claude/skills/` | Skills por boundary com referências carregadas sob demanda |
| `.claude/agents/` | Papéis independentes `reviewer` (read-only) e `verifier` (validação) |
| `.claude/settings.json` | Permissões de ferramenta do projeto |
| `specs/` | Packages de feature e templates reservados |
| `docs/` | Produto, domínio, arquitetura e metodologia duráveis |
| `contracts/` | Contratos externos compartilhados quando aplicável |
| `evals/harness/` | Avaliação manual do comportamento do agente sob este harness |

## Permissões locais

`.claude/settings.json` mantém `permissions.defaultMode` em `default`: o agente
pede aprovação para qualquer ferramenta fora da allowlist em vez de agir por
conta própria.

A allowlist cobre apenas inspeção read-only do repositório (`git status`,
`git diff`, `git log`, `git show`, `git ls-files`) e os comandos de validação que
já existem no projeto (`npm run build`, `npm run lint`, `mvnw.cmd test`).

A denylist bloqueia `WebSearch`, `WebFetch`, `curl`, `wget`, `git push` e a
leitura de arquivos `.env`.

O Claude Code não oferece um sandbox de rede por processo. As regras acima são
controle por política, não isolamento: um build continua podendo acessar a rede
através do gerenciador de dependências. Uma aprovação concede apenas a
capacidade necessária à operação aprovada — ela não autoriza instalações não
solicitadas, ações externas, uso de fontes externas como requisitos nem
exposição de dados. Essas ações continuam limitadas pelo pedido do usuário e
pelo contrato em `CLAUDE.md`.

`.claude/settings.local.json` é pessoal e não versionado.

## Aplicações

- `apps/backend/` — Java 21 / Spring Boot. Validação: `apps/backend/mvnw.cmd test`.
- `apps/frontend/` — React / TypeScript / Vite. Validação: `npm run build` e
  `npm run lint` a partir de `apps/frontend`.
