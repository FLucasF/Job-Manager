# Web Exception Handling

Translate application failures into consistent HTTP error responses at the web
boundary.

Prefer centralized exception translation.

## Centralize HTTP Translation

Use `@RestControllerAdvice` and focused `@ExceptionHandler` methods for
application-wide REST error translation when appropriate.

Avoid repeating `try/catch` blocks in controllers for the same error mappings.

## Keep Exceptions Boundary-Neutral

Domain and application exceptions should describe the failure, not the HTTP
status.

Translate them at the web boundary.

Example:

```text
VacancyNotFoundException
        ↓
web exception handler
        ↓
404 response
```

## Prefer Problem Details

Use Spring's `ProblemDetail` / `ErrorResponse` support for standardized HTTP
error responses when it fits the API contract.

Keep project-specific extension fields stable and minimal.

## Preserve Safe Error Information

Expose information clients need to understand or correct the request.

Do not expose:

- stack traces;
- SQL details;
- filesystem paths;
- secrets;
- internal infrastructure messages;
- sensitive personal data.

## Validation Errors

Map validation failures consistently with the rest of the API error model.

Field-level details may be included when safe and useful to the client.

## Unexpected Failures

Unexpected exceptions should produce a controlled generic server error
response.

Log operational details at the appropriate internal boundary without exposing
them to clients.

## Handler Scope

Use specific exception mappings before broad fallback handling.

Do not create a separate handler method for every exception when multiple
exceptions have the same stable external contract.

## Avoid

- repeated controller-level `try/catch`
- HTTP status fields embedded in domain exceptions
- exposing raw exception messages by default
- stack traces in API responses
- inconsistent error shapes between endpoints
- broad handlers that accidentally convert every failure into the same client
  error
