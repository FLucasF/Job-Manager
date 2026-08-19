# Generics

Use generics to preserve relationships between types and provide reusable,
compile-time-safe APIs.

Do not introduce generic parameters unless they carry useful type information.

## Avoid Raw Types

Prefer:

```java
List<Vacancy>
Repository<Vacancy, UUID>
```

over raw generic declarations.

Raw types remove compile-time guarantees and can cause failures later.

## Generic Methods

Use generic methods when an operation genuinely applies to multiple types and
the relationship between input and output matters.

Example:

```java
public static <T> T requirePresent(Optional<T> value) {
    // ...
}
```

Do not make a method generic when a concrete type better expresses the domain.

## Wildcards

Use wildcards when the contract intentionally accepts a family of related
generic types.

Remember the practical rule:

- `? extends T` is useful when consuming values as `T`;
- `? super T` is useful when supplying values of type `T`.

Do not introduce wildcards when an exact type is clearer.

## Generic Bounds

Use bounds to express capabilities required by a generic algorithm.

Avoid broad or deeply nested bounds that make an API difficult to understand.

## Do Not Hide Domain Concepts

Do not replace meaningful domain contracts with generic frameworks such as:

```java
Service<T, ID, R, Q>
```

unless multiple real use cases share the same semantics.

Generic CRUD abstractions often erase domain differences and create coupling.

## Avoid Unchecked Casts

Do not use casts to force generic code to compile.

If an unchecked cast is unavoidable at a framework boundary, isolate and
justify it locally.

## Prefer Specific APIs

Prefer:

```java
Vacancy save(Vacancy vacancy);
```

when that is the actual contract.

Do not generalize APIs simply because Java allows it.

## Avoid

- raw types
- generic parameters that add no useful relationship
- wildcard-heavy APIs without a concrete need
- unchecked casts hidden inside reusable abstractions
- generic CRUD layers that erase domain semantics
- premature generic frameworks
