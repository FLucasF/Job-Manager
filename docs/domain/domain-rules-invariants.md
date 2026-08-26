# Regras e Invariantes do Domínio — Job Manager

**Status:** Draft / candidate rules (non-normative)
**Metodologias:** DDD (Aggregate Invariants) + Specification by Example/BDD para tornar regras testáveis
**Objetivo:** transformar o modelo de domínio em regras explícitas, identificáveis e verificáveis.

---


## Document authority

This document records candidate cross-feature domain rules.

A Ready specification or explicit user request may use a rule here only after
that rule has appropriate accepted authority. Draft/Open rules are refinement
context, not implementation authorization.

Frontend validation may mirror a rule for user experience, but durable
invariants remain enforced by the backend and, where applicable, by database
constraints.

---

# 1. Convenção

Cada regra recebe um identificador estável.

Formato:

```text
<contexto>-<número>
```

Exemplos:

```text
AUTH-001
PROFILE-004
VACANCY-012
APPLICATION-003
```

Esses IDs podem ser citados por:

- `spec.md`;
- testes;
- OpenAPI;
- ADRs;
- mensagens de erro internas;
- documentação técnica.

---

# 2. Níveis de regra

## 2.1 Invariante de domínio

Regra que deve permanecer verdadeira independentemente da interface.

Exemplo:

```text
APPLICATION-001:
um candidato não pode possuir duas candidaturas
para a mesma vaga.
```

## 2.2 Regra de aplicação

Coordena fluxo ou autorização.

Exemplo:

```text
AUTH-004:
rotas privadas exigem identidade autenticada.
```

## 2.3 Regra de apresentação

Comportamento do frontend.

Exemplo:

```text
UI-001:
durante uma mutation, impedir submissão duplicada.
```

Este documento prioriza invariantes e regras de aplicação com impacto no domínio.

---

# 3. Identity & Access

## AUTH-001 — E-mail de login é obrigatório

**Regra**

Uma tentativa de autenticação exige e-mail.

**Given**

Usuário sem e-mail informado.

**When**

Solicita autenticação.

**Then**

A tentativa é rejeitada antes de autenticar.

---

## AUTH-002 — Senha de login é obrigatória

Uma tentativa de autenticação exige senha.

---

## AUTH-003 — E-mail deve estar normalizado

Antes de comparação/persistência:

```text
trim
normalização de casing conforme política
```

A regra de case-insensitive deve ser implementada consistentemente no banco e serviço.

---

## AUTH-004 — Recurso privado exige usuário autenticado

Abrange:

- vagas;
- candidaturas;
- criação de vaga;
- rascunhos;
- perfil.

**Invariante de autorização**

Nenhum caso de uso privado pode confiar apenas no frontend.

O backend deve aplicar autenticação.

---

## AUTH-005 — Usuário só atua em nome da própria identidade

`userId` de operações privadas deve vir do contexto autenticado quando a operação for "meu perfil", "minhas candidaturas" ou "meus rascunhos".

Não confiar em `userId` enviado pelo browser para ownership.

---

## AUTH-006 — Credencial inválida não revela qual parte falhou

Resposta de autenticação não deve distinguir publicamente:

- e-mail inexistente;
- senha incorreta.

---

## AUTH-007 — Senha nunca é persistida em texto puro

Persistir apenas `passwordHash`.

---

## AUTH-008 — Sessão expirada invalida acesso

Ao detectar sessão/token expirado:

- rejeitar a operação;
- remover/invalidar contexto local quando aplicável;
- exigir nova autenticação.

---

# 4. UserAccount

## USER-001 — E-mail de conta é único

Duas contas não podem compartilhar o mesmo e-mail normalizado.

**Enforcement recomendado**

```text
application validation
+
database UNIQUE constraint
```

---

## USER-002 — Conta e perfil possuem relação 1:1

Cada `UserAccount` possui no máximo um `UserProfile`.

Cada `UserProfile` pertence exatamente a um `UserAccount`.

---

# 5. Perfil

## PROFILE-001 — Usuário só altera o próprio perfil

O `userId` alvo é obtido da identidade autenticada.

---

## PROFILE-002 — Nome completo é obrigatório quando o perfil é considerado válido

O frontend mostra nome como obrigatório.

**Validação**

- não nulo;
- não vazio após trim.

Limites exatos de caracteres devem ser definidos no contrato.

---

## PROFILE-003 — E-mail deve possuir formato válido

Se a tela de perfil permitir alterar o e-mail:

- validar formato;
- verificar unicidade;
- atualizar `UserAccount`, não duplicar fonte de verdade no perfil.

