# Job Manager - Project Operating Contract

## Purpose

This repository contains the Job Manager application, split into a Spring Boot
backend and a React + TypeScript frontend. Treat this file as the project-level
operating contract for Codex and contributors.

## Source of truth and change policy

- System and user instructions take precedence over this file.
- A valid, versioned document in `specs/` is the source of truth for product
  behavior, acceptance criteria, scope, API contracts, persistence effects,
  and security rules.
- Do not implement, modify, or refactor application code or tests when no
  applicable spec exists. Stop and report the missing spec instead.
- Do not infer requirements from the current skeleton, a README, or a similar
  feature. Existing code is integration context only.
- If a spec omits a decision that changes behavior, list the missing decision
  and affected boundaries, then wait for clarification.
- Documentary analysis, repository inspection, and test diagnosis may proceed
  without a spec, provided they do not modify tracked application behavior.
- Keep changes narrowly scoped to the requested capability. Do not add
  speculative endpoints, fields, states, dependencies, or abstractions.

## Repository boundaries

- `apps/backend/`: Java 21 and Spring Boot backend. Backend changes belong
  here, including JPA, Flyway, validation, HTTP contracts, security, and
  backend unit/integration tests.
- `apps/frontend/`: React + TypeScript frontend. Frontend changes belong here,
  including UI, routing, client-side state, accessibility, and frontend
  unit/integration tests.
- `contracts/`: shared or explicitly versioned API contracts. Update this
  boundary when a spec changes an externally observable contract.
- `specs/`: versioned product and technical requirements. A feature spec must
  be present before implementation begins.
- `.agents/skills/`: reusable domain workflows and references. Load only the
  skill(s) and references relevant to the current task; do not read every
  reference by default.
- `.codex/`: repository-local Codex configuration. Keep it portable and free
  of personal machine paths, credentials, and model preferences.

## Required workflow

1. Identify the requested capability and locate its applicable spec in
   `specs/`.
2. Read the complete spec before editing code, tests, contracts, or database
   migrations.
3. Extract scope, acceptance criteria, business rules, states, failures,
   security constraints, persistence effects, and affected applications.
4. Inspect only the implementation and tests relevant to those boundaries.
5. Load the smallest relevant set of skill references.
6. Implement only the specified behavior and preserve compatible behavior that
   does not conflict with the spec.
7. Add or update tests for each applicable acceptance criterion.
8. Run the relevant validation commands and review the final diff against the
   spec before reporting completion.

## Architecture and dependency rules

- Keep transport, application/domain behavior, persistence, and infrastructure
  responsibilities at their intended boundaries.
- Keep frontend feature code isolated from transport details through the
  existing project conventions; do not introduce a state library or router
  without a spec or explicit task requirement.
- Prefer existing dependencies and project tooling. Do not install a package
  merely because a reference mentions it.
- Treat API and database changes as compatibility-sensitive changes. Update
  the relevant contract and migration together when the spec requires both.

## Validation commands

Use commands that already exist in the affected application:

- Backend build/tests: `apps/backend/mvnw.cmd test`
- Frontend typecheck/build: `npm run build` from `apps/frontend`
- Frontend lint: `npm run lint` from `apps/frontend`

If a required command, service, database, browser, or environment variable is
not available, report the exact prerequisite and do not invent a replacement.

## Testing policy

- Backend unit and integration tests belong to the backend workflow.
- Frontend unit and integration tests belong to the frontend workflow.
- Complete browser journeys belong to the quality-assurance workflow and must
  be justified by acceptance criteria in a spec.
- Test observable behavior and outcomes, not implementation details.
- Do not weaken assertions, increase retries, or hide failures to make a test
  pass.
- Preserve traces, screenshots, and reports when diagnosing E2E failures.

## Security and data handling

- Never commit secrets, credentials, tokens, private keys, or real personal
  data.
- Do not log passwords, tokens, authorization headers, or sensitive payloads.
- Do not weaken authentication, authorization, CORS/CSRF, validation, or
  secret handling without an explicit spec and security rationale.
- Treat migrations and destructive data operations as contract-impacting
  changes; verify their exact scope before applying them.

## Completion criteria

A change is complete only when:

- the applicable spec and acceptance criteria are satisfied;
- relevant tests and validations pass, or unavailable prerequisites are
  explicitly documented;
- no unrelated tracked files are changed;
- the final response summarizes behavior, validation performed, and any
  remaining limitation or follow-up.
