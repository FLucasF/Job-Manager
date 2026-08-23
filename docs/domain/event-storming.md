# Event Storming — Job Manager

> **Status:** Discovery / non-normative
> **Document role:** discovery artifact.
> This document preserves domain discovery, alternatives, and hotspots.
> Candidate domain structure and rules live in the Draft domain documents. A
> hotspot is not implementation authorization.
>
> Canonical vocabulary: capability `job-applications`, entity
> `JobApplication`, and account entity `UserAccount`. Historical discovery
> labels below must be read through this mapping and do not define requirements.

## 1. Objetivo

Este documento registra um **Event Storming completo do sistema Job Manager**, derivado das funcionalidades já identificadas no frontend e das User Stories existentes.

O objetivo é transformar as funcionalidades observáveis da interface em um modelo explícito de:

- atores;
- comandos;
- eventos de domínio;
- políticas;
- agregados;
- read models;
- regras de negócio;
- bounded contexts;
- integrações;
- pontos de decisão;
- lacunas ainda não resolvidas.

Este documento **não substitui** a especificação funcional, o modelo de domínio, os ADRs ou o contrato OpenAPI. Ele serve como etapa de descoberta e organização do domínio antes da criação dessas especificações.

---

# 2. Convenções

Neste documento, os elementos do Event Storming são representados assim:

| Elemento | Significado |
|---|---|
| **Ator** | Pessoa ou sistema que inicia uma ação |
| **Comando** | Intenção explícita de alterar o estado do sistema |
| **Evento de Domínio** | Fato relevante que já aconteceu no domínio |
| **Política** | Regra que reage a um evento e pode disparar outro comando |
| **Agregado** | Fronteira de consistência responsável por proteger invariantes |
| **Read Model** | Modelo de leitura otimizado para consulta e apresentação |
| **Sistema Externo** | Serviço ou dependência fora do domínio principal |
| **Hotspot** | Questão em aberto, ambiguidade ou decisão ainda não fechada |

Exemplo conceitual:

```text
Ator
  ↓
Comando
  ↓
Agregado
  ↓
Evento de Domínio
  ↓
Política
  ↓
Novo Comando
```

---

# 3. Visão geral do domínio

O sistema possui, no estado atual de descoberta, cinco capacidades centrais:

1. autenticar usuários;
2. manter o perfil profissional do usuário;
3. criar e publicar vagas;
4. descobrir vagas disponíveis;
5. registrar e consultar candidaturas.

Fluxo macro:

```text
Usuário
  │
  ├── autentica-se
  │
  ├── mantém seu perfil
  │
  ├── consulta vagas
  │     └── candidata-se
  │
  └── cria vagas
        ├── salva como rascunho
        └── publica
```

---

# 4. Atores identificados

## 4.1 Visitante

Usuário ainda não autenticado.

Pode:

- acessar a tela de login;
- informar credenciais;
- tentar autenticar-se.

Não pode:

- visualizar vagas privadas;
- candidatar-se;
- criar vagas;
- editar perfil;
- consultar candidaturas.

---

## 4.2 Usuário autenticado

Ator principal do sistema.

Pode:

- consultar vagas;
- pesquisar vagas;
- filtrar vagas;
- candidatar-se;
- consultar suas candidaturas;
- criar vagas;
- salvar vaga como rascunho;
- publicar vaga;
- consultar e editar seu perfil;
- gerenciar interesses profissionais;
- encerrar sua sessão.

> **Hotspot:** atualmente o frontend não deixa explícito se existem papéis distintos, como `CANDIDATE`, `EMPLOYER` ou `ADMIN`. Até que isso seja definido, considera-se apenas `Usuário autenticado`.

---

## 4.3 Sistema

Representa ações automáticas ou reativas executadas pela aplicação.

Exemplos:

- restaurar sessão;
- detectar sessão expirada;
- validar dados;
- impedir duplicidade;
- carregar dados dependentes;
- atualizar read models.

---

# 5. Bounded Contexts propostos

A divisão abaixo é uma proposta inicial derivada dos fluxos funcionais.

## 5.1 Identity & Access

Responsável por:

- autenticação;
- sessão;
- logout;
- proteção de acesso.

Principais conceitos:

- User Identity;
- Session;
- Credentials.

---

## 5.2 User Profile

Responsável por:

- dados pessoais;
- escolaridade;
- endereço;
- apresentação pessoal;
- interesses profissionais.

Principais conceitos:

- User Profile;
- Interest;
- Address;
- Education Level.

---

## 5.3 Vacancy Management

Responsável por:

- criação de vagas;
- rascunhos;
- publicação;
- modalidade remota/presencial;
- dados de contato;
- descrição;
- requisitos.

Principais conceitos:

- Vacancy;
- Vacancy Draft;
- Employment Type;
- Vacancy Status;
- Vacancy Address.

---

## 5.4 Vacancy Discovery

Responsável pela experiência de leitura e descoberta de vagas:

- listagem;
- pesquisa;
- filtros;
- formatação;
- estado vazio;
- visualização resumida.

Esse contexto pode consumir dados de `Vacancy Management`, mas não deve ser responsável pelas invariantes de criação/publicação de vagas.

---

## 5.5 Job Applications (`job-applications`)

Responsável por:

- candidatura;
- prevenção de duplicidade;
- consulta de candidaturas;
- visualização de detalhes relacionados à candidatura.

Principais conceitos:

