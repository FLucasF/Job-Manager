# Schema Design

Design the relational schema to preserve data integrity, model real
relationships, and support the application's expected access patterns.

Keep database constraints aligned with domain invariants that must remain true
regardless of the application code path.

## Contents

- [Model Identity Deliberately](#model-identity-deliberately)
- [Use Foreign Keys for Real Relationships](#use-foreign-keys-for-real-relationships)
- [Enforce Required Data](#enforce-required-data)
- [Enforce Uniqueness](#enforce-uniqueness)
- [Use Check Constraints When They Protect Stable Invariants](#use-check-constraints-when-they-protect-stable-invariants)
- [Choose Column Types by Meaning](#choose-column-types-by-meaning)
- [Normalize by Default](#normalize-by-default)
- [Keep Relationships Proportional](#keep-relationships-proportional)
- [Sensitive Data](#sensitive-data)
- [Migrations](#migrations)
- [Avoid](#avoid)

## Model Identity Deliberately

Choose primary keys according to the system's identity needs.

Use surrogate identifiers when they provide stable internal identity.

Do not use mutable business attributes as primary keys when they can change.

Keep business uniqueness separate from technical row identity when appropriate.

## Use Foreign Keys for Real Relationships

Use foreign keys when one table depends on or references another relational
entity.

Do not rely only on application code to preserve referential integrity.

Define delete/update behavior deliberately.

Avoid cascading database actions across unrelated lifecycle boundaries.

## Enforce Required Data

Use `NOT NULL` when the database value is truly required.

Do not make columns nullable merely to simplify persistence mapping.

Keep nullability aligned with the actual domain and migration strategy.

## Enforce Uniqueness

Use unique constraints or indexes for invariants that must remain unique under
concurrent requests.

Examples may include:

```text
email
CPF
external provider identifier
business key
```

Only enforce uniqueness when it is part of the actual business or technical
contract.

Do not rely on an application pre-check as the only protection against
duplicates.

## Use Check Constraints When They Protect Stable Invariants

Consider database check constraints for simple rules that must always hold in
persisted data.

Examples:

```text
salary >= 0
start_date <= end_date
status in an allowed database representation
```

Do not duplicate complex business workflows in database constraints.

## Choose Column Types by Meaning

Use database types that represent the stored value accurately.

Avoid storing values as generic strings when a more precise type exists.

Examples include:

```text
boolean values as boolean
timestamps as temporal types
numeric values as numeric types
UUIDs using the database's supported UUID representation when appropriate
```

Do not serialize structured relational data into text or JSON merely to avoid
modeling relationships unless schemaless storage is intentionally required.

## Normalize by Default

Prefer a normalized schema when data represents distinct concepts with
independent identity or lifecycle.

Duplicate data only when denormalization solves a measured or concrete access
problem and the consistency tradeoff is understood.

Do not denormalize preemptively for hypothetical performance.

## Keep Relationships Proportional

Model cardinality explicitly:

```text
one-to-one
one-to-many
many-to-one
many-to-many
```

Do not create many-to-many relationships mechanically.

Use an explicit join entity/table when the relationship itself has attributes,
lifecycle, audit data, or business meaning.

## Sensitive Data

Schema design must consider sensitive-data policy.

Do not duplicate personal or sensitive data across tables without a concrete
need.

Encryption, masking, retention, and logging rules belong to the security
references.

## Migrations

Schema changes must be compatible with the project's migration strategy.

Do not make manual production-only schema changes outside versioned migrations.

## Avoid

- mutable business values as primary keys without a strong reason
- application-only referential integrity
- application-only uniqueness enforcement
- nullable columns without semantic justification
- generic text columns for well-defined structured values
- unnecessary many-to-many relationships
- premature denormalization
- duplicated sensitive data without purpose
- schema changes outside versioned migrations
