# Development Methodology — Job Manager

## Document role

This document explains how Job Manager uses discovery, specification, design,
delivery and validation methods. It does not own product behavior, domain rules,
architecture or formal contracts, and it does not present the local workflow as
a universal definition of Spec-Driven Development.

## Method set

The project may use, proportionally and when relevant:

- User Stories and examples to capture product intent;
- Event Storming for discovery, commands, events, policies and hotspots;
- DDD Strategic Design for language and boundary candidates;
- DDD Tactical Design and aggregate invariants when model depth is justified;
- BDD/Specification by Example for observable examples;
- ADD and Quality Attribute Scenarios for architecture-significant trade-offs;
- C4 to communicate system/container/component structure;
- ADRs for accepted architecture-significant decisions and rationale;
- Contract-First/OpenAPI when an applicable Ready spec or explicit user request
  requires a formal HTTP contract and the applicable architecture is accepted;
- optional specification packages for executable feature authority;
- RPI for execution of each task;
- independent review/verification for post-implementation evidence.

Using a method does not automatically adopt every practice or tool commonly
associated with it. In particular, Job Manager does not require global state
files, lessons files, mandatory context files, autonomous resolution of material
ambiguity, per-task auto-commits, specific sub-agent batching, mutation testing
for every feature, task-count thresholds, model tiers or editor-specific tools.

## Authority boundaries

```text
product behavior
→ Ready specs/<id>/spec.md or an explicit user request

feature technical design
→ specs/<id>/design.md for package-driven work
→ bounded local Plan for directly authorized work

work breakdown
→ specs/<id>/tasks.md for package-driven work
→ bounded local Plan for directly authorized work

post-implementation evidence
→ specs/<id>/validation.md for package-driven work
→ proportional verification evidence for directly authorized work

durable domain knowledge
→ accepted docs/domain documents

project-wide architecture
→ accepted docs/architecture documents and ADRs

formal external representation
→ contracts/, when applicable
```

Discovery, methodology, templates, Draft/Open documents, code and examples are
not silent requirement sources. Neither execution path may infer missing product
requirements or silently resolve a material Draft/Open domain or architecture
decision.

## Canonical package-driven flow

```text
Product intent
      ↓
Specify
      ↓
spec.md — Draft
      ↓
refinement / human decisions
      ↓
Design
      ↓
design.md
      ↓
contract/API design, when applicable
      ↓
tasks.md
      ↓
consistency review
      ↓
human approval
      ↓
spec.md — Ready
      ↓
Execute
      ↓
TASK-001
Research → local Plan → Implement → Verify
      ↓
TASK-002...
      ↓
independent verifier/reviewer
      ↓
validation.md
      ↓
PASS | FAIL
```

`Ready` and mandatory human approval are local Job Manager Harness policies for
package-driven work. Ready authorizes execution within that workflow. An explicit
user request may authorize work without a package. Validation occurs afterward;
PASS does not redefine the spec, and FAIL starts correction plus re-verification.

## Specify

Specify turns product intent into explicit behavior. `spec.md` owns the problem,
goals, scope, requirements, acceptance criteria, edge cases, applicable domain
rules, affected boundaries, failures, security, persistence, contract impact,
traceability and success criteria.

Material product decisions must be made by humans. Agents may research
discoverable repository facts. Material ambiguity keeps the package Draft.

Acceptance criteria must be observable and testable. EARS is a recommended way
to express criteria when useful, not a universal or mandatory SDD syntax.

## Design

Design translates requirements into the technical approach for the whole
feature. `design.md` is mandatory for every Ready package in this experiment so
packages remain uniform, auditable and comparable across runs.

Scope (`Small | Medium | Large | Complex`) changes expected depth only. A Small
design may be concise; a Complex design may need more research, interactions,
risks and tasks. There are no fixed thresholds for files, tasks, tokens, models,
effort or time.

Design maps requirements/ACs to components, interfaces, data, contracts,
persistence, errors, security and verification. It cannot create requirements or
silently decide cross-cutting architecture. Material Open Decisions must be
resolved before Ready or before directly authorized dependent implementation.

