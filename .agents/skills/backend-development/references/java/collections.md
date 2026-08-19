# Collections

Choose collection types according to semantics and expose collection boundaries
intentionally.

Prefer collection interfaces in contracts when the implementation is not part
of the behavior.

## Contents

- [Choose by Semantics](#choose-by-semantics)
- [Program to Interfaces](#program-to-interfaces)
- [Empty Collections](#empty-collections)
- [Immutable Boundaries](#immutable-boundaries)
- [Avoid Exposing Internal Mutable State](#avoid-exposing-internal-mutable-state)
- [Avoid Unnecessary Copies](#avoid-unnecessary-copies)
- [Streams](#streams)
- [Parallel Streams](#parallel-streams)
- [Avoid](#avoid)

## Choose by Semantics

Use:

- `List<T>` when order and duplicates are meaningful;
- `Set<T>` when uniqueness is meaningful;
- `Map<K, V>` when lookup by key is the primary relationship.

Do not choose an implementation by habit.

## Program to Interfaces

Prefer:

```java
private final List<Vacancy> vacancies;
```

over exposing a concrete implementation when callers do not need to know it.

Choose the concrete implementation internally according to access patterns and
behavior.

## Empty Collections

Return empty collections instead of `null`.

Prefer:

```java
return List.of();
```

when there are no results.

## Immutable Boundaries

Use immutable factory methods or defensive copies when callers must not mutate
the collection.

Examples:

```java
List.of(...)
Set.of(...)
Map.of(...)
List.copyOf(...)
Set.copyOf(...)
Map.copyOf(...)
```

Remember that unmodifiable collections do not make mutable elements deeply
immutable.

## Avoid Exposing Internal Mutable State

Do not return a mutable internal collection directly when callers could violate
object invariants.

Prefer an unmodifiable view or defensive copy according to the ownership
contract.

## Avoid Unnecessary Copies

Do not copy collections mechanically when the boundary already guarantees safe
ownership and immutability.

Use defensive copies where they protect a real invariant.

## Streams

Use streams when they make transformation pipelines clearer.

Prefer straightforward loops when stateful logic, early exits, or complex
branching would make a stream pipeline harder to understand.

Do not use streams solely to make code look functional.

## Parallel Streams

Do not use parallel streams by default in server-side application code.

Parallelism changes execution and resource behavior and must be justified by
measurement and workload characteristics.

## Avoid

- returning `null` collections
- concrete collection types in contracts without a reason
- mutable internal collections escaping unintentionally
- collection implementations chosen by folklore
- streams that obscure control flow
- parallel streams without measurement and explicit justification
