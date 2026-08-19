# Exceptions

Use exceptions to represent exceptional conditions, preserve useful context,
and keep failure contracts explicit.

Do not use exceptions as normal control flow.

## Contents

- [Catch Only When Useful](#catch-only-when-useful)
- [Preserve Causes](#preserve-causes)
- [Checked and Unchecked Exceptions](#checked-and-unchecked-exceptions)
- [Domain and Application Errors](#domain-and-application-errors)
- [Do Not Catch Broadly](#do-not-catch-broadly)
- [Resource Management](#resource-management)
- [Logging](#logging)
- [Avoid](#avoid)

## Catch Only When Useful

Catch an exception when the current boundary can:

- recover from it;
- translate it to a more appropriate abstraction;
- add meaningful context;
- perform required cleanup not already handled by resource management.

Avoid catching an exception only to rethrow the same exception unchanged.

## Preserve Causes

When translating an exception, preserve the original cause.

Prefer:

```java
throw new VacancyPersistenceException("Failed to save vacancy", exception);
```

over losing the original exception.

## Checked and Unchecked Exceptions

Use checked exceptions only when callers are expected to reasonably recover
from or explicitly handle the condition.

Use unchecked exceptions for programming errors, invalid states, or failures
that callers generally cannot recover from locally.

Do not choose checked or unchecked exceptions mechanically.

## Domain and Application Errors

Use domain- or application-specific exceptions when they improve the contract.

Examples:

```text
VacancyNotFoundException
VacancyAlreadyClosedException
UnauthorizedVacancyAccessException
```

Do not encode HTTP status codes inside domain exceptions.

HTTP translation belongs to the web boundary.

## Do Not Catch Broadly

Avoid:

```java
catch (Exception exception) {
}
```

unless the boundary genuinely owns all failures and handles them intentionally.

Never swallow exceptions silently.

## Resource Management

Use try-with-resources for `AutoCloseable` resources.

Prefer:

```java
try (InputStream input = source.openStream()) {
    // ...
}
```

over manual close handling where try-with-resources applies.

## Logging

Do not log and rethrow the same exception at every layer.

Choose the boundary that owns the operational context to prevent duplicate
stack traces and noisy logs.

Never include sensitive data in exception messages or logs.

## Avoid

- exceptions as ordinary branching logic
- empty catch blocks
- broad `catch (Exception)` without boundary ownership
- losing original causes
- leaking infrastructure exceptions through every layer
- domain exceptions coupled to HTTP
- duplicate logging of the same failure
