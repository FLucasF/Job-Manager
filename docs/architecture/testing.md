# Testing Architecture

**Status:** Draft

Tests provide evidence for requirements; they do not define product behavior.
Verify each acceptance criterion at the smallest effective level.

## Ownership by level

- backend unit/integration tests belong to `apps/backend/`;
- frontend unit/integration tests belong to `apps/frontend/`;
- complete browser journeys belong to the quality-assurance workflow;
- structural harness/package checks belong to `scripts/check-harness.ps1`.

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

## Repository commands

Use commands that actually exist:

```text
harness
→ powershell -File scripts/check-harness.ps1

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

- `../../.agents/skills/backend-development/references/testing/`
- `../../.agents/skills/frontend-development/references/testing/`
- `.agents/skills/quality-assurance/` for E2E journeys.
