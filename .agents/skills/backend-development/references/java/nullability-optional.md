# Nullability and Optional

Model absence explicitly and keep nullability contracts predictable.

Use `Optional` deliberately. Do not replace every nullable value with
`Optional`.

## Contents

- [Optional as a Return Contract](#optional-as-a-return-contract)
- [Do Not Use Optional Mechanically](#do-not-use-optional-mechanically)
- [Collections](#collections)
- [Null at Boundaries](#null-at-boundaries)
- [Required Dependencies](#required-dependencies)
- [Avoid `Optional.get()`](#avoid-optionalget)
- [Do Not Hide Domain Errors](#do-not-hide-domain-errors)
- [Avoid](#avoid)

## Optional as a Return Contract

Use `Optional<T>` when absence is an expected and meaningful result.

Prefer:

```java
Optional<Vacancy> findById(UUID id);
```

when the vacancy may not exist.

Do not return `null` from a method whose declared return type is `Optional`.

Use:

```java
return Optional.empty();
```

instead.

## Do Not Use Optional Mechanically

Avoid using `Optional` by default for:

- entity fields
- DTO fields
- method parameters
- collection elements

Prefer a direct type when the value is required.

For optional request fields, use the representation that best matches the
serialization and validation contract.

## Collections

Return empty collections instead of `null`.

Prefer:

```java
return List.of();
```

over:

```java
return null;
```

for a method that returns a collection.

## Null at Boundaries

Validate or normalize nullable external input before it enters core application
logic.

Do not allow unknown nullability from HTTP, persistence, or third-party APIs to
propagate unchecked through the codebase.

## Required Dependencies

Required constructor dependencies should not be nullable.

Prefer immutable `final` fields for required collaborators.

## Avoid `Optional.get()`

Do not call `Optional.get()` without first proving presence.

Prefer operations such as:

```java
orElseThrow(...)
map(...)
flatMap(...)
ifPresent(...)
```

when they better express the contract.

## Do Not Hide Domain Errors

Do not use `Optional.empty()` when absence actually represents an exceptional
business condition that should produce a specific domain or application error.

Choose the representation according to the contract.

## Avoid

- returning `null` for `Optional`
- returning `null` collections
- `Optional` fields by default
- `Optional` parameters by default
- unchecked nullability crossing application boundaries
- `Optional.get()` as routine control flow
- using absence to hide meaningful errors
