# Persistence Architecture

**Status:** Draft

## Purpose

This document defines database ownership, ORM boundaries, schema evolution,
transactions, and compatibility rules for Job Manager persistence.

## Technology baseline

The currently configured relational persistence stack is:

- PostgreSQL;
- JPA/Hibernate;
- Spring Data JPA;
- Flyway.

Persistence belongs to `apps/backend/`.

The frontend never connects directly to PostgreSQL.

## Schema ownership

Flyway owns production schema evolution.

Hibernate validates mappings against the schema and does not own production
schema mutation.

Current backend configuration uses:

```text
spring.jpa.hibernate.ddl-auto = validate
spring.flyway.enabled = true
```

Responsibility split:

```text
Ready specification or explicit user request requires persistence change
        ↓
Backend persistence design
        ↓
Flyway migration
        ↓
PostgreSQL schema
        ↑
Hibernate validates mappings
```

Do not use ORM auto-update as a substitute for versioned migrations.

## Migration rules

- Schema changes are explicit, versioned, and reviewable.
- Applied shared/production migrations are immutable history; move forward with
  a new migration instead of casually editing old migrations.
- Environments should share the same migration history.
- Constraints must account for existing data.
- Data backfills require consideration of execution time, locking, batching,
  recovery, and realistic dataset size when applicable.
- Destructive schema changes require explicit scope in the applicable Ready
  specification or user request and careful review.

## JPA boundary

JPA entities are persistence representations. They are not automatically:

- domain models;
- application contracts;
- HTTP request models;
- HTTP response models.

Use separation only where different responsibilities or change reasons justify
it; do not create redundant model layers mechanically.

## Repository ownership

Persistence implementations stay inside the feature/infrastructure boundary
that owns them.

Application behavior must not reach directly into another feature's Spring Data
repository.

Where a meaningful boundary is needed, application code depends on a deliberate
persistence contract and infrastructure provides the implementation.

Do not introduce repository interfaces only as ceremony.

## Transactions

Place transaction boundaries around coherent application operations.

For use cases coordinating multiple persistence operations, prefer the
application operation as the transaction boundary:

```text
Controller
    ↓
Application operation  ← transaction boundary
    ↓
Repositories
```

Transactions protect consistency; they are not decorations for every method.

Avoid:

- `@Transactional` on controllers;
- transactions spanning unrelated work;
- unnecessarily long transactions;
- remote calls inside database transactions without a consistency reason;
- swallowing failures that should cause rollback;
- relying accidentally on Spring proxy self-invocation.

## Relationships and aggregates

Model relationships according to actual lifecycle and consistency needs.

Do not introduce large object graphs, cascading operations, eager relationships,
or aggregate boundaries without requirements that justify them.

Cross-feature persistence relationships must not erase feature ownership.

## Queries and indexes

Choose query and indexing strategies from actual access patterns.

Do not add indexes or specialized query mechanisms speculatively.

When performance requirements exist, validate query shape and database behavior
rather than assuming ORM defaults are sufficient.

## Sensitive data

Persistence of personal or sensitive information must coordinate with the
security architecture.

Do not persist a field merely because the frontend sends it. Data collection,
storage, disclosure, and retention require purpose and scope.

Encryption at rest or application-level encryption is not automatically
required for every field and must be decided according to the data and threat
model.

## Compatibility

Database changes are compatibility-sensitive.

For each schema-changing capability, consider:

- existing rows;
- nullability;
- constraints;
- application/migration ordering;
- data migration;
- rollback/recovery needs;
- deployment topology when independent compatibility matters.

## Related implementation references

Load only the relevant persistence topic, for example:

- [entities](../../.claude/skills/backend-development/references/persistence/entities.md)
- [schema design](../../.claude/skills/backend-development/references/persistence/schema-design.md)
- [repositories](../../.claude/skills/backend-development/references/persistence/repositories.md)
- [relationships](../../.claude/skills/backend-development/references/persistence/relationships.md)
- [transactions](../../.claude/skills/backend-development/references/persistence/transactions.md)
- [queries](../../.claude/skills/backend-development/references/persistence/queries.md)
- [indexing](../../.claude/skills/backend-development/references/persistence/indexing.md)
- [migrations](../../.claude/skills/backend-development/references/persistence/migrations.md)

Do not load every persistence reference for a simple change.
