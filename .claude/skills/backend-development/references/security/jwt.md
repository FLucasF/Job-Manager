# JWT

Use JWT as a signed bearer-token format only when it fits the authentication
architecture.

Treat possession of a valid bearer token as security-sensitive.

## Prefer Framework Validation

Use Spring Security Resource Server support for bearer-token processing and JWT
validation when the application accepts JWT access tokens.

Do not implement custom signature verification or token parsing in controllers.

## Validate Token Trust

Validate the properties required by the trust model, including as applicable:

- signature;
- issuer (`iss`);
- audience (`aud`);
- expiration (`exp`);
- not-before (`nbf`).

Do not accept a token merely because its JSON can be decoded.

## Keep Claims Minimal

Put only information required for authentication or authorization decisions in
the token.

Avoid personal or sensitive data in JWT claims when it is not required.

A signed JWT is not automatically encrypted; clients and intermediaries holding
the token may be able to read its claims.

## Authorities

Map external scopes or claims into application authorities deliberately.

Do not spread raw provider-specific claim parsing throughout application code.

## Token Lifetime

Use finite access-token lifetimes.

Do not issue effectively permanent bearer tokens.

Revocation, refresh, and session-continuity strategy must match the system's
risk model.

## Storage and Transport

Accept bearer tokens through the intended secure transport mechanism, normally
the `Authorization: Bearer` header for APIs.

Do not place access tokens in URLs.

Never log bearer tokens.

## Signing Keys

Keep signing secrets or private keys outside source control.

Plan key rotation when the system owns token issuance.

Prefer asymmetric signing when it provides useful separation between token
issuer and token validators.

## Avoid

- custom JWT verification when Spring Security can own it
- trusting decoded but unverified claims
- sensitive PII in token claims without necessity
- access tokens in query parameters
- logging JWTs
- permanent access tokens
- hardcoded signing secrets