---

## PROFILE-004 — CPF deve ser armazenado em forma normalizada

Representação sugerida:

```text
somente dígitos
```

Formatação:

```text
000.000.000-00
```

é responsabilidade de apresentação.

---

## PROFILE-005 — CPF deve ser estruturalmente válido

Quando informado, validar:

- quantidade de dígitos;
- dígitos verificadores.

---

## PROFILE-006 — Política de edição do CPF é uma decisão obrigatória

**Status:** OPEN

Alternativas:

1. imutável após definição;
2. editável com validação;
3. editável apenas por fluxo especial.

Nenhuma implementação deve escolher silenciosamente uma alternativa.

---

## PROFILE-007 — Unicidade do CPF depende de decisão explícita

**Status:** OPEN

Recomendação candidata:

```text
cpf UNIQUE
```

somente se o CPF for identificador único de pessoa no produto.

---

## PROFILE-008 — Telefone deve ser normalizado

Persistir forma canônica.

A máscara visual não deve ser persistida como regra central.

---

## PROFILE-009 — Cidade deve pertencer ao estado selecionado

Para endereço:

```text
city.stateCode == address.stateCode
```

---

## PROFILE-010 — Interesse não pode estar duplicado

O conjunto de interesses do perfil é matematicamente um `Set`.

**Enforcement**

- domínio: `Set<InterestId>`;
- banco: chave única `(user_id, interest_id)`.

---

## PROFILE-011 — Interesse precisa existir no catálogo

Não é permitido associar um `InterestId` inexistente.

---

## PROFILE-012 — Escolaridade deve existir no catálogo

Se informada, deve referenciar opção válida.

---

## PROFILE-013 — Remoção de interesse é idempotente no resultado

Após remover um interesse:

```text
interestId ∉ profile.interests
```

Uma segunda tentativa pode ser:

- no-op; ou
- 404/validation error.

A API deve escolher um comportamento consistente.

---

## PROFILE-014 — Atualização falha não altera estado persistido parcialmente

Alteração de perfil deve ser transacional para os dados coordenados no mesmo caso de uso.

---

# 6. Endereço

## ADDRESS-001 — Estado é obrigatório quando endereço completo é exigido

Aplicável a:

- perfil, se o endereço for obrigatório;
- vaga presencial publicada.

---

## ADDRESS-002 — Cidade é obrigatória quando endereço completo é exigido

---

## ADDRESS-003 — Cidade e estado devem ser consistentes

Nunca persistir:

```text
city.state != selected state
```

---

## ADDRESS-004 — Complemento é opcional

---

## ADDRESS-005 — Número deve ser tratado como texto

Não assumir inteiro.

Isso permite valores como:

```text
S/N
12A
KM 3
```

se o produto decidir aceitá-los.

A validação final precisa ser definida na spec Ready ou solicitação explícita
aplicável.

---

# 7. Vacancy — Ownership

## VACANCY-001 — Toda vaga possui um criador

```text
creatorId != null
```

---

## VACANCY-002 — Criador vem da identidade autenticada

O frontend não define arbitrariamente o proprietário.

---

## VACANCY-003 — Usuário só altera rascunho de sua propriedade

Ao editar ou publicar:

```text
vacancy.creatorId == authenticatedUserId
```

---

# 8. Vacancy — Estado

## VACANCY-004 — Nova vaga começa como DRAFT

Quando persistida pela primeira vez:

```text
status = DRAFT
```

---

## VACANCY-005 — DRAFT pode estar incompleta

Regras obrigatórias para publicação não devem impedir salvamento de rascunho, salvo um mínimo técnico explicitamente definido.

---

## VACANCY-006 — PUBLISHED satisfaz todas as invariantes de publicação

Não existe vaga `PUBLISHED` inválida.

---

## VACANCY-007 — Publicação é transição controlada

Permitido:

```text
DRAFT -> PUBLISHED
```

Não permitir atribuição arbitrária do status pelo request.

---

## VACANCY-008 — `publishedAt` só existe após publicação

```text
status = DRAFT     => publishedAt = null
status = PUBLISHED => publishedAt != null
```

---

# 9. Vacancy — Campos de publicação

## VACANCY-009 — Título é obrigatório para publicação

---

## VACANCY-010 — Tipo de emprego é obrigatório para publicação

O tipo informado deve existir no catálogo/enum contratado.

---

## VACANCY-011 — E-mail de contato é obrigatório para publicação

Deve ser e-mail válido.

---

## VACANCY-012 — Telefone de contato é obrigatório para publicação

Deve estar no formato de domínio aceito.

---

