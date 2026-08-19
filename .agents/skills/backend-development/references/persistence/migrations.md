# Database Migrations

Manage schema evolution with versioned migrations.

Treat the database schema as a production artifact that changes through
reviewable, repeatable migration steps.

## Use One Migration Mechanism

Use the project's selected migration tool consistently, such as Flyway or
Liquibase.

Do not mix multiple schema-initialization mechanisms for production schema
ownership without a deliberate reason.

## Do Not Rely on Automatic Schema Mutation in Production

Do not use ORM automatic schema update as the production migration strategy.

Schema changes must be explicit, versioned, and reviewable.

## Migrations Are Immutable History

Once a migration has been applied to shared or production environments, do not
edit it casually.

Create a new migration that moves the schema forward.

## Backward-Compatible Changes

For zero-downtime or independently deployed systems, prefer incremental changes
when needed:

```text
add new structure
deploy compatible code
migrate/backfill data
remove old structure later
```

Do not combine incompatible schema and application changes into one step when
deployment topology requires compatibility.

## Data Migrations

Treat data backfills and transformations as operational work.

Consider:

- execution time;
- locking;
- batching;
- rollback/recovery;
- production dataset size.

Do not assume a migration that is fast on development data is safe on
production data.

## Constraints

Add constraints intentionally and consider existing invalid data before
enforcing them.

## Environment Consistency

Run the same migration history across environments.

Do not maintain a manually edited production schema that differs from migration
history.

## Avoid

- ORM auto-update as production schema management
- editing already-applied migrations
- manual production-only schema changes
- multiple tools owning the same schema without a reason
- large blocking backfills without operational review
- migrations tested only against empty databases
