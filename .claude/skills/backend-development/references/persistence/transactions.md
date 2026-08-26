# Transactions

Place transaction boundaries around coherent application operations.

Use transactions to protect consistency, not as decoration on every method.

## Prefer Application-Level Boundaries

For use cases that coordinate multiple persistence operations, prefer the
transaction boundary at the application service that owns the workflow.

Typical shape:

```text
Controller
    ↓
Application Service  ← transaction boundary
    ↓
Repositories
```

This keeps the atomic unit aligned with the use case.

## Keep Transactions Focused

Do not hold database transactions open longer than required.

Avoid performing slow remote calls, user interaction, or unrelated work inside
a database transaction unless consistency requirements justify it.

## Read-Only Work

Use read-only transaction semantics when they accurately describe a read
operation and provide value to the persistence setup.

Do not rely on `readOnly = true` as an authorization or correctness guarantee.

## Rollback Semantics

Know which failures cause rollback in the project's Spring transaction
configuration.

Do not catch and swallow a failure inside a transactional method when the
operation should roll back.

## Proxy Boundaries

Do not design transaction behavior that depends accidentally on Spring proxy
self-invocation.

Keep transactional entry points explicit and test them at integration level
when behavior matters.

## Repository Transactions

Repository-level transaction defaults do not define the correct transaction
boundary for multi-repository application workflows.

Prefer the use-case boundary when several operations must succeed or fail
together.

## Avoid

- `@Transactional` on controllers
- transactions around unrelated work
- long transactions spanning remote calls without justification
- one transaction per repository call when the use case must be atomic
- swallowed exceptions that leave partial work committed
- relying on proxy behavior without understanding the call boundary
