# Operability Architecture

**Status:** Draft

## Purpose

This document defines current runtime configuration and operational boundaries,
and explicitly identifies delivery/observability decisions that have not yet
been adopted.

## Runtime configuration

Environment-specific values remain externalized from application source.

The backend currently receives database configuration from:

```text
DB_URL
DB_USERNAME
DB_PASSWORD
```

Do not hardcode environment credentials into source, specifications,
architecture documentation, agent configuration, or reusable references.

## Environment separation

Development, test, and production environments may differ in runtime values,
but they should not silently use different architectural behavior.

Environment-specific behavior should be explicit and supported by real project
requirements.

Do not use profiles or environment flags as hidden feature toggles without a
clear ownership model.

## Observability status

The backend skill contains reusable guidance for logging, metrics, tracing,
health checks, and Actuator exposure, but the current application baseline does
not establish a complete observability stack.

Therefore the architecture does not currently require:

- Spring Boot Actuator;
- a metrics backend;
- distributed tracing;
- a centralized log provider;
- specific health endpoint exposure.

When operational requirements make these capabilities necessary, choose the
minimum architecture needed and update this document.

## Logging baseline

Even before a full observability stack exists:

- logs must not expose passwords, tokens, authorization headers, or sensitive
  payloads;
- operational messages should be meaningful and avoid unnecessary noise;
- logging should not become part of business behavior.

Detailed logging practices belong in observability/security references.

## Delivery status

Production delivery architecture is intentionally undecided.

The project does not yet establish in architecture:

- container strategy;
- CI/CD provider;
- frontend hosting provider;
- backend hosting provider;
- database hosting provider;
- deployment topology;
- release strategy;
- rollback strategy.

Do not infer these decisions from historical plans, external examples, or skill
references.

## Build boundaries

Frontend and backend retain independent build tooling inside the monorepo.

```text
backend
→ Maven Wrapper

frontend
→ npm + Vite/TypeScript
```

Repository-level orchestration may be introduced later if it solves a concrete
workflow need.

## Network access and external integrations

External providers, MCP servers, plugins, and hosted services are capabilities,
not architecture by default.

Adding a runtime provider or external system to Job Manager requires explicit
project need and appropriate configuration/security boundaries.

## Operational migrations

Database migrations are part of application delivery when persistence changes.
They remain governed by the persistence architecture and must not be replaced by
manual production-only schema edits.

## Open decisions

Delivery topology, CI/CD, observability and recovery choices are centralized in
[Open Architecture Decisions](open-decisions.md). They must not be selected
silently by a feature.

## Related implementation references

Backend observability guidance:

- `../../.agents/skills/backend-development/references/observability/`

Spring configuration guidance:

- `../../.agents/skills/backend-development/references/spring/configuration.md`
- `../../.agents/skills/backend-development/references/spring/profiles.md`

Security-sensitive logging and secrets guidance:

- `../../.agents/skills/backend-development/references/security/`