## VACANCY-013 — Remuneração é obrigatória para publicação

**Status parcial**

O mockup indica obrigatoriedade.

Ainda deve ser definido:

- `> 0` ou `>= 0`;
- moeda;
- "a combinar";
- periodicidade.

---

## VACANCY-014 — Descrição é obrigatória para publicação

---

## VACANCY-015 — Requisitos são obrigatórios para publicação

---

## VACANCY-016 — Modalidade é obrigatória para publicação

Valores atuais:

```text
REMOTE
ONSITE
```

---

# 10. Vacancy — Modalidade

## VACANCY-017 — Vaga REMOTE não exige endereço físico

```text
workMode = REMOTE
```

permite:

```text
address = null
```

---

## VACANCY-018 — Vaga ONSITE exige endereço

Para publicar:

```text
workMode = ONSITE
=> address != null
```

---

## VACANCY-019 — Endereço ONSITE precisa ser completo segundo a regra de publicação

No mínimo, conforme mockup:

- endereço;
- número;
- estado;
- cidade.

Complemento opcional.

---

## VACANCY-020 — Alternar para REMOTE não publica automaticamente

Alteração de modalidade apenas muda o rascunho.

---

## VACANCY-021 — Alternar modalidade revalida requisitos

Ao mudar:

```text
REMOTE -> ONSITE
```

a vaga deixa de ser publicável enquanto localização obrigatória estiver ausente.

---

# 11. Vacancy — Rascunho

## DRAFT-001 — Salvar rascunho não exige invariantes completas de publicação

---

## DRAFT-002 — Rascunho pertence ao criador

---

## DRAFT-003 — Apenas o criador pode recuperar o rascunho

---

## DRAFT-004 — Reabrir rascunho preserva dados persistidos

---

## DRAFT-005 — Critério mínimo de rascunho precisa ser definido

**Status:** OPEN

Possibilidades:

- nenhum campo funcional obrigatório;
- título obrigatório;
- ao menos um campo preenchido.

Recomendação: permitir persistência com poucos requisitos para realmente suportar trabalho incompleto.

---

# 12. Vacancy Discovery

## DISCOVERY-001 — Somente vagas elegíveis aparecem em "Vagas disponíveis"

Regra mínima candidata:

```text
status = PUBLISHED
```

---

## DISCOVERY-002 — DRAFT nunca aparece na descoberta pública/autenticada

---

## DISCOVERY-003 — Busca não altera a vaga

Busca é query/read model.

---

## DISCOVERY-004 — Filtros não alteram o domínio

São critérios de consulta.

---

## DISCOVERY-005 — Pesquisa e filtros podem ser combinados

O resultado deve satisfazer:

```text
text criteria
AND
selected filters
```

salvo regra explícita diferente.

---

## DISCOVERY-006 — Filtros disponíveis precisam ser definidos pela autoridade aplicável

**Status:** OPEN

Não implementar campos arbitrários.

---

## DISCOVERY-007 — `alreadyApplied` é derivado da identidade atual

Para cada card:

```text
alreadyApplied =
exists JobApplication(candidateId=currentUser, vacancyId=vacancy.id)
```

---

# 13. JobApplication

## APPLICATION-001 — Candidatura requer usuário autenticado

---

## APPLICATION-002 — Candidatura exige vaga existente

Se `vacancyId` não existe:

```text
404 / domain not found
```

---

## APPLICATION-003 — Candidatura exige vaga publicada

```text
vacancy.status == PUBLISHED
```

---

## APPLICATION-004 — Candidatura é única por candidato e vaga

```text
UNIQUE(candidateId, vacancyId)
```

Essa é uma invariante crítica.

Deve existir tanto em:

- regra de aplicação/domínio;
- constraint no banco.

---

## APPLICATION-005 — Status inicial é APPLIED

```text
new JobApplication.status = APPLIED
```

Enquanto não existir workflow adicional.

---

## APPLICATION-006 — Candidatura pertence ao usuário autenticado

`candidateId` é obtido do contexto autenticado.

---

## APPLICATION-007 — Autocandidatura precisa de decisão explícita

**Status:** OPEN

Regra candidata:

```text
candidateId != vacancy.creatorId
```

Não aplicar sem decisão formal.

---

## APPLICATION-008 — Criar candidatura é atômico

Nunca devem existir duas candidaturas criadas por corrida concorrente.

A constraint única no banco é proteção obrigatória.

---

## APPLICATION-009 — Minha lista contém apenas candidaturas do usuário atual

---

## APPLICATION-010 — Usuário não pode consultar candidatura privada de outro usuário

Se houver endpoint por ID, validar ownership.

