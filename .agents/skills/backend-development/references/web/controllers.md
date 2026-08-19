# Controllers

Use Spring MVC controllers as HTTP adapters.

Controllers translate HTTP input into application calls and application results
into HTTP responses. Keep business behavior outside the controller.

## Keep Controllers Thin

Controllers may own:

- route mapping;
- path, query, header, and body extraction;
- request DTO validation;
- authenticated request context extraction;
- HTTP response status and headers;
- delegation to application services.

Avoid business rules, persistence access, or multi-step workflows in
controllers.

## Depend on Application Contracts

Prefer:

```text
Controller
    ↓
Application Service / Use Case
```

Avoid:

```text
Controller
    ↓
JPA Repository
```

Do not bypass the application boundary for convenience.

## Use HTTP-Specific Types at the Web Boundary

Spring MVC types are appropriate in controllers.

Do not propagate types such as `ResponseEntity`, servlet requests, or HTTP
headers into domain behavior.

## Prefer Method-Specific Mappings

Prefer mappings such as:

```java
@GetMapping
@PostMapping
@PutMapping
@PatchMapping
@DeleteMapping
```

when they express the endpoint clearly.

Use class-level mappings for stable resource prefixes.

## Constructor Injection

Use constructor injection for required controller collaborators.

When Lombok is adopted, `@RequiredArgsConstructor` is acceptable.

## Response Construction

Use `ResponseEntity` when explicit control over status or headers is required.

Do not wrap every successful response in `ResponseEntity` mechanically when
the framework can express the contract clearly without it.

## Keep Mapping Logic Small

Simple request-to-application or application-to-response transformations may
remain near the web boundary.

Move mapping to a dedicated mapper when it becomes reused, complex, or obscures
controller intent.

## Avoid

- business logic in controllers
- direct repository access
- domain rules expressed as HTTP conditions
- persistence entities as request or response contracts
- large mapping blocks that hide endpoint intent
- unnecessary `ResponseEntity` wrapping
- generic base controllers that erase resource-specific behavior
