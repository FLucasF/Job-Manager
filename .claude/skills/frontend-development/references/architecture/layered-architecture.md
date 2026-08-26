# Frontend Layered Architecture

Referência para responsabilidades e direção de dependências dentro das features.

## Contents

- Layering strategy
- Components
- Hooks
- Model
- Repository
- Dependency direction
- Pure logic
- Layer bypass
- Avoid accidental layers
- Cross-boundary coordination
- Responsibility boundaries

## Layering Strategy

[DEFAULT] Use camadas para separar responsabilidades que realmente existem.

Um fluxo comum pode ser:

```text
Component
→ Hook
→ Repository
→ HTTP Client
```

Quando há regra pura de feature:

```text
Component/Hook
→ Model
```

[HARD RULE] A arquitetura não exige que toda feature possua todas essas camadas.

Crie uma camada somente quando existir uma responsabilidade concreta para ela.

## Components

Componentes são responsáveis por:

- renderização;
- composição da UI;
- user interaction;
- apresentação de estados;
- delegação de ações.

[HARD RULE] Componentes não devem conhecer detalhes de transporte ou infraestrutura externa.

Evite componentes que possuem:

```text
endpoint
HTTP client config
serialization
repository implementation details
```

Acesso a dados pertence a `data-access.md`.

## Hooks

Hooks conectam comportamento ao runtime React.

Podem coordenar:

- React state;
- React lifecycle;
- Context;
- queries/mutations;
- feature operations;
- dados e ações expostos para componentes.

[HARD RULE] Não use custom hook como destino genérico para qualquer lógica retirada de um componente.

Antes de criar um hook, pergunte se o comportamento realmente precisa de React.

## Model

[DEFAULT] `model/` contém regras e transformações puras da feature quando esse boundary é útil.

Exemplo:

```ts
function canApplyToVacancy(
  vacancy: Vacancy,
  user: User,
): boolean {
  return (
    vacancy.status === 'OPEN' &&
    user.status === 'ACTIVE' &&
    vacancy.ownerId !== user.id
  )
}
```

[HARD RULE] Model não deve depender de:

- React;
- hooks;
- DOM;
- presentation components;
- HTTP client;
- Repository implementation.

Isso mantém a regra utilizável e testável sem infraestrutura React.

## Repository

Repository representa acesso a uma fonte externa da feature.

Conceitualmente:

```text
feature operation
→ repository
→ transport/client
```

[HARD RULE] Repository não deve depender de components ou hooks.

Detalhes completos de Repository, HTTP, mapping e external boundaries pertencem a `data-access.md`.

## Dependency Direction

[HARD RULE] Dependências devem seguir responsabilidades.

Exemplos permitidos:

```text
Component → Hook
Component → Model
Hook → Model
Hook → Repository
Repository → shared HTTP client
Feature → Shared
```

Evite:

```text
Hook → Component
Model → React
Model → Hook
Model → Repository
Repository → Hook
Repository → Component
Shared → Feature
```

Camadas de menor nível não conhecem detalhes das camadas de apresentação.

## Keep Pure Logic Outside React

[DEFAULT] Se uma regra pode existir como função pura, mantenha-a fora de hooks.

Evite:

```tsx
function useCanApplyToVacancy(
  vacancy: Vacancy,
  user: User,
) {
  return canApplyToVacancy(vacancy, user)
}
```

quando o wrapper React não adiciona nenhuma responsabilidade.

Componentes e hooks podem consumir diretamente funções puras quando isso mantém os boundaries corretos.

## Hooks Coordinate; They Do Not Absorb Everything

[DEFAULT] Um hook pode coordenar uma operação React:

```tsx
function useVacancies() {
  return useQuery({
    queryKey: ['vacancies'],
    queryFn: vacancyRepository.findAll,
  })
}
```

Mas lógica como:

```text
mapping puro
formatting
capability rule
validation pura
route builder
```

não precisa virar hook sem necessidade de React.

## Presentation Does Not Own Infrastructure

[HARD RULE] Não faça um component/hook subir de nível arquitetural apenas para acessar diretamente infraestrutura.

Evite:

```text
Component → HTTP Client
```

quando a arquitetura possui um boundary de data access.

A mesma regra vale para importações internas que invertam dependências.

## Avoid Layer Bypass by Responsibility

[DEFAULT] "Pular uma camada" só é problema quando outra responsabilidade acaba absorvida no lugar errado.

Por exemplo:

```text
Component → Model
```

pode ser perfeitamente válido para uma regra pura.

Por outro lado:

```text
Component → HTTP Client
```

faz presentation conhecer infraestrutura e viola o boundary.

[HARD RULE] Não aplique uma sequência rígida de camadas quando não existe responsabilidade intermediária.

## Avoid Accidental Layers

[HARD RULE] Não crie:

```text
Service
→ UseCase
→ Gateway
→ Repository
→ Adapter
```

apenas para parecer arquiteturalmente completo.

Uma nova abstração deve possuir pelo menos uma responsabilidade clara, como:

- estabilizar contrato;
- encapsular regra;
- isolar infraestrutura;
- coordenar workflow;
- permitir substituição necessária.

Se ela apenas repassa argumentos e resultado, reavalie sua existência.

## Shared Is Lower-Level

[HARD RULE] `shared/` deve permanecer independente de features.

```text
feature
→ shared
```

A decisão física de onde um módulo vive pertence a `project-structure.md`.

## Cross-Feature Coordination

[SITUATIONAL] Quando um fluxo envolve múltiplas features, mantenha a coordenação no boundary que representa aquele workflow, em vez de criar imports circulares entre internals.

Não mova automaticamente lógica multi-feature para `shared/`: compartilhado e coordenação de aplicação não são a mesma responsabilidade.

## Responsibility Boundaries

Esta referência é dona de:

- component/hook/model/repository responsibilities;
- dependency direction;
- pure logic boundary;
- necessidade real de camadas.

Outras responsabilidades:

- localização física → `project-structure.md`;
- state ownership → `state-placement.md`;
- repository/transport details → `data-access.md`;
- router dependencies → `routing.md`.
