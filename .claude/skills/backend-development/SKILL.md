---
name: backend-development
description: Implements, modifies, fixes, refactors, and reviews Java and Spring Boot backends from an applicable Ready package in specs/ or an explicit user request. Use for backend architecture, Spring MVC and REST contracts, JPA and transactions, security, observability, and backend unit or integration tests. Do not use for frontend work or complete E2E/browser journeys.
---

# Backend Development

Use this skill for Java and Spring Boot backend work. `CLAUDE.md` governs the
spec gate, RPI workflow, architecture authority, security, validation, and
completion.

When a Ready package applies, Research must consume its `spec.md`, `design.md`
and `tasks.md` plus any applicable formal contract. Without one, use the explicit
user request and accepted repository authority without inventing product
behavior. For package-driven work, the task-local Plan refines operational steps
only and cannot redefine the package. For directly authorized work, it may also
define feature-local backend design, contract mapping and work breakdown needed
by the request, but not observable behavior, cross-cutting architecture or
unauthorized dependencies. After package-driven implementation, independent
verification records evidence in `validation.md`.

Never infer missing product requirements from code, examples or Draft material.
If the work depends on a material Draft/Open domain or architecture decision,
stop until human authority accepts it in the appropriate durable owner; an
explicit implementation request does not silently resolve that decision.

## Domain Workflow

1. From completed Research against the applicable Ready package or explicit user
   request, identify the backend acceptance criteria and the affected web,
   application/domain, persistence, security, observability, and test boundaries.
2. Inspect only the affected backend code, configuration, contracts, migrations,
   and tests.
3. Load the smallest reference set for the concrete technical concerns below.
4. Keep domain/application behavior independent of HTTP, persistence, and
   infrastructure details; adapt those concerns at their intended boundaries.
5. Treat API and database changes as compatibility-sensitive and synchronize
   contracts and versioned migrations when required.
6. Add unit tests for isolated Java/domain behavior and integration tests for
   Spring, HTTP, persistence, security, or infrastructure collaboration. Route
   complete browser journeys to `quality-assurance`.
7. Run `apps/backend/mvnw.cmd test`, then map results to every applicable backend
   acceptance criterion and relevant failure path.

For review, start with the checklist for each affected concern. Open detailed
references only for concrete questions raised by the checklist; never load the
whole library.

## Reference Routing

### Architecture

Use when deciding project structure, responsibilities, architectural
boundaries, dependency direction, SOLID, cohesion, or coupling.

- Feature-first project organization and package ownership:
  [project-structure.md](references/architecture/project-structure.md)
- Responsibilities of web, application, domain, and infrastructure boundaries:
  [layered-architecture.md](references/architecture/layered-architecture.md)
- Clean Architecture, policy vs. detail, and pragmatic boundaries:
  [clean-architecture.md](references/architecture/clean-architecture.md)
- Allowed source dependency and import direction:
  [dependency-direction.md](references/architecture/dependency-direction.md)
- SOLID design decisions:
  [solid.md](references/architecture/solid.md)
- Cohesion, coupling, shared abstractions, and responsibility signals:
  [cohesion-coupling.md](references/architecture/cohesion-coupling.md)
- Architecture review:
  [review-checklist.md](references/architecture/review-checklist.md)

For structural changes, read `project-structure.md` and only the additional
architecture references required by the decision.

### Java

Use for language-level safety and design decisions independent of Spring.

- Type safety, raw types, casts, explicit domain types, and enums:
  [type-safety.md](references/java/type-safety.md)
- Nullability and `Optional` contracts:
  [nullability-optional.md](references/java/nullability-optional.md)
- Immutability, defensive copies, and records:
  [immutability-records.md](references/java/immutability-records.md)
- Lombok usage policy:
  [lombok.md](references/java/lombok.md)
- Exception design and handling:
  [exceptions.md](references/java/exceptions.md)
- Collection semantics and ownership:
  [collections.md](references/java/collections.md)
- Generic APIs, bounds, and wildcards:
  [generics.md](references/java/generics.md)
- Date/time types, timezone handling, and testable clocks:
  [date-time.md](references/java/date-time.md)
- Java review:
  [review-checklist.md](references/java/review-checklist.md)

Do not read Java references merely because the project is written in Java.
Load them when the task involves the corresponding design decision.

