# Dependency Direction

Use dependency direction rules to preserve architectural boundaries.

This reference defines which parts of the application may depend on which
other parts.

## Contents

- [Default Direction](#default-direction)
- [Allowed](#allowed)
- [Avoid](#avoid)
- [Dependency Inversion](#dependency-inversion)
- [Cross-Feature Dependencies](#cross-feature-dependencies)
- [Dependency Cycles](#dependency-cycles)
- [Framework Dependencies](#framework-dependencies)
- [Review Imports, Not Only Calls](#review-imports-not-only-calls)

## Default Direction

Within a feature:

```text
web ───────────→ application
                     ↓
                   domain

infrastructure ─→ application
infrastructure ─→ domain
```

Inner boundaries must not depend on outer implementation details.

## Allowed

Examples:

```text
web → application
application → domain
infrastructure → application
infrastructure → domain
```

## Avoid

```text
domain → application
domain → web
domain → infrastructure

application → web
application → persistence implementation

web → JPA repository
```

## Dependency Inversion

When application behavior requires an external capability, define a contract
at the boundary that requires it.

Example:

```java
public interface VacancyRepository {
    Optional<Vacancy> findById(UUID id);
    Vacancy save(Vacancy vacancy);
}
```

Infrastructure provides the implementation.

Do not introduce an interface when the dependency does not cross a meaningful
boundary or require substitution.

## Cross-Feature Dependencies

Features should depend on deliberate contracts, not implementation internals.

Avoid:

```text
jobapplication
    ↓
vacancy.infrastructure.persistence
```

Prefer:

```text
jobapplication
    ↓
vacancy.application contract
```

Keep feature dependencies acyclic.

## Dependency Cycles

Do not resolve cyclic dependencies with:

- lazy injection
- service locator
- global mutable state
- moving everything into `shared`

A cycle usually indicates unclear ownership or an incorrect boundary.

Refactor responsibilities or introduce a meaningful contract.

## Framework Dependencies

Framework dependencies are expected in outer boundaries.

Examples:

```text
web → Spring MVC
infrastructure.persistence → Spring Data JPA
```

Avoid framework types propagating into inner APIs without a concrete need.

## Review Imports, Not Only Calls

Runtime control flow does not determine architectural dependency direction.

Review source-level imports and declared types.

A persistence adapter may call a domain object while still depending inward
on the domain.

## Avoid

- circular feature dependencies
- controller-to-repository shortcuts
- domain-to-infrastructure imports
- application APIs exposing HTTP-specific types
- accessing another feature's internal implementation
- introducing interfaces solely to satisfy a diagram
