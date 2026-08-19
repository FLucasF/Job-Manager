# DTO Mapping

Use explicit web DTOs to protect HTTP contracts from domain and persistence
representations.

Request and response models belong to the web boundary.

## Separate Persistence from HTTP

Do not expose JPA entities directly as API contracts.

Prefer:

```text
HTTP Request
    ↓
Request DTO
    ↓
Application / Domain
```

and:

```text
Application / Domain Result
    ↓
Response DTO
    ↓
HTTP Response
```

## Prefer Purpose-Specific DTOs

Model DTOs according to the endpoint contract.

Prefer:

```text
CreateVacancyRequest
UpdateVacancyRequest
VacancyResponse
```

over one mutable DTO reused for unrelated operations.

Do not reuse a response DTO as an input model only because the fields currently
match.

## Records

Prefer Java records for simple immutable request and response data carriers
when their semantics fit.

## Mapping Ownership

Keep HTTP-specific mapping in the web boundary.

Do not make domain objects depend on response DTOs.

Persistence mapping belongs to the persistence boundary, not to web DTO
mappers.

## Avoid Reflection Mapping by Default

Prefer explicit mapping when it keeps transformations visible and type-safe.

Introduce a mapping library only when repetitive mapping is substantial and the
project accepts the generated/implicit behavior.

Do not add a mapper abstraction for trivial one-line transformations solely to
satisfy architecture ceremony.

## Control Exposed Fields

A response should contain only fields that belong to that API contract.

Do not expose internal fields simply because they exist on the domain or
persistence object.

Sensitive-data masking and disclosure rules belong to the security references.

## Avoid

- JPA entities as REST DTOs
- one universal DTO for create, update, and response
- domain objects depending on web DTOs
- accidental exposure of internal fields
- reflection-based mapping without a clear benefit
- ceremonial mapper classes for trivial transformations
