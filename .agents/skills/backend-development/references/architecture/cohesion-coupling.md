# Cohesion and Coupling

Prefer highly cohesive units with explicit and minimal coupling.

Use cohesion and coupling as practical signals when deciding whether code
belongs together or should be separated.

## Cohesion

Keep behavior together when it operates on the same concept and changes for
the same reasons.

Prefer:

```text
Vacancy
├── publish()
├── close()
└── changeSalary(...)
```

when these operations preserve vacancy invariants.

Avoid scattering related business behavior across generic utility or service
classes without a reason.

## Coupling

Depend only on collaborators required to perform the responsibility.

A class with many unrelated dependencies may indicate excessive
responsibility.

Prefer explicit constructor dependencies.

Avoid hidden dependencies through:

- static mutable state
- service locators
- global application context access
- unrelated utility classes

## Change Together, Stay Together

Code that consistently changes for the same business reason is a candidate to
remain together.

Code that changes independently may deserve a separate boundary.

Do not split code simply because files become visually large.

## Feature Coupling

Minimize dependencies between business features.

Prefer narrow contracts over reaching into another feature's internals.

Avoid bidirectional feature dependencies.

## Shared Abstractions

Do not extract shared abstractions based only on superficial similarity.

Two pieces of code that currently look alike may represent different business
concepts and evolve independently.

Extract shared behavior when the concepts and reasons for change are actually
shared.

## Constructor Size as a Signal

A large number of constructor dependencies is a design signal, not a rule.

Investigate whether the class:

- coordinates too many responsibilities
- crosses multiple feature boundaries
- depends on unnecessary collaborators

Do not hide excessive dependencies behind a facade solely to reduce the
constructor parameter count.

## Avoid

- god services
- generic managers
- catch-all utility classes
- unnecessary cross-feature dependencies
- shared modules used as dumping grounds
- abstractions extracted from accidental duplication
- facades that only conceal excessive coupling
