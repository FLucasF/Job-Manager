# Mocking

Use mocks to isolate a unit from slow, nondeterministic, or out-of-scope
collaborators.

Mock boundaries, not everything.

## Mock Collaborators with Behavior

Good mock candidates include:

```text
repository port in a service unit test
external service port
message publisher port
time-independent infrastructure abstraction
```

Prefer real value objects and simple deterministic collaborators.

## Stub Only What the Scenario Needs

Configure the minimum behavior required for the test.

Avoid global setup that gives every mock a large default behavior unrelated to
the scenario.

## Verify Interactions Only When They Matter

Verify a call when the interaction itself is part of the behavior, such as:

```text
notification was published
repository was not called after validation failure
external write occurred exactly once
```

Prefer state/output assertions when the interaction is incidental.

## Avoid Over-Specification

Do not verify every call, argument, and invocation order unless those details
are contractual.

Over-specified mocks make safe refactoring unnecessarily expensive.

## Do Not Mock the Subject's Own Data Model

Avoid mocking:

```text
records
DTOs
value objects
collections
simple domain entities
```

when real instances are cheap.

## Infrastructure Confidence

Mocks cannot prove:

```text
SQL correctness
JPA mappings
transactions
JSON serialization
Spring Security filters
database constraints
```

Use integration tests for those behaviors.

## Avoid

- mocks everywhere
- deep-stub chains
- mocking value objects
- large shared mock setup
- verifying incidental call order
- using mocks to claim infrastructure integration works
