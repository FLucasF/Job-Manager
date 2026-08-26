# End-to-End Test Data

Referência para criar, isolar, rastrear e limpar dados utilizados por cenários E2E.

## Contents

- Test ownership
- Explicit preconditions
- Factories and builders
- Unique data
- API and database setup
- Authentication data
- Parallel execution
- Dates and external effects
- Sensitive data
- Cleanup and retries
- Responsibility boundaries

## Test Data Responsibility

[HARD RULE] Cada cenário deve executar sobre estado conhecido, reproduzível e independente.

```text
scenario
→ known preconditions
→ owned test data
→ journey
→ observable result
```

Evite dependência de:

- dados que "já devem existir";
- execuções anteriores;
- ordem dos testes;
- developer machine;
- usuários mutáveis compartilhados.

## Every Test Owns Required State

[HARD RULE] Cada cenário cria ou recebe explicitamente os recursos mutáveis de que precisa.

Nunca:

```text
Test A
→ creates user

Test B
→ assumes user from A exists
```

## Explicit Preconditions

[DEFAULT] Torne visíveis os dados que alteram o comportamento.

```ts
createTestVacancy({
  status: 'OPEN',
  ownerId: recruiter.id,
})
```

é preferível a esconder `status`/`ownerId` em defaults quando eles definem o cenário.

## Minimal but Valid Data

[DEFAULT] Use defaults válidos + overrides específicos.

```text
valid baseline
+
scenario-relevant values
```

Evite fixtures enormes com propriedades irrelevantes.

## Factories

[DEFAULT] Use factories quando vários cenários precisam criar entidades válidas.

```ts
createTestUser({
  role: 'RECRUITER',
})
```

[HARD RULE] Defaults não devem conceder capacidades inesperadas.

Evite default `ADMIN` quando a maioria dos cenários não precisa disso.

## Builders

[SITUATIONAL] Builders podem ajudar em grafos relacionais mais complexos.

Use quando tornam relações claras:

```text
company
→ recruiter
→ vacancy
→ application
```

Não esconda relações que determinam o comportamento.

## Avoid Magic Fixtures

[HARD RULE] Não dependa de convenções como:

```text
user #3 is recruiter
vacancy #7 is closed
```

O cenário deve expressar isso explicitamente.

## Static Seed Data

[SITUATIONAL] Compartilhe somente dados realmente estáveis/imutáveis:

- reference categories;
- countries;
- system roles;
- read-only configuration.

[HARD RULE] Recursos que podem ser editados, excluídos ou consumidos não devem ser seed compartilhado mutável.

## Unique Test Data

[DEFAULT] Recursos mutáveis devem evitar colisões entre:

```text
parallel workers
retries
shards
other runs
```

Exemplo:

```text
recruiter-e2e-<run>-<worker>@example.test
vacancy-e2e-<unique-id>
```

## Deterministic Uniqueness

[DEFAULT] Prefira identificadores rastreáveis.

Possíveis componentes:

```text
runId
parallelIndex
testId
controlled UUID
```

[HARD RULE] Randomness não deve decidir role, status, permission ou qualquer propriedade que altera a regra testada.

## Reproducibility

[HARD RULE] Quando um teste falhar, deve ser possível reconstruir seus dados relevantes.

Se usar geração aleatória, registre/preserve a seed ou identificadores necessários.

## Setup Through API

[DEFAULT] Use API/helpers para preconditions quando a ação não é parte da jornada.

```text
Goal
→ edit vacancy through UI

Setup
→ create vacancy through API

Journey
→ open
→ edit
→ save
```

[HARD RULE] Não use API setup para bypassar o comportamento sob teste.

## Setup Helpers

[DEFAULT] Helpers devem expressar capacidades claras:

```text
testData.createRecruiter(...)
testData.createVacancy(...)
```

e retornar identificadores úteis.

[HARD RULE] Não esconda side effects importantes em helper genérico.

## Direct Database Setup

[SITUATIONAL] Pode ser adequado para:

- fast seeding;
- environment reset;
- complex preconditions;
- isolated test infrastructure.

[DEFAULT] Prefira API quando ela é suficientemente estável e rápida.

[HARD RULE] Se database setup for necessário, encapsule-o; não espalhe SQL pelos tests.

## Database State Must Be Known

[HARD RULE] Persistência usada pela suíte precisa de estratégia explícita:

```text
disposable environment
isolated database/schema
reset
unique data + cleanup
```

Não use uma base de conteúdo desconhecido como precondition.