- JobApplication;
- JobApplication Status.

---

## 5.6 Reference Data

Contexto de apoio para dados relativamente estáveis.

Possíveis dados:

- estados;
- cidades;
- escolaridades;
- tipos de emprego;
- interesses profissionais.

> **Hotspot:** deve ser definido se esses valores serão:
>
> - enums internos;
> - tabelas do banco;
> - dados provenientes de serviços externos;
> - combinação das opções anteriores.

---

# 6. Big Picture Event Storming

## 6.1 Autenticação

```text
Visitante
  ↓
[Informar credenciais]
  ↓
[Autenticar usuário]
  ↓
(User Identity / Session)
  ↓
<Usuário autenticado>
  ↓
[Restaurar sessão quando necessário]
```

Possíveis falhas:

```text
[Autenticar usuário]
  ├── <Autenticação recusada>
  └── <Usuário autenticado>
```

Sessão:

```text
<Sessão expirada>
  ↓
Política: invalidar acesso local
  ↓
[Encerrar sessão local]
  ↓
<Sessão encerrada>
```

Logout:

```text
Usuário autenticado
  ↓
[Encerrar sessão]
  ↓
<Sessão encerrada>
```

---

## 6.2 Consulta de vagas

```text
Usuário autenticado
  ↓
[Consultar vagas disponíveis]
  ↓
Read Model: Vagas Disponíveis
  ↓
<Listagem de vagas apresentada>
```

Pesquisa:

```text
Usuário autenticado
  ↓
[Pesquisar vagas]
  ↓
Read Model: Vagas Filtradas
  ↓
<Resultados de vagas apresentados>
```

Filtros:

```text
Usuário autenticado
  ↓
[Aplicar filtros de vagas]
  ↓
Read Model: Vagas Filtradas
  ↓
<Filtros aplicados>
  ↓
<Resultados de vagas apresentados>
```

Remoção de filtro:

```text
Usuário autenticado
  ↓
[Remover filtro]
  ↓
<Filtro removido>
  ↓
Política: recalcular consulta
  ↓
[Consultar vagas com critérios atuais]
```

---

## 6.3 Candidatura

```text
Usuário autenticado
  ↓
[Candidatar-se à vaga]
  ↓
(JobApplication)
  ↓
<Candidatura criada>
```

Duplicidade:

```text
[Candidatar-se à vaga]
  ↓
Verificar candidatura existente
  ├── já existe → rejeitar comando
  └── não existe → <Candidatura criada>
```

Consulta:

```text
Usuário autenticado
  ↓
[Consultar minhas candidaturas]
  ↓
Read Model: Minhas Candidaturas
  ↓
<Candidaturas apresentadas>
```

Detalhes:

```text
Usuário autenticado
  ↓
[Consultar detalhes da candidatura]
  ↓
Read Model: Detalhes da Vaga Candidatada
  ↓
<Detalhes apresentados>
```

---

## 6.4 Criação de vaga

```text
Usuário autenticado
  ↓
[Iniciar criação de vaga]
  ↓
(Vacancy)
  ↓
<Rascunho de vaga iniciado>
```

Preenchimento:

```text
[Informar dados da vaga]
  ↓
<Dados da vaga alterados>
```

Modalidade:

```text
[Definir vaga como remota]
  ↓
<Modalidade da vaga alterada para remota>
```

ou:

```text
[Definir vaga como presencial]
  ↓
<Modalidade da vaga alterada para presencial>
```

Salvamento:

```text
[Salvar vaga como rascunho]
  ↓
<Vaga salva como rascunho>
```

Publicação:

```text
[Publicar vaga]
  ↓
Validar invariantes de publicação
  ├── inválida → comando rejeitado
  └── válida
        ↓
      <Vaga publicada>
```

---

## 6.5 Perfil

```text
Usuário autenticado
  ↓
[Consultar perfil]
  ↓
Read Model: Meu Perfil
  ↓
<Perfil apresentado>
```

Atualização:

```text
Usuário autenticado
  ↓
[Atualizar perfil]
  ↓
(User Profile)
  ↓
<Perfil atualizado>
```

Interesses:

```text
[Adicionar interesse]
  ↓
<Interesse adicionado ao perfil>
```

```text
[Remover interesse]
  ↓
<Interesse removido do perfil>
```

---

# 7. Event Storming detalhado — Identity & Access

## 7.1 Comando: Autenticar usuário

**Ator:** Visitante

### Dados mínimos

- e-mail;
- senha.

### Pré-condições

- e-mail informado;
- senha informada;
- e-mail em formato aceitável.

### Agregado / componente responsável

`Session` ou serviço de autenticação.

### Evento de sucesso

`UserAuthenticated`

Em português:

`UsuárioAutenticado`

### Eventos / resultados alternativos

- `AuthenticationRejected`;
- `AuthenticationFailed`.

### Regras

- credenciais inválidas não devem revelar qual campo está incorreto;
- uma tentativa em processamento não deve ser duplicada;
- o usuário autenticado deve receber uma sessão válida.

---

## 7.2 Comando: Restaurar sessão

**Ator:** Sistema

### Dado inicial

Existe evidência local de uma sessão anterior.

### Resultado

- sessão válida → `SessionRestored`;
- sessão inválida → `SessionRejected`.

### Política

Se a sessão não puder ser restaurada:

```text
<SessionRejected>
  ↓
[RedirectToLogin]
```

---

