# Fetching

Design fetch plans according to each use case.

Avoid both loading large object graphs eagerly and triggering uncontrolled
lazy-loading queries.

## Default Toward Narrow Graphs

Keep persistent associations lazy where practical and fetch what a use case
actually needs.

Do not change an association to eager loading merely to silence a lazy-loading
or N+1 problem.

## Detect N+1

Treat repeated per-row association queries as a query-design problem.

Typical signal:

```text
1 query loads vacancies
N queries load one association for each vacancy
```

Fix the query/fetch plan instead of hiding the issue with a larger session
scope.

## Fetch Explicitly Per Use Case

Use an appropriate mechanism when related data is required together, such as:

- fetch joins;
- entity graphs;
- projections;
- batch fetching.

Choose based on the result shape and cardinality.

## Do Not Fetch Everything

A single giant join is not automatically efficient.

Review:

- result multiplication;
- duplicated rows;
- memory use;
- pagination behavior;
- unnecessary columns and associations.

## Lazy Loading Boundaries

Do not depend on accidental lazy loading during JSON serialization or after the
intended persistence boundary.

Load required data deliberately before mapping the response.

## Measure

Use SQL logs, profiling, query metrics, or integration tests when fetch behavior
is performance-sensitive.

Do not optimize fetch strategy from assumptions alone.

## Avoid

- eager loading as a universal fix
- N+1 queries
- accidental queries during serialization
- giant fetch joins for every endpoint
- depending on an open persistence context to hide missing fetch design
- changing fetch plans without observing generated SQL
