# Job Manager — Project Operating Contract

## Purpose and precedence

This repository contains the Job Manager backend and frontend. System and user
instructions take precedence over this file.

Sources of truth are separated by responsibility:

- an explicit user request may directly authorize work and define requested
  behavior outside the specification workflow;
- a valid `Ready` package in `specs/<spec-id>/` defines feature behavior;
- `specs/README.md` defines the package contract and lifecycle;
- accepted documents under `docs/domain/` own durable domain knowledge;
- accepted documents under `docs/architecture/` own project-wide architecture;
- `contracts/` owns formal shared external contracts when applicable;
- `.claude/skills/` contains reusable workflows and technical guidance;
- `.claude/agents/` defines the specialized `reviewer` and `verifier` roles;
- `.claude/settings.json` contains concrete tool-permission configuration;
- `apps/` contains implementation and is not a requirement source.

Repository location does not grant authority outside those responsibilities.
Draft/Open documents, code, tests, examples, templates and research are context,
not silent sources of product requirements for either execution path.

## Specification workflow

The canonical feature package is:

```text
specs/<spec-id>/
├── spec.md
├── design.md
├── tasks.md
└── validation.md  # created after implementation
```

`spec.md` owns the package lifecycle. `Ready` is a local Job Manager Harness
policy and requires valid, mutually consistent `spec.md`, `design.md` and
`tasks.md`. `validation.md` is not part of the Ready Gate.

An applicable, valid `Ready` package is the preferred authority for changes to
application code, application tests, external contracts or database migrations.
When no applicable `Ready` package exists, an explicit user request may
authorize the change directly. In that case, use the request and accepted
domain/architecture documents as authority. State operational assumptions, but
never silently infer missing product requirements. Ask the user to resolve any
material product ambiguity before implementing the affected behavior.

`Draft`, `Superseded`, templates and examples are context rather than authority,
but their presence or the absence of a package does not by itself block work
explicitly requested by the user.

A material domain or architecture decision recorded as `Draft` or `Open` remains
blocking in both paths whenever the requested implementation depends on it. An
explicit implementation request does not silently accept or resolve that
decision; obtain human resolution and record it in the appropriate durable owner
before continuing the dependent work.

Human approval is required before changing `spec.md` from `Draft` to `Ready`.
Material product ambiguity blocks `Ready`; discoverable repository facts may be
researched, but agents must not invent product decisions.

Specification refinement follows the detailed package contract in
`specs/README.md`. Application work outside that workflow remains allowed when
directly authorized as described above.

## Required execution workflow

When using the specification workflow, preparation is:

```text
Specify → Design → Tasks → consistency review → human approval → Ready
```

Task execution uses proportional RPI:

```text
TASK-xxx → Research → local Plan → Implement → Verify
```

Directly authorized work uses the same proportional execution discipline without
requiring a persisted `TASK-xxx` artifact:

```text
Research → local Plan → Implement → Verify
```

Research consumes the applicable Ready spec, design and tasks when they exist;
otherwise it consumes the explicit user request. It also reads the applicable
contract, accepted domain/architecture documents and only the skills/references
needed for the task.

For package-driven work, the local Plan is operational: it may choose files,
order, commands and checks, but cannot redefine requirements, acceptance
criteria, design, contract impact, task scope or dependencies. For directly
authorized work, the local Plan may additionally define feature-local technical
design, contract mapping and work breakdown needed to realize the explicit
request. It still cannot add observable product behavior, resolve a material
Draft/Open decision, adopt cross-cutting architecture, contradict an accepted
contract or introduce an unauthorized dependency. If a required choice is
cross-cutting rather than feature-local, stop and resolve it in the durable
architecture owner before implementation.

If execution governed by a Ready package reveals a material change, stop, return
the package to Draft, correct the artifacts, repeat consistency review and human
approval, and only resume package-driven execution after it is Ready again.
Work authorized directly by the user instead resolves material ambiguity with
the user without requiring creation of a specification package.

## Independent validation

After package-driven implementation, an independent verifier/reviewer creates or
updates `validation.md`. Outside the package workflow, proportionate review and
verification still apply, but creating `validation.md` is not required. The local
process principle is `author != verifier` when independent validation applies.

