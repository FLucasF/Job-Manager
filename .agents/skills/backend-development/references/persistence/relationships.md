# Persistence Relationships

Model JPA relationships according to ownership, lifecycle, and query behavior.

Do not mirror every object reference as a bidirectional database relationship.

## Add Relationships Deliberately

Create an entity association only when navigation or lifecycle semantics justify
it.

A foreign-key value or explicit query may be simpler than a large object graph.

## Prefer the Minimum Navigation Needed

Use unidirectional relationships when reverse navigation is unnecessary.

Introduce bidirectional relationships only when both directions are genuinely
useful and the synchronization responsibility is clear.

## Ownership

Understand which side owns the database relationship.

Keep both sides synchronized in application code when a bidirectional
relationship requires it.

Do not rely on an in-memory association update that does not update the owning
side.

## Cascade

Configure cascading only for lifecycle operations that should actually
propagate.

Do not use broad cascade settings merely to make persistence errors disappear.

Review `REMOVE` and orphan removal carefully because they can delete dependent
rows.

## Aggregate Boundaries

Do not cascade persistence operations across unrelated aggregate or feature
boundaries.

Independent lifecycle usually implies independent persistence operations.

## Collections

Avoid exposing mutable relationship collections directly when callers could
break consistency.

Provide behavior that preserves relationship invariants where appropriate.

## Serialization

Do not serialize JPA relationship graphs directly as REST responses.

Use explicit response DTOs to prevent recursive graphs, accidental lazy loading,
and unintended data exposure.

## Avoid

- bidirectional relationships by default
- cascade-all without lifecycle justification
- large connected entity graphs
- cross-aggregate cascading
- mutable association collections escaping without control
- persistence relationship graphs used directly as API responses
