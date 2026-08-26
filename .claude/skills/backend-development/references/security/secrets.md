# Secrets

Keep application secrets outside source control and minimize where they are
available.

Treat credentials, signing keys, API tokens, encryption keys, and private keys
as secrets.

## External Secret Sources

Load production secrets from an approved runtime secret source or deployment
environment.

Do not commit production secrets to:

```text
application.yml
application.properties
source code
test fixtures
Dockerfiles
repository scripts
```

## Least Exposure

Provide each runtime component only the secrets it needs.

Do not expose all environment secrets to every application or process by
default.

## No Secret Logging

Never log secret values.

Be careful with:

- startup configuration dumps;
- exception messages;
- debug logging;
- HTTP headers;
- environment inspection.

## Rotation

Design secrets so they can be rotated without source changes.

Support overlapping key/token validity when the external protocol requires a
safe rotation window.

## Defaults

Do not provide real or production-capable default secrets.

Fail startup for missing critical secrets rather than falling back to a weak
hardcoded value.

## Development and Tests

Use isolated development/test credentials.

Do not copy production secrets into local configuration to simplify testing.

## Avoid

- committed secrets
- hardcoded JWT or encryption keys
- production credentials reused in tests
- secret values in logs
- broad secret exposure to unrelated components
- weak fallback secrets
