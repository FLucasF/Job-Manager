# Security Testing

Test authentication and authorization as explicit backend contracts.

A successful functional response does not prove that unauthorized callers are
blocked correctly.

## Test Anonymous Access

For protected endpoints, verify anonymous requests are rejected according to the
API authentication contract.

For public endpoints, verify they remain intentionally accessible.

## Test Authorities and Roles

Verify representative allowed and denied authorities.

Do not test only the privileged happy path.

## Test Object-Level Authorization

For endpoints containing resource identifiers, verify that an authenticated
caller cannot access another caller's protected resource merely by changing the
identifier.

## Test Property-Level Disclosure

Verify sensitive properties are:

- omitted when the caller must not receive them;
- masked when the contract permits only partial disclosure;
- fully returned only when explicitly authorized.

Do not treat masked output as proof of object-level authorization.

## Method Security

When application services use method-level authorization, test the allowed and
denied cases using Spring Security's test support.

Do not rely only on controller route tests to prove method security.

## CSRF

When CSRF protection applies to the credential model, test unsafe HTTP methods
with valid and invalid/missing CSRF tokens.

Do not disable CSRF in tests merely to simplify requests if production requires
it.

## JWT/Bearer Authentication

For resource-server endpoints, use Spring Security test support to establish
the required authenticated principal/claims for web-boundary tests.

Keep separate integration coverage for any custom token mapping or validation
configuration that is application-specific.

## Sensitive Errors

Verify authentication and authorization failures do not expose credentials,
token contents, internal exception details, or unnecessary account information.

## Avoid

- security tests covering only successful access
- assuming random/UUID identifiers prevent unauthorized access
- disabling security filters in every controller test
- treating frontend authorization as backend coverage
- skipping CSRF scenarios when CSRF is enabled
- asserting secrets or raw tokens in test output
