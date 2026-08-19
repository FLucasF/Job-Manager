# Test Strategy

Choose the smallest test scope that can prove the behavior with sufficient
confidence.

Use unit tests for isolated logic and integration tests for framework,
persistence, security, serialization, transaction, and infrastructure behavior.

## Test Behavior, Not Implementation Shape

Prefer assertions about observable outcomes.

Do not make tests depend on private methods, incidental call order, or internal
structure unless that structure is itself the contract.

## Match the Test to the Risk

Use unit tests for:

- domain rules;
- application branching;
- pure transformations;
- failure paths that do not require infrastructure.

Use integration tests for behavior that depends on:

- Spring configuration;
- dependency wiring;
- transactions;
- JPA/Hibernate;
- SQL/database constraints;
- serialization and validation;
- Spring Security;
- external infrastructure adapters.

## Keep Full-Context Tests Intentional

Use `@SpringBootTest` when the behavior requires the full application context.

Do not use it as the default for every test.

Prefer a narrower test when the full context provides no additional confidence.

## Test Important Failure Paths

For meaningful operations, cover more than the happy path.

Consider:

```text
invalid input
missing resource
forbidden access
duplicate/conflicting state
persistence failure
concurrency conflict
external dependency failure
```

Test only failure modes that belong to the responsibility under test.

## Deterministic Tests

Control time, random values, identifiers, external services, and persisted
state when nondeterminism would make tests flaky.

Do not rely on execution order between independent tests.

## Test Data

Create only the data relevant to the scenario.

Prefer builders/factories/fixtures that make intent clear.

Avoid giant shared fixtures whose unrelated defaults hide what the test needs.

## Test Pyramid as a Heuristic

Keep most business-rule feedback fast and local.

Use fewer broader integration tests to verify boundaries that mocks cannot
prove.

Do not optimize for a target percentage of each test type.

## Avoid

- `@SpringBootTest` for every test
- testing private implementation details
- tests that only mirror method calls
- happy-path-only coverage for critical behavior
- shared mutable test state
- order-dependent tests
- mocks used to simulate behavior better verified by real infrastructure
