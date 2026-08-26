# Job Manager Documentation

`docs/` is the canonical tree for durable project-specific product/discovery,
domain, architecture and methodology documentation. Canonical location does not
make every document normative; each boundary declares its own status/authority.

## Entry points

- [Architecture](architecture.md) — architecture router and status rules;
- [Domain Documentation](domain/README.md) — domain router;
- [Product Backlog](product/frontend-user-stories.md) — non-normative discovery;
- [Development Methodology](methodology/development-methodology.md) — local
  specification and delivery process;
- [Job Manager Harness](methodology/job-manager-harness.md) — operational
  overview of the harness;
- [Harness Migration](methodology/harness-migration-codex-to-claude.md) — record
  of the Codex to Claude Code migration and its known divergences.

Load only documents relevant to the current task.

## Responsibility split

```text
docs/
→ durable project knowledge

specs/
→ feature behavior and acceptance criteria

contracts/
→ formal shared external contracts when applicable

.claude/skills/**/references/
→ reusable technical guidance

apps/
→ implementation
```

Draft/Open documents provide refinement context only. They cannot silently act
as normative authority for a Ready specification.
