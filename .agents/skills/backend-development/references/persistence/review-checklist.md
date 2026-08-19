# Persistence Review Checklist

Use this checklist after reading the persistence references relevant to the
change.

Do not use this checklist as a substitute for the detailed references.

## Contents

- [Entities](#entities)
- [Schema Design](#schema-design)
- [Repositories](#repositories)
- [Relationships](#relationships)
- [Transactions](#transactions)
- [Fetching](#fetching)
- [Queries](#queries)
- [Indexing](#indexing)
- [Locking and Concurrency](#locking-and-concurrency)
- [Auditing](#auditing)
- [Migrations](#migrations)
- [Final Review](#final-review)

## Entities

- [ ] JPA entities remain persistence concerns rather than accidental HTTP contracts.
- [ ] Separate domain and persistence models are used only when the boundary provides value.
- [ ] Entity identity and equality are deliberate.
- [ ] Lombok does not generate unsafe setters, equality, hash code, or string output by default.
- [ ] Database constraints protect invariants that must hold independently of application code.
- [ ] Sensitive persisted fields are not assumed safe to serialize or log.

## Schema Design

- [ ] Primary keys and business uniqueness have deliberate, separate semantics where appropriate.
- [ ] Foreign keys, nullability, column types, and constraints match the modeled invariants.
- [ ] Delete and update behavior preserves the intended lifecycle boundaries.
- [ ] Check and unique constraints protect stable invariants without duplicating complex workflows.
- [ ] Normalization is preferred unless deliberate denormalization solves a concrete access problem.
- [ ] Sensitive data is not duplicated across tables without a justified need.

## Repositories

- [ ] Repository contracts express actual application persistence needs.
- [ ] Controllers do not access repositories directly.
- [ ] Spring Data repositories remain inside the persistence boundary where appropriate.
- [ ] Repository implementations contain persistence logic, not business workflows.
- [ ] Other features do not access internal repository implementations directly.
- [ ] Return types communicate zero/one/many/paged result semantics.

## Relationships

- [ ] Entity relationships exist only where navigation or lifecycle semantics justify them.
- [ ] Bidirectional relationships have a clear need and ownership rule.
- [ ] Cascade and orphan-removal behavior matches lifecycle ownership.
- [ ] Cascades do not cross unrelated aggregate or feature boundaries.
- [ ] Relationship graphs are not serialized directly as API responses.

## Transactions

- [ ] Transaction boundaries align with coherent application use cases.
- [ ] Controllers are not transaction owners.
- [ ] Multi-repository atomic work shares the required transaction boundary.
- [ ] Transactions do not remain open across slow external work without justification.
- [ ] Failures that should roll back are not swallowed.
- [ ] Transaction behavior does not depend accidentally on self-invocation/proxy quirks.

## Fetching

- [ ] Fetch behavior was chosen for the use case rather than globally.
- [ ] N+1 query behavior was considered.
- [ ] Required relationships are loaded deliberately before response mapping.
- [ ] Eager loading was not introduced as a universal fix.
- [ ] Large fetch joins were reviewed for row multiplication and pagination effects.
- [ ] Generated SQL is inspected or measured when fetch performance matters.

## Queries

- [ ] Derived query names remain readable.
- [ ] Explicit/native queries are used only when they improve clarity or capability.
- [ ] Dynamic filters are bounded to supported behavior.
- [ ] Potentially large results are limited or paginated.
- [ ] Large datasets are filtered/aggregated in the database when appropriate.
- [ ] Projections are used deliberately and are not accidental public API contracts.
- [ ] Non-trivial generated SQL was reviewed when performance matters.

## Indexing

- [ ] Indexes correspond to real query predicates, joins, ordering, grouping, or uniqueness needs.
- [ ] Composite-index column order follows the query access pattern.
- [ ] Selectivity and actual query plans are inspected when index performance matters.
- [ ] Unique indexes preserve correctness rather than serving only as performance hints.
- [ ] Redundant indexes and write, storage, and maintenance costs were considered.
- [ ] Index migrations account for production table size, locking, and supported online/concurrent operations.

## Locking and Concurrency

- [ ] Lost-update behavior is intentional.
- [ ] Optimistic locking is used where concurrent updates must be detected.
- [ ] Pessimistic locking is limited to cases that justify database-level serialization.
- [ ] Locks are held for the shortest practical transaction.
- [ ] Uniqueness invariants are enforced by database constraints where races are possible.
- [ ] Retries cannot duplicate non-idempotent side effects without protection.

## Auditing

- [ ] Audit metadata exists only where useful.
- [ ] Technical timestamps use consistent time semantics.
- [ ] Actor metadata is supplied without coupling entities to HTTP.
- [ ] Last-modified metadata is not mistaken for a complete audit trail.
- [ ] Audit records do not duplicate sensitive data unnecessarily.

## Migrations

- [ ] Schema changes use the project's selected versioned migration tool.
- [ ] Production does not rely on ORM automatic schema update.
- [ ] Previously applied migrations were not modified.
- [ ] Migration compatibility matches deployment requirements.
- [ ] Large backfills were reviewed for production data volume and locking.
- [ ] Database environments follow the same migration history.

## Final Review

- [ ] Persistence details remain behind the intended architectural boundary.
- [ ] Correctness is enforced at the database where application-only checks are insufficient.
- [ ] Query and transaction design is proportional to the actual workload.
- [ ] Added persistence abstractions solve current problems rather than adding ceremony.