## 7.3 Evento: Sessão expirada

Nome sugerido:

`SessionExpired`

### Política

```text
<SessionExpired>
  ↓
[ClearLocalSession]
  ↓
<LocalSessionCleared>
  ↓
[RedirectToLogin]
```

---

## 7.4 Comando: Encerrar sessão

**Ator:** Usuário autenticado

### Evento

`SessionEnded`

### Pós-condições

- sessão local removida;
- conteúdo protegido não pode continuar acessível;
- usuário direcionado para login.

---

# 8. Event Storming detalhado — User Profile

## 8.1 Agregado: UserProfile

Responsável por manter consistência dos dados editáveis do perfil.

### Dados atualmente observados

- nome completo;
- e-mail;
- CPF;
- telefone;
- escolaridade;
- endereço;
- estado;
- cidade;
- sobre você;
- interesses.

### Invariantes candidatas

- nome obrigatório;
- e-mail válido;
- telefone válido quando obrigatório;
- CPF válido quando editável ou cadastrado;
- cidade compatível com estado;
- interesse não pode ser duplicado.

> Essas invariantes precisam ser confirmadas no modelo de domínio.

---

## 8.2 Comando: Consultar perfil

**Ator:** Usuário autenticado

### Read Model

`MyProfileView`

### Dados exibidos

- dados pessoais;
- localização;
- escolaridade;
- apresentação;
- interesses.

### Evento observável

`ProfileDisplayed`

> Tecnicamente, consultas normalmente não geram eventos de domínio persistidos. O evento acima representa comportamento observável no Event Storming, não necessariamente algo a ser armazenado.

---

## 8.3 Comando: Atualizar perfil

**Ator:** Usuário autenticado

### Agregado

`UserProfile`

### Evento

`ProfileUpdated`

### Regras

- apenas campos permitidos podem ser alterados;
- dados inválidos impedem atualização;
- estado e cidade devem ser consistentes;
- interesses devem permanecer sem duplicidade.

### Hotspot

**CPF editável ou somente leitura?**

Decisão necessária:

```text
Opção A
CPF imutável após cadastro

Opção B
CPF editável com validação

Opção C
CPF editável somente por fluxo específico
```

---

## 8.4 Comando: Adicionar interesse

**Ator:** Usuário autenticado

### Agregado

`UserProfile`

### Evento

`InterestAddedToProfile`

### Invariante

O mesmo interesse não pode existir duas vezes no perfil.

### Alternativa

Se já existir:

`DuplicateInterestRejected`

---

## 8.5 Comando: Remover interesse

**Ator:** Usuário autenticado

### Evento

`InterestRemovedFromProfile`

### Pós-condição

O interesse deixa de participar da lista de preferências do perfil.

---

# 9. Event Storming detalhado — Vacancy Management

## 9.1 Agregado: Vacancy

Esse agregado é o principal candidato a proteger as regras da criação e publicação de vagas.

### Possíveis atributos

- id;
- creatorId;
- title;
- employmentType;
- contactEmail;
- contactPhone;
- compensation;
- remote;
- address;
- city;
- state;
- description;
- requirements;
- status;
- createdAt;
- updatedAt;
- publishedAt.

### Status candidatos

```text
DRAFT
PUBLISHED
```

> **Hotspot:** podem existir posteriormente `CLOSED`, `ARCHIVED` ou `CANCELLED`, mas eles ainda não aparecem nos requisitos atuais.

---

## 9.2 Comando: Iniciar criação de vaga

**Ator:** Usuário autenticado

### Evento

`VacancyDraftStarted`

### Resultado

Uma nova vaga em estado de edição passa a existir no frontend ou backend.

### Hotspot

Definir se o registro de rascunho é criado:

- imediatamente ao abrir a tela;
- apenas ao selecionar `Salvar Rascunho`;
- apenas localmente até o primeiro salvamento.

---

## 9.3 Comando: Atualizar dados da vaga

**Ator:** Usuário autenticado

### Evento

`VacancyDraftChanged`

### Dados possíveis

- título;
- tipo de emprego;
- contato;
- remuneração;
- descrição;
- requisitos;
- localização;
- modalidade.

> Não é obrigatório persistir um evento para cada alteração de campo. O evento representa a mudança conceitual no domínio.

---

## 9.4 Comando: Definir vaga como remota

### Evento

`VacancyMarkedAsRemote`

### Política de interface

```text
<VacancyMarkedAsRemote>
  ↓
Ocultar/desativar obrigatoriedade de endereço presencial
```

### Invariante candidata

Uma vaga remota não precisa possuir localização física obrigatória para publicação.

### Hotspot

Definir se endereço previamente preenchido:

- é apagado imediatamente;
- é mantido no formulário, mas não enviado;
- é preservado como informação não ativa.

---

## 9.5 Comando: Definir vaga como presencial

### Evento

`VacancyMarkedAsOnsite`

### Política

Uma vaga presencial passa a exigir os dados mínimos de localização definidos pelo domínio.

Possíveis campos:

- endereço;
- número;
- cidade;
- estado.

Complemento permanece opcional.

---

## 9.6 Comando: Salvar vaga como rascunho

**Ator:** Usuário autenticado

### Agregado

`Vacancy`

### Evento

`VacancyDraftSaved`

### Invariantes candidatas

Rascunho pode ser incompleto.

Deve ser definido um conjunto mínimo para persistência.

Exemplo:

