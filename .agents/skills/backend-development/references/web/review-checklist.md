# Web Review Checklist

Use this checklist after reading the web references relevant to the change.

Do not use this checklist as a substitute for the detailed references.

## Controllers

- [ ] Controllers are focused on HTTP adaptation.
- [ ] Controllers delegate application behavior instead of implementing business rules.
- [ ] Controllers do not access persistence repositories directly.
- [ ] HTTP-specific types remain at the web boundary.
- [ ] Mapping code does not obscure endpoint intent.
- [ ] `ResponseEntity` is used only when explicit response control is useful.

## DTO Mapping

- [ ] Request and response DTOs are distinct from persistence entities.
- [ ] DTOs reflect endpoint-specific contracts rather than one universal model.
- [ ] Domain code does not depend on web DTOs.
- [ ] Response fields are explicitly controlled.
- [ ] Mapping abstractions are introduced only when they provide real value.
- [ ] Sensitive fields follow the security disclosure and masking policy.

## HTTP Contracts

- [ ] Paths model resources clearly.
- [ ] HTTP methods match operation semantics.
- [ ] Path, query, body, and headers are used for their intended roles.
- [ ] Status codes represent endpoint outcomes consistently.
- [ ] Domain types do not own HTTP status decisions.
- [ ] Retried side-effecting operations have an idempotency strategy when required.
- [ ] Existing external contracts were not changed casually.

## Validation

- [ ] External input is structurally validated at the web boundary.
- [ ] Business invariants remain in application/domain logic.
- [ ] Expensive or unbounded client-controlled input has reasonable limits.
- [ ] Validation behavior is not delegated accidentally to persistence failures.
- [ ] Validation errors use the standard API error model.

## Exception Handling

- [ ] Repeated exception translation is centralized where appropriate.
- [ ] Domain/application exceptions remain HTTP-neutral.
- [ ] Error responses use the project's consistent structured format.
- [ ] Internal details and sensitive data are not exposed.
- [ ] Unexpected failures return controlled server errors.
- [ ] Broad handlers do not hide meaningful client/server distinctions.

## Pagination, Filtering, and Sorting

- [ ] Potentially large collections are bounded.
- [ ] Page size has intentional defaults and maximums.
- [ ] Total counts are computed only when clients need them.
- [ ] Supported filters and sort fields are explicit.
- [ ] Pagination ordering is deterministic when required.
- [ ] Spring Data pagination types do not leak into inner layers without need.

## Final Review

- [ ] The API contract is simpler for clients than the underlying implementation.
- [ ] HTTP concerns remain isolated from domain and persistence concerns.
- [ ] New abstractions protect a real contract or boundary rather than adding ceremony.
