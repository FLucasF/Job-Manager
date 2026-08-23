# Contract Architecture

**Status:** Draft

This document defines contract ownership and synchronization. It does not create
product requirements or imply that OpenAPI already exists.

## Direction of authority

```text
spec.md
→ required HTTP behavior

design.md
→ feature technical and contract design

contracts/openapi.yaml
→ shared formal representation, when applicable

tasks.md
→ implementation work

validation.md
→ independent evidence after implementation
```

Contract/API design may be created or refined during Draft/Design. A Draft
contract never authorizes application changes. Ready requires any applicable
contract to be sufficiently defined, validated and consistent.

## HTTP contract responsibilities

An applicable specification defines observable resource, request, response,
status, validation, authentication, authorization, failure and collection
semantics. Design maps those requirements to operations/schemas without
inventing behavior.

Do not infer the API from JPA entities, UI models or current implementation.
Keep domain models, persistence entities, application results, HTTP DTOs,
frontend models and formal schemas distinct when responsibilities differ.

## Compatibility

Treat removed/renamed fields, new required fields, validation/status changes,
identifier changes, pagination/filter semantics and security changes as
compatibility-sensitive. The spec must authorize observable changes.

For current-user resources, obtain ownership from the accepted authentication
context rather than trusting arbitrary browser-supplied owner IDs.

## Errors and security

Translate internal failures at the HTTP boundary. Never expose stack traces,
framework/persistence internals, secrets or unnecessary sensitive values.
Authentication/security-scheme choices remain Open until resolved in
[Open Architecture Decisions](open-decisions.md).

## Workflow

```text
Draft spec
→ Design and applicable contract design
→ consistency/contract validation
→ human approval
→ Ready
→ backend/frontend implementation
→ independent validation
```

If contract design exposes product or cross-cutting architecture ambiguity, stop
and resolve it before Ready. Do not promote `arch/openapi.initial.yaml`.

## Related guidance

- [HTTP contracts](../../.agents/skills/backend-development/references/web/http-contracts.md)
- [DTO mapping](../../.agents/skills/backend-development/references/web/dto-mapping.md)
- [frontend data access](../../.agents/skills/frontend-development/references/architecture/data-access.md)