```text
Para salvar rascunho:
- autenticação válida;
- ownership válido;
- nenhum requisito de publicação completo é obrigatório.
```

### Hotspot

Definir se algum campo mínimo será obrigatório para rascunho.

---

## 9.7 Comando: Recuperar rascunho

**Ator:** Usuário autenticado

### Read Model

`MyVacancyDrafts`

### Resultado

`VacancyDraftLoaded`

### Regras

- usuário só pode carregar rascunhos que pode editar;
- dados salvos devem preencher novamente o formulário.

### Hotspot crítico

Não existe interface definida para localizar rascunhos.

Precisamos definir:

- tela;
- lista;
- acesso;
- ações;
- ordenação;
- exclusão, se existir.

---

## 9.8 Comando: Publicar vaga

**Ator:** Usuário autenticado

### Agregado

`Vacancy`

### Evento de sucesso

`VacancyPublished`

### Invariantes candidatas

Para publicação, a vaga deve possuir:

- título;
- tipo de emprego;
- e-mail de contato válido;
- telefone válido;
- remuneração válida;
- descrição;
- requisitos;
- modalidade definida.

Se presencial:

- endereço obrigatório;
- número obrigatório;
- estado obrigatório;
- cidade obrigatória.

Se remota:

- endereço presencial não obrigatório.

### Evento alternativo

`VacancyPublicationRejected`

### Razões possíveis

- dados obrigatórios ausentes;
- dados inválidos;
- estado da vaga incompatível;
- usuário sem autorização.

---

# 10. Event Storming detalhado — Vacancy Discovery

## 10.1 Read Model: AvailableVacancies

Modelo destinado à listagem principal.

### Dados sugeridos

- vacancyId;
- title;
- company/creator display name, se aplicável;
- publicationDate;
- location;
- compensation;
- employmentType;
- remote;
- alreadyApplied.

> **Hotspot:** o campo "empresa" aparece visualmente, mas o modelo atual ainda não define formalmente uma entidade Company/Employer.

---

## 10.2 Comando conceitual: Consultar vagas disponíveis

Embora seja uma query, no Event Storming ela é mantida como intenção do usuário.

**Ator:** Usuário autenticado

### Resultado

`AvailableVacanciesDisplayed`

### Regra candidata

A listagem deve apresentar apenas vagas elegíveis para descoberta.

> **Hotspot:** hoje ainda não está formalizado se isso significa apenas `PUBLISHED` ou se haverá outras regras.

---

## 10.3 Comando: Pesquisar vagas

### Entrada

- termo textual.

### Read Model

`VacancySearchResults`

### Política

Combinar termo textual com filtros ativos.

### Hotspots

Definir quais campos participam da pesquisa:

- título;
- descrição;
- cidade;
- estado;
- tipo de emprego;
- empresa;
- outros.

---

## 10.4 Comando: Aplicar filtros

### Evento observável

`VacancyFiltersApplied`

### Possíveis filtros ainda não confirmados

- trabalho remoto;
- estado;
- cidade;
- tipo de emprego;
- remuneração;
- interesse/categoria.

> Esses filtros são hipóteses. O mockup confirma a existência da ação de filtrar, mas não define o conjunto final de filtros.

---

## 10.5 Comando: Remover filtro

### Evento

`VacancyFilterRemoved`

### Política

Reexecutar a consulta utilizando os critérios restantes.

---

# 11. Event Storming detalhado — Job Applications

## 11.1 Agregado: JobApplication

Responsável por proteger as regras da candidatura.

### Possíveis atributos

- id;
- candidateId;
- vacancyId;
- status;
- createdAt;
- updatedAt.

### Status inicial candidato

`APPLIED`

> Outros status não devem ser adicionados sem requisito explícito.

---

## 11.2 Comando: Candidatar-se à vaga

**Ator:** Usuário autenticado

### Agregado

`JobApplication`

### Evento

`ApplicationSubmitted`

ou, em português:

`CandidaturaRealizada`

### Invariantes candidatas

- usuário precisa estar autenticado;
- vaga precisa existir;
- vaga deve estar disponível para candidatura;
- usuário não pode possuir candidatura duplicada para a mesma vaga.

### Hotspot

Definir se o criador de uma vaga pode candidatar-se à própria vaga.

Recomendação de domínio a validar:

```text
creatorId != candidateId
```

---

## 11.3 Tentativa de candidatura duplicada

### Dado

Já existe candidatura do mesmo usuário para a mesma vaga.

### Comando

`ApplyToVacancy`

### Resultado

Comando rejeitado.

### Evento opcional de auditoria

`DuplicateApplicationRejected`

> Esse evento só precisa existir como evento persistido se houver valor de auditoria. Caso contrário, pode ser apenas um resultado de validação.

---

## 11.4 Comando: Consultar minhas candidaturas

### Read Model

`MyApplications`

### Dados sugeridos

- applicationId;
- vacancyId;
- title;
- organization/creator;
- date;
- location;
- compensation;
- status;
- details action.

---

## 11.5 Comando: Consultar detalhes de uma candidatura

### Read Model

`ApplicationDetails`

ou

`AppliedVacancyDetails`

### Resultado

Dados detalhados da vaga e da candidatura.

### Hotspot

A UI ainda não define se o detalhe será:

- modal;
- drawer;
- rota/página própria.

---

# 12. Políticas identificadas

## POLICY-001 — Sessão inválida força reautenticação

