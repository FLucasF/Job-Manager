# Type Safety

Use Java's type system to make invalid states and invalid operations harder to
represent.

Prefer compile-time guarantees over casts, raw types, loosely typed values, or
runtime checks when the type system can express the constraint directly.

## Contents

- [Preserve Type Information](#preserve-type-information)
- [Avoid Unchecked Operations](#avoid-unchecked-operations)
- [Avoid Type-Escaping with `Object`](#avoid-type-escaping-with-object)
- [Avoid Unnecessary Casts](#avoid-unnecessary-casts)
- [Model Domain Concepts with Domain Types](#model-domain-concepts-with-domain-types)
- [Prefer Enums to Magic Strings](#prefer-enums-to-magic-strings)
- [Keep API Contracts Precise](#keep-api-contracts-precise)
- [Keep External Boundaries Typed](#keep-external-boundaries-typed)
- [Avoid](#avoid)

## Preserve Type Information

Use parameterized types instead of raw types.

Prefer:

```java
List<Vacancy> vacancies = new ArrayList<>();
Map<UUID, Worker> workersById = new HashMap<>();
```

Avoid:

```java
List vacancies = new ArrayList();
Map workersById = new HashMap();
```

## Avoid Unchecked Operations

Treat unchecked compiler warnings as design signals.

Do not suppress `unchecked` warnings globally or broadly.

When an unchecked operation is unavoidable:

- isolate it in the smallest possible scope;
- verify the assumption before exposing a typed result;
- document why the operation is safe;
- keep unchecked values from propagating through the application.

## Avoid Type-Escaping with `Object`

Do not use `Object` when the domain has a more precise type.

Prefer concrete types, generic contracts, sealed hierarchies, or domain-specific
representations when appropriate.

## Avoid Unnecessary Casts

Repeated casts often indicate that type information was lost earlier.

Avoid:

```java
Object result = service.execute();
Vacancy vacancy = (Vacancy) result;
```

Prefer:

```java
Vacancy vacancy = service.execute();
```

## Model Domain Concepts with Domain Types

Consider explicit types for concepts such as:

```text
Email
Cpf
Money
VacancyId
WorkerId
```

when they have invariants, behavior, or are easy to confuse with other values.

Do not create wrapper types mechanically for every field.

## Prefer Enums to Magic Strings

Prefer:

```java
public enum VacancyStatus {
    DRAFT,
    PUBLISHED,
    CLOSED
}
```

over duplicated string literals representing domain states.

## Keep API Contracts Precise

Method signatures should communicate what callers may provide and receive.

Avoid broadening types solely to make APIs superficially reusable.

## Keep External Boundaries Typed

Convert and validate framework, serialization, reflection, and external API data
at the boundary before passing it into application or domain code.

## Avoid

- raw generic types
- broad `@SuppressWarnings`
- unchecked casts as normal application flow
- `Object` as a generic escape hatch
- magic strings for domain states
- loss of type information across boundaries
- generic abstractions without a real type relationship
