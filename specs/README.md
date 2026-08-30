# Specification Package Contract

This document is the normative contract for specification packages in `specs/`.
The workflow is a local Harness convention inspired by the roles
Specify, Design, Tasks, Execute and Validate; it is not a universal definition
of Spec-Driven Development.

## Canonical structure

```text
specs/
├── README.md
├── _templates/
│   ├── spec-template.md
│   ├── design-template.md
│   ├── tasks-template.md
│   └── validation-template.md
└── <spec-id>/
    ├── spec.md
    ├── design.md
    ├── tasks.md
    └── validation.md
```

`specs/_templates/` is reserved scaffolding, not a feature package. Templates
are guidance, not authority or validator schemas. Changing a template must not
invalidate an existing package.

Direct Markdown allowlist inside `specs/<spec-id>/`:

- `spec.md`;
- `design.md`;
- `tasks.md`;
- `validation.md`.

Other direct Markdown files are rejected by this local convention. In
particular, `plan.md` and `STATE.md` are not feature-package artifacts.

## Lifecycle and flow

```text
Product intent
→ Specify
→ spec.md (Draft)
→ refinement / human decisions
→ Design
→ design.md
→ contract/API design when applicable
→ tasks.md
→ consistency review
→ human approval
→ spec.md (Ready)
→ Execute tasks with RPI
→ independent Validate
→ validation.md
→ PASS | FAIL
```

During initial Draft, `spec.md` may exist alone. During refinement, design,
tasks and applicable formal contracts may be created and validated. A Draft
package does not by itself authorize application implementation, application-test
changes for the feature, executable feature migrations, task execution or
fabricated validation evidence. Its status does not block work independently
authorized by an explicit user request outside the package workflow.

That separate authorization still cannot supply missing product requirements or
silently accept a material domain/architecture decision from Draft/Open
material. Dependent work pauses until human authority resolves and records the
decision in its durable owner.

Ready requires valid and mutually consistent `spec.md`, `design.md` and
`tasks.md`. Human approval is required before the physical `Draft → Ready`
transition. `validation.md` is created after execution and is never a Ready
prerequisite.

If package-driven implementation discovers a material change, stop, return the
package to Draft, correct it, repeat consistency review/human approval, and reach
Ready again before resuming that workflow.

## `spec.md` — behavior and lifecycle

Required metadata:

```yaml
---
id: <lowercase-kebab-case>
version: <positive-integer>
status: Draft | Ready | Superseded
scope: Small | Medium | Large | Complex
---
```

Rules:

- the immediate package directory must equal `id`;
- `spec.md` is the only lifecycle owner;
- `scope` is case-sensitive and controls expected depth, not Ready artifacts;
- no numeric thresholds for files, tasks, tokens, model, effort or time apply;
- Draft and Superseded do not independently authorize implementation and do not
  override a separate explicit user authorization;
- material product decisions cannot be invented;
- Ready cannot use Draft/Open external documents as normative authority;
- HTTP impact and applicable formal contracts must be explicit;
- material open questions must be `None` before Ready.

The spec must semantically cover, combining headings when useful:

- Problem Statement;
- Goals / Objective;
- In scope and Out of scope;
- Assumptions & Open Questions;
- Requirements;
- Acceptance Criteria;
- Edge Cases;
- Applicable Domain Rules;
- Affected Boundaries;
- Failures and Validation;
- Security and Authorization;
- Persistence and Migrations;
- Contract Impact;
- Requirement Traceability;
- Success Criteria.

Acceptance criteria must be concrete, testable and observable. EARS forms such
as `WHEN ... THEN the system SHALL ...` are recommended scaffolding, not a hard
gate. Do not duplicate every criterion in EARS and Given/When/Then.

## `design.md` — specification-wide technical design

`design.md` translates requirements into a technical solution without creating
behavior or expanding scope. It is required for every Ready package,
independently of scope, and has no lifecycle of its own.

