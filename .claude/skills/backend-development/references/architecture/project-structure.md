# Project Structure

Organize backend code primarily by business feature, with internal boundaries
that separate domain, application, web, and infrastructure concerns.

## Contents

- [Default Structure](#default-structure)
- [Feature First](#feature-first)
- [Internal Feature Boundaries](#internal-feature-boundaries)
- [Keep Structure Proportional](#keep-structure-proportional)
- [Package Ownership](#package-ownership)
- [Shared Code](#shared-code)
- [Avoid](#avoid)

## Default Structure

Prefer feature-first organization:

```text
src/main/java/com/example/application/
├── Application.java
│
├── vacancy/
│   ├── domain/
│   ├── application/
│   ├── web/
│   └── infrastructure/
│
├── worker/
│   ├── domain/
│   ├── application/
│   ├── web/
│   └── infrastructure/
│
├── jobapplication/
│   ├── domain/
│   ├── application/
│   ├── web/
│   └── infrastructure/
│
└── auth/
    ├── domain/
    ├── application/
    ├── web/
    └── infrastructure/
```

Keep the Spring Boot application class in the root package above application
features.

## Feature First

Group code by business capability before technical type.

Prefer:

```text
vacancy/
worker/
jobapplication/
auth/
```

Avoid organizing the whole application primarily as:

```text
controller/
service/
repository/
entity/
dto/
```

Global technical folders make feature boundaries harder to see and cause
unrelated business concepts to grow together.

## Internal Feature Boundaries

Use only the boundaries required by the feature.

### `domain`

Contains business concepts and behavior that should remain independent from
delivery and persistence details.

Typical contents:

- entities and aggregates with business behavior
- value objects
- domain rules
- domain-specific exceptions

Do not place HTTP, persistence, or framework-specific concerns in the domain
unless there is a deliberate project-level reason.

### `application`

Coordinates application use cases.

Typical contents:

- application services
- use cases
- commands or inputs when useful
- interfaces required by the application

Application code coordinates business behavior but should not contain HTTP
mapping or persistence implementation details.

### `web`

Adapts HTTP requests and responses to application operations.

Typical contents:

- controllers
- request DTOs
- response DTOs
- HTTP-specific mappings

Keep business rules outside this boundary.

### `infrastructure`

Contains technical implementations required by inner boundaries.

Typical contents:

```text
infrastructure/
├── persistence/
├── messaging/
└── external/
```

Examples include:

- JPA entities
- Spring Data repositories
- persistence adapters
- external service clients

Do not introduce empty subpackages in anticipation of future requirements.

## Keep Structure Proportional

Do not reproduce every architectural layer mechanically.

A small feature may start as:

```text
vacancy/
├── application/
├── web/
└── infrastructure/
```

Add a separate domain boundary when meaningful business rules or domain
concepts justify it.

Prefer the simplest structure that preserves the required dependency
boundaries.

## Package Ownership

A feature owns its internal implementation.

Code from another feature should not reach into internal persistence,
controller, or implementation classes.

Prefer interaction through a deliberate public contract.

Avoid:

```text
worker
    ↓
vacancy.infrastructure.persistence.VacancyJpaRepository
```

Prefer:

```text
worker
    ↓
vacancy application contract
```

## Shared Code

Do not create `shared`, `common`, or `util` as default destinations.

Move code to shared infrastructure only when:

- it is genuinely used by multiple features;
- its responsibility is stable and well defined;
- sharing does not introduce unwanted coupling.

Prefer duplication of trivial code over a premature abstraction that couples
unrelated features.

## Avoid

- global `controller`, `service`, `repository`, and `entity` packages
- framework details leaking into unrelated boundaries
- direct access to another feature's persistence implementation
- cyclic dependencies between features
- empty architecture folders created only to match a diagram
- generic `utils` or `helpers` packages without clear ownership
- abstractions introduced only for hypothetical future requirements