### Spring

Use for Spring container, component, and runtime-configuration decisions.

- Constructor injection, bean selection, and dependency visibility:
  [dependency-injection.md](references/spring/dependency-injection.md)
- Spring stereotypes, bean responsibilities, scopes, and component ownership:
  [component-design.md](references/spring/component-design.md)
- Externalized and typed Spring Boot configuration:
  [configuration.md](references/spring/configuration.md)
- Environment-specific configuration and profiles:
  [profiles.md](references/spring/profiles.md)
- Spring review:
  [review-checklist.md](references/spring/review-checklist.md)

Do not create a separate configuration abstraction when existing Spring
configuration or security-secret references already cover the concern.

### Web

Use for Spring MVC and REST API boundary decisions.

- Controller responsibilities and delegation:
  [controllers.md](references/web/controllers.md)
- Request/response DTO boundaries and mapping:
  [dto-mapping.md](references/web/dto-mapping.md)
- REST paths, methods, status codes, headers, and idempotency:
  [http-contracts.md](references/web/http-contracts.md)
- Structural request validation and Bean Validation boundaries:
  [validation.md](references/web/validation.md)
- Centralized HTTP exception translation and error responses:
  [exception-handling.md](references/web/exception-handling.md)
- Pagination, filtering, sorting, and bounded collection endpoints:
  [pagination-filtering-sorting.md](references/web/pagination-filtering-sorting.md)
- Web review:
  [review-checklist.md](references/web/review-checklist.md)

Use Spring MVC as the HTTP adapter of the web boundary. Do not reorganize the
whole project into global MVC technical folders; read the architecture
references when package structure is involved.

### Persistence

Use for JPA, Hibernate, Spring Data, relational schema, indexing, database,
query, and transaction decisions.

- JPA entity boundaries, identity, mutation, and database constraints:
  [entities.md](references/persistence/entities.md)
- Relational schema, keys, column types, constraints, and normalization:
  [schema-design.md](references/persistence/schema-design.md)
- Repository contracts and Spring Data repository placement:
  [repositories.md](references/persistence/repositories.md)
- JPA relationships, ownership, cascade, and lifecycle:
  [relationships.md](references/persistence/relationships.md)
- Transaction boundaries and rollback behavior:
  [transactions.md](references/persistence/transactions.md)
- Fetch plans, lazy loading, eager loading, and N+1:
  [fetching.md](references/persistence/fetching.md)
- Derived, JPQL, native, dynamic, and projection queries:
  [queries.md](references/persistence/queries.md)
- Query-driven indexes, query plans, selectivity, and index cost:
  [indexing.md](references/persistence/indexing.md)
- Optimistic/pessimistic locking and concurrent-update correctness:
  [locking-concurrency.md](references/persistence/locking-concurrency.md)
- Persistence auditing metadata:
  [auditing.md](references/persistence/auditing.md)
- Versioned database migrations:
  [migrations.md](references/persistence/migrations.md)
- Persistence review:
  [review-checklist.md](references/persistence/review-checklist.md)

Read only the persistence reference for the concrete persistence concern. Do
not load all JPA references for a simple repository change.

### Security

Use whenever authentication, authorization, credentials, tokens, personal
data, sensitive data, secrets, masking, encryption, CORS, CSRF, or security
logging is affected.

- Authentication boundary and authenticated principal:
  [authentication.md](references/security/authentication.md)
- Request-, method-, object-, property-, and function-level authorization:
  [authorization.md](references/security/authorization.md)
- JWT bearer-token validation and claims:
  [jwt.md](references/security/jwt.md)
- Password hashing and credential handling:
  [password-security.md](references/security/password-security.md)
- Personal/sensitive-data minimization, disclosure, retention, and protection:
  [data-protection.md](references/security/data-protection.md)
- Type-specific response masking with `Obfuscator<T>`:
  [response-obfuscation.md](references/security/response-obfuscation.md)
- Recoverable sensitive-data encryption and key concerns:
  [encryption.md](references/security/encryption.md)
- Runtime secrets and secret rotation:
  [secrets.md](references/security/secrets.md)
- Sensitive-data rules for logs:
  [logging-sensitive-data.md](references/security/logging-sensitive-data.md)
- Browser CORS and CSRF decisions:
  [cors-csrf.md](references/security/cors-csrf.md)
