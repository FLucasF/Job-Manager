# Testing Architecture

**Status:** Draft

Tests provide evidence for requirements; they do not define product behavior.
Verify each acceptance criterion at the smallest effective level.

## Ownership by level

- backend unit/integration tests belong to `apps/backend/`;
- frontend unit/integration tests belong to `apps/frontend/`;
- complete browser journeys belong to the quality-assurance workflow.

Specification packages, templates and harness evals are documentary conventions
reviewed manually. There is no structural harness validator, CI gate or Git hook.

Use backend integration tests when confidence depends on Spring, HTTP,
persistence, migrations, transactions or security. Use frontend integration
tests for collaboration among components, hooks, state, routing and data access.
Use E2E only when a complete browser/system journey adds necessary confidence.

## Specification traceability

- `design.md` maps ACs to a verification strategy;
- `tasks.md` assigns concrete tests and deterministic Verify commands;
- `validation.md` records commands actually executed and concrete AC evidence.

One AC may need evidence at multiple boundaries; strict 1:1 mapping is not
required. Cover relevant failure, validation, authorization, persistence,
concurrency and UI-state paths required by the spec. Do not invent unspecified
failure behavior.

Outside the package workflow, map tests to the explicit user request and record
the commands and observable evidence proportionally; `design.md`, `tasks.md` and
`validation.md` are not required.

## Repository commands

Use commands that actually exist:

```text
backend
→ apps/backend/mvnw.cmd test

frontend build/typecheck
→ npm run build from apps/frontend

frontend lint
→ npm run lint from apps/frontend
```

Do not add tools or replacement commands merely because guidance mentions them.

## Integrity

Never obtain a pass by weakening assertions, suppressing errors, deleting valid
tests, hiding failures, increasing retries without diagnosis or bypassing
security controls. Missing evidence is a gap, not a pass.

## Related guidance

- `../../.claude/skills/backend-development/references/testing/`
- `../../.claude/skills/frontend-development/references/testing/`
- `.claude/skills/quality-assurance/` for E2E journeys.
