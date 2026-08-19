# Unit Testing

Use unit tests for behavior that can be verified without starting the Spring
application context or external infrastructure.

Keep unit tests fast, isolated, and focused.

## Instantiate Objects Directly

Construct the class under test with normal Java constructors.

Prefer:

```java
var service = new VacancyService(repository);
```

over starting Spring merely to create the object.

Constructor injection should make application components easy to test without
the container.

## Test One Behavioral Responsibility

A unit test may exercise multiple methods when required by one behavior.

Do not interpret "unit" as one method or one assertion.

Keep the scope around one cohesive object or small collaborating unit.

## Use Real Value Objects

Prefer real domain values, records, and simple collaborators when they are
cheap and deterministic.

Do not mock every dependency automatically.

## Parameterized Tests

Use parameterized tests when the same behavior must hold across a meaningful
set of inputs.

Do not replace readable named scenarios with a large data matrix when each case
has distinct business meaning.

## Assertions

Assert business-relevant outcomes and state.

Avoid assertions that only prove implementation calls occurred when the result
can be verified directly.

## Time-Dependent Logic

Inject a `Clock` or other controllable time source when time changes behavior.

Do not use sleeps or depend on the wall clock in unit tests.

## Avoid

- Spring context startup for pure unit tests
- mocking simple records or value objects
- one test per private method
- sleeps
- assertions tied to incidental implementation structure
- test inheritance hierarchies that obscure individual scenarios