## Contract/API design

Formal contract work may happen during Draft/Design. In package-driven work, the
spec owns externally observable requirements and the design owns the feature's
contract strategy. In directly authorized work, the explicit request owns the
observable requirements and the bounded local Plan maps their contract strategy.
`contracts/openapi.yaml` is the shared formal representation when applicable in
either path.

A Draft contract does not authorize implementation by itself. Package-driven
work requires the applicable contract to be sufficiently defined and consistent
before Ready. Directly requested work may define the contract without a spec,
but must not promote a historical/provisional OpenAPI or invent behavior absent
from the user's request or another accepted source. It may create
`contracts/openapi.yaml` only after `ARCH-OPEN-008` is accepted. OpenAPI linting,
compatibility checking, publication, generation or stub tooling additionally
requires accepted `ARCH-OPEN-004`.

## Tasks

`tasks.md` decomposes design into granular, auditable units with requirements,
ACs, prior dependencies, binary `Done when`, concrete tests and deterministic
repository commands in `Verify`.

Every AC must have task coverage, but many-to-many mapping is valid. Tasks cannot
expand the spec/design or invent tooling.

## Consistency review and Ready

Before Ready, review:

- metadata, scope and package structure;
- requirement/AC mapping through design and tasks;
- contradictions and material open questions/decisions;
- domain and architecture authority/status;
- security and migration sufficiency;
- applicable HTTP contract sufficiency;
- task dependencies and real verification commands.

Draft/Open external material may inform refinement but cannot be normative for a
Ready spec. Legitimate feature-local behavior belongs in the spec; project-wide
decisions belong in their durable owner. Human approval then authorizes the
physical transition to Ready.

## Execute with RPI

Each `TASK-xxx` follows:

```text
Research → local Plan → Implement → Verify
```

Directly authorized work follows the same sequence without requiring a persisted
`TASK-xxx` artifact.

For package-driven work, Research reads the Ready package. Otherwise it reads
the explicit user request. Both paths also consume the applicable contract,
relevant accepted domain/architecture documents and the minimum necessary
skills/references.

The local Plan is temporary and is not a persisted requirement source. In
package-driven work, it is operational only: it may define files, order,
commands and checks but cannot redefine requirements, ACs, design, contract
impact, task scope or dependencies.

In directly authorized work, the local Plan may also define feature-local
technical design, contract mapping and work breakdown required to realize the
explicit request. It cannot add observable product behavior, resolve a material
Draft/Open decision, adopt cross-cutting architecture, contradict an accepted
contract or introduce an unauthorized dependency. A required cross-cutting
choice stops execution until it is accepted in the durable architecture owner.

If a material change is discovered:

```text
STOP → Draft/refinement → correct artifacts → consistency review
→ human approval → Ready → resume
```

That transition applies to package-driven work. In directly authorized work,
stop and obtain the missing human product decision or acceptance of the durable
domain/architecture decision before resuming; creating a package is optional.

## Independent Validate

After package-driven execution, a verifier/reviewer independent from the author
records in `validation.md`:

- task completion;
- evidence for every AC;
- commands/gates actually executed;
- findings and deviations;
- correction/reverification iterations;
- final verdict PASS or FAIL.

Missing evidence is a gap. The verifier cannot invent evidence or requirements.
Outside the package workflow, proportional review and verification still apply,
but `validation.md` is optional.
Detailed runner state/telemetry is deferred to a future `harness-runner` spec.

## Architecture methods

Event Storming and DDD produce discovery/model candidates; candidates do not
become accepted rules automatically. ADD and quality scenarios help surface
architectural drivers without moving product behavior into architecture. C4
communicates boundaries and relationships rather than duplicating feature flows.
ADRs record accepted significant choices only; do not create empty ceremony.

## Academic rationale

The workflow separates intent, behavior, technical design, work decomposition,
execution and independent evidence. Mandatory design for Ready reduces package
variation and improves auditability and comparability of experiment telemetry,
while proportional depth avoids artificial complexity for small changes.