```text
<SessionExpired>
  ↓
[ClearLocalSession]
  ↓
[RedirectToLogin]
```

---

## POLICY-002 — Nova candidatura atualiza a visualização da vaga

```text
<ApplicationSubmitted>
  ↓
[RefreshVacancyApplicationState]
  ↓
Vaga passa a indicar "já candidatado"
```

---

## POLICY-003 — Nova candidatura atualiza Minhas Candidaturas

```text
<ApplicationSubmitted>
  ↓
[RefreshMyApplications]
```

---

## POLICY-004 — Modalidade remota altera requisitos de endereço

```text
<VacancyMarkedAsRemote>
  ↓
[DisableOnsiteAddressRequirements]
```

---

## POLICY-005 — Modalidade presencial ativa requisitos de endereço

```text
<VacancyMarkedAsOnsite>
  ↓
[EnableOnsiteAddressRequirements]
```

---

## POLICY-006 — Estado selecionado restringe cidades

```text
<StateSelected>
  ↓
[LoadCitiesForState]
  ↓
<CitiesAvailableForSelection>
```

Aplicável a:

- perfil;
- criação de vaga presencial.

---

## POLICY-007 — Mudança de estado invalida cidade incompatível

```text
<StateChanged>
  ↓
Verificar cidade atual
  ↓
se incompatível
  ↓
[ClearSelectedCity]
```

---

## POLICY-008 — Publicação exige validação completa

```text
[PublishVacancy]
  ↓
[ValidateVacancyForPublication]
  ├── inválida → rejeitar
  └── válida → <VacancyPublished>
```

---

## POLICY-009 — Rascunho utiliza validação mais permissiva

```text
[SaveVacancyDraft]
  ↓
[ValidateVacancyForDraft]
  ↓
<VacancyDraftSaved>
```

A validação de rascunho não deve ser igual à validação de publicação.

---

## POLICY-010 — Atualização bem-sucedida do perfil sincroniza read model

```text
<ProfileUpdated>
  ↓
[RefreshMyProfile]
```

---

# 13. Agregados candidatos

## 13.1 UserAccount

Responsabilidade:

- identidade usada na autenticação.

Possível relação:

```text
UserAccount
    │ 1
    │
    │ 1
UserProfile
```

> Pode ser uma única entidade `User` no modelo físico. A separação aqui é conceitual.

---

## 13.2 UserProfile

Responsabilidade:

- dados pessoais;
- localização;
- escolaridade;
- interesses;
- apresentação.

Protege:

- integridade do perfil;
- interesses sem duplicidade;
- consistência de localização.

---

## 13.3 Vacancy

Responsabilidade:

- ciclo de criação;
- rascunho;
- publicação;
- invariantes de modalidade;
- dados da vaga.

Protege:

- regras remoto/presencial;
- requisitos mínimos de publicação;
- ownership.

---

## 13.4 JobApplication

Responsabilidade:

- vínculo candidato ↔ vaga.

Protege:

```text
(candidateId, vacancyId) deve ser único
```

Essa regra deve idealmente existir também como constraint de persistência.

---

# 14. Relações conceituais

```text
User
 │
 ├────────────── 1 UserProfile
 │                    │
 │                    └── * Interests
 │
 ├────────────── * Vacancies created
 │
 └────────────── * Applications
                         │
                         │ * : 1
                         ▼
                      Vacancy
```

Forma alternativa:

```text
User
 ├── owns Profile
 ├── creates Vacancy
 └── submits Application

Vacancy
 └── receives Application

Application
 ├── belongs to User
 └── belongs to Vacancy
```

---

# 15. Read Models

## RM-001 — AuthenticatedUserHeader

Utilizado no cabeçalho.

Dados:

- userId;
- displayName ou identificador;
- session state.

---

## RM-002 — AvailableVacancies

Utilizado em `Vagas`.

Dados mínimos derivados do mockup:

- id;
- título;
- identificação do publicador/empresa;
- data;
- localização;
- remuneração;
- tipo;
- candidatura existente.

---

## RM-003 — VacancySearchResults

Representação da listagem após:

- pesquisa;
- filtros;
- pesquisa + filtros.

---

## RM-004 — MyApplications

Utilizado em `Minhas Candidaturas`.

Dados:

- applicationId;
- vacancyId;
- resumo da vaga;
- status, se aplicável;
- ação para detalhes.

---

## RM-005 — ApplicationDetails

Detalhes de uma candidatura e/ou vaga relacionada.

Campos dependem da definição final da UI.

---

## RM-006 — VacancyCreationForm

Read/write model utilizado na criação.

Inclui:

- dados básicos;
- contato;
- remuneração;
- modalidade;
- localização;
- descrição;
- requisitos.

---

## RM-007 — MyVacancyDrafts

Ainda não possui tela definida.

Deve permitir identificar:

- id;
- título ou fallback;
- última atualização;
- modalidade;
- estado `DRAFT`.

---

## RM-008 — MyProfile

Inclui:

- nome;
- e-mail;
- CPF;
- telefone;
- escolaridade;
- endereço;
- estado;
- cidade;
- sobre;
- interesses.

---

## RM-009 — ReferenceData

Pode fornecer:

- estados;
- cidades;
- escolaridades;
- tipos de emprego;
- interesses.

---

# 16. Sistemas externos ou dependências

## 16.1 Banco de dados

Responsável por persistência.