Validation records task completion, acceptance-criteria evidence, commands and
gates actually executed, findings, deviations, fix/reverification iterations
and final verdict `PASS` or `FAIL`. Missing evidence is a gap, not a pass. A
failure requires correction and new verification; validation never creates new
requirements or silently rewrites spec/design/tasks.

## Repository boundaries

- `apps/backend/`: Java/Spring backend, HTTP, validation, security, persistence,
  migrations and backend tests.
- `apps/frontend/`: React/TypeScript UI, routing, client state, accessibility and
  frontend tests.
- `contracts/`: formal shared/versioned external contracts.
- `specs/`: feature packages and reserved `_templates/` scaffolding.
- `docs/`: durable product, domain, architecture and methodology documentation.
- `.claude/skills/`: reusable workflows/references, not project requirements.
- `.claude/agents/`: specialized reviewer/verifier role definitions.
- `.claude/settings.json`: concrete harness permissions, without credentials or
  personal paths.

Keep transport, application/domain, persistence and infrastructure concerns at
their documented boundaries. Do not add speculative behavior, dependencies,
abstractions, infrastructure or adjacent improvements.

## Architecture and contract gates

Feature work must remain within accepted architecture. A feature spec may
constrain implementation but cannot institutionalize a cross-cutting decision.
When a material architecture choice is missing or conflicts with accepted
architecture, stop and resolve it in the correct owner; add an ADR when durable
decision history is warranted.

For package-driven HTTP changes:

- `spec.md` owns externally observable requirements;
- `design.md` owns the feature's technical/contract design;
- `contracts/openapi.yaml` is the shared formal representation when applicable;
- `tasks.md` implements the already-defined contract.

For directly authorized HTTP changes, the explicit user request owns observable
requirements. The local Plan may map them to feature-local implementation and
contract details within accepted architecture without becoming a persisted
requirement or cross-cutting architecture source.
Keep `contracts/openapi.yaml` synchronized when applicable.

Contracts may be designed during Draft, but their presence alone is not product
authority. Package-driven implementation requires applicable contracts to be
sufficiently defined and consistent before Ready. Directly authorized work may
define and implement the contract together when the user's request supplies the
necessary behavior, but only after any applicable material architecture decision
has been accepted. Treat API/database changes as compatibility-sensitive and
keep contracts and migrations synchronized.

Creating `contracts/openapi.yaml` requires accepted `ARCH-OPEN-008`. Adopting
OpenAPI linting, compatibility checking, publication, generation or stub tooling
also requires accepted `ARCH-OPEN-004`.

## Skills and references

Select the smallest relevant skill set. References explain techniques; they do
not authorize technologies, dependencies, requirements or architecture. When a
reference conflicts with a Ready spec or accepted architecture, follow the
higher-authority source and report the conflict.

## Validation commands

Use existing commands; do not invent replacements:

- backend: `apps/backend/mvnw.cmd test`;
- frontend build/typecheck: `npm run build` from `apps/frontend`;
- frontend lint: `npm run lint` from `apps/frontend`.

Run only commands relevant to changed boundaries. Report exact missing
prerequisites. Never weaken assertions, suppress errors, add retries, bypass
security controls or alter validation configuration merely to obtain a pass.

## Security and external tools

Never commit secrets, credentials, tokens, keys, real personal data or personal
OAuth state. Do not log sensitive values or weaken authentication,
authorization, CORS/CSRF, validation, secret handling or data protection without
explicit authority. Verify exact scope before migrations or destructive actions.

External tools are capabilities, not sources of requirements. Prefer
repository-local authority and read-only access; do not perform destructive or
production-impacting external actions without explicit authorization.

## Completion criteria

A change is complete only when:

- it was authorized by either an applicable Ready package or an explicit user
  request;
- every applicable task and acceptance criterion has concrete evidence;
- architecture, domain authority, contracts and migrations remain consistent;
- relevant validation passes or unavailable prerequisites are reported exactly;
- no gate or security control was weakened;
- no unrelated/speculative change was introduced;
- independent validation records `PASS` when the Ready package workflow applies;
  and
- the final diff was reviewed against scope and authority.
