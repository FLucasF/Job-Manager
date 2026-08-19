# Controller Testing

Use controller tests to verify the observable Spring MVC contract without
duplicating application or domain behavior.

Prefer the smallest test scope that proves the web boundary.

## Choose the Test Scope Deliberately

Use `@WebMvcTest` with `MockMvc` when the test must verify Spring MVC routing,
request binding, validation, serialization, exception translation, or web
security while replacing application collaborators at the boundary.

Use standalone `MockMvc` setup only when intentionally testing a narrowly
assembled controller configuration. Do not use it to claim that application
MVC configuration, controller advice, filters, or security wiring works.

Use `@SpringBootTest` only when the full application context or a real HTTP
boundary is part of the behavior being proved.

## Assert the HTTP Contract

Verify externally observable behavior such as:

```text
HTTP method and route
path, query, header, and body binding
status code
response headers
JSON shape and serialization
request validation
standard error response
authentication and authorization when applicable
```

Assert response fields that define the contract. Avoid snapshots or assertions
so broad that intentional unrelated fields make the test fragile.

## Keep the Application Boundary Controlled

Replace the controller's application service or use-case collaborator when the
test is scoped to the web adapter.

Use real request and response DTOs, validators, JSON configuration, controller
advice, and other web components whose behavior the test intends to prove.

Stub only scenario-relevant application outcomes. Verify delegation only when
the passed command, query, authenticated principal, or other input is part of
the controller's responsibility.

## Cover Validation and Errors

Test representative invalid input for each distinct validation behavior that
affects the HTTP contract.

Verify that expected application exceptions are translated by the configured
exception handler into the intended status and error response.

Do not reproduce every domain failure in controller tests. Cover additional
cases at the application or domain level when their HTTP translation is the
same.

## Include Security When It Is Part of the Contract

When the endpoint is protected, verify representative anonymous, allowed, and
denied requests with Spring Security test support.

Include CSRF behavior for state-changing browser-authenticated requests when
the application security model requires it.

Do not disable filters merely to make a protected endpoint test easier. If the
test intentionally excludes security, keep that scope explicit and cover the
security contract separately.

## Keep Fixtures at the Web Boundary

Build requests and expected responses from API DTOs or JSON payloads.

Do not use persistence entities as convenient HTTP fixtures. Keep payloads
minimal so the scenario and contract remain visible.

## Avoid

- testing controller methods by direct invocation when MVC behavior matters
- mocking JSON serialization, validation, controller advice, or filters that
  are part of the asserted contract
- duplicating all application or domain scenarios through HTTP
- asserting private methods or incidental collaborator calls
- using full application context for every controller test
- treating standalone `MockMvc` as proof of application web configuration
- disabling security without separate contract coverage
