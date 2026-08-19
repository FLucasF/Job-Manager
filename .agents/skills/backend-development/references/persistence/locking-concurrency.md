# Locking and Concurrency

Protect concurrent updates according to the actual contention and consistency
requirements of the use case.

Prefer optimistic concurrency for normal multi-user update flows unless
contention or correctness requirements justify pessimistic locking.

## Optimistic Locking

Use a version field when lost updates must be detected.

Example:

```java
@Version
private long version;
```

Handle optimistic-lock conflicts as expected concurrency outcomes at the
appropriate application or web boundary.

Do not silently overwrite a concurrent update.

## Pessimistic Locking

Use pessimistic locks only when the operation requires database-level
serialization and the expected contention justifies the cost.

Keep the locked transaction short.

Do not hold pessimistic locks across remote calls or user interaction.

## Select the Lock at the Query Boundary

Apply lock semantics to the repository/query operation that requires them.

Do not add locks globally to all repository access.

## Unique Constraints for Races

When correctness depends on uniqueness, enforce the invariant in the database
even if application code checks first.

Application pre-checks alone are vulnerable to concurrent requests.

## Idempotency and Concurrency

For externally retried operations, combine transaction and uniqueness/idempotency
design where duplicate side effects are possible.

Do not assume a transaction alone prevents duplicate requests.

## Avoid

- last-write-wins when lost updates are unacceptable
- pessimistic locking by default
- locks held during slow external operations
- application-only uniqueness checks
- global repository locking policies
- retry loops that can repeat non-idempotent side effects without protection
