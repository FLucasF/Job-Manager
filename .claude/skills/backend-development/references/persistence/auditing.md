# Persistence Auditing

Record creation and modification metadata when it has operational or business
value.

Do not confuse persistence auditing metadata with a complete security audit
trail.

## Standard Metadata

Use Spring Data auditing when the application needs fields such as:

```text
createdAt
updatedAt
createdBy
updatedBy
```

Apply only the metadata the system actually uses.

## Use Appropriate Time Types

Prefer modern Java time types such as `Instant` for technical timestamps when
they represent a global moment.

Keep time sourcing consistent with the project's date/time policy.

## Current Actor

Use an auditor provider when `createdBy` or `updatedBy` must identify the current
authenticated actor.

Do not couple persistence entities to controller or request objects to discover
the user.

## Auditing Is Not Event History

`updatedAt` and `updatedBy` tell who last changed a row.

They do not provide:

- previous values;
- complete access history;
- immutable security evidence;
- business event history.

Use a dedicated audit/event mechanism when those requirements exist.

## Sensitive Data

Do not duplicate sensitive personal data into audit metadata or history without
a concrete requirement and retention policy.

## Avoid

- audit fields added everywhere without use
- discovering the current user through HTTP objects inside entities
- treating last-modified metadata as a full audit trail
- storing unnecessary sensitive data in audit records
- inconsistent timestamp types across audited entities
