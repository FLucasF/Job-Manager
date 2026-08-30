# Date and Time

Use Java's `java.time` API and make time handling explicit, deterministic, and
testable.

Choose temporal types according to the meaning of the data.

## Choose the Correct Type

Use `Instant` for a machine timestamp representing a moment on the global
timeline.

Use `LocalDate` for a calendar date without a time or timezone.

Use `LocalDateTime` only when a date and time intentionally have no timezone or
offset semantics.

Use `OffsetDateTime` when the offset is part of the exchanged or persisted
representation.

Use `ZonedDateTime` when timezone rules and a named zone are relevant.

## Prefer UTC for System Timestamps

For technical timestamps such as:

```text
createdAt
updatedAt
expiresAt
lastLoginAt
```

prefer an unambiguous instant representation.

Convert to local presentation zones at system boundaries when needed.

## Inject Clock for Time-Dependent Logic

Avoid directly coupling business rules to the system clock.

Prefer:

```java
public class TokenService {

    private final Clock clock;

    public TokenService(Clock clock) {
        this.clock = clock;
    }

    public boolean isExpired(Instant expiresAt) {
        return !clock.instant().isBefore(expiresAt);
    }
}
```

This treats the exact expiration instant as expired and makes tests
deterministic.

## Avoid Legacy Date APIs

Prefer `java.time` over legacy APIs such as `java.util.Date` and
`java.util.Calendar` for new application code.

Use legacy types only when required by a boundary, and convert them promptly.

## Time Zones

Do not rely on the server's default timezone for business behavior.

Make the intended timezone explicit when converting between local and global
representations.

## Parsing and Formatting

Keep parsing and formatting at boundaries where possible.

Do not store formatted date strings as domain time values when a temporal type
is appropriate.

## Avoid

- `new Date()` in new domain/application code
- `LocalDateTime` for globally meaningful timestamps without a clear reason
- implicit server-default timezone assumptions
- `Instant.now()` scattered through test-sensitive business logic
- storing formatted strings instead of temporal types
- timezone conversion inside unrelated business code