- Security review:
  [review-checklist.md](references/security/review-checklist.md)

For personal or sensitive data, consider authorization before disclosure,
then decide whether the field should be omitted, fully returned, or masked.
Masking does not replace authorization, encryption, password hashing, or
anonymization.

When masking is required, use the dedicated semantic obfuscator for the data
type, such as `EmailObfuscator` or `CpfObfuscator`, instead of a generic
type-switch utility.

### Observability

Use for production diagnostics, telemetry, health, and management endpoints.

- Operational logging:
  [logging.md](references/observability/logging.md)
- Metrics and cardinality:
  [metrics.md](references/observability/metrics.md)
- Distributed tracing and span boundaries:
  [tracing.md](references/observability/tracing.md)
- Liveness, readiness, and health checks:
  [health-checks.md](references/observability/health-checks.md)
- Spring Boot Actuator endpoint exposure:
  [actuator-exposure.md](references/observability/actuator-exposure.md)
- Observability review:
  [review-checklist.md](references/observability/review-checklist.md)

When logging may contain credentials or personal data, also read
`references/security/logging-sensitive-data.md`.

### Testing

Use for backend test scope, Spring integration testing, persistence testing,
security testing, and structural architecture verification.

- Test scope and overall strategy:
  [test-strategy.md](references/testing/test-strategy.md)
- Java-level unit tests without Spring context:
  [unit-testing.md](references/testing/unit-testing.md)
- Spring/infrastructure integration tests:
  [integration-testing.md](references/testing/integration-testing.md)
- Spring MVC/controller contract tests:
  [controller-testing.md](references/testing/controller-testing.md)
- JPA/repository/database tests:
  [repository-testing.md](references/testing/repository-testing.md)
- Mocking boundaries and interaction verification:
  [mocking.md](references/testing/mocking.md)
- Disposable real infrastructure with Testcontainers:
  [testcontainers.md](references/testing/testcontainers.md)
- Authentication, authorization, CSRF, and sensitive-disclosure tests:
  [security-testing.md](references/testing/security-testing.md)
- Automated architecture-boundary tests:
  [architecture-testing.md](references/testing/architecture-testing.md)
- Testing review:
  [review-checklist.md](references/testing/review-checklist.md)

Do not add Testcontainers, ArchUnit, Spring Modulith, or another testing tool
unless the project already uses it and the applicable Ready spec or explicit
user request requires the relevant behavior.
Do not install dependencies or invent tooling from reference guidance.

Map pure Java/domain rules to backend unit tests and collaboration with Spring,
HTTP, persistence, or infrastructure to backend integration tests. Map each
test to a behavior or acceptance criterion; do not add tests solely to increase
numeric coverage. Route any complete browser/system journey to
`quality-assurance`.

## Cross-Concern Routing

Some tasks require more than one reference area.

### New REST Endpoint

Usually consider:

- [controllers.md](references/web/controllers.md)
- [http-contracts.md](references/web/http-contracts.md)
- [dto-mapping.md](references/web/dto-mapping.md)
- [validation.md](references/web/validation.md) when external input is accepted
- the relevant architecture reference only if a new boundary or feature
  structure is introduced
- the relevant security reference when the endpoint is protected or exposes
  sensitive data
- the relevant testing reference when adding or changing tests

Do not load unrelated persistence or Java references unless the endpoint
actually touches those concerns.

### Persistence Change

Usually consider:

- the specific persistence reference for the change
- [dependency-direction.md](references/architecture/dependency-direction.md)
  only when repository ownership or
  boundary direction changes
- [data-protection.md](references/security/data-protection.md) and
  [encryption.md](references/security/encryption.md) when personal or
  sensitive storage changes
- the relevant repository/integration testing reference when verification is
  required

### Authentication or Sensitive-Data Change

Read the relevant security references first.

Add web, persistence, observability, or testing references only for the
boundaries changed by the task.

### Refactoring

Do not load every checklist.

Read the detailed references for the affected concerns, then use only those
concerns' review checklists.

## Final Rules

References do not authorize new dependencies, patterns, or abstractions. Do not
bypass application boundaries, expose persistence models as HTTP contracts,
confuse authentication with authorization, treat masking as encryption or
anonymization, or optimize persistence/observability without a concrete reason.
