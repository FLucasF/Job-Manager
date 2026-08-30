# Integration Testing

Use integration tests to verify behavior that depends on real Spring
configuration or infrastructure interaction.

Prefer the smallest integration scope that proves the boundary.

## Verify Real Boundaries

Good integration-test targets include:

```text
Spring bean wiring
transaction behavior
JPA mappings
database constraints
repository queries
JSON serialization
validation
security filters
external adapter configuration
```

Do not replace these with mocks if the framework or infrastructure behavior is
the risk being tested.

## Context Reuse

Keep test application-context configuration consistent where practical.

Avoid unnecessary context customization and `@DirtiesContext` because changing
the context reduces Spring's context-cache reuse.

Use context reset only when the test genuinely mutates shared application
context state.

## Data Isolation

Each test must control the database state it depends on.

Use rollback, cleanup, isolated schemas/containers, or deterministic setup
according to the test type.

Do not depend on data left by another test.

## Transaction Caveat

A test-managed transaction can hide behavior that occurs after commit.

When commit, asynchronous processing, or real HTTP transaction boundaries are
part of the behavior, structure the test so those boundaries actually occur.

## External Infrastructure

Prefer disposable or isolated infrastructure for integration tests.

Do not point automated tests at shared developer or production-like databases
that accumulate state.

## Avoid

- full application context without a reason
- mocks for the infrastructure behavior being verified
- tests depending on execution order
- shared mutable database state
- excessive `@DirtiesContext`
- assuming rollback proves after-commit behavior

## Stack Mechanism

The stack-specific mechanisms for this concern live in the overlay skill for the
technology in use, when one exists. This reference states the rule; the overlay
states how the stack expresses it. When no overlay exists, the rule still applies
and the mechanism comes from general knowledge of that technology, declared as
such.
