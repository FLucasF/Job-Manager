# Layered Architecture

Separate responsibilities between web, application, domain, and
infrastructure boundaries.

Layers are responsibility boundaries, not mandatory folders for every class.

## Contents

- [Responsibilities](#responsibilities)
- [Typical Flow](#typical-flow)
- [Controllers](#controllers)
- [Application Services](#application-services)
- [Infrastructure](#infrastructure)
- [Avoid](#avoid)

## Responsibilities

### Web

Responsible for HTTP concerns:

- request parsing
- request validation
- authentication context extraction
- HTTP status codes
- request and response DTOs
- response serialization

Web code delegates application behavior instead of implementing business
rules.

### Application

Responsible for coordinating use cases.

Application services may:

- load required data
- invoke domain behavior
- coordinate multiple collaborators
- define transactional use-case boundaries
- return application results

Avoid HTTP-specific and persistence-specific implementation details here.

### Domain

Responsible for business behavior and invariants.

Prefer keeping important business rules close to the concepts they govern.

The domain should not require controllers, HTTP responses, JPA repositories,
or external API clients to express its rules.

### Infrastructure

Implements technical details required by the application.

Examples:

- database persistence
- JPA mappings
- external HTTP clients
- messaging
- file storage

Infrastructure may depend on inner contracts. Inner boundaries should not
depend on infrastructure implementations.

## Typical Flow

```text
HTTP Request
    ↓
Controller
    ↓
Application Service
    ↓
Domain
    ↓
Required abstraction
    ↑
Infrastructure implementation
```

Runtime calls may travel in either direction.

Source-code dependencies must still respect the project's dependency rules.

## Controllers

Keep controllers focused on the HTTP boundary.

Avoid:

```java
@PostMapping
public ResponseEntity<?> create(...) {
    // query database
    // calculate business rules
    // mutate entity
    // send email
}
```

Prefer delegation to an application operation.

## Application Services

Application services coordinate workflows.

Do not turn them into containers for every business rule.

When behavior naturally belongs to a domain concept, keep it there.

## Infrastructure

Treat persistence, HTTP clients, frameworks, and external systems as
replaceable technical details where a meaningful boundary exists.

Do not create adapters or interfaces merely because infrastructure exists.

Introduce a boundary when isolation provides a concrete architectural benefit.

## Avoid

- business logic in controllers
- HTTP types leaking into domain logic
- persistence implementations becoming application contracts
- domain objects acting only as mutable data bags when meaningful behavior
  belongs to them
- application services accumulating unrelated responsibilities
- layers that exist only as pass-through wrappers
