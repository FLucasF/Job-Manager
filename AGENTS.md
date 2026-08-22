# Job Manager - Project Operating Contract

## Purpose

This repository contains the Job Manager application, split into a backend and
a frontend application.

Treat this file as the project-level operating contract for Codex and
contributors.

This file governs how work is performed in the repository. Product behavior,
architectural decisions, and reusable implementation guidance are governed by
their respective sources of truth defined below.

## Source of truth and change policy

* System and user instructions take precedence over this file.
* This `AGENTS.md` defines the operating rules for Codex within this repository.
* Valid, versioned documents in `specs/` are the source of truth for feature
  and system behavior, acceptance criteria, scope, business rules, states,
  failures, externally observable contract changes, persistence effects, and
  security requirements.
* `docs/architecture.md` is the source of truth for the currently accepted
  project architecture, including technology choices, architectural
  boundaries, persistence strategy, infrastructure decisions, and
  cross-cutting technical constraints.
* Accepted ADRs in `docs/adr/` record architecture-significant decisions,
  their rationale, considered alternatives, and consequences.
* ADRs explain why an architectural decision exists. The current effective
  architecture must remain represented in `docs/architecture.md`.
* A feature spec may impose technical constraints within the accepted
  architecture, but it must not silently redefine a project-wide
  architectural decision.
* When satisfying a spec requires changing an existing architectural decision,
  treat that as an explicit architecture change. Update the relevant
  architecture documentation and ADR before or together with the
  implementation.
* Do not introduce an architecture-significant technology, dependency,
  provider, or pattern solely because it appears convenient for implementing a
  feature.
* Do not implement, modify, or refactor application code or tests when no
  applicable spec exists. Stop and report the missing spec instead.
* Do not infer product requirements from the current skeleton, a README,
  existing implementation, or a similar feature. Existing code is integration
  context only.
* If a spec omits a decision that changes observable behavior, list the
  missing decision and affected boundaries, then wait for clarification.
* If implementation requires an unresolved architecture-significant decision,
  stop and report the missing architecture decision instead of selecting a
  technology or pattern implicitly.
* Documentary analysis, repository inspection, test diagnosis, architecture
  analysis, and harness maintenance may proceed without a feature spec when
  they do not modify tracked application behavior.
* Keep changes narrowly scoped to the requested capability. Do not add
  speculative endpoints, fields, states, dependencies, abstractions, or
  infrastructure.

## Repository boundaries

* `apps/backend/`: backend application. Backend implementation, persistence,
  database migrations, validation, HTTP interfaces, security, and backend
  unit/integration tests belong here.
* `apps/frontend/`: frontend application. UI, routing, client-side state,
  accessibility, and frontend unit/integration tests belong here.
* `contracts/`: shared or explicitly versioned external API contracts. Update
  this boundary when a spec changes an externally observable contract.
* `specs/`: versioned feature and system specifications. An applicable feature
  spec must be present before application implementation begins.
* `docs/architecture.md`: current accepted project architecture and
  project-wide technical decisions.
* `docs/adr/`: architecture decision records for architecture-significant
  choices and their rationale.
* `.agents/skills/`: reusable domain workflows and references. Load only the
  skill(s) and references relevant to the current task; do not read every
  reference by default.
* `.codex/`: repository-local Codex configuration. Keep it portable and free
  of personal machine paths and credentials. Model and runtime assignments are
  versioned project-harness decisions and must be explicitly configured.

Repository location does not make a document authoritative outside its
responsibility. Follow the source-of-truth rules above when documents overlap.

## Codex model policy

* Model selection and reasoning effort are part of the versioned project
  harness. The main model, main reasoning effort, and built-in/default
  subagent assignments must be explicit.
* Every custom agent must explicitly declare `model` and
  `model_reasoning_effort`; future choices must be justified by the role's
  responsibility rather than relying on implicit inheritance.
* Built-in agents without role-specific configuration use the defaults in
  `[agents]`.
* Model assignments must not change as a side effect of product work. They are
  harness changes and should preferably be supported by eval evidence.
* Select capacity and reasoning proportional to the role. Do not automatically
  choose either the most powerful or the cheapest model.
* Report unavailable models instead of applying a silent fallback.

| Role                      | Model           | Reasoning effort                     |
| ------------------------- | --------------- | ------------------------------------ |
| Main                      | `gpt-5.6-sol`   | `medium`                             |
| Default/built-in subagent | `gpt-5.6-terra` | `medium`                             |
| Reviewer                  | `gpt-5.6-terra` | `high`                               |
| Verifier                  | `gpt-5.6-luna`  | `low`                                |
| Native `/review`          | `gpt-5.6-terra` | Inherited; not separately configured |

For comparable future evaluations, keep the commit, prompt, harness, model,
and reasoning effort fixed whenever possible.

