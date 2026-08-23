# Job Manager — Project Operating Contract

## Purpose and precedence

This repository contains the Job Manager backend and frontend. System and user
instructions take precedence over this file.

Sources of truth are separated by responsibility:

- a valid `Ready` package in `specs/<spec-id>/` defines feature behavior;
- `specs/README.md` defines the package contract and lifecycle;
- accepted documents under `docs/domain/` own durable domain knowledge;
- accepted documents under `docs/architecture/` own project-wide architecture;
- `contracts/` owns formal shared external contracts when applicable;
- `.agents/skills/` contains reusable workflows and technical guidance;
- `.codex/` contains concrete Codex runtime/model configuration;
- `apps/` contains implementation and is not a requirement source.

Repository location does not grant authority outside those responsibilities.
Draft/Open documents, code, tests, examples, templates and research are context,
not silent sources of requirements for a `Ready` specification.

## Specification gate

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

Only an applicable, valid `Ready` package authorizes changes to application
code, application tests, external contracts or database migrations. `Draft`,
`Superseded`, templates and examples do not.

Human approval is required before changing `spec.md` from `Draft` to `Ready`.
Material product ambiguity blocks `Ready`; discoverable repository facts may be
researched, but agents must not invent product decisions.

Documentary work, architecture analysis, specification refinement and harness
maintenance may proceed while Draft when they do not implement application
behavior. Follow the detailed contract in `specs/README.md`.

## Required execution workflow

Specification preparation:

```text
Specify → Design → Tasks → consistency review → human approval → Ready
```

Task execution uses proportional RPI:

```text
TASK-xxx → Research → local Plan → Implement → Verify
```

Research consumes the Ready spec, design, tasks, applicable contract, accepted
domain/architecture documents and only the skills/references needed for the
task. The local Plan may choose files, operational order, commands and checks;
it must not redefine requirements, acceptance criteria, design, cross-cutting
architecture, contract impact, task scope or dependencies.

If execution reveals a material change, stop, return the package to Draft,
correct the artifacts, repeat consistency review and human approval, and only
resume after the package is Ready again.

## Independent validation

After implementation, an independent verifier/reviewer creates or updates
`validation.md`. The local process principle is `author != verifier`.

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
- `.agents/skills/`: reusable workflows/references, not project requirements.
- `.codex/`: concrete harness configuration, without credentials or personal
  paths.

Keep transport, application/domain, persistence and infrastructure concerns at
their documented boundaries. Do not add speculative behavior, dependencies,
abstractions, infrastructure or adjacent improvements.

## Architecture and contract gates

Feature work must remain within accepted architecture. A feature spec may
constrain implementation but cannot institutionalize a cross-cutting decision.
When a material architecture choice is missing or conflicts with accepted
architecture, stop and resolve it in the correct owner; add an ADR when durable
decision history is warranted.

For HTTP changes:

- `spec.md` owns externally observable requirements;
- `design.md` owns the feature's technical/contract design;
- `contracts/openapi.yaml` is the shared formal representation when applicable;
- `tasks.md` implements the already-defined contract.

Contracts may be designed during Draft, but their presence never authorizes
implementation. Ready requires applicable contracts to be sufficiently defined
and consistent. Treat API/database changes as compatibility-sensitive and keep
contracts and migrations synchronized.

## Skills and references

Select the smallest relevant skill set. References explain techniques; they do
not authorize technologies, dependencies, requirements or architecture. When a
reference conflicts with a Ready spec or accepted architecture, follow the
higher-authority source and report the conflict.

## Validation commands

Use existing commands; do not invent replacements:

- harness: `powershell -File scripts/check-harness.ps1`;
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

- the applicable Ready package authorized it;
- every task and acceptance criterion has concrete evidence;
- architecture, domain authority, contracts and migrations remain consistent;
- relevant validation passes or unavailable prerequisites are reported exactly;
- no gate or security control was weakened;
- no unrelated/speculative change was introduced;
- independent validation records `PASS`; and
- the final diff was reviewed against scope and authority.