Dados principais candidatos:

- users;
- profiles;
- interests;
- user_interests;
- vacancies;
- applications;
- sessions ou refresh tokens, dependendo da estratégia.

---

## 16.2 Serviço de autenticação

Pode ser:

- interno ao backend;
- provedor externo.

> Ainda não definido.

---

## 16.3 Fonte de estados e cidades

Pode ser:

- banco interno;
- arquivo estático;
- serviço externo.

> Ainda não definido.

---

# 17. Fluxos ponta a ponta

# 17.1 Login bem-sucedido

```text
Visitante
  ↓
[EnterCredentials]
  ↓
[AuthenticateUser]
  ↓
<UserAuthenticated>
  ↓
Política: criar/restaurar contexto autenticado
  ↓
[LoadAvailableVacancies]
  ↓
AvailableVacancies
```

---

# 17.2 Usuário consulta e se candidata a uma vaga

```text
Usuário autenticado
  ↓
[LoadAvailableVacancies]
  ↓
AvailableVacancies
  ↓
[ApplyToVacancy]
  ↓
Application
  ↓
<ApplicationSubmitted>
  ↓
Política
  ├── atualizar card da vaga
  └── atualizar Minhas Candidaturas
```

---

# 17.3 Usuário pesquisa e filtra vagas

```text
Usuário
  ↓
[SearchVacancies]
  ↓
<SearchCriteriaChanged>
  ↓
[ApplyVacancyFilters]
  ↓
<VacancyFiltersApplied>
  ↓
[QueryVacancies]
  ↓
VacancySearchResults
```

---

# 17.4 Usuário cria uma vaga presencial

```text
Usuário
  ↓
[StartVacancyCreation]
  ↓
<VacancyDraftStarted>
  ↓
[SetEmploymentType]
  ↓
[SetContactInformation]
  ↓
[SetCompensation]
  ↓
[MarkVacancyAsOnsite]
  ↓
<VacancyMarkedAsOnsite>
  ↓
[SetVacancyAddress]
  ↓
[SetDescription]
  ↓
[SetRequirements]
  ↓
[PublishVacancy]
  ↓
Validate publication rules
  ↓
<VacancyPublished>
```

---

# 17.5 Usuário cria uma vaga remota

```text
Usuário
  ↓
[StartVacancyCreation]
  ↓
<VacancyDraftStarted>
  ↓
[SetBasicVacancyData]
  ↓
[MarkVacancyAsRemote]
  ↓
<VacancyMarkedAsRemote>
  ↓
Política: endereço deixa de ser obrigatório
  ↓
[SetDescription]
  ↓
[SetRequirements]
  ↓
[PublishVacancy]
  ↓
<VacancyPublished>
```

---

# 17.6 Usuário salva um rascunho

```text
Usuário
  ↓
[StartVacancyCreation]
  ↓
<VacancyDraftStarted>
  ↓
[ChangeVacancyDraft]
  ↓
[SaveVacancyDraft]
  ↓
Validate draft rules
  ↓
<VacancyDraftSaved>
```

---

# 17.7 Usuário recupera um rascunho

```text
Usuário
  ↓
[OpenMyVacancyDrafts]
  ↓
MyVacancyDrafts
  ↓
[OpenVacancyDraft]
  ↓
<VacancyDraftLoaded>
  ↓
VacancyCreationForm preenchido
```

---

# 17.8 Usuário atualiza perfil

```text
Usuário
  ↓
[LoadMyProfile]
  ↓
MyProfile
  ↓
[ChangeProfileFields]
  ↓
[AddInterest] / [RemoveInterest]
  ↓
[SaveProfile]
  ↓
Validate profile
  ↓
<ProfileUpdated>
```

---

# 18. Invariantes de domínio candidatas

Estas regras ainda precisam ser confirmadas na modelagem formal do domínio.

## User / Profile

- usuário autenticado só altera o próprio perfil;
- e-mail deve possuir formato válido;
- CPF não pode ser duplicado entre usuários, caso seja identificador único;
- cidade deve pertencer ao estado selecionado;
- interesse não pode ser duplicado no mesmo perfil.

---

## Vacancy

- uma vaga possui um proprietário/criador;
- rascunho pode ser incompleto;
- vaga publicada deve possuir todos os campos obrigatórios;
- vaga presencial precisa de localização válida;
- vaga remota não exige endereço presencial;
- remuneração não pode ser negativa;
- somente o proprietário autorizado pode alterar seu rascunho.

---

## Application

- candidatura pertence a um usuário;
- candidatura pertence a uma vaga;
- combinação `(candidateId, vacancyId)` é única;
- vaga deve estar disponível para receber candidatura;
- candidatura duplicada deve ser rejeitada.

---

# 19. Hotspots e decisões em aberto

## HOTSPOT-001 — Papéis de usuário

Pergunta:

Existe diferença entre:

- candidato;
- recrutador;
- empresa;
- administrador?

Impacta:

- autorização;
- navegação;
- criação de vaga;
- candidatura;
- modelo de dados.

---

## HOTSPOT-002 — Empresa / organização

O card de vaga sugere informação de empresa/publicador.

É necessário definir:

- existe entidade `Company`?
- vaga pertence a `User` ou `Company`?
- usuário pode representar uma empresa?
- nome exibido vem do perfil do criador?

---

## HOTSPOT-003 — CPF

Definir:

- obrigatório?
- único?
- editável?
- mascarado em respostas?
- armazenado protegido?

