# Logging

Use logs to explain important runtime events and failures without turning the
application into a stream of implementation noise.

Prefer structured, contextual logs that help operators answer what happened,
where, and for which request or entity.

## Log at Meaningful Boundaries

Good logging boundaries include:

- application operations with operational value;
- integration failures;
- unexpected exceptions;
- security-relevant events when policy allows;
- startup and configuration outcomes that help diagnose deployment problems.

Do not log every method entry and exit.

## Use Appropriate Levels

Use levels consistently:

```text
ERROR  unexpected failures requiring attention
WARN   degraded or suspicious conditions
INFO   meaningful lifecycle or business-operational events
DEBUG  diagnostic details useful during investigation
TRACE  very fine-grained diagnostics, rarely needed
```

Do not use `ERROR` for expected client mistakes or normal business outcomes.

## Add Context

Prefer stable contextual identifiers such as:

```text
request/correlation id
internal entity id
operation name
integration name
```

Avoid relying on free-form messages alone when structured fields are available.

## Avoid Duplicate Error Logs

Do not log the same exception at every layer.

Log it where enough operational context exists to act on the failure.

## Do Not Build Audit Trails Accidentally

Operational logs are not a substitute for a deliberate audit-event model.

If immutable business/security history is required, use a dedicated mechanism.

## Sensitive Data

Sensitive-data rules belong to
`references/security/logging-sensitive-data.md`.

Do not copy personal data, credentials, tokens, request bodies, or entire
entities into logs by default.

## Lombok

When Lombok is adopted, `@Slf4j` is appropriate for logger creation.

Lombok only removes logger boilerplate; it does not define what is safe or
useful to log.

## Avoid

- method-entry logging everywhere
- duplicate stack traces across layers
- `ERROR` for expected validation/business outcomes
- concatenated sensitive objects in log messages
- operational logs used as an implicit audit trail
- logging entire request or response objects by default
