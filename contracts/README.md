# Contract Governance

`contracts/` owns formal shared external representations when applicable. A
contract represents behavior required by a specification or explicit user
request; it does not create product requirements by itself.

Package-driven ownership flow:

```text
spec.md
→ externally observable requirement

design.md
→ feature technical and contract design

contracts/openapi.yaml
→ canonical shared formal representation when applicable

tasks.md
→ implementation of the defined contract
```

Directly authorized ownership flow:

```text
explicit user request
→ externally observable requirements

accepted domain/architecture + local Plan
→ bounded technical and contract design

contracts/openapi.yaml
→ canonical shared formal representation when applicable

implementation
→ synchronized realization of the defined contract
```

The direct-path local Plan may define bounded feature-local technical and
contract details. It cannot add observable requirements, resolve a material
Draft/Open decision or adopt cross-cutting architecture.

Contract/API design may occur during Draft/Design. Package-driven implementation
requires a Ready package and a sufficiently defined, consistent contract.
Implementation explicitly requested outside that workflow does not require a
Ready package, but must still keep the applicable contract defined and
consistent.

`contracts/openapi.yaml` may be created when an applicable Ready specification or
an explicit user request requires it, but only after `ARCH-OPEN-008` is accepted.
OpenAPI linting, compatibility checking, publication, generation or stub tooling
also requires accepted `ARCH-OPEN-004`. Do not promote
`arch/openapi.initial.yaml` automatically or add speculative endpoints. Both
decisions remain in `docs/architecture/open-decisions.md`.