---

## HOTSPOT-004 — Estratégia de autenticação

Definir:

- JWT;
- sessão server-side;
- access + refresh token;
- provedor externo.

---

## HOTSPOT-005 — Filtros

O mockup confirma a ação, mas não define os filtros.

Precisamos fechar:

- campos filtráveis;
- operadores;
- combinação;
- persistência na URL ou estado local.

---

## HOTSPOT-006 — Busca

Definir quais atributos são pesquisáveis.

---

## HOTSPOT-007 — Detalhes da vaga/candidatura

Definir:

- página;
- modal;
- drawer;
- conteúdo apresentado.

---

## HOTSPOT-008 — Rascunhos

Definir:

- onde são listados;
- como abrir;
- se podem ser excluídos;
- se existe autosave;
- validação mínima.

---

## HOTSPOT-009 — Perfil

Definir:

- botão explícito `Salvar alterações`;
- ou autosave.

Recomendação atual:

`Salvar alterações`.

---

## HOTSPOT-010 — Estados de Vacancy

Atualmente inferidos:

- `DRAFT`;
- `PUBLISHED`.

Avaliar necessidade futura de:

- `CLOSED`;
- `ARCHIVED`;
- `CANCELLED`.

Não implementar sem requisito.

---

## HOTSPOT-011 — Estados de JobApplication

Atualmente somente a existência de candidatura é necessária.

Não adicionar workflow como:

- `REVIEWING`;
- `ACCEPTED`;
- `REJECTED`;

sem requisito explícito.

---

## HOTSPOT-012 — Usuário pode candidatar-se à própria vaga?

Precisa de regra explícita.

---

## HOTSPOT-013 — Dados de referência

Definir origem de:

- cidades;
- estados;
- escolaridade;
- tipo de emprego;
- interesses.

---

## HOTSPOT-014 — Remuneração

Definir:

- moeda;
- precisão;
- se zero é permitido;
- se existe faixa mínima/máxima;
- valor mensal, horário ou outro;
- se pode ser "a combinar".

---

## HOTSPOT-015 — Contato da vaga

Definir:

- e-mail e telefone obrigatórios?
- podem vir pré-preenchidos do perfil?
- podem ser diferentes dos dados pessoais?
- são públicos para candidatos?

---

# 20. Comandos consolidados

## Identity & Access

- `AuthenticateUser`
- `RestoreSession`
- `EndSession`
- `ClearLocalSession`

## User Profile

- `LoadMyProfile`
- `UpdateProfile`
- `AddInterest`
- `RemoveInterest`
- `SelectState`
- `SelectCity`

## Vacancy Management

- `StartVacancyCreation`
- `ChangeVacancyDraft`
- `SetEmploymentType`
- `SetContactInformation`
- `SetCompensation`
- `MarkVacancyAsRemote`
- `MarkVacancyAsOnsite`
- `SetVacancyAddress`
- `SetDescription`
- `SetRequirements`
- `SaveVacancyDraft`
- `OpenVacancyDraft`
- `PublishVacancy`

## Vacancy Discovery

- `LoadAvailableVacancies`
- `SearchVacancies`
- `ApplyVacancyFilters`
- `RemoveVacancyFilter`

## Applications

- `ApplyToVacancy`
- `LoadMyApplications`
- `LoadApplicationDetails`

---

# 21. Eventos consolidados

## Identity & Access

- `UserAuthenticated`
- `AuthenticationRejected`
- `SessionRestored`
- `SessionExpired`
- `SessionEnded`

## User Profile

- `ProfileUpdated`
- `InterestAddedToProfile`
- `InterestRemovedFromProfile`
- `StateSelected`
- `CitySelected`

## Vacancy Management

- `VacancyDraftStarted`
- `VacancyDraftChanged`
- `VacancyMarkedAsRemote`
- `VacancyMarkedAsOnsite`
- `VacancyDraftSaved`
- `VacancyDraftLoaded`
- `VacancyPublished`
- `VacancyPublicationRejected`

## Vacancy Discovery

- `VacancyFiltersApplied`
- `VacancyFilterRemoved`
- `VacancySearchCriteriaChanged`

## Applications

- `ApplicationSubmitted`
- `DuplicateApplicationRejected`

---

# 22. Mapeamento entre bounded contexts

```text
┌───────────────────────┐
│   Identity & Access   │
└───────────┬───────────┘
            │ authenticated user
            ▼
┌───────────────────────┐
│     User Profile      │
└───────────────────────┘

            │ userId
            ▼
┌───────────────────────┐
│  Vacancy Management   │
└───────────┬───────────┘
            │ published vacancies
            ▼
┌───────────────────────┐
│   Vacancy Discovery   │
└───────────┬───────────┘
            │ selected vacancy
            ▼
┌───────────────────────┐
│     Applications      │
└───────────────────────┘
```

Dependências conceituais:

```text
Identity & Access
    ↓ fornece identidade

User Profile
Vacancy Management
Applications

Vacancy Management
    ↓ fornece vagas publicadas

Vacancy Discovery
Applications

Applications
    ↓ fornece estado de candidatura

Vacancy Discovery
```

---

# 23. Context Map preliminar

## Identity & Access → demais contextos

Contrato fornecido:

```text
AuthenticatedUser
- userId
- authorization context
```

---

## Vacancy Management → Vacancy Discovery

Contrato conceitual:

