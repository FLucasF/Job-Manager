# Indexing

Create indexes to support real query patterns and integrity requirements.

Do not add indexes mechanically to every searchable or foreign-key column.

## Contents

- [Start from Queries](#start-from-queries)
- [Measure Before Optimizing](#measure-before-optimizing)
- [Use Selective Indexes](#use-selective-indexes)
- [Composite Indexes](#composite-indexes)
- [Unique Indexes](#unique-indexes)
- [Foreign Keys](#foreign-keys)
- [Pagination](#pagination)
- [Index Cost](#index-cost)
- [Partial and Specialized Indexes](#partial-and-specialized-indexes)
- [Remove Unused or Redundant Indexes](#remove-unused-or-redundant-indexes)
- [Migrations](#migrations)
- [Avoid](#avoid)

## Start from Queries

Design indexes around observed or expected database access patterns.

Review:

```text
WHERE predicates
JOIN keys
ORDER BY
GROUP BY
uniqueness constraints
pagination access paths
```

Do not create indexes solely because a column appears frequently in the model.

## Measure Before Optimizing

For non-trivial performance work, inspect the actual query plan.

Use the database's execution-plan tooling to understand:

```text
table scans
index scans
join strategy
estimated vs actual rows
sort operations
filter selectivity
```

Do not assume an index helps without checking the query shape and dataset.

## Use Selective Indexes

Indexes are most useful when they significantly narrow the searched rows or
support required ordering/join behavior.

Low-selectivity columns may provide little benefit alone.

Do not index boolean or small-enum columns automatically.

## Composite Indexes

Use composite indexes when queries frequently filter or sort by multiple
columns together.

Column order matters.

Design the leading columns according to the real query predicates and ordering
requirements.

Do not create every possible column combination.

## Unique Indexes

Use unique indexes or constraints when uniqueness is part of correctness.

A uniqueness index may serve both integrity and lookup performance.

Do not replace a business uniqueness requirement with a non-unique performance
index.

## Foreign Keys

Foreign-key columns often participate in joins and may benefit from indexing.

Evaluate the database engine and actual query pattern rather than applying a
blanket rule.

## Pagination

For large datasets, review indexes used by pagination and sorting.

Stable indexed ordering can improve predictable page access.

For deep pagination, consider whether offset pagination remains appropriate for
the workload before adding increasingly complex indexes.

## Index Cost

Every index has a cost.

Consider:

```text
insert/update/delete overhead
disk usage
vacuum/maintenance cost
migration time
write amplification
```

Do not optimize reads while ignoring a write-heavy workload.

## Partial and Specialized Indexes

Use partial, expression, or database-specific indexes only when a concrete
query or constraint justifies the added coupling.

Document the query pattern that requires the specialized index.

Do not introduce database-specific indexing features merely because they are
available.

## Remove Unused or Redundant Indexes

Review indexes that overlap heavily or no longer support active queries.

Do not keep redundant indexes indefinitely because removing them feels risky;
verify usage and query plans first.

## Migrations

Create and remove indexes through versioned migrations.

For large production tables, consider lock duration and the database's online
or concurrent index-building capabilities when supported.

Do not assume index creation is operationally cheap.

## Avoid

- indexing every column
- indexing low-selectivity fields without evidence
- composite indexes without query-driven column order
- duplicate or heavily overlapping indexes
- optimizing by intuition without query-plan inspection
- ignoring index cost on write-heavy tables
- database-specific indexes without a concrete need
- large production index operations without migration/locking review
