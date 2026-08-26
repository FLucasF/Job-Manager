# Backend Architecture

**Status:** Draft

## Purpose

This document defines the Draft backend structure, responsibilities, and
dependency rules for Job Manager.

Detailed implementation practices live in the backend-development references.

## Technology baseline

The backend uses:

- Java 21;
- Spring Boot 4.1;
- Spring MVC;
- Bean Validation;
- Spring Data JPA;
- Flyway;
- PostgreSQL.

Exact dependency versions remain authoritative in `apps/backend/pom.xml`.

## Primary organization: feature first

Backend code is organized primarily by business capability rather than one
global set of technical folders.

Target shape:

```text
src/main/java/com/jobmanager/backend/
├── BackendApplication.java
├── vacancy/
├── worker/
├── jobapplication/
└── auth/
```

Actual features are introduced when required by specifications or explicitly
requested outside the specification workflow.

Avoid organizing the entire backend as:

```text
controller/
service/
repository/
entity/
dto/
```

because this spreads one business capability across unrelated global folders.

## Internal feature boundaries

A feature may use these boundaries when the responsibilities exist:

```text
feature/
├── domain/
├── application/
├── web/
└── infrastructure/
```

They are not mandatory folders.

### Domain

Owns business concepts, invariants, and pure business behavior that should not
need HTTP or persistence implementation details.

Do not create a separate domain layer for a feature that has no meaningful
domain behavior.

### Application

Owns use-case coordination.

Typical responsibilities include:

- loading required data through deliberate contracts;
- coordinating domain behavior;
- coordinating multiple collaborators;
- defining coherent transactional use-case boundaries;
- returning application results.

Application code must not become an HTTP mapping layer or a persistence
implementation layer.

### Web

Spring MVC is the backend HTTP adapter.

Web owns:

- request parsing;
- boundary validation;
- authentication context extraction when authentication exists;
- request and response DTOs;
- HTTP status and header semantics;
- translation between HTTP and application operations.

Controllers delegate application behavior. Business rules and persistence
workflows do not live in controllers.

### Infrastructure

Owns technical implementations such as:

- JPA persistence;
- external HTTP clients;
- messaging when adopted;
- file storage when adopted;
- other technical adapters.

Do not create adapters, interfaces, or infrastructure packages only to match a
diagram.

## Dependency direction

Default source dependency direction within a feature:

```text
web ───────────────→ application
                         ↓
                       domain

infrastructure ─────→ application
infrastructure ─────→ domain
```

Avoid:

```text
domain → infrastructure
domain → web
application → web
application → concrete persistence implementation
web → JPA repository
```

Runtime calls may move in different directions; source-level imports must still
respect ownership.

## Dependency inversion

When application behavior requires a capability implemented by infrastructure,
define a contract at the boundary that requires the capability when doing so
protects a meaningful dependency boundary.

Do not create an interface only because an implementation class exists.

## Cross-feature dependencies

A feature owns its internal implementation.

Another feature must not import internal controllers, JPA repositories, or
infrastructure implementations directly.

Prefer explicit application-facing contracts where cross-feature collaboration
is genuinely required.

Feature dependencies must remain acyclic.

## Business logic placement

Use this ownership order:

```text
HTTP semantics
→ web

use-case orchestration
→ application

business invariant / pure business behavior
→ domain when a domain boundary is justified

technical integration
→ infrastructure
```

Keep logic close to the responsibility that gives it meaning.

## Proportional architecture

Job Manager does not require ceremony for its own sake.

Do not add:

```text
Controller → Service → UseCase → Gateway → Repository → Adapter
```

when intermediate boundaries only forward parameters and results.

Add a layer or abstraction when it owns a real responsibility such as policy,
isolation, coordination, or a stable contract.

## Framework boundaries

Spring dependencies are expected in outer technical boundaries.

Avoid propagating framework-specific types into inner application/domain APIs
without a concrete need.

Using Spring Boot does not authorize adding unrelated Spring modules. New
architecture-significant dependencies must be required by the project and
accepted explicitly.

## Related implementation references

Load only what the task requires:

- [project structure](../../.claude/skills/backend-development/references/architecture/project-structure.md)
- [layered architecture](../../.claude/skills/backend-development/references/architecture/layered-architecture.md)
- [clean architecture](../../.claude/skills/backend-development/references/architecture/clean-architecture.md)
- [dependency direction](../../.claude/skills/backend-development/references/architecture/dependency-direction.md)
- [cohesion and coupling](../../.claude/skills/backend-development/references/architecture/cohesion-coupling.md)
- [SOLID](../../.claude/skills/backend-development/references/architecture/solid.md)

Use web, persistence, security, Spring, observability, Java, and testing
references only when those concerns are actually involved.