```text
PublishedVacancy
- id
- title
- employmentType
- compensation
- remote
- location
- publishedAt
- display owner
```

---

## Vacancy Management → job-applications

`job-applications` precisa verificar:

- vaga existe;
- vaga está disponível;
- identificador do proprietário, se a regra de autocandidatura existir.

---

## job-applications → Vacancy Discovery

Pode fornecer:

```text
hasApplied(vacancyId, userId)
```

ou um read model já enriquecido.

Objetivo:

permitir que a interface indique que o usuário já se candidatou.

---

# 24. Dados que devem orientar o OpenAPI

O Event Storming sugere pelo menos os seguintes grupos de endpoints.

> Estes endpoints são apenas uma consequência candidata do domínio. O contrato final deve ser decidido na etapa Contract-First.

## Auth

```text
POST /auth/login
POST /auth/logout
GET  /auth/me
```

---

## Profile

```text
GET /profile
PUT/PATCH /profile
```

Interesses podem ser tratados:

- dentro do payload do perfil; ou
- em endpoints específicos.

Decisão deve considerar consistência e simplicidade.

---

## Vacancies

```text
GET  /vacancies
POST /vacancies
GET  /vacancies/{id}
```

Possíveis operações adicionais:

```text
GET   /vacancies/drafts
GET   /vacancies/drafts/{id}
PATCH /vacancies/{id}
POST  /vacancies/{id}/publish
```

A modelagem final depende de como rascunho e publicação forem tratados.

---

## Applications

```text
POST /vacancies/{vacancyId}/applications
GET  /applications/me
GET  /applications/{id}
```

---

## Reference Data

Possíveis:

```text
GET /states
GET /states/{stateId}/cities
GET /employment-types
GET /education-levels
GET /interests
```

Pode não ser necessário endpoint para tudo caso alguns valores sejam enums versionados no contrato.

---

# 25. Sugestão de eventos que NÃO precisam ser persistidos

Nem todo item usado no Event Storming precisa virar uma tabela de eventos ou Event Sourcing.

Exemplos que podem permanecer apenas como conceitos:

- `VacancyFiltersApplied`;
- `VacancyFilterRemoved`;
- `ProfileDisplayed`;
- `AvailableVacanciesDisplayed`;
- `CitiesAvailableForSelection`.

O objetivo do Event Storming é descobrir comportamento.

A arquitetura atual **não precisa usar Event Sourcing**.

---

# 26. Sequência recomendada após este Event Storming

## Etapa 1 — Resolver hotspots críticos

Prioridade:

1. papéis de usuário;
2. empresa/publicador;
3. autenticação;
4. CPF;
5. filtros;
6. rascunhos;
7. detalhes de vaga;
8. salvamento de perfil;
9. dados de referência;
10. regras de candidatura.

---

## Etapa 2 — Criar modelo de domínio

Documentar formalmente:

```text
User
UserProfile
Interest
Vacancy
Application
Address
```

Para cada entidade/agregado:

- atributos;
- value objects;
- invariantes;
- lifecycle;
- relacionamentos;
- ownership.

---

## Etapa 3 — Criar Architecture Drivers

Extrair:

- requisitos funcionais críticos;
- atributos de qualidade;
- restrições tecnológicas;
- requisitos de segurança;
- integração frontend/backend;
- testabilidade;
- deploy.

---

## Etapa 4 — Criar C4

Produzir:

- C1 — System Context;
- C2 — Containers;
- C3 — Components relevantes.

---

## Etapa 5 — Registrar ADRs necessários

Exemplos:

- estratégia de autenticação;
- organização arquitetural do backend;
- organização do frontend;
- contrato REST;
- estratégia para dados de referência.

---

## Etapa 6 — Definir OpenAPI

Transformar:

```text
Comandos
+
Queries
+
Eventos relevantes
+
Invariantes
```

em contratos HTTP claros.

---

## Etapa 7 — Refinar specs para Ready

Cada spec deve ligar:

```text
User Stories
    +
Given / When / Then
    +
Regras de domínio
    +
Contratos da API
    +
Arquitetura aplicável
    +
Testes esperados
```

---

# 27. Resultado do Event Storming

O Event Storming atual identifica como núcleo do sistema:

```text
User
    │
    ├── UserProfile
    │       └── Interests
    │
    ├── creates
    │      ↓
    │    Vacancy
    │      │
    │      ├── DRAFT
    │      └── PUBLISHED
    │
    └── submits
           ↓
       Application
           │
           └── Vacancy
```

Os comportamentos principais são:

```text
Authenticate User
Update Profile
Discover Vacancies
Search Vacancies
Filter Vacancies
Create Vacancy
Save Vacancy Draft
Publish Vacancy
Apply To Vacancy
View Applications
```

E as principais invariantes candidatas são:

```text
Application:
one candidate + one vacancy = at most one application

Vacancy:
DRAFT may be incomplete

Vacancy:
PUBLISHED must satisfy publication requirements

Vacancy:
ONSITE requires location

Vacancy:
REMOTE does not require physical address

Profile:
city must be compatible with state

Profile:
interest cannot be duplicated
```

---

# 28. Status do documento

Este Event Storming deve ser considerado:

**Discovery / Draft**

Ele se torna uma referência de domínio estável somente depois que os hotspots forem resolvidos.

Não utilizar hipóteses marcadas como `Hotspot` como requisitos definitivos de implementação.