## Codex runtime policy

* The main runtime uses `workspace-write`, approvals are `on-request`, and
  workspace command network access is disabled by default.
* Ordinary tasks must not change sandbox, approval, or network settings. Such
  changes are explicit harness changes.
* Custom agents may be more restrictive. The reviewer remains `read-only`; the
  verifier inherits the runtime sandbox because build and test tools may need
  to create normal artifacts.
* Do not use overrides to bypass the harness policy without an explicit
  request.

## Required workflow

1. Identify the requested capability and locate its applicable spec in
   `specs/`.
2. Read the complete applicable spec before editing application code, tests,
   external contracts, or database migrations.
3. Extract the spec's scope, acceptance criteria, business rules, states,
   failures, security requirements, persistence effects, externally observable
   contract changes, and affected applications.
4. Identify the implementation boundaries affected by the requested behavior.
5. Determine whether the change operates within the accepted architecture or
   requires an architecture-significant decision.
6. Read only the sections of `docs/architecture.md` and accepted ADRs relevant
   to the affected boundaries.
7. If a required architectural decision is missing or the spec conflicts with
   the accepted architecture, stop and report the conflict or missing decision
   instead of resolving it implicitly.
8. Inspect only the existing implementation and tests relevant to the affected
   boundaries.
9. Select the smallest relevant set of skills from `.agents/skills/`.
10. Load only the references needed for the task. References provide reusable
    implementation guidance and must not override the spec or accepted project
    architecture.
11. Implement only the specified behavior within the accepted architecture.
12. Preserve existing compatible behavior that does not conflict with the
    applicable spec.
13. Update `contracts/` when the spec changes an externally observable API
    contract.
14. Add or update tests for every applicable acceptance criterion and relevant
    failure path.
15. Run the validation commands applicable to every affected application.
16. Review the final diff against the applicable spec, accepted architecture,
    relevant ADRs, contracts, and requested scope before reporting completion.

## Architecture and dependency rules

* Keep transport, application/domain behavior, persistence, and infrastructure
  responsibilities at their intended architectural boundaries.
* Implement feature behavior within the architecture and technology choices
  defined by `docs/architecture.md` and accepted ADRs.
* Do not derive project-wide architectural decisions from a feature spec unless
  that spec explicitly requires an architecture change and the corresponding
  architecture decision is recorded.
* Do not introduce, replace, or remove architecture-significant technologies
  merely because a feature requires a capability.
* Changes involving persistence technology, migration tooling, routing
  strategy, state-management libraries, authentication mechanisms, messaging
  systems, infrastructure providers, deployment strategy, or similarly
  cross-cutting dependencies require an explicit architecture decision when
  they alter the established architecture.
* Keep frontend feature code isolated from transport details according to the
  accepted project architecture and relevant frontend references.
* Keep backend domain/application behavior isolated from infrastructure
  concerns according to the accepted project architecture and relevant backend
  references.
* Prefer existing dependencies and project tooling.
* Do not install a package merely because a skill or reference mentions it.
* A reference documents how to use an applicable pattern or technology; it
  does not authorize introducing that technology into the project.
* Treat API and database changes as compatibility-sensitive changes.
* Update the relevant contract and migration together when the applicable spec
  requires both.
* Do not perform destructive schema or infrastructure changes unless they are
  explicitly required, scoped, and supported by the applicable spec and
  architecture decision.

## Specification rules

* Specifications describe required outcomes and constraints, not arbitrary
  implementation preferences.
* Acceptance criteria must be observable and testable whenever reasonably
  possible.
* Business rules must be explicit rather than inferred from existing code.
* Required states, failures, validation behavior, authorization behavior, and
  persistence effects must be represented when relevant to the capability.
* Externally observable API changes must be represented explicitly in the
  applicable spec and synchronized with `contracts/`.
* Architecture-significant changes discovered during specification or
  implementation must be handled through the architecture decision process,
  not hidden inside implementation work.
* Do not expand scope because an adjacent improvement appears useful.
* When requirements are ambiguous in a way that could produce materially
  different behavior, report the ambiguity instead of selecting one
  interpretation silently.

## Skill and reference policy

* Skills define reusable workflows for classes of engineering tasks.
* References define reusable implementation guidance, patterns, conventions,
  and review criteria.
* Skills and references are not sources of truth for product requirements or
  project-specific architectural choices.
* Load only the minimum relevant skill and reference set required for the
  current task.
* Do not read every available reference by default.
* A technology-specific reference may be used only when that technology is
  already part of the accepted architecture or has been explicitly approved
  through an architecture decision.
* When a skill or reference conflicts with an applicable spec or accepted
  project architecture, report the conflict and follow the higher-authority
  project source of truth.
