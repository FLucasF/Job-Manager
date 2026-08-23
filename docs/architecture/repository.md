# Repository Architecture

**Status:** Draft

## Top-level ownership

```text
job-manager/
├── .agents/       reusable workflows/references
├── .codex/        concrete Codex configuration
├── apps/          frontend/backend implementation
├── contracts/     formal shared external contracts
├── docs/          durable project documentation
├── evals/         harness/agent evaluations
├── specs/         feature packages and templates
├── scripts/       repository harness checks
└── AGENTS.md      concise routing and gates
```

Colocation does not merge authority.

## Specification layout

```text
specs/
├── README.md
├── _templates/    reserved scaffolding; not a package
└── <spec-id>/
    ├── spec.md
    ├── design.md
    ├── tasks.md
    └── validation.md  # after implementation
```

The package contract lives only in `specs/README.md`; this architecture document
records physical ownership without repeating validation details.

## Cross-boundary rules

- frontend never accesses backend persistence directly;
- backend never depends on frontend implementation;
- specs do not mirror current code as requirements;
- technical references do not override project architecture;
- contracts are not inferred from persistence or UI models;
- harness changes are explicit, not incidental feature side effects;
- new top-level directories require a durable unowned responsibility.

## Application placement guidance

- [backend project structure](../../.agents/skills/backend-development/references/architecture/project-structure.md)
- [frontend project structure](../../.agents/skills/frontend-development/references/architecture/project-structure.md)
