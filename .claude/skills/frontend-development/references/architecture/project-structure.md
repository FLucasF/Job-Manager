# Frontend Project Structure

Referência para decidir onde arquivos e módulos devem viver no frontend.

## Contents

- Base structure
- Feature-first organization
- `app/`
- `features/`
- Feature internal structure
- `shared/`
- Shared vs feature
- Feature public API
- Cross-feature dependencies
- File placement decision
- Responsibility boundaries

## Base Structure

[DEFAULT] Organize a aplicação por responsabilidade de alto nível:

```text
src/
├── app/
├── features/
├── shared/
└── main.tsx
```

Use:

```text
app/
→ composição e configuração global

features/
→ funcionalidades/domínios da aplicação

shared/
→ código reutilizável e independente de feature
```

## Feature-First Organization

[HARD RULE] Código específico de negócio deve permanecer próximo da feature a que pertence.

Prefira:

```text
features/
├── auth/
├── users/
├── vacancies/
└── applications/
```

a uma estrutura global baseada apenas em tipo técnico:

```text
components/
hooks/
repositories/
services/
types/
```

que espalha uma mesma funcionalidade pela aplicação inteira.

## `app/`

[DEFAULT] `app/` pertence à inicialização e composição da aplicação.

Exemplos:

```text
app/
├── providers/
├── router/
├── styles/
└── config/
```

Responsabilidades adequadas:

- global providers;
- router composition;
- global configuration;
- global styles;
- application bootstrap.

[HARD RULE] Não mova regras específicas de uma feature para `app/` apenas porque são usadas por uma página/rota.

## `features/`

Uma feature concentra código relacionado a uma capacidade ou domínio específico.

Exemplo:

```text
features/
└── vacancies/
    ├── components/
    ├── hooks/
    ├── model/
    ├── repository/
    └── types/
```

[DEFAULT] Mantenha código local à feature enquanto não existir motivo real para compartilhá-lo.

## Feature Internal Structure

[DEFAULT] Crie subdiretórios apenas para responsabilidades que realmente existem.

Uma feature pequena pode ser:

```text
profile/
├── ProfileCard.tsx
└── useProfile.ts
```

[HARD RULE] Não crie automaticamente:

```text
components/
hooks/
model/
repository/
types/
pages/
```

apenas para manter simetria entre features.

Quando essas responsabilidades existirem, sua semântica e direção de dependência pertencem a `layered-architecture.md`.

## Feature-Specific Pages

[SITUATIONAL] Use `pages/` dentro da feature quando existe uma distinção útil entre route entry points e componentes internos.

```text
vacancies/
├── pages/
│   ├── VacancyListPage.tsx
│   └── VacancyDetailsPage.tsx
├── components/
└── ...
```

Não crie `pages/` quando não adiciona um boundary real.

Routing decide o significado das páginas como route boundaries.

## `shared/`

[HARD RULE] `shared/` contém código reutilizável que não conhece domínio específico.

Exemplos:

```text
shared/
├── api/
├── ui/
├── hooks/
├── lib/
└── config/
```

Bons candidatos:

```text
Button
Modal
http-client
formatDate
environment config
```

Não coloque:

```text
VacancyCard
useVacancies
vacancyRepository
canApplyToVacancy
```

em `shared/` apenas porque parecem reutilizáveis.

## Shared vs Feature

Use esta pergunta:

```text
O módulo pode existir sem conhecer
Vacancy, User, Application
ou outro domínio da aplicação?
```

Se sim, pode ser candidato a `shared/`.

Se conhece diretamente uma feature/domínio, mantenha-o próximo desse domínio.

## Shared Must Not Depend on Features

[HARD RULE] A direção permitida é:

```text
feature
→ shared
```

Não:

```text
shared
→ feature
```

Se um módulo em `shared/` precisa importar uma feature específica, reavalie seu ownership.

## Avoid Premature Sharing

[HARD RULE] Não mova código para `shared/` por antecipação.

Antes de compartilhar, confirme:

1. existe reutilização ou independência real;
2. o comportamento compartilhado é realmente o mesmo;
3. a abstração não precisa conhecer regras específicas das features;
4. compartilhar reduz duplicação sem aumentar acoplamento.

Código parecido não implica responsabilidade compartilhada.

## Feature Public API

[SITUATIONAL] Quando uma feature possui consumidores externos e internals relevantes, uma API pública pode estabilizar esse boundary.

Exemplo:

```text
features/vacancies/index.ts
```

pode expor somente capacidades públicas.

```ts
export { VacancyCard } from './components/VacancyCard'
export { useVacancies } from './hooks/useVacancies'
```

[HARD RULE] Não introduza barrel/public API apenas por convenção quando a feature ainda é pequena.

## Avoid Cross-Feature Internal Coupling

[DEFAULT] Código externo não deve depender de internals profundos de outra feature quando aquilo representa uma capacidade pública.

Evite:

```ts
import { something }
  from '@/features/vacancies/model/internal/helpers'
```

se o consumidor deveria usar uma API pública estável.

[HARD RULE] Não crie dependências cíclicas entre features para facilitar um caso local.

Quando duas features realmente compartilham uma capacidade, reavalie ownership ou extraia uma abstração independente somente se ela possuir responsabilidade própria.

## File Placement Decision

Ao criar ou mover um arquivo:

```text
É composição/configuração global?
→ app/

Pertence a um domínio/capacidade específica?
→ features/<feature>/

É reutilizável e independente de features?
→ shared/
```

Dentro de uma feature, só então classifique a responsabilidade:

```text
presentation
→ components/pages

React integration
→ hooks

pure feature rules
→ model

external data access
→ repository
```

[HARD RULE] Não escolha localização apenas pela extensão do arquivo ou pelo tipo técnico.

## Moving Existing Files

[DEFAULT] Ao mover um arquivo, preserve seus boundaries públicos quando possível.

Verifique:

- imports internos;
- aliases;
- public API da feature;
- consumers externos;
- dependency direction.

Não transforme uma reorganização física em mudança arquitetural acidental.

## Responsibility Boundaries

Esta referência é dona de:

- `app/`, `features/`, `shared/`;
- colocação física de arquivos;
- feature-first organization;
- shared-vs-feature;
- feature public API.

Outras responsabilidades:

- responsabilidades das camadas → `layered-architecture.md`;
- ownership de estado → `state-placement.md`;
- Repository/HTTP → `data-access.md`;
- route/page boundaries → `routing.md`.
