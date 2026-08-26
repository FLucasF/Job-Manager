# Testcontainers

Use Testcontainers when integration tests require realistic disposable
infrastructure.

Prefer containers for database or service behavior that differs materially from
in-memory substitutes.

## Match Production Infrastructure

Use the same database technology as production when behavior depends on:

```text
SQL dialect
constraints
indexes
locking
transaction semantics
extensions
native queries
```

Pin an intentional image version instead of relying on an unbounded `latest`
tag.

## Keep Containers Test-Owned

Tests should create or reuse disposable infrastructure through the test setup.

Do not depend on a manually running developer database for automated
integration-test correctness.

## Spring Boot Integration

Use Spring Boot's Testcontainers integration/service connections when it makes
connection configuration simpler and explicit.

Do not duplicate manual dynamic-property wiring when the framework integration
already expresses the connection correctly.

## Container Lifecycle

Choose lifecycle according to test isolation and suite performance.

Container reuse within a test suite is acceptable when each test still controls
its own logical data state.

Do not make tests order-dependent because they share a container.

## Readiness

Use the container/module's appropriate readiness behavior.

Do not replace readiness with arbitrary sleeps.

## CI

Treat a compatible container runtime as an explicit test-environment
requirement.

Fail clearly when required infrastructure cannot start.

## Avoid

- shared developer databases
- `latest` image tags without intent
- sleeps for container readiness
- container reuse that leaks test data
- manual connection configuration duplicated across tests
- Testcontainers for pure unit tests
