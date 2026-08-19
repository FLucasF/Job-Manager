# Testing Review Checklist

Use this checklist after reading the testing references relevant to the change.

Do not use this checklist as a substitute for the detailed references.

## Strategy

- [ ] The test scope is the smallest one that proves the behavior with enough confidence.
- [ ] Unit tests cover isolated business/application behavior where appropriate.
- [ ] Integration tests cover framework/infrastructure behavior that mocks cannot prove.
- [ ] Full-context tests are used intentionally rather than by default.
- [ ] Important failure paths are covered for critical behavior.
- [ ] Tests are deterministic and independent of execution order.

## Unit Tests

- [ ] Pure unit tests do not start the Spring context.
- [ ] Objects are constructed directly through normal dependencies.
- [ ] Real value objects are preferred over unnecessary mocks.
- [ ] Assertions focus on behavioral outcomes.
- [ ] Time-dependent behavior uses controllable time rather than sleeps/wall-clock assumptions.

## Integration Tests

- [ ] Spring Test support is used only where framework integration matters.
- [ ] Real framework/database behavior is not replaced by mocks when it is the subject of the test.
- [ ] Test data is isolated between tests.
- [ ] Context customization and `@DirtiesContext` are minimized.
- [ ] After-commit behavior is not accidentally hidden by test-managed rollback.

## Controller Tests

- [ ] Tests assert the external HTTP contract.
- [ ] Validation and representative error mappings are covered.
- [ ] Controller tests do not duplicate all application/domain scenarios.
- [ ] Security is included when it is part of the endpoint contract.
- [ ] Persistence entities are not used as accidental API fixtures.

## Repository Tests

- [ ] Non-trivial queries, mappings, constraints, and locking behavior use real persistence integration tests.
- [ ] The production database engine is used when engine-specific behavior matters.
- [ ] Trivial framework CRUD is not tested merely for coverage.
- [ ] Query performance risks such as N+1 are reviewed when relevant.
- [ ] Database constraints are tested where they protect important correctness.

## Mocking

- [ ] Only out-of-scope collaborators are mocked.
- [ ] Simple values and domain objects are real instances.
- [ ] Mock setup contains only scenario-relevant behavior.
- [ ] Interaction verification is limited to behaviorally meaningful calls.
- [ ] Mocks are not being used to claim framework/infrastructure integration works.

## Testcontainers

- [ ] Containers are used only where realistic infrastructure adds confidence.
- [ ] Image versions are intentional.
- [ ] Tests do not depend on manually managed shared infrastructure.
- [ ] Container sharing does not create order-dependent test data.
- [ ] Readiness relies on proper wait behavior rather than sleeps.
- [ ] CI explicitly supports the required container runtime.

## Security Tests

- [ ] Protected endpoints have anonymous-access tests.
- [ ] Allowed and denied authorization cases are represented.
- [ ] Object-level authorization is tested when resource IDs are client-controlled.
- [ ] Sensitive property disclosure/masking is tested.
- [ ] Method-level security is tested when used.
- [ ] CSRF behavior is tested when applicable.
- [ ] Authentication/authorization errors do not expose sensitive detail.

## Architecture Tests

- [ ] Automated architecture rules represent stable, high-value boundaries.
- [ ] Architecture tests match the documented architecture.
- [ ] Style/lint concerns are not duplicated as architecture rules.
- [ ] Violations are not hidden through exclusions merely to make tests pass.

## Final Review

- [ ] Tests provide confidence in behavior rather than implementation trivia.
- [ ] The suite balances fast feedback with realistic boundary verification.
- [ ] New test helpers reduce repetition without hiding scenario intent.
- [ ] Added testing infrastructure solves a concrete confidence gap.
