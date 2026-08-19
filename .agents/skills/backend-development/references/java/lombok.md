# Lombok

Use Lombok selectively to remove incidental boilerplate without hiding class
design decisions.

Prefer Java language features when they express the intent clearly.

## Contents

- [Preferred Uses](#preferred-uses)
- [Avoid `@Data` as a Default](#avoid-data-as-a-default)
- [JPA Entities](#jpa-entities)
- [Builders](#builders)
- [Constructors](#constructors)
- [Lombok `@Value`](#lombok-value)
- [Lombok `@NonNull`](#lombok-nonnull)
- [Experimental Features](#experimental-features)
- [Configuration](#configuration)
- [Avoid](#avoid)

## Preferred Uses

### Required Constructor Injection

When Lombok is part of the project, `@RequiredArgsConstructor` is appropriate
for required `final` dependencies.

```java
@Service
@RequiredArgsConstructor
public class VacancyService {

    private final VacancyRepository vacancyRepository;
}
```

Keep constructor injection as the design principle. Lombok only generates the
constructor.

### Logging

Use `@Slf4j` when the project uses SLF4J and Lombok.

```java
@Slf4j
@Service
public class VacancyService {
}
```

### Getters

Use `@Getter` when read access is part of the class API.

Do not generate setters automatically unless mutability is intentional.

## Avoid `@Data` as a Default

Do not use `@Data` mechanically on domain objects or persistence entities.

`@Data` implicitly combines multiple decisions:

- getters
- setters
- `toString`
- `equals`
- `hashCode`
- required constructor generation

Prefer the smallest annotations required by the class.

## JPA Entities

Use Lombok conservatively on JPA entities.

Be especially careful with:

- `@Data`
- `@EqualsAndHashCode`
- `@ToString`
- generated setters

Relationships, lazy-loading behavior, and persistence identity can make
generated equality or string representations unsafe or misleading.

Define these behaviors explicitly when necessary.

## Builders

Use `@Builder` when it materially improves construction readability, especially
for objects with meaningful optional configuration.

Do not add builders to simple objects that are already clear to construct.

## Constructors

Use `@NoArgsConstructor`, `@AllArgsConstructor`, and related annotations only
when a framework or concrete design need requires them.

Do not generate every constructor by default.

## Lombok `@Value`

Prefer Java records for simple immutable data carriers when record semantics
fit.

Use Lombok `@Value` only when a class is more appropriate than a record and
the annotation adds clear value.

## Lombok `@NonNull`

Do not treat Lombok `@NonNull` as a substitute for:

- request validation
- Bean Validation
- domain invariants
- correct nullability modeling

## Experimental Features

Avoid Lombok experimental features by default.

Adopt them only when the project intentionally accepts their stability and
maintenance tradeoffs.

## Configuration

Use `lombok.config` when project-wide Lombok policies need to be enforced.

Prefer deterministic project configuration over relying on developer or agent
memory.

## Avoid

- `@Data` everywhere
- generated setters without intentional mutability
- Lombok annotations that hide domain invariants
- careless `equals`, `hashCode`, or `toString` generation on JPA entities
- builders without a readability benefit
- experimental features by default
- Lombok where a native Java feature is clearer
