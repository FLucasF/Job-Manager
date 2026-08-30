# Repositories

Use repositories as persistence boundaries, not as containers for business
logic.

Keep repository contracts focused on the queries and persistence operations the
application actually needs.

## Application-Facing Contract

When Clean Architecture requires persistence inversion, define the repository
contract on the inner side that needs persistence.

Example:

```java
public interface VacancyRepository {
    Optional<Vacancy> findById(VacancyId id);
    Vacancy save(Vacancy vacancy);
}
```

Infrastructure implements that contract using JPA or Spring Data.

Do not create repository interfaces mechanically when there is no meaningful
boundary.

## Keep Contracts Intentional

Prefer repository operations that express application needs.

Avoid creating a generic repository API with every possible CRUD operation when
the feature does not need them.

## Return Types

Use return types that communicate the query contract.

Examples:

```text
Optional<T>  expected zero-or-one result
List<T>      bounded multiple results
Slice<T>     paged results without required total count
Page<T>      paged results when total count is part of the contract
```

Do not return `null` collections.

## Repository Logic

Repositories may own persistence-specific query composition and mapping.

Do not place business workflows, authorization decisions, or domain state
transitions in repository implementations.

## Cross-Feature Access

Do not access another feature's internal JPA repository directly.

Use that feature's deliberate application contract.

## Avoid

- controller-to-repository shortcuts
- business logic in repositories
- exposing Spring Data repositories as application-wide services
- generic CRUD contracts that erase feature semantics
- `null` collection results
- direct cross-feature repository access

## Stack Mechanism

The stack-specific mechanisms for this concern live in the overlay skill for the
technology in use, when one exists. This reference states the rule; the overlay
states how the stack expresses it. When no overlay exists, the rule still applies
and the mechanism comes from general knowledge of that technology, declared as
such.
