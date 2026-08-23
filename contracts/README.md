# Contract Governance

`contracts/` owns formal shared external representations when applicable. A
contract represents behavior required by a specification; it does not create
product requirements or authorize implementation.

Ownership flow:

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

Contract/API design may occur during Draft/Design. Ready is not required to
create or refine a contract, but implementation requires a Ready package and the
applicable contract must be sufficiently defined and consistent before Ready.

`contracts/openapi.yaml` does not exist until an applicable specification
requires it. Do not promote `arch/openapi.initial.yaml` automatically or add
speculative endpoints. Tooling choices remain in
`docs/architecture/open-decisions.md`.