---

# 14. Reference Data

## REF-001 — Cidade sempre referencia estado válido

---

## REF-002 — InterestId precisa ser válido

---

## REF-003 — EducationLevelId precisa ser válido

---

## REF-004 — EmploymentTypeId precisa ser válido

---

## REF-005 — Frontend não deve inventar catálogo divergente do backend

Opções devem vir de:

- contrato versionado compartilhado; ou
- endpoint de reference data.

---

# 15. Concorrência e consistência

## CONSISTENCY-001 — Duplicidade de candidatura é protegida no banco

Mesmo com duas requisições simultâneas:

```text
count(candidateId, vacancyId) <= 1
```

---

## CONSISTENCY-002 — E-mail único é protegido no banco

---

## CONSISTENCY-003 — Atualização de agregado usa boundary transacional

Casos de uso que modificam um agregado devem completar ou falhar como uma unidade.

---

## CONSISTENCY-004 — Publicação não pode deixar vaga parcialmente atualizada

Mudança de:

```text
DRAFT -> PUBLISHED
```

e `publishedAt` devem ser persistidas atomicamente.

---

# 16. Segurança de dados

## SECURITY-001 — PasswordHash nunca é retornado pela API

---

## SECURITY-002 — Credenciais nunca aparecem em logs

---

## SECURITY-003 — CPF não deve ser exposto desnecessariamente

Quando uma resposta não precisa de CPF:

```text
não incluir o campo
```

Quando precisar, aplicar política de exposição/mascaramento definida para o produto.

---

## SECURITY-004 — Dados de ownership são verificados no backend

Nunca confiar em:

- botão oculto;
- rota protegida apenas no React;
- `creatorId` recebido do browser.

---

# 17. Regras de erro

Recomendação de classes semânticas.

| Tipo | Exemplo | HTTP candidato |
|---|---|---:|
| Validation | campo inválido | 400 |
| Unauthorized | sem autenticação | 401 |
| Forbidden | recurso de outro usuário | 403 |
| Not Found | vaga inexistente | 404 |
| Conflict | candidatura duplicada | 409 |
| Internal | falha inesperada | 500 |

A definição final pertence ao contrato OpenAPI.

---

# 18. Especificações executáveis candidatas

Exemplo para candidatura.

```gherkin
Feature: Candidatura a vaga

  Scenario: Candidatura criada com sucesso
    Given que o usuário está autenticado
    And a vaga existe
    And a vaga está publicada
    And o usuário ainda não possui candidatura para a vaga
    When o usuário se candidata
    Then uma candidatura deve ser criada com status APPLIED
    And deve existir apenas uma candidatura para o par usuário-vaga

  Scenario: Candidatura duplicada
    Given que o usuário já possui candidatura para a vaga
    When ele tenta se candidatar novamente
    Then a operação deve ser rejeitada por conflito
    And nenhuma candidatura adicional deve ser criada
```

Exemplo para publicação.

```gherkin
Feature: Publicação de vaga

  Scenario: Publicar vaga presencial válida
    Given que a vaga está em DRAFT
    And possui todos os campos obrigatórios
    And a modalidade é ONSITE
    And possui endereço válido
    When o criador publica a vaga
    Then a vaga deve ficar PUBLISHED
    And publishedAt deve ser definido

  Scenario: Publicar vaga presencial sem endereço
    Given que a vaga está em DRAFT
    And a modalidade é ONSITE
    And não possui endereço
    When o criador tenta publicá-la
    Then a publicação deve ser rejeitada
    And a vaga deve permanecer DRAFT
```

---

# 19. Matriz de enforcement

| Regra | Frontend | Backend | Banco |
|---|---:|---:|---:|
| e-mail válido | ✅ | ✅ | — |
| e-mail único | feedback | ✅ | ✅ |
| candidatura única | feedback | ✅ | ✅ |
| vaga PUBLISHED válida | feedback | ✅ | constraints parciais |
| ownership | UX | ✅ | FK/queries |
| cidade pertence ao estado | UX | ✅ | FK/modelagem se possível |
| interesse único no perfil | UX | ✅ | ✅ |
| senha não exposta | — | ✅ | ✅ armazenamento hash |

Princípio:

> validação no frontend melhora UX; invariantes verdadeiras devem ser protegidas no backend e, quando aplicável, também no banco.

---

# 20. Open rules

Material unresolved domain questions are centralized in
[Open Domain Decisions](open-decisions.md). A dependent spec remains Draft, and
directly authorized dependent implementation remains paused, until each
applicable decision is resolved in the correct owner or explicitly outside scope.
