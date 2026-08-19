# Clean Architecture

Use Clean Architecture to protect important business and application policies
from volatile technical details.

Apply it pragmatically. Preserve meaningful boundaries without mechanically
reproducing architectural diagrams.

## Contents

- [Dependency Rule](#dependency-rule)
- [Policy and Detail](#policy-and-detail)
- [Boundaries](#boundaries)
- [Do Not Abstract Mechanically](#do-not-abstract-mechanically)
- [Framework Independence](#framework-independence)
- [Data Across Boundaries](#data-across-boundaries)
- [Avoid](#avoid)

## Dependency Rule

Source-code dependencies should point toward more stable application and
business policies.

Conceptually:

```text
Infrastructure ──→ Application ──→ Domain
Web ─────────────→ Application ──→ Domain
```

Avoid dependencies in the opposite direction:

```text
Domain ──X──→ Spring MVC
Domain ──X──→ JPA
Application ──X──→ persistence implementation
```

## Policy and Detail

Treat these primarily as policies:

- business rules
- application use cases
- domain concepts

Treat these primarily as details:

- Spring MVC
- JPA and Hibernate
- database engines
- external APIs
- messaging implementations
- serialization
- HTTP

A technical detail may change without requiring unrelated business rules to
change.

## Boundaries

Introduce an architectural boundary when it protects the application from a
meaningful source of change or dependency.

Examples:

```text
Application
    ↓
VacancyRepository
    ↑
JpaVacancyRepository
```

or:

```text
Application
    ↓
EmailSender
    ↑
SmtpEmailSender
```

The abstraction should be owned by the side that needs the capability.

## Do Not Abstract Mechanically

Do not automatically create:

```text
UseCase
UseCaseImpl
InputPort
OutputPort
RepositoryPort
RepositoryAdapter
DomainService
Mapper
```

for every operation.

A concrete application service is acceptable when no useful substitution or
boundary exists.

Create interfaces when they represent a meaningful contract or dependency
inversion.

## Framework Independence

Framework independence does not require removing every Spring annotation from
inner application classes.

A Spring annotation is acceptable when it does not cause important business
logic to depend on framework-specific behavior.

Focus primarily on dependency direction and replaceable details rather than
annotation purity.

## Data Across Boundaries

Do not pass outer-layer representations inward when doing so couples inner
logic to an external detail.

Examples to avoid in domain/application APIs:

- `ResponseEntity`
- `HttpServletRequest`
- persistence-specific projections
- JPA entities used only as database representations

Use representations appropriate to the receiving boundary.

## Avoid

- domain depending on framework APIs
- application depending directly on volatile infrastructure implementations
- business behavior coupled to HTTP
- persistence models automatically becoming API contracts
- interfaces with only ceremonial value
- architecture that increases complexity without protecting a real boundary
