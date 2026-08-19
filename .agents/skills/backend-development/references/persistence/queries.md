# Persistence Queries

Choose the simplest query mechanism that keeps intent readable and query cost
under control.

Keep query complexity in the persistence boundary.

## Derived Queries

Use Spring Data derived query methods for simple, stable predicates.

Keep method names readable.

When a derived name becomes difficult to understand, switch to an explicit
query mechanism.

## Explicit Queries

Use JPQL or another explicit query form when it communicates the query more
clearly than a long method name.

Use native SQL only when database-specific capabilities or performance needs
justify the coupling.

## Dynamic Filtering

Use a focused dynamic-query mechanism such as specifications when filters are
genuinely composable.

Do not build unrestricted query languages from arbitrary client input.

## Projections

Use projections when a use case needs only a subset of persistent data and
loading full entities would add unnecessary work.

Do not return persistence projections as public API contracts by accident.

## Bounded Results

Queries that can return many rows must have intentional limits or pagination.

Do not load an unbounded result set and filter it in memory when the database
can perform the filtering.

## Query Count and Shape

Review generated SQL for non-trivial queries.

Pay attention to:

- joins;
- indexes;
- row counts;
- count queries;
- N+1 behavior;
- unnecessary selected columns.

## Database Work Belongs in the Database

Prefer filtering, sorting, grouping, and aggregation in the database when they
can be expressed efficiently and safely there.

Do not move large datasets into Java only to perform routine relational work.

## Avoid

- unreadably long derived method names
- native SQL without a concrete need
- unrestricted dynamic query input
- unbounded queries
- in-memory filtering of large persisted datasets
- selecting full entities when a narrow projection is sufficient
- query decisions without inspecting generated SQL when performance matters
