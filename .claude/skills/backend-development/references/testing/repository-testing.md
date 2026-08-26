# Repository Testing

Use repository integration tests to verify persistence behavior that Java mocks
cannot prove.

Test against the same database engine as production when SQL dialect,
constraints, locking, or database behavior matters.

## Verify Persistence Semantics

Repository tests are appropriate for:

```text
JPA mappings
custom queries
derived queries with non-trivial semantics
constraints
relationships and cascades
fetch plans
pagination
locking
database-specific SQL
```

Do not test Spring Data's trivial generated CRUD behavior without a project-
specific reason.

## Prefer Real Database Behavior

Use an isolated real database/container when database behavior is the subject of
the test.

Do not assume an in-memory database is equivalent to the production engine.

## Verify Generated SQL When Needed

For performance-sensitive or complex queries, inspect the resulting query
behavior.

A passing functional assertion does not prove absence of N+1 queries,
unnecessary joins, or inefficient result loading.

## Constraints and Races

Test important uniqueness and integrity constraints at the database boundary.

Application pre-check tests do not prove database enforcement.

## Data Setup

Keep fixtures minimal and scenario-specific.

Use explicit persisted state so the query condition is visible from the test.

## Avoid

- mocking repositories in repository tests
- testing trivial framework CRUD for coverage
- assuming an in-memory dialect matches production
- giant shared SQL fixtures
- ignoring constraint and query behavior
- using repository tests as substitutes for application-level transaction tests
