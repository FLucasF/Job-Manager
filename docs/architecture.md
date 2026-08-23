# Job Manager Architecture

**Status:** Draft

This is the architecture router. The current baseline remains Draft until its
material project-wide decisions are explicitly accepted. A Ready specification
cannot use Draft/Open architecture content as normative authority.

## Responsibility and precedence

- `specs/<id>/spec.md` owns feature behavior;
- `specs/<id>/design.md` owns feature technical design within accepted
  architecture;
- `docs/architecture/` owns durable project-wide architectural constraints;
- `docs/domain/` owns durable domain knowledge according to document status;
- `contracts/` owns formal shared external representations when applicable;
- `.agents/skills/**/references/` provides reusable guidance only;
- `apps/**` is implementation context, not a requirement source.

## System boundary

```text
User → React/TypeScript frontend → HTTP → Java/Spring backend → PostgreSQL
```

The frontend never accesses persistence directly. Backend domain/application
behavior remains isolated from transport and infrastructure details when those
concerns have different reasons to change.

## Routing

- [Architecture Drivers](architecture/architecture-drivers.md)
- [C4 Model](architecture/c4-model.md)
- [Repository](architecture/repository.md)
- [Backend](architecture/backend.md)
- [Frontend](architecture/frontend.md)
- [Persistence](architecture/persistence.md)
- [Contracts](architecture/contracts.md)
- [Security](architecture/security.md)
- [Testing](architecture/testing.md)
- [Operability](architecture/operability.md)
- [Open Architecture Decisions](architecture/open-decisions.md)

Domain routing starts at [Domain Documentation](domain/README.md). Methodology is
documented in [Development Methodology](methodology/development-methodology.md).

## Stop conditions

Stop before implementation when work:

- depends normatively on a Draft/Open architecture decision;
- requires an unrecorded project-wide technology or structural choice;
- conflicts with an accepted boundary;
- would let a feature design silently institutionalize cross-cutting policy.

Resolve the decision in its architectural owner and create an ADR when durable
decision history is warranted. Resolving one decision does not promote an
entire Draft document.
