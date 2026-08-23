# Open Architecture Decisions

This file records unresolved project-wide architecture questions. Every entry
is non-normative while `Status: Open`. A feature must not answer one silently.

## ARCH-OPEN-001 — Authentication mechanism

**Status:** Open

Question: JWT, server-side session, OAuth/OIDC or another mechanism?

Boundaries: backend, frontend, contracts, security and operations.

## ARCH-OPEN-002 — Authorization model

**Status:** Open

Question: Which roles/capabilities and ownership rules are project-wide?

Boundaries: backend, frontend, contracts and security.

## ARCH-OPEN-003 — Frontend routing and state tooling

**Status:** Open

Question: Which routing, server-state, global-state and form libraries are
accepted project dependencies?

Boundaries: frontend architecture, testing and bundle/runtime behavior.

## ARCH-OPEN-004 — OpenAPI tooling

**Status:** Open

Question: Which linting, compatibility checking, documentation publication,
client generation or server-stub strategy should be adopted?

Boundaries: contracts, backend, frontend, CI and developer workflow.

## ARCH-OPEN-005 — Delivery and infrastructure

**Status:** Open

Question: Which hosting topology, CI/CD architecture and runtime infrastructure
will be adopted?

Boundaries: operability, security and deployment.

## ARCH-OPEN-006 — Observability stack

**Status:** Open

Question: Which logging, metrics and tracing stack will be adopted?

Boundaries: backend, frontend, operability and infrastructure.

## ARCH-OPEN-007 — Modular Monolith acceptance

**Status:** Open

Question: Will Modular Monolith be accepted as the durable backend architecture?

Boundaries: architecture drivers, C4, backend and repository structure.

## ARCH-OPEN-008 — Contract-First/OpenAPI acceptance

**Status:** Open

Question: Will Contract-First/OpenAPI be accepted as durable project-wide
architecture rather than used only when a Ready spec requires a formal HTTP
contract?

Boundaries: contracts, backend, frontend and methodology.
