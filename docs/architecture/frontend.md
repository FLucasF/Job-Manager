# Frontend Architecture

**Status:** Draft

## Purpose

This document defines the Draft frontend structure, responsibility
boundaries, dependency direction, state ownership, data-access boundary, and
routing principles for Job Manager.

Detailed implementation guidance remains in frontend-development references.

## Technology baseline

The frontend currently uses:

- React 19;
- TypeScript 6;
- Vite 8;
- ESLint.

Exact versions are authoritative in `apps/frontend/package.json` and the
lockfile.

Libraries demonstrated by references are not automatically installed or
adopted by this architecture.

## Primary organization: feature first

Target source organization:

```text
src/
├── app/
├── features/
├── shared/
└── main.tsx
```

### `app/`

Owns application composition and global setup, such as:

- providers;
- router composition when routing is adopted;
- global configuration;
- global styles when applicable;
- application bootstrap.

Feature-specific business behavior does not move into `app/` merely because it
is used by a page.

### `features/`

Owns business capabilities.

Example shape as capabilities are specified:

```text
features/
├── auth/
├── vacancies/
├── workers/
└── applications/
```

A feature starts small and gains subdirectories only when concrete
responsibilities exist.

### `shared/`

Owns reusable code that is independent from specific business features.

The allowed dependency direction is:

```text
feature → shared
```

Never:

```text
shared → feature
```

Do not move code to `shared/` merely because future reuse seems possible.

## Internal feature responsibilities

When useful, a feature may contain:

```text
components/
hooks/
model/
repository/
pages/
types/
```

These are responsibilities, not mandatory folders.

### Components and pages

Own rendering, UI composition, interaction, and presentation of states.

Components do not own raw HTTP details or backend persistence concepts.

Pages may represent route entry boundaries when that distinction is useful.

### Hooks

Own behavior that genuinely needs the React runtime, such as React state,
lifecycle, Context integration, or query/mutation coordination.

Do not move pure logic into a hook merely to remove it from a component.

### Model

Owns pure feature rules and transformations when a dedicated pure boundary is
useful.

Model code stays independent from React, DOM, hooks, HTTP clients, and
repository implementation.

### Repository

Owns access to external data sources for the feature when the feature accesses
backend capabilities.

A typical flow is:

```text
Component
  ↓
React integration hook
  ↓
Repository
  ↓
shared HTTP client
  ↓
Backend
```

The Repository knows operations and transport shapes. It does not navigate,
show toasts, manipulate modals, or update React component state.

## Frontend dependency direction

Allowed examples:

```text
Component → Hook
Component → Model
Hook → Model
Hook → Repository
Repository → shared HTTP client
Feature → Shared
```

Avoid:

```text
Hook → Component
Model → React
Model → Repository
Repository → Hook
Repository → Component
Shared → Feature
```

Layer bypass is acceptable when responsibilities remain correct. For example,
`Component → Model` can be valid. `Component → raw HTTP client` violates the
candidate presentation/infrastructure separation documented by this Draft.

## State ownership

State lives at the smallest correct owner.

Use the responsibility model:

```text
single component
→ local state

nearby components
→ nearest common owner

subtree-wide dependency/state
→ Context/provider when justified

remote source of truth
→ server state

temporary edit draft
→ form state

navigable/shareable view state
→ URL

independent distant client-only consumers
→ consider global client state
```

Choose a state-management tool only after ownership is clear.

Do not mirror the same source of truth across URL, query cache, Context,
component state, or global stores without a distinct responsibility.

Derived values are calculated instead of stored when possible.

## Data-access rules

- Presentation does not know raw endpoints or serialization details.
- Feature-specific repositories stay close to the feature.
- Shared transport configuration belongs in a shared API boundary when it is
  genuinely global.
- External DTOs are mapped only when a meaningful distinction exists between
  external and internal models.
- Server-state/cache policy stays outside the Repository when it belongs to a
  React/server-state library.
- Repository errors may be normalized at the data boundary, but presentation
  decisions remain above it.

## Routing architecture

Routing maps URLs to meaningful navigable locations.

When routing is adopted, global router composition belongs under `app/` and
feature-specific page behavior stays in the feature.

Principles:

- routes represent navigable boundaries, not component names;
- path params represent essential identity/hierarchy;
- search params represent navigable filters, pagination, sorting, search, or
  similar view state;
- URL state is not duplicated into independent React state;
- route parameters are external input and must be parsed/validated as needed;
- router code does not become the owner of feature business rules;
- frontend route protection does not replace backend authorization.

The routing library and other project-wide frontend tooling choices remain in
[Open Architecture Decisions](open-decisions.md). Technology-specific references
are implementation guidance only, not architecture authorization.

## Related implementation references

- [project structure](../../.claude/skills/frontend-development/references/architecture/project-structure.md)
- [layered architecture](../../.claude/skills/frontend-development/references/architecture/layered-architecture.md)
- [state placement](../../.claude/skills/frontend-development/references/architecture/state-placement.md)
- [data access](../../.claude/skills/frontend-development/references/architecture/data-access.md)
- [routing](../../.claude/skills/frontend-development/references/architecture/routing.md)

Use forms, accessibility, security, performance, React/TSX, TypeScript,
Tailwind, React Router, UI-state, and testing references only when the task
requires those concerns and the relevant technology is accepted.