* Do not introduce dependencies, frameworks, patterns, or infrastructure
  merely because they are demonstrated by a reference.

## Validation commands

Use commands that already exist in the affected application:

* Backend build/tests: `apps/backend/mvnw.cmd test`
* Frontend typecheck/build: `npm run build` from `apps/frontend`
* Frontend lint: `npm run lint` from `apps/frontend`

Run every validation applicable to the files and behavior changed.

If a required command, service, database, browser, environment variable, or
other prerequisite is not available, report the exact prerequisite and do not
invent a replacement or silently skip the validation.

Do not modify validation configuration solely to make a failing change pass
unless the applicable spec or an explicit harness change requires that
configuration change.

## Testing policy

* Backend unit and integration tests belong to the backend workflow.
* Frontend unit and integration tests belong to the frontend workflow.
* Complete browser journeys belong to the quality-assurance workflow and must
  be justified by acceptance criteria in a spec.
* Every applicable acceptance criterion should have verification at the
  smallest effective testing level.
* Test observable behavior and outcomes, not implementation details.
* Include relevant failure paths, boundary conditions, validation behavior,
  and authorization behavior when required by the spec.
* Integration tests should verify important interactions with real application
  boundaries when unit tests cannot provide sufficient confidence.
* Do not weaken assertions, increase retries, suppress errors, remove
  meaningful tests, or hide failures to make a test pass.
* Preserve traces, screenshots, reports, and other diagnostic artifacts when
  diagnosing E2E failures.
* A failing existing test must be investigated before being changed. Do not
  assume the test is obsolete solely because new implementation behavior
  differs from it.

## Security and data handling

* Never commit secrets, credentials, tokens, private keys, or real personal
  data.
* Keep credentials and environment-specific secrets outside versioned harness,
  specs, skills, references, and application source.
* Do not log passwords, tokens, authorization headers, or sensitive payloads.
* Do not weaken authentication, authorization, CORS/CSRF, input validation,
  secret handling, sensitive-data protection, or other security controls
  without an explicit spec and security rationale.
* Security requirements specific to a capability belong in its applicable
  spec.
* Project-wide security architecture and cross-cutting security decisions
  belong in the architecture documentation and accepted ADRs.
* Treat migrations and destructive data operations as contract-impacting
  changes; verify their exact scope before applying them.
* Prefer least-privilege access for external systems and development tooling.
* Do not place personal OAuth state, access tokens, provider credentials, or
  machine-specific secrets in repository-local configuration.

## External tools and integrations

* External tools, plugins, MCP servers, hosted services, and provider
  integrations are capabilities available to the agent; they are not
  automatically sources of truth for project requirements or architecture.
* Prefer repository-local specifications, architecture documentation, skills,
  and references over external contextual sources when both cover the same
  project decision.
* Use external documentation when current or version-specific information is
  required and the local references do not provide sufficient guidance.
* External documentation must not silently override project rules,
  specifications, or accepted architectural decisions.
* Prefer read-only access when write access is unnecessary.
* Do not perform destructive or production-impacting external actions without
  explicit authorization and applicable project requirements.
* Credentials and connection state for external tools must not be committed to
  the repository.
* If an external integration is unavailable, report the limitation rather than
  inventing its result.

## Harness change policy

* Changes to `AGENTS.md`, `.codex/`, model assignments, runtime policy,
  agent definitions, eval configuration, skills, or harness enforcement are
  harness changes rather than ordinary product changes.
* Do not alter harness behavior as an incidental side effect of implementing a
  feature.
* Harness changes should have an explicit purpose and should remain narrowly
  scoped.
* Changes affecting model selection, reasoning effort, tool permissions,
  sandbox behavior, validation gates, or agent responsibilities should be
  justified and preferably supported by evaluation evidence.
* Keep harness configuration deterministic, versioned, portable, and free of
  personal machine state.
* Do not depend on account-specific integrations for mandatory enforcement when
  an equivalent repository-local or CI-enforced mechanism is required for
  reproducibility.

## Completion criteria

A change is complete only when:

* the applicable spec and all relevant acceptance criteria are satisfied;
* the implementation remains consistent with the applicable project
  architecture and accepted ADRs;
* any architecture-significant change has an explicit recorded decision;
* relevant API contracts are synchronized when externally observable behavior
  changes;
* required migrations are present and consistent with persistence changes;
* relevant tests and validations pass, or unavailable prerequisites are
  explicitly documented;
* no assertion, validation, security control, or quality gate was weakened only
  to make the change pass;
* no unrelated tracked files are changed;
* no speculative behavior or dependency was added outside the requested scope;
* the final diff has been reviewed against the applicable spec and
  architectural constraints;
* the final response summarizes the implemented behavior, validation
  performed, architecture or contract changes when applicable, and any
  remaining limitation or follow-up.
