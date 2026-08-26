# Pagination, Filtering, and Sorting

Bound collection endpoints and make query behavior explicit.

Do not allow clients to control unbounded query cost.

## Paginate Potentially Large Collections

Use pagination for endpoints whose result set can grow materially.

Avoid returning an unbounded `List` from externally accessible collection
endpoints when the dataset is not inherently small.

## Bound Page Size

Define a safe default and maximum page size.

Do not trust arbitrary client-provided page sizes.

The exact limits are project policy and should reflect expected payload and
query cost.

## Page vs Slice

Use a total-count `Page` only when clients need total-count metadata and the
extra count query is acceptable.

Use a `Slice` or another lighter contract when clients only need to know
whether more results exist.

Do not compute totals automatically when the API does not need them.

## Keep Framework Types at the Right Boundary

Spring Data `Pageable`, `Page`, and `Sort` are convenient at web/persistence
boundaries.

Do not leak Spring Data pagination types into domain behavior when doing so
couples the domain unnecessarily to the framework.

Translate to an application-level query object when a meaningful boundary
requires it.

## Filtering

Expose only supported filters.

Do not accept arbitrary property names or unrestricted query expressions by
default.

Validate filter combinations when some combinations are invalid or
unreasonably expensive.

## Sorting

Allow sorting only by explicitly supported fields.

Do not pass arbitrary client-provided property names directly into dynamic
queries when that creates unsafe or unstable behavior.

Provide deterministic ordering when pagination correctness depends on it.

## Stable Contracts

Keep page numbering, size limits, sort syntax, and response metadata consistent
across collection endpoints unless a resource has a justified exception.

## Avoid

- unbounded collection responses
- unlimited client-selected page sizes
- count queries when totals are not needed
- arbitrary field sorting
- unrestricted dynamic filtering
- framework pagination types leaking through all architectural layers
- pagination without deterministic ordering when records can move between pages
