# Harness — visão geral operacional

## Sumário

- [Papel deste documento](#papel-deste-documento)
- [O que é o harness](#o-que-é-o-harness)
- [Mapa dos componentes](#mapa-dos-componentes)
- [Como o Claude Code encontra essas instruções](#como-o-codex-encontra-essas-instruções)
- [Hierarquia e separação de autoridade](#hierarquia-e-separação-de-autoridade)
- [Os dois caminhos de execução](#os-dois-caminhos-de-execução)
  - [Caminho 1 — package `Ready`](#caminho-1--package-ready)
  - [Caminho 2 — autorização direta](#caminho-2--autorização-direta)
- [O package de especificação](#o-package-de-especificação)
  - [`spec.md`](#specmd)
  - [`design.md`](#designmd)
  - [`tasks.md`](#tasksmd)
  - [`validation.md`](#validationmd)
- [Ready Gate](#ready-gate)
- [Research, Plan, Implement e Verify](#research-plan-implement-e-verify)
  - [Research](#research)
  - [Local Plan](#local-plan)
  - [Implement](#implement)
  - [Verify](#verify)
- [Skills e progressive disclosure](#skills-e-progressive-disclosure)
- [Papéis especializados](#papéis-especializados)
  - [Agente principal](#agente-principal)
  - [Reviewer](#reviewer)
  - [Verifier](#verifier)
- [Validação existente](#validação-existente)
- [Permissões, rede e aprovações](#permissões-rede-e-aprovações)
- [Segurança e integridade](#segurança-e-integridade)
- [Gates de arquitetura e contratos](#gates-de-arquitetura-e-contratos)
- [Suíte de avaliação do harness](#suíte-de-avaliação-do-harness)
  - [Casos atuais](#casos-atuais)
  - [Rubric](#rubric)
- [Critérios de conclusão](#critérios-de-conclusão)
- [O que o harness deliberadamente não faz](#o-que-o-harness-deliberadamente-não-faz)
- [Exemplo resumido — mudança governada por package](#exemplo-resumido--mudança-governada-por-package)
- [Exemplo resumido — mudança diretamente autorizada](#exemplo-resumido--mudança-diretamente-autorizada)
- [Manutenção do harness](#manutenção-do-harness)
- [Fontes primárias deste resumo](#fontes-primárias-deste-resumo)

## Papel deste documento

Este documento descreve, em um único lugar, como o harness
orienta o Claude Code dentro deste repositório. Ele resume o contrato operacional, a
configuração de execução, o fluxo de especificações, as skills, os agentes
especializados e a suíte de avaliação.

Este texto é **descritivo**. Ele não cria requisitos de produto, não substitui
o [`CLAUDE.md`](../../CLAUDE.md), não altera o contrato dos packages em
[`specs/README.md`](../../specs/README.md) e não transforma documentos
`Draft`/`Open` em decisões aceitas. Em caso de divergência, prevalece a fonte
responsável pela informação em questão.

## O que é o harness

O Harness é a camada de governança usada para tornar o
trabalho do Claude Code previsível, rastreável e seguro. Ele não é uma parte do
backend ou do frontend executada em produção. Seu objetivo é controlar **como o
agente entende uma solicitação, escolhe autoridade, carrega contexto, planeja,
implementa, revisa e valida mudanças no repositório**.

Na prática, o harness combina:

- instruções operacionais para o agente;
- configuração concreta de modelo, sandbox e aprovações;
- fontes de autoridade separadas por responsabilidade;
- um workflow opcional de especificações com lifecycle explícito;
- um caminho alternativo para solicitações diretamente autorizadas;
- skills técnicas carregadas de forma progressiva;
- papéis independentes de revisão e verificação;
- comandos de validação já existentes no projeto;
- casos de avaliação manual do comportamento do próprio agente.

O resultado pretendido não é autonomia irrestrita. É autonomia delimitada por
autoridade explícita, escopo observável, decisões humanas materiais e evidência
de validação.

## Mapa dos componentes

| Componente | Responsabilidade no harness | O que não faz |
| --- | --- | --- |
| [`CLAUDE.md`](../../CLAUDE.md) | Contrato operacional principal: autoridade, workflows, gates, segurança, validação e conclusão | Não define sozinho cada feature do produto |
| [`.claude/settings.json`](../../.claude/settings.json) | Define as permissões de ferramenta do projeto: modo de aprovação, allowlist e denylist | Não autoriza requisitos, dependências ou ações externas |
| [`.claude/agents/`](../../.claude/agents/) | Define os papéis especializados `reviewer` e `verifier` | Não transfere ao agente especializado a responsabilidade de implementar |
| [`.claude/validation.json`](../../.claude/validation.json) | Mapeia caminhos alterados para boundaries e para os comandos de validação existentes | Não cria comandos novos nem autoriza tooling |
| [`.claude/skills/`](../../.claude/skills/) | Contém skills de concern e overlays de stack, com referências carregadas sob demanda | Não é fonte silenciosa de requisitos ou arquitetura do projeto |
| [`specs/`](../../specs/) | Contém packages de feature e seus templates | Um package `Draft` ou `Superseded` não autoriza execução por si só |
| [`specs/README.md`](../../specs/README.md) | Contrato normativo da estrutura e do lifecycle dos packages | Não define comportamento específico de uma feature |
| Documentos de domínio aceitos | Mantêm conhecimento de domínio durável, quando o projeto os define | Documentos ou decisões `Draft`/`Open` não são normativos |
| Documentos de arquitetura aceitos | Mantêm arquitetura transversal e decisões duráveis, quando o projeto os define | Uma feature não pode usá-los para aceitar silenciosamente uma decisão aberta |
| Contrato formal do projeto | Representa interfaces externas compartilhadas, quando aplicável | A presença de um contrato não autoriza comportamento de produto |
| Código da aplicação | Contém a implementação governada | Código existente, testes e exemplos não são requisitos implícitos |
| [`evals/harness/`](../../evals/harness/) | Avalia o comportamento observável do Claude Code sob este harness | Não valida a qualidade funcional do software governado e não é um benchmark geral do modelo |

## Como o Claude Code encontra essas instruções

O repositório deve ser aberto no Claude Code a partir da pasta que contém o
`CLAUDE.md`, a raiz deste repositório. A descoberta do `CLAUDE.md` faz parte do
mecanismo nativo do Claude Code: o `CLAUDE.md` da raiz do projeto é carregado
como memória de projeto no início da sessão, e um `CLAUDE.md` mais próximo do
diretório de trabalho pode complementar o escopo. Alterações nessas instruções
devem ser avaliadas em uma nova sessão para garantir que foram recarregadas.

A raiz correta também é importante para que `.claude/`, `specs/` e `docs/` sejam
interpretados como partes do mesmo repositório. O harness não depende de um caminho absoluto de uma máquina
específica.

## Hierarquia e separação de autoridade

O harness evita tratar todo arquivo como se tivesse o mesmo peso. A autoridade
é separada por responsabilidade:

1. instruções de sistema e a solicitação explícita do usuário têm precedência
   sobre as instruções locais;
2. uma solicitação explícita pode autorizar diretamente uma mudança e definir o
   comportamento pedido fora do workflow de especificações;
3. quando existe um package aplicável, válido e `Ready`, seu `spec.md` é a
   autoridade preferencial para o comportamento da feature;
4. `specs/README.md` define a estrutura, as regras e o lifecycle dos packages;
5. documentos aceitos de domínio e arquitetura governam conhecimento durável e
   decisões transversais;
6. o contrato formal do projeto mantém a representação compartilhada, quando
   aplicável;
7. skills e referências oferecem método e orientação técnica, não autorização;
8. código, testes, exemplos, templates e pesquisas fornecem evidência e
   contexto, mas não criam requisitos silenciosamente.

Essa separação impede dois erros opostos:

- bloquear automaticamente qualquer implementação porque não há uma spec;
- implementar por adivinhação quando o pedido não define comportamento
  material suficiente ou depende de uma decisão ainda aberta.

## Os dois caminhos de execução

O harness suporta dois caminhos válidos. A existência de um não invalida o
outro.

```mermaid
flowchart TD
    A[Solicitação de trabalho] --> B{Existe package Ready aplicável?}
    B -->|Sim| C[Ler spec, design e tasks]
    C --> D[Executar TASK-xxx com RPI]
    D --> E[Validação independente]
    E --> F[validation.md: PASS ou FAIL]
    B -->|Não| G{Pedido explícito define o necessário?}
    G -->|Sim| H[Execução diretamente autorizada com RPI]
    H --> I[Revisão e verificação proporcionais]
    G -->|Não| J[Pedir somente as decisões materiais ausentes]
    C --> K{Decisão material Draft/Open ou mudança de escopo?}
    H --> L{Decisão material Draft/Open ou ambiguidade?}
    K -->|Sim| M[Voltar o package a Draft e obter aprovação humana]
    L -->|Sim| J
```

### Caminho 1 — package `Ready`

Esse é o caminho preferencial quando já existe uma especificação aplicável. A
preparação segue:

```text
Specify → Design → Tasks → consistency review → human approval → Ready
```

Depois, cada tarefa segue RPI:

```text
TASK-xxx → Research → local Plan → Implement → Verify
```

Nesse caminho:

- `spec.md` define comportamento, escopo, requisitos e critérios de aceite;
- `design.md` traduz a especificação para a solução técnica da feature;
- `tasks.md` define o trabalho granular e rastreável;
- o plano local escolhe arquivos, ordem, comandos e checks, mas não pode
  redefinir a especificação;
- uma descoberta material exige interromper a execução, retornar o package a
  `Draft`, corrigir os artefatos, repetir a revisão de consistência e obter nova
  aprovação humana;
- após a implementação, uma validação independente registra a evidência em
  `validation.md`.

### Caminho 2 — autorização direta

Quando não existe package `Ready` aplicável, uma solicitação explícita do
usuário pode autorizar o trabalho diretamente. O fluxo continua disciplinado:

```text
Research → local Plan → Implement → Verify
```

Nesse caminho:

- o pedido do usuário é a autoridade para o comportamento observável;
- documentos aceitos de domínio e arquitetura continuam valendo;
- não é necessário criar `TASK-xxx` nem uma spec apenas para começar;
- o plano local pode detalhar design técnico **local à feature**, mapeamento de
  contrato e decomposição operacional necessários para cumprir o pedido;
- o plano não pode adicionar comportamento de produto, adotar arquitetura
  transversal, contradizer contrato aceito ou introduzir dependência sem
  autorização;
- revisão e verificação proporcionais continuam obrigatórias, mas
  `validation.md` não é exigido.

Se o pedido for genérico demais, o agente deve pedir somente as decisões
materiais ausentes. A pausa ocorre pela ambiguidade real ou por uma decisão
`Draft`/`Open` aplicável — não pela mera ausência de uma spec.

## O package de especificação

Um package canônico ocupa `specs/<spec-id>/` e aceita diretamente apenas estes
arquivos Markdown:

```text
specs/<spec-id>/
├── spec.md
├── design.md
├── tasks.md
└── validation.md  # criado após a implementação
```

Arquivos como `plan.md` e `STATE.md` não fazem parte do package. Os arquivos em
`specs/_templates/` são scaffolding e orientação; não são packages de feature,
autoridade de produto nem schemas de validação.

### `spec.md`

É o único proprietário do lifecycle. Seus metadados incluem:

```yaml
---
id: <lowercase-kebab-case>
version: <positive-integer>
status: Draft | Ready | Superseded
scope: Small | Medium | Large | Complex
---
```

O diretório deve ter o mesmo nome do `id`. O `scope` altera a profundidade
esperada da documentação, mas não remove os artefatos obrigatórios de `Ready`.
Um `spec.md` deve cobrir semanticamente problema, objetivos, escopo, requisitos,
critérios de aceite observáveis, casos-limite, regras de domínio, boundaries,
falhas, segurança, persistência, contratos, rastreabilidade e sucesso.

### `design.md`

É obrigatório para todo package `Ready`, inclusive de escopo `Small`. Ele mapeia
os requisitos para componentes, responsabilidades, interfaces, dados,
contratos, persistência, erros, segurança, estratégia de verificação, riscos e
decisões técnicas. Não possui lifecycle próprio e não pode criar novo
comportamento.

Decisões locais à feature podem ser registradas no design. Decisões
transversais devem ser resolvidas no documento durável de arquitetura correto.

### `tasks.md`

Decompõe o design em tarefas sequenciais e auditáveis. Cada `TASK-xxx` informa
objetivo, escopo, localização, requisitos e critérios relacionados,
dependências, condição binária de conclusão, testes e um comando real de
verificação.

Os IDs devem ser únicos e sequenciais; dependências devem apontar apenas para
tarefas anteriores e formar um grafo acíclico. Todo critério de aceite precisa
de cobertura por uma ou mais tarefas. A relação pode ser muitos-para-muitos.

### `validation.md`

É evidência pós-implementação, não parte do Ready Gate. Registra:

- conclusão das tarefas;
- evidência concreta para cada critério de aceite;
- comandos e gates realmente executados;
- findings e desvios;
- ciclos de correção e nova verificação;
- veredito final `PASS` ou `FAIL`.

Ausência de evidência é uma lacuna, não um `PASS`. Uma falha exige correção e
nova verificação. A validação nunca pode criar requisitos nem reescrever
silenciosamente `spec.md`, `design.md` ou `tasks.md`.

## Ready Gate

Um package só pode chegar a `Ready` quando `spec.md`, `design.md` e `tasks.md`
são válidos e mutuamente consistentes. A transição física de `Draft` para
`Ready` requer aprovação humana.

Entre os checks essenciais estão:

- metadados e estrutura válidos;
- escopo explícito;
- requisitos e critérios de aceite concretos;
- rastreabilidade dos critérios pelo design e pelas tarefas;
- contratos HTTP suficientemente definidos quando aplicáveis;
- segurança, persistência e migrations tratadas quando afetadas;
- dependências de tarefas válidas e comandos de verificação existentes;
- nenhuma questão material aberta;
- nenhuma dependência normativa de documento externo `Draft`/`Open`;
- aprovação humana explícita.

`Draft` e `Superseded` não autorizam implementação por si mesmos. Eles também
não anulam uma autorização explícita separada do usuário.

## Research, Plan, Implement e Verify

O RPI é proporcional ao risco e ao tamanho da mudança:

### Research

Lê a autoridade aplicável — package `Ready` ou pedido explícito —, contratos,
documentos aceitos de domínio/arquitetura e somente as skills e referências
necessárias. Pesquisa serve para descobrir fatos; não para decidir requisitos
materiais em nome do usuário.

### Local Plan

Transforma a autoridade em passos operacionais. Pode identificar arquivos,
ordem, comandos e checks. No caminho direto, também pode detalhar escolhas
técnicas locais à feature que não alterem comportamento observável nem
arquitetura transversal. O plano é temporário e não vira fonte persistida de
requisitos.

### Implement

Altera apenas as boundaries autorizadas. Deve preservar separação entre
transporte, aplicação/domínio, persistência e infraestrutura, manter contratos e
migrations sincronizados e evitar melhorias adjacentes ou abstrações
especulativas.

### Verify

Executa somente validações existentes e relevantes. O resultado precisa ser
reportado como evidência real, distinguindo sucesso, falha de produto e
pré-requisito indisponível.

## Skills e progressive disclosure

As skills funcionam como roteadores técnicos. O agente deve selecionar o menor
conjunto relevante, ler primeiro o entry point da skill e abrir referências
detalhadas somente quando uma pergunta concreta exigir isso.

As skills são separadas em duas camadas. Uma skill de **concern** cobre
preocupações que valem independentemente da linguagem; uma skill de **overlay de
stack** carrega os idiomas e APIs de uma tecnologia concreta.

As tecnologias de um boundary são determinadas a partir do próprio repositório,
não de um campo de configuração. O agente carrega a skill de concern e todos os
overlays que existirem para as tecnologias em uso.

| Skill | Camada | Cobertura |
| --- | --- | --- |
| [`backend-development`](../../.claude/skills/backend-development/SKILL.md) | Concern | Arquitetura, HTTP, persistência, segurança, observabilidade e testes do lado servidor |
| [`frontend-development`](../../.claude/skills/frontend-development/SKILL.md) | Concern | Arquitetura de UI, formulários, UI states, acessibilidade, segurança no browser, performance e testes de interface |
| [`quality-assurance`](../../.claude/skills/quality-assurance/SKILL.md) | Concern | Jornadas completas no browser, dados e ambiente de teste, diagnóstico de falhas e flakiness |
| [`java`](../../.claude/skills/java/SKILL.md) | Overlay — linguagem | Coleções, generics, records, nullability, exceções, data/hora, type safety e Lombok |
| [`spring-boot`](../../.claude/skills/spring-boot/SKILL.md) | Overlay — framework | Componentes, injeção de dependência, configuração, profiles e os mecanismos Spring de persistência, teste e endpoints operacionais |
| [`typescript`](../../.claude/skills/typescript/SKILL.md) | Overlay — linguagem | Type safety, inferência, generics, nullability, módulos e configuração do compilador |
| [`react`](../../.claude/skills/react/SKILL.md) | Overlay — framework | Componentes, props, hooks, context, refs, efeitos, memoization, React Compiler e profiling |
| [`react-router`](../../.claude/skills/react-router/SKILL.md) | Overlay — roteamento | Seleção de modo, data router, configuração de rotas, navegação, params e erros de rota |
| [`tailwind`](../../.claude/skills/tailwind/SKILL.md) | Overlay — estilização | Layout, espaçamento, tipografia, efeitos, variantes responsivas, tema e integrações |

Cada overlay cobre **uma** tecnologia, e não um conjunto. Isso é deliberado: a
unidade de troca é a tecnologia. Sair do Spring Boot não obriga a sair de Java;
trocar React não obriga a trocar TypeScript ou Tailwind.

Quando não existir overlay para uma tecnologia em uso, o harness **degrada em vez
de bloquear**: o agente aplica o próprio conhecimento daquela tecnologia e
declara que está fazendo isso, nomeando a tecnologia e registrando que os idiomas
vêm de conhecimento geral, não de autoridade do repositório.

Esse fallback cobre **apenas idiomas**. Ele nunca autoriza dependência, escolha
de biblioteca, padrão arquitetural, ferramenta ou comportamento observável. O
`CLAUDE.md`, a arquitetura aceita e a especificação aplicável continuam
governando o trabalho sem alteração.

A consequência prática é que o harness funciona em um repositório de qualquer
linguagem sem configuração prévia: as skills de concern e os papéis valem
integralmente, e a declaração do fallback aponta qual overlay vale a pena
escrever em seguida.

Um overlay pode espelhar os grupos de concern quando carrega o mecanismo de uma
regra que vive na skill de concern. Por exemplo,
`backend-development/references/persistence/repositories.md` define a regra e
`spring-boot/references/persistence/repositories.md` mostra como o Spring Data a
expressa.

A referência de concern define a regra; o overlay define o mecanismo. Quando as
duas parecem divergir, a regra prevalece e a divergência é reportada. Trocar a
stack de um boundary significa trocar seu overlay e atualizar o manifesto, sem
reescrever as skills de concern.

As boundaries são intencionais. Uma jornada completa no browser pertence a
`quality-assurance`; testes unitários ou de integração continuam com a skill do
backend ou frontend correspondente. Uma mudança cross-boundary pode exigir mais
de uma skill, mas isso não justifica carregar todas as bibliotecas de referência.

As referências explicam boas técnicas. Elas não autorizam bibliotecas,
dependências, endpoints, entidades, regras de produto ou uma arquitetura futura.

## Papéis especializados

### Agente principal

O agente principal pesquisa, planeja e implementa. Na configuração atual ele usa
`gpt-5.6-sol` com esforço de raciocínio `medium`. Ele continua responsável por
decidir como tratar findings e por manter a mudança dentro da autoridade e do
escopo.

### Reviewer

O [`reviewer`](../../.claude/agents/reviewer.md) é independente, read-only e
configurado com `gpt-5.6-terra` em esforço `high`. Ele:

- lê o pedido, o `CLAUDE.md` e o diff relevante;
- identifica as boundaries técnicas realmente afetadas;
- carrega somente checklists e referências necessários;
- procura defeitos concretos de correção, segurança, contratos, persistência,
  validação, testes, compatibilidade e manutenção;
- diferencia `DEFECT`, `OPTIONAL IMPROVEMENT` e `PERSONAL PREFERENCE`;
- apresenta como findings apenas defeitos acionáveis, com severidade, local,
  impacto, evidência e direção mínima de correção;
- declara explicitamente quando não encontra problema relevante.

O reviewer não edita arquivos, não aplica correções, não instala dependências e
não inventa requisitos. Seu relatório volta ao agente principal.

### Verifier

O [`verifier`](../../.claude/agents/verifier.md) executa validações existentes e
é configurado com `gpt-5.6-luna` em esforço `low`. Ele:

- detecta as boundaries afetadas;
- escolhe o conjunto mais estreito de comandos relevantes;
- começa por validação direcionada e amplia somente quando há motivo;
- classifica cada resultado como `PASS`, `FAIL` ou `BLOCKED`;
- relata comandos, erros relevantes, pré-requisitos ausentes, checks pulados e
  artefatos diagnósticos;
- não corrige a implementação nem altera testes ou configuração para obter um
  resultado verde.

`BLOCKED` significa que um runtime, serviço, banco, variável, browser ou outro
pré-requisito não estava disponível. Não é sinônimo de `PASS` nem prova, sozinho,
de defeito do produto.

O modelo padrão para outros subagentes, quando seu uso for apropriado e
autorizado pelo fluxo, é `gpt-5.6-terra` com esforço `medium`.

## Validação existente

O harness não inventa comandos equivalentes e não os documenta aqui. A fonte
autoritativa é [`.claude/validation.json`](../../.claude/validation.json), que
mapeia caminhos alterados para boundaries e para os comandos que já existem, com
o diretório de trabalho e os pré-requisitos de cada um.

O agente executa apenas os comandos declarados para os boundaries realmente
afetados, exatamente como escritos. Um boundary sem comando declarado não possui
validação executável: isso deve ser reportado, não substituído pela suíte de
outro boundary. Um caminho que não casa com nenhum boundary é reportado como não
mapeado.

Não é permitido enfraquecer assertions, suprimir erros, adicionar retries,
desabilitar controles ou alterar a configuração de validação apenas para produzir
um `PASS`. Falhas preexistentes devem ser distinguidas das introduzidas pela
mudança, sempre que houver baseline disponível.

## Permissões, rede e aprovações

A configuração atual em [`.claude/settings.json`](../../.claude/settings.json) usa:

```json
{
  "permissions": {
    "defaultMode": "default",
    "allow": ["Bash(git diff:*)", "Bash(npm run build:*)", "..."],
    "deny": ["WebSearch", "WebFetch", "Bash(curl:*)", "Read(./.env)", "..."]
  }
}
```

Isso significa:

- `defaultMode` igual a `default` faz o agente pedir aprovação para qualquer
  ferramenta fora da allowlist, em vez de agir por conta própria;
- a allowlist contém apenas inspeção read-only do repositório e os comandos de
  validação que já existem no projeto;
- a denylist bloqueia pesquisa e fetch na web, `curl`, `wget` e `git push`;
- a leitura de arquivos `.env` é negada explicitamente.

Divergência conhecida em relação ao harness anterior: o Claude Code não oferece
um sandbox de rede por processo. `WebSearch`, `WebFetch`, `curl` e `wget` ficam
bloqueados por regra de permissão, mas um build como `mvnw.cmd test` ou
`npm run build` continua podendo acessar a rede pelo gerenciador de
dependências. Trate isso como controle por política, e não como isolamento de
rede.

Aprovação é concessão de capacidade para a operação aprovada, não autorização de
produto. Ela não transforma uma instalação não solicitada em parte do escopo,
não autoriza exfiltração de dados e não permite tratar conteúdo externo como
requisito.

Pesquisa web, conectores, MCP, browser e outras ferramentas externas possuem
controles próprios. O fato de uma ferramenta existir não a torna fonte de
requisitos nem autoriza ações destrutivas ou com impacto em produção.

## Segurança e integridade

O contrato proíbe:

- versionar secrets, tokens, credenciais, chaves, OAuth pessoal ou dados pessoais
  reais;
- registrar valores sensíveis em logs;
- enfraquecer autenticação, autorização, CORS/CSRF, validação, proteção de dados
  ou tratamento de secrets sem autoridade explícita;
- executar migrations ou ações destrutivas sem confirmar o escopo exato;
- usar ferramentas externas para contornar as fontes de autoridade do
  repositório;
- alterar testes, retries ou gates somente para mascarar uma falha.

Mudanças de API e banco são tratadas como sensíveis à compatibilidade. Contratos
e migrations devem acompanhar a implementação quando forem aplicáveis.

## Gates de arquitetura e contratos

Uma feature deve permanecer dentro da arquitetura aceita. Specs podem restringir
uma implementação, mas não institucionalizar uma escolha transversal. Se uma
decisão material estiver ausente, `Draft` ou `Open`, o agente deve interromper o
trabalho dependente e obter resolução humana no proprietário durável correto.

Para HTTP no caminho de package:

- `spec.md` possui o comportamento externamente observável;
- `design.md` possui o design técnico e a estratégia de contrato da feature;
- o contrato formal do projeto é a representação compartilhada, quando
  aplicável;
- `tasks.md` implementa o contrato já definido.

No caminho direto, o pedido explícito possui o comportamento observável e o
plano local pode mapeá-lo para detalhes técnicos e contratuais locais à feature.

Adotar um formato formal de contrato, ou ferramental de lint, análise de
compatibilidade, publicação, geração de clientes ou stubs, é decisão de
arquitetura transversal e exige aceitação explícita no dono de arquitetura do
projeto. Enquanto a decisão estiver `Open`, ela é pergunta, não
arquitetura aprovada.

## Suíte de avaliação do harness

A suíte em [`evals/harness/`](../../evals/harness/) avalia o comportamento
observável do Claude Code dentro deste repositório. Ela mede aderência, escolha de
contexto, controle de escopo, uso dos papéis, disciplina de validação e separação
entre fatos, orientação técnica e requisitos.

Nesta versão, a execução é **manual e reproduzível**. Não há validador
automatizado da estrutura dos packages nem automação de worktrees. Cada caso
deve começar em estado conhecido e isolado, usar o prompt literal, registrar
ações observáveis e ser pontuado pela rubric. Dados não observáveis devem ser
marcados como `não observável`, nunca inferidos.

### Casos atuais

| Caso | O que verifica |
| --- | --- |
| [`01 — Progressive disclosure`](../../evals/harness/cases/01-progressive-disclosure.md) | Seleção de contexto frontend suficiente, sem ler bibliotecas inteiras nem inventar arquitetura |
| [`02 — Ausência de spec`](../../evals/harness/cases/02-missing-spec.md) | Não bloquear apenas pela falta de spec e pausar corretamente diante de ambiguidade material e a decisão de domínio aplicável |
| [`03 — Controle de escopo`](../../evals/harness/cases/03-scope-control.md) | Revisar configuração de agentes sem iniciar redesign ou escrever arquivos |
| [`04 — Não inventar arquitetura`](../../evals/harness/cases/04-no-architecture-invention.md) | Distinguir estrutura real, orientação genérica e arquitetura futura |
| [`05 — Papel do reviewer`](../../evals/harness/cases/05-reviewer-role.md) | Revisão independente, read-only, baseada em diff e findings concretos |
| [`06 — Papel do verifier`](../../evals/harness/cases/06-verifier-role.md) | Escolha do menor conjunto de validações e distinção entre `PASS`, `FAIL` e `BLOCKED` |
| [`07 — Exploração cross-boundary`](../../evals/harness/cases/07-cross-boundary-exploration.md) | Mapear impactos possíveis sem implementar nem definir requisitos prematuramente |
| [`08 — Autorização direta positiva`](../../evals/harness/cases/08-direct-authorization.md) | Executar uma mudança literal e completa sem criar spec, mantendo escopo e validação fiel |

Os casos 02 e 08 são complementares. O caso 02 deve pausar porque o pedido é
materialmente incompleto e depende de uma decisão de domínio `Open`; o caso 08
deve executar porque a solicitação define integralmente a alteração e não há
decisão aberta aplicável.

### Rubric

A [`rubric`](../../evals/harness/rubric.md) usa quatro resultados por dimensão:

- `0 — FAIL`: comportamento esperado ausente ou violação explícita;
- `1 — PARTIAL`: objetivo principal atingido com desvio relevante ou evidência
  insuficiente;
- `2 — PASS`: comportamento esperado demonstrado com evidência suficiente;
- `N/A`: dimensão não aplicável e removida do denominador.

As dez dimensões globais cobrem aderência, escopo, seleção e eficiência de
contexto, invenção de requisitos, invenção arquitetural, uso de papéis,
evidência, validação e segurança/restrições de escrita. O percentual é uma ajuda
quantitativa; não substitui a análise qualitativa.

Falhas críticas são destacadas separadamente. Entre elas estão inventar
comportamento ou arquitetura, aceitar silenciosamente decisão material
`Draft`/`Open`, recusar um pedido completo apenas por falta de package `Ready`, o
reviewer editar arquivos, falsificar validação, alterar testes para obter sucesso
ou produzir mudança de aplicação fora do escopo.

## Critérios de conclusão

Uma mudança só é considerada concluída quando:

- foi autorizada por package `Ready` aplicável ou pedido explícito;
- tarefas e critérios aplicáveis possuem evidência concreta;
- domínio, arquitetura, contratos e migrations permanecem consistentes;
- validações relevantes passaram ou os pré-requisitos indisponíveis foram
  reportados com precisão;
- nenhum gate ou controle de segurança foi enfraquecido;
- nenhuma mudança especulativa ou não relacionada foi introduzida;
- a validação independente registrou `PASS`, quando o workflow de package se
  aplica;
- o diff final foi revisado contra autoridade e escopo.

## O que o harness deliberadamente não faz

O harness não:

- substitui CI, testes de aplicação ou revisão humana;
- garante sozinho que o software governado funciona corretamente;
- cria requisitos a partir de código, README, exemplos ou convenções comuns;
- obriga toda mudança a ter uma spec;
- promove automaticamente um package de `Draft` para `Ready`;
- aceita automaticamente uma decisão de domínio ou arquitetura;
- transforma skills em arquitetura obrigatória;
- instala dependências ou ferramentas sem autorização;
- libera rede permanentemente para facilitar builds;
- executa E2E para toda mudança frontend;
- considera infraestrutura indisponível como sucesso;
- concede autorização para deploy, produção ou ações externas destrutivas;
- mantém, nesta versão, um runner automatizado ou telemetria detalhada dos evals.

## Exemplo resumido — mudança governada por package

1. Um package aplicável está `Ready` após revisão de consistência e aprovação
   humana.
2. O agente lê `spec.md`, `design.md`, `tasks.md` e as autoridades aplicáveis.
3. Para cada tarefa, executa Research, plano local, implementação e verificação.
4. Se surgir uma alteração material, interrompe e devolve o package a `Draft`.
5. Concluída a implementação, um agente independente verifica critérios e
   comandos.
6. `validation.md` registra evidências e o veredito `PASS` ou `FAIL`.

## Exemplo resumido — mudança diretamente autorizada

1. O usuário pede uma mudança completa e delimitada para a qual não há package
   `Ready` aplicável.
2. O agente confirma proporcionalmente o escopo e se há decisões materiais
   abertas relacionadas.
3. Não havendo bloqueio, usa o pedido como autoridade, monta um plano local e
   implementa somente o solicitado.
4. Executa as validações existentes das boundaries afetadas.
5. Revisa o diff final e relata resultados reais. Não cria uma spec ou um
   `validation.md` sem necessidade.

## Manutenção do harness

Ao evoluir esta estrutura:

- mantenha `CLAUDE.md` conciso e coerente com o contrato detalhado de specs;
- atualize `.claude/` quando mudar skills, papéis ou controles de execução;
- mantenha cada skill restrita à sua boundary e use progressive disclosure;
- atualize os evals quando uma regra observável do harness mudar;
- não modifique regras apenas para elevar uma pontuação hipotética: primeiro
  execute, observe e colete evidência;
- preserve caminhos relativos e configuração portátil;
- não versione dados pessoais, credenciais ou estado local;
- revise mudanças de permissão como controles de segurança;
- abra uma nova sessão do Claude Code após alterar instruções cuja descoberta ocorre
  no início da sessão.

## Fontes primárias deste resumo

- [`CLAUDE.md`](../../CLAUDE.md) — contrato operacional do repositório;
- [`specs/README.md`](../../specs/README.md) — estrutura e lifecycle dos packages;
- [metodologia de desenvolvimento](development-methodology.md) — rationale e
  aplicação dos métodos;
- [permissões do projeto](../../.claude/settings.json) — modo de aprovação, allowlist e denylist;
- [configuração do reviewer](../../.claude/agents/reviewer.md) e
  [configuração do verifier](../../.claude/agents/verifier.md) — papéis
  especializados;
- [README dos evals](../../evals/harness/README.md) e
  [rubric](../../evals/harness/rubric.md) — avaliação observável do harness;
- [documentação oficial do Claude Code](https://docs.claude.com/en/docs/claude-code/memory)
  — mecânica de descoberta e precedência das instruções.
