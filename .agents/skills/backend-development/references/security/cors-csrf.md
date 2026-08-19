# CORS and CSRF

Configure CORS and CSRF according to browser behavior and the application's
authentication mechanism.

Do not disable either control merely to make frontend requests succeed.

## CORS

Allow only the frontend origins, methods, and headers required by the deployed
application.

Prefer explicit allowed origins.

Do not use unrestricted origins together with credentialed browser requests.

Keep production CORS policy in runtime-aware configuration rather than
hardcoding development origins into application logic.

## Preflight

CORS preflight requests must be handled before authentication rejects them.

Use Spring MVC/Spring Security CORS integration rather than implementing
preflight handling in controllers.

## CSRF

Spring Security enables CSRF protection for unsafe methods by default.

Keep CSRF protection when browser credentials are automatically attached to
requests, such as cookie/session authentication, unless the architecture has a
well-understood alternative.

## Stateless Bearer APIs

For an API that authenticates exclusively through bearer tokens that the browser
does not attach automatically, CSRF risk differs from cookie-based
authentication.

Disable CSRF only after confirming the actual credential transport and browser
threat model.

Do not use "REST API" alone as the reason to disable CSRF.

## SPA Integration

When a SPA uses cookie/session authentication, integrate the frontend with the
CSRF token flow expected by Spring Security.

Do not bypass CSRF by changing unsafe state-changing operations to GET.

## CORS Is Not Authorization

An allowed origin does not grant permission to data or operations.

Authorization remains required for every protected resource.

## Avoid

- `csrf.disable()` without a credential/threat-model decision
- permissive CORS copied from development into production
- using CORS as access control
- GET requests for state-changing operations to avoid CSRF handling
- controller-level custom preflight logic
- assuming all token-based browser designs are automatically CSRF-safe