## Authentication Users

[DEFAULT] Use usuários que representem exatamente o papel necessário.

```text
candidate
recruiter
admin
```

[HARD RULE] Não autentique tudo como admin apenas para simplificar setup.

## Least Privilege

[DEFAULT] Test data deve possuir a menor capacidade necessária à jornada.

Isso torna permission regressions visíveis.

## Shared Auth State

[SITUATIONAL] Uma mesma identidade pode ser compartilhada apenas quando cenários não alteram estado conflitante.

Não compartilhe indiscriminadamente se tests fazem:

- logout;
- password/profile change;
- permission change;
- account deletion;
- mutable resource ownership.

Mecânica de `storageState` pertence a `playwright.md`.

## Parallel Execution

[HARD RULE] Dados devem suportar workers paralelos sem interferência.

Evite:

```text
same mutable email
same unique title
delete all records
global singleton modification
```

[DEFAULT] Isolamento por worker/database/schema é forte quando a infraestrutura suporta, mas não é obrigatório se unique owned data resolve.

## Global Counts

[HARD RULE] Não faça assertion:

```text
there are exactly 5 vacancies
```

em ambiente onde outros scenarios podem criar dados.

Prefira localizar o recurso pertencente ao teste.

## Time and Dates

[DEFAULT] Use datas relativas/controladas quando o cenário depende de tempo.

Evite fixtures que expiram inesperadamente.

```text
expiration = fixed date in the near future
```

eventualmente quebra.

[DEFAULT] Quando timezone é relevante, torne-o explícito no data/environment contract.

## External Notifications

[HARD RULE] Test data nunca deve causar acidentalmente:

```text
real email
real SMS
real push
real payment
real production webhook
```

Use sandboxes/fakes/controlled boundaries.

## Personal and Payment Data

[HARD RULE] Não use PII real, cartão real ou contas reais.

Use dados sintéticos e instrumentos de sandbox.

## Sensitive Data in Artifacts

[HARD RULE] Screenshots, traces, videos e logs podem capturar dados de teste.

Use dados seguros mesmo no ambiente E2E.

## File Fixtures

[DEFAULT] Arquivos versionados devem ser pequenos, estáveis e destinados a teste.

[SITUATIONAL] Gere arquivos dinamicamente quando o conteúdo precisa ser único ou específico do cenário.

Não dependa de path local da máquina do desenvolvedor.

## Cleanup Strategy

[HARD RULE] Defina como dados deixam de afetar execuções futuras.

Opções:

```text
environment disposal
database reset
delete after test/suite
TTL cleanup
unique isolated database
```

[DEFAULT] Prefira disposal/reset quando a infraestrutura torna isso simples e confiável.

## Do Not Delete Unowned Data

[HARD RULE] Cleanup só remove recursos pertencentes à execução/teste.

Nunca use cleanup amplo em ambiente compartilhado sem namespace/ownership seguro.

## Cleanup Must Be Idempotent

[DEFAULT] Reexecutar cleanup não deve criar uma segunda falha desnecessária se o recurso já desapareceu.

## Preserve Original Failure

[HARD RULE] Falha de cleanup deve ser visível, mas não apagar a causa original de um journey failure.

## Retry-Aware Data

[HARD RULE] Retry não deve reutilizar estado quebrado de uma tentativa anterior.

Use:

```text
idempotent setup
fresh unique data
known reset
```

conforme a estratégia.

## Sharding

[DEFAULT] Dados não devem assumir que todos os testes executam na mesma máquina/job.

Namespaces/identifiers precisam funcionar entre shards quando a suíte é distribuída.

## Local and CI Consistency

[DEFAULT] A estratégia conceitual de dados deve ser a mesma localmente e em CI.

Valores concretos podem mudar por environment, mas não dependa de preconditions manuais locais.

## Failure Classification

[DEFAULT] Diferencie:

```text
setup failure
journey failure
cleanup failure
```

Isso melhora diagnóstico.

Detalhes pertencem a `failure-diagnosis.md`.

## Responsibility Boundaries

Esta referência é dona de:

- factories/builders;
- precondition data;
- uniqueness/isolation;
- authentication identities;
- data cleanup/lifecycle;
- retry/shard-safe data.

Outras responsabilidades:

- scenario selection → `test-scenarios.md`;
- environment provisioning → `environment.md`;
- Playwright API setup/auth mechanics → `playwright.md`;
- diagnosing failures → `failure-diagnosis.md`.
