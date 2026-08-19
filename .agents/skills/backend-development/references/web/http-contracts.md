# HTTP Contracts

Design REST endpoints around explicit resource semantics and stable HTTP
contracts.

Use HTTP methods, status codes, paths, query parameters, headers, and bodies
according to their intended protocol roles.

## Resource-Oriented Paths

Prefer nouns that identify resources.

Prefer:

```text
/vacancies
/vacancies/{vacancyId}
/workers/{workerId}/applications
```

Avoid verb-heavy paths when an HTTP method already expresses the operation.

Use action-style endpoints only when the operation does not map cleanly to
resource state.

## Method Semantics

Use:

- `GET` for retrieval without intended state mutation;
- `POST` for creation or non-idempotent processing;
- `PUT` for complete replacement when that contract is intended;
- `PATCH` for partial modification;
- `DELETE` for deletion semantics.

Do not choose methods based only on which annotation is easiest to implement.

## Path, Query, and Body

Use path parameters for resource identity.

Use query parameters for concerns such as:

- filtering;
- pagination;
- sorting;
- optional retrieval controls.

Use the request body for structured input that represents creation, replacement,
or modification data.

## Status Codes

Return status codes that reflect the outcome of the HTTP operation.

Keep status translation in the web boundary.

Do not encode HTTP status concerns into domain models or domain exceptions.

## Content Types

Declare request and response media types when the endpoint requires a contract
more specific than the application's normal JSON defaults.

Reject unsupported formats rather than silently interpreting ambiguous input.

## Headers

Use headers for protocol-level metadata such as authentication, caching,
conditional requests, correlation, or location metadata.

Do not move ordinary business fields into custom headers without a protocol
reason.

## Idempotency

Preserve the natural idempotency semantics of HTTP methods.

For operations that may be retried and can create duplicate side effects,
introduce explicit idempotency handling only when the use case requires it.

## Contract Stability

Treat externally consumed endpoint shapes as contracts.

Do not rename fields, change status semantics, or alter pagination shapes
casually once clients depend on them.

## Avoid

- action verbs in every resource path
- GET endpoints that intentionally mutate application state
- path parameters used for optional filters
- business data hidden in custom headers
- domain types carrying HTTP status decisions
- protocol behavior chosen only for implementation convenience
