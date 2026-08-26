# Immutability and Records

Prefer immutable state where practical and use Java records for concise,
transparent data carriers.

Do not use records mechanically for every class.

## Prefer Immutable State

Use `final` fields when a reference should not change after construction.

Prefer creating valid objects in one step rather than constructing incomplete
objects and mutating them later.

## Records

Use records when a type primarily represents a fixed set of values.

Good candidates include:

- request DTOs
- response DTOs
- immutable application inputs
- small value carriers
- simple value objects when record semantics fit

Example:

```java
public record VacancyResponse(
    UUID id,
    String title,
    VacancyStatus status
) {}
```

## Records Are Shallowly Immutable

A record prevents reassignment of its components but does not make referenced
objects deeply immutable.

For mutable collections, protect the boundary when immutability is required:

```java
public record SearchResult(List<Vacancy> vacancies) {

    public SearchResult {
        vacancies = List.copyOf(vacancies);
    }
}
```

## Validation in Record Constructors

Use a compact constructor when a record must enforce simple invariants.

Example:

```java
public record Email(String value) {

    public Email {
        Objects.requireNonNull(value);
    }
}
```

Keep complex business workflows outside record constructors.

## Domain Entities

Do not convert stateful domain entities to records only to reduce boilerplate.

A class may be more appropriate when it has:

- identity
- lifecycle
- controlled mutation
- rich behavior
- state transitions

## Defensive Copies

When exposing mutable collections or arrays across boundaries, use defensive
copies where mutation by callers would violate invariants.

## Avoid

- mutable DTOs without a need
- setters only to simplify object creation
- assuming record components are deeply immutable
- records for entities with meaningful mutable lifecycle
- exposing mutable internal collections directly
- using Lombok `@Value` when a Java record expresses the intent more clearly
