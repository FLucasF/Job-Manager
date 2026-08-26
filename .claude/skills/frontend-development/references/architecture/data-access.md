# Frontend Data Access

Referência para isolar acesso a fontes externas e definir o boundary de Repository.

## Contents

- Data access boundary
- Repository responsibility
- React integration
- Shared transport client
- Repository placement
- External contracts
- Mapping
- Errors
- Mutations and UI effects
- Server-state boundary
- Responsibility boundaries

## Data Access Boundary

[HARD RULE] Presentation não deve conhecer detalhes de transporte.

Evite:

```tsx
function VacancyList() {
  useEffect(() => {
    fetch('/api/vacancies')
  }, [])
}
```

ou hooks de feature que embutem endpoint/serialização quando a arquitetura usa Repository.

Prefira:

```text
Component
→ React integration hook
→ Repository
→ HTTP Client
→ Backend
```

## Repository Responsibility

[DEFAULT] Repository é o boundary entre a feature/aplicação e uma fonte externa de dados.

Pode conhecer:

- endpoints;
- request/response format;
- transport client;
- serialization;
- external DTOs;
- mapping necessário para o modelo interno.

Não deve conhecer:

- React rendering;
- modal/toast;
- navigation;
- component state;
- component implementations.

## Repository API

[DEFAULT] Exponha operações em linguagem útil para a feature.

```ts
export const vacancyRepository = {
  async findAll(): Promise<Vacancy[]> {
    const response = await api.get<VacancyResponse[]>('/vacancies')

    return response.data.map(toVacancy)
  },

  async findById(id: string): Promise<Vacancy> {
    const response = await api.get<VacancyResponse>(
      `/vacancies/${id}`,
    )

    return toVacancy(response.data)
  },
}
```

Consumers usam:

```ts
vacancyRepository.findAll()
vacancyRepository.findById(id)
```

e não precisam conhecer `GET /vacancies`.

## React Integration

[DEFAULT] Hooks podem integrar Repository com server-state tooling.

```tsx
function useVacancies() {
  return useQuery({
    queryKey: ['vacancies'],
    queryFn: vacancyRepository.findAll,
  })
}
```

[HARD RULE] Se Repository é o boundary adotado, não repita raw HTTP dentro do hook.

Hook conhece a **operação**; Repository conhece o **transporte/fonte**.

## Shared Transport Client

[DEFAULT] Centralize configuração transversal de transporte quando ela é realmente compartilhada.

Exemplo:

```text
shared/api/http-client.ts
```

pode possuir:

- base URL;
- serialization defaults;
- common headers/interceptors;
- transport-specific configuration.

[HARD RULE] Não replique configuração global do client em cada feature.

## Repository Placement

[DEFAULT] Repository específico deve permanecer próximo da feature:

```text
features/
└── vacancies/
    └── repository/
        └── vacancy.repository.ts
```

Infraestrutura genérica permanece em `shared/`:

```text
shared/
└── api/
    └── http-client.ts
```

A regra física geral pertence a `project-structure.md`.

## External Contracts

[HARD RULE] Não deixe detalhes externos vazarem pela UI sem necessidade.

Se a API retorna:

```ts
interface VacancyResponse {
  id: string
  created_at: string
}
```

e a aplicação usa:

```ts
interface Vacancy {
  id: string
  createdAt: Date
}
```

faça a adaptação em um boundary apropriado de data access.

## Mapping

[SITUATIONAL] Mapeie somente quando existe diferença relevante entre contrato externo e modelo consumido.

```ts
function toVacancy(
  response: VacancyResponse,
): Vacancy {
  return {
    id: response.id,
    createdAt: new Date(response.created_at),
  }
}
```

[HARD RULE] Não crie DTO + mapper + domain model quando as estruturas já são equivalentes e nenhuma responsabilidade adicional existe.

## Error Boundary

[DEFAULT] Repository pode receber/normalizar falhas de transporte para um contrato de data access apropriado quando isso evita vazamento de infraestrutura.

[HARD RULE] Repository não decide como a UI apresenta a falha.

Por exemplo, não:

```text
catch
→ toast
→ navigate
```

A camada superior interpreta o resultado/erro conforme a feature.

Form-specific server error mapping pertence a forms quando representa erros de formulário.

## Mutations

Repository executa leitura/escrita externa e retorna resultado.

A coordenação de mutation pode decidir:

- pending;
- cache reconciliation;
- success reaction;
- retry policy exposta pela camada apropriada.

[HARD RULE] Repository não deve navegar, fechar dialog, resetar formulário ou mostrar toast.

Esses efeitos pertencem aos boundaries de interação/coordenação.

## Server-State Boundary

[DEFAULT] Server-state tooling é responsável por lifecycle/cache da consulta ou mutation; Repository é responsável pela operação externa.

```text
server-state hook
→ pending/cache/reconciliation

repository
→ external operation
```

[HARD RULE] Não duplique remote data em estado paralelo sem responsabilidade diferente.

A decisão de ownership do estado pertence a `state-placement.md`.

## Query Keys and Cache Policy

[SITUATIONAL] Quando a ferramenta de server state exige query keys/cache policy, mantenha essa configuração próxima do boundary React/server-state da feature.

Não coloque política de cache dentro do Repository se ela depende da biblioteca React usada acima dele.

## Repository Is Not a Domain Service

[HARD RULE] Não transforme Repository em container genérico para regras de UI ou regras de negócio apenas porque ele acessa dados.

Se uma regra é pura, ela pode pertencer ao model/domain boundary.

Se coordena React/server state, pode pertencer a hook/application coordination.

## Responsibility Boundaries

Esta referência é dona de:

- Repository;
- transport boundary;
- external DTO/mapping;
- shared HTTP client;
- React-to-repository data flow.

Outras responsabilidades:

- dependency direction → `layered-architecture.md`;
- physical placement → `project-structure.md`;
- server-state ownership → `state-placement.md`;
- form submission/error presentation → forms;
- route navigation → `routing.md`.
