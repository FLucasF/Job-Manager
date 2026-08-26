# Sensitive Data in Logs

Treat logs as a data-disclosure boundary.

Log enough context to operate the system without copying credentials or
unnecessary personal data into observability storage.

## Never Log Credentials or Tokens

Do not log:

- passwords;
- password hashes;
- bearer tokens;
- JWTs;
- session identifiers;
- reset tokens;
- API keys;
- encryption keys;
- `Authorization` headers.

## Minimize Personal Data

Do not log full CPF, email, phone, or other personal data unless a concrete
operational requirement justifies it and the logging policy allows it.

Prefer stable non-sensitive identifiers such as internal entity IDs or
correlation IDs.

## Errors

Do not place sensitive request bodies or values into exception messages.

A stack trace may be internally useful; the data embedded in the message may
still be unsafe.

## Structured Logging

Choose explicit structured fields.

Do not serialize entire request, response, entity, authentication principal, or
DTO objects into logs by default.

## Redaction

When logging a partially identifying value is genuinely required, apply an
approved masking/redaction policy.

Do not create ad-hoc masking rules inside logging statements.

## Log Levels

Changing a logger to debug or trace must not cause secrets to become visible.

Sensitive-data safety must hold at every log level expected in real
environments.

## Avoid

- whole request/response logging by default
- `toString()` of entities containing personal data
- credential or token logging
- exception messages containing secrets
- relying on production log level to hide unsafe debug statements
- ad-hoc personal-data masking inside individual log calls
