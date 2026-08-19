# SOLID

Apply SOLID as design heuristics.

Use the principles to improve cohesion, coupling, substitutability,
extensibility, and testability.

Do not introduce abstractions solely to demonstrate SOLID.

## Single Responsibility Principle

Keep a class focused on a cohesive responsibility and a primary reason to
change.

A class handling persistence, business calculation, email delivery, and HTTP
mapping likely contains multiple responsibilities.

Do not interpret SRP as "one method per class".

Split responsibilities only when the resulting boundaries are meaningful.

## Open/Closed Principle

Prefer designs where known variation can be extended without repeatedly
modifying stable policy code.

Introduce strategies or abstractions when multiple real behaviors or
implementations exist.

Do not design extension points for hypothetical requirements.

## Liskov Substitution Principle

Implementations must honor the behavioral expectations of their contracts.

Avoid implementations that:

- reject operations promised by the contract
- require stronger preconditions unexpectedly
- weaken expected guarantees
- return incompatible semantics

If an implementation cannot honor a contract, reconsider the abstraction.

## Interface Segregation Principle

Keep contracts focused on the capabilities their consumers need.

Avoid broad interfaces that force clients to depend on unrelated operations.

Do not create one interface per method mechanically.

## Dependency Inversion Principle

High-level application policy should avoid unnecessary dependencies on
volatile implementation details.

Depend on an abstraction when a meaningful architectural boundary requires
it.

Dependency inversion is a design principle.

Dependency injection is one mechanism that can connect those dependencies.

## Prefer Composition

Prefer composition when inheritance does not express a genuine
substitutability relationship.

Do not create inheritance hierarchies merely to reuse implementation.

## Avoid

- `SomethingService` classes accumulating unrelated behavior
- interfaces created only because every class "needs an interface"
- `Impl` classes with no meaningful alternative or boundary
- speculative extensibility
- inheritance used only for code reuse
- mechanical application of SOLID that makes simple code harder to understand
