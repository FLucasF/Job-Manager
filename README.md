# Harness

A governance harness for agent-assisted software work, built for Claude Code.

It defines where authority comes from, how a change gets specified and approved,
how context is loaded, who reviews, who validates and what counts as done. It is
independent of language and stack: the technologies of a project are determined
from that project, not declared to the harness.

## Abrindo o projeto

Abra como diretório de trabalho do Claude Code a pasta que contém este README. É
a partir dessa raiz que o Claude Code carrega o contrato `CLAUDE.md` como memória
de projeto e descobre as skills em `.claude/skills/`, os papéis especializados em
`.claude/agents/` e as permissões em `.claude/settings.json`.

Alterações em `CLAUDE.md`, nas skills ou nos agentes são carregadas no início da
sessão. Abra uma nova sessão depois de alterá-las.

## Componentes

| Caminho | Papel |
| --- | --- |
| `CLAUDE.md` | Contrato operacional: autoridade, workflows, gates, segurança e conclusão |
| `specs/` | Contrato dos packages de feature e templates reservados |
| `.claude/skills/` | Skills de concern (agnósticas) e overlays de stack, com referências sob demanda |
| `.claude/agents/` | Papéis independentes `reviewer` (read-only) e `verifier` (validação) |
| `.claude/settings.json` | Permissões de ferramenta do projeto |
| `.claude/validation.json` | Mapa de caminhos alterados para boundaries e comandos de validação |
| `docs/` | Documentação durável sobre o harness |
| `evals/harness/` | Avaliação manual do comportamento do agente sob este harness |

## Camadas de skill

Uma skill de **concern** cobre decisões que valem independentemente da
linguagem: arquitetura, persistência, segurança, HTTP, testes, observabilidade,
acessibilidade, formulários, estados de UI e performance.

Um **overlay de stack** carrega os idiomas de uma tecnologia. Hoje existem
`java`, `spring-boot`, `typescript`, `react`, `react-router` e `tailwind`.

O agente determina as tecnologias a partir do próprio repositório e carrega os
overlays que existirem. Quando não existe overlay, ele aplica conhecimento
próprio apenas para idiomas e declara que está fazendo isso — o harness degrada
em vez de bloquear, e funciona em um projeto de qualquer linguagem sem
configuração prévia.

## Adotando em um projeto

Copie `CLAUDE.md`, `.claude/` e `specs/` para a raiz do projeto e declare os
boundaries dele em `.claude/validation.json`: os caminhos de cada área e os
comandos de validação que já existem, com diretório de trabalho e pré-requisitos.

O manifesto declara comandos, e apenas isso. Nome de comando não se adivinha; a
stack, sim.

## Permissões locais

`.claude/settings.json` mantém `permissions.defaultMode` em `default`: o agente
pede aprovação para qualquer ferramenta fora da allowlist em vez de agir por
conta própria. A allowlist cobre apenas inspeção read-only do repositório. A
denylist bloqueia `WebSearch`, `WebFetch`, `curl`, `wget`, `git push` e a leitura
de arquivos `.env`.

O Claude Code não oferece um sandbox de rede por processo. Essas regras são
controle por política, não isolamento: um build continua podendo acessar a rede
pelo gerenciador de dependências. Uma aprovação concede apenas a capacidade
necessária à operação aprovada — ela não autoriza instalações não solicitadas,
ações externas, uso de fontes externas como requisitos nem exposição de dados.

`.claude/settings.local.json` é pessoal e não versionado.
