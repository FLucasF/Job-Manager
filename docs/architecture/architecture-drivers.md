# Architecture Drivers — Job Manager

**Status:** Draft

This document records candidate project-wide drivers, constraints, quality
attributes, risks and tactics. It does not own feature behavior. A Ready spec
cannot cite this Draft baseline as normative authority.

## Business goals

- evolve the existing frontend into a maintainable full-stack application;
- keep backend domain/application behavior explicit and testable;
- reduce accidental coupling between browser, HTTP, persistence and framework;
- support auditable specification-driven delivery;
- avoid agents inventing product or cross-cutting architecture decisions.

## Constraints

- monorepo with separate `apps/frontend` and `apps/backend` boundaries;
- browser frontend communicates with backend through HTTP;
- persistence is relational and schema evolution is versioned;
- application changes require either a Ready feature package or an explicit user
  request;
- existing dependencies/tooling are preferred until an explicit decision
  authorizes change.

Exact technology versions remain owned by application manifests.

## Quality attributes

### Security

Protect private resources, enforce authorization server-side, minimize sensitive
data exposure and keep secrets out of source/logs. Authentication and final role
model remain open architecture decisions.

### Correctness and integrity

Represent durable invariants at the responsible boundary and use database
constraints when persistence correctness requires them. Candidate domain rules
remain Draft until accepted.

### Maintainability

Organize code by business capability, keep dependency direction explicit and
avoid mapping/layers without concrete responsibility.

### Testability

Test observable outcomes at the smallest effective level; use integration tests
when confidence depends on framework, HTTP, persistence, security or browser
collaboration.

### Contract compatibility

Treat externally observable API changes as compatibility-sensitive and keep the
formal contract synchronized when one is applicable.

### Usability and accessibility

Provide observable loading, empty, error, pending and recovery states, and use
semantic/keyboard-accessible interfaces.

### Performance

Measure before optimizing. Bound potentially growing data access when product
requirements establish pagination/search semantics.

### Operability and recoverability

Keep runtime configuration externalized, migrations versioned and failures
diagnosable without leaking sensitive data. Deployment and observability stacks
remain open.

## Candidate architectural tactics

- feature-first organization inside each application;
- explicit web/application/domain/infrastructure responsibilities when needed;
- DTO/contract separation from persistence models;
- versioned migrations and schema validation;
- centralized HTTP error translation;
- test-level selection based on affected boundary;
- progressive disclosure of technical references.

These tactics remain part of a Draft baseline until accepted in the appropriate
architecture owner/ADR.

## Risks

- visual frontend becoming coupled directly to raw HTTP details;
- backend becoming an anemic global CRUD hierarchy;
- domain rules duplicated inconsistently across boundaries;
- formal contract drifting from implemented behavior;
- Draft/Open choices being silently treated as accepted;
- overengineering before requirements justify structure;
- legacy documentation paths continuing to compete with `docs/`.

## Open decisions

All unresolved project-wide choices are centralized in
[Open Architecture Decisions](open-decisions.md). A dependent implementation is
blocked until its material Open decision is accepted, whether authority comes
from a Ready package or an explicit user request.