It covers when applicable:

- Summary / Architecture Overview;
- Requirement Mapping;
- Implementation Approach;
- Affected Boundaries;
- Code Reuse / Existing Patterns;
- Components / Responsibilities;
- Interfaces and Data Models;
- Contract/API Changes;
- Persistence and Migrations;
- Error Handling Strategy;
- Security Considerations;
- Verification Strategy;
- Risks, Mitigations and Rollback Considerations;
- Tech Decisions and Open Decisions.

Every acceptance criterion must map to implementation and verification. Open
Decisions must be `None` before Ready. Feature-local technical decisions may
remain here; project-wide/cross-cutting decisions must be resolved in the proper
architecture owner. Design cannot use a Draft/Open external document to fill a
spec gap.

## `tasks.md` — auditable work breakdown

`tasks.md` decomposes the design into granular, ordered, auditable units. It is
required for Ready.

Recommended top-level content:

- Test Coverage Matrix;
- Gate Check Commands;
- Execution Plan;
- Task Breakdown;
- Acceptance Criteria → Task Traceability.

Task format:

```markdown
## TASK-001 — Title

Objective:

Scope:

Where:

Requirements:
- REQ-001

Acceptance Criteria:
- AC-001

Dependencies:
- none

Done when:
- binary observable condition

Tests:
- concrete coverage

Verify:
`<existing deterministic repository command>`
```

Task IDs must be unique and sequential. Dependencies must exist, point only to
prior tasks and be acyclic. Each task traces to requirements/ACs or an explicit
design item, and every AC is covered by one or more tasks. Many-to-many mapping
is valid. Tasks cannot expand spec/design. `Verify` must use a real known
command; never invent build/test tooling.

## RPI execution plan

Each task executes as:

```text
Research → local Plan → Implement → Verify
```

Research consumes the package, applicable contract, accepted domain/
architecture documents and necessary skills/references. The local Plan is
temporary and may select files, order, commands and checks. It cannot redefine
requirements, acceptance criteria, design, cross-cutting architecture, contract
impact, task scope or dependencies.

## `validation.md` — independent post-implementation evidence

The independent verifier/reviewer creates validation after implementation. The
local process principle is `author != verifier`.

Required semantic content:

- Execution Metadata;
- Task Completion;
- Acceptance Criteria Evidence;
- Verification / Gate Results;
- Reviewer Findings;
- Deviations;
- Fix / Re-verification Iterations;
- Final Verdict (`PASS` or `FAIL`).

Validation is not a requirement source and cannot redefine spec, design or tasks
retroactively. Record only commands/gates actually run and preserve findings.
Missing evidence is `GAP`, not `PASS`. PASS requires no pending blocker under
this contract. FAIL requires correction and new verification before PASS.

Runner run IDs, attempts, fingerprints, locking, resume, recovery, iteration
limits and detailed telemetry are intentionally unspecified until the future
`harness-runner` specification.

## Ready consistency review

Ready requires:

- valid metadata, id/directory and scope;
- valid design and tasks;
- AC traceability in design and tasks;
- no material open question/decision;
- adequate accepted domain/architecture authority;
- no normative dependency on Draft/Open external material;
- sufficiently designed migrations and security when applicable;
- sufficiently defined and validated HTTP contract when applicable;
- no contradiction among applicable artifacts;
- explicit human approval.

A legitimate feature-local decision may be specified by the feature. A feature
must not silently accept a project-wide architecture/domain decision. Resolving
one decision does not automatically promote an entire Draft document.

## Contract/API governance

- `spec.md` owns HTTP requirements and observable behavior;
- `design.md` owns feature contract strategy/design;
- the project's contract artifact is the canonical shared formal representation
  when applicable;
- `tasks.md` implements the already-defined contract.

Formal contract work may occur during Draft/Design but does not alone authorize
implementation. Package-driven execution requires sufficient applicable contract
definition before Ready.
