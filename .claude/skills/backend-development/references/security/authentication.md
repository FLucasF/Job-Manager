# Authentication

Use Spring Security as the authentication boundary for identifying callers.

Keep authentication concerns separate from business behavior and authorization
rules.

## Centralize Authentication

Let the security filter chain establish the authenticated principal before
application code executes.

Avoid parsing credentials or authenticating users manually inside controllers.

## Explicit Public Endpoints

Keep anonymous endpoints deliberate and minimal.

Prefer a default-authenticated posture and explicitly permit only endpoints that
must be public.

## Authentication Principal

Expose a stable application identity from the authenticated principal.

Do not make domain code depend directly on servlet requests or security filter
internals.

Translate authentication context at the appropriate boundary when inner code
needs the current actor.

## Authentication Failure

Return controlled authentication failures.

Do not reveal whether an account exists, which credential was wrong, internal
provider details, or stack traces when that information is unnecessary.

## Sessions vs Bearer Tokens

Choose the authentication persistence mechanism according to the application
architecture.

Do not combine session and bearer-token behavior accidentally.

When the API uses bearer tokens, keep token validation in Spring Security rather
than duplicating verification in controllers.

## Account State

Authentication should respect account state when the system supports concepts
such as:

- disabled accounts;
- locked accounts;
- expired credentials;
- revoked access.

Do not treat successful credential verification as sufficient when account
policy forbids access.

## Avoid

- authentication logic in controllers
- manually parsing `Authorization` headers in application code
- permissive anonymous access by default
- leaking account existence through detailed login errors
- domain code depending on `HttpServletRequest`
- multiple independent authentication implementations for the same flow
