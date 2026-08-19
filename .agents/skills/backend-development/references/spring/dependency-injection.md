# Dependency Injection

Prefer explicit constructor injection for required Spring-managed dependencies.

Use dependency injection to connect collaborators without hiding ownership or
dependency direction.

## Required Dependencies

Prefer constructor injection with `final` fields.

```java
@Service
@RequiredArgsConstructor
public class VacancyService {

    private final VacancyRepository vacancyRepository;
}
```

A manually declared constructor is equally valid.

Do not add `@Autowired` to a single constructor unless the project has a
specific reason.

## Avoid Field Injection

Avoid:

```java
@Autowired
private VacancyRepository vacancyRepository;
```

Field injection hides required dependencies, prevents normal immutable fields,
and makes plain unit construction harder.

## Optional Dependencies

Do not make a required business dependency optional only to simplify bean
creation.

Use optional injection only when the application genuinely supports operation
without that collaborator.

## Multiple Implementations

When multiple beans implement the same contract, make the selection explicit.

Use a meaningful qualifier or a deliberate primary implementation.

Do not rely on bean names or accidental scan order.

## Constructor Size as a Signal

Many constructor dependencies may indicate excessive responsibility.

Review the class before hiding the problem behind a facade, service locator, or
dependency container wrapper.

## Do Not Use the Container as a Service Locator

Avoid retrieving normal application dependencies through:

```java
ApplicationContext.getBean(...)
```

Prefer declared constructor dependencies.

Use container lookup only for framework integration cases that genuinely
require dynamic resolution.

## Dependency Direction

Spring injection does not override architectural dependency rules.

The fact that Spring can wire two beans does not mean the dependency is
architecturally valid.

## Lombok

When Lombok is adopted, `@RequiredArgsConstructor` is acceptable for required
`final` dependencies.

Treat Lombok only as constructor generation; constructor injection remains the
design decision.

## Avoid

- field injection
- hidden dependencies
- service locator patterns for normal application code
- ambiguous injection between multiple implementations
- optional injection used to conceal missing required dependencies
- adding interfaces solely to enable dependency injection
