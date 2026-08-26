# Contract Architecture

**Status:** Draft

This document defines contract ownership and synchronization. It does not create
product requirements or imply that OpenAPI already exists.

## Direction of authority

Package-driven work uses:

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

Directly authorized work uses:

```text
explicit user request
→ required HTTP behavior

accepted domain/architecture + local Plan
→ bounded technical and contract design

contracts/openapi.yaml
→ shared formal representation, when applicable

implementation and proportional verification
→ synchronized behavior and evidence
```

The local Plan may define feature-local technical and contract details for a
directly authorized request. It is not a requirement or cross-cutting
architecture source and cannot resolve a material Draft/Open decision.

Contract/API design may be created or refined during Draft/Design. A Draft
contract is not authority by itself. Package-driven work requires any applicable
contract to be sufficiently defined, validated and consistent before Ready;
work explicitly requested outside that workflow may proceed without a package
only after any material applicable architecture decision is accepted.

## HTTP contract responsibilities

An applicable specification, or an explicit user request when no Ready package
governs the work, defines observable resource, request, response, status,
validation, authentication, authorization, failure and collection semantics.
The package design or direct-path local Plan maps those requirements to
operations/schemas without inventing behavior.

Do not infer the API from JPA entities, UI models or current implementation.
Keep domain models, persistence entities, application results, HTTP DTOs,
frontend models and formal schemas distinct when responsibilities differ.

## Compatibility

Treat removed/renamed fields, new required fields, validation/status changes,
identifier changes, pagination/filter semantics and security changes as
compatibility-sensitive. The applicable Ready spec or explicit user request must
authorize observable changes.

For current-user resources, obtain ownership from the accepted authentication
context rather than trusting arbitrary browser-supplied owner IDs.

## Errors and security

Translate internal failures at the HTTP boundary. Never expose stack traces,
framework/persistence internals, secrets or unnecessary sensitive values.
Authentication/security-scheme choices remain Open until resolved in
[Open Architecture Decisions](open-decisions.md).

## Package-driven workflow

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
and resolve it before Ready or before directly authorized implementation. Do not
promote `arch/openapi.initial.yaml`.

Creating `contracts/openapi.yaml` requires accepted `ARCH-OPEN-008`. OpenAPI
linting, compatibility checking, publication, generation or stub tooling also
requires accepted `ARCH-OPEN-004`.

## Related guidance

- [HTTP contracts](../../.claude/skills/backend-development/references/web/http-contracts.md)
- [DTO mapping](../../.claude/skills/backend-development/references/web/dto-mapping.md)
- [frontend data access](../../.claude/skills/frontend-development/references/architecture/data-access.md)
