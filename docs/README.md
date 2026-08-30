# Harness Documentation

`docs/` holds durable documentation about the harness itself: what it is, how it
works and how it is evaluated. Canonical location does not make every document
normative; each one declares its own status and authority.

## Entry points

- [Development Methodology](methodology/development-methodology.md) — the local
  specification and delivery process;
- [Harness Overview](methodology/harness-overview.md) — operational overview of
  the components and how they fit together;
- [Migration Record](methodology/migration-codex-to-claude.md) — the Codex to
  Claude Code migration, the stack generalization and their known divergences.

Load only documents relevant to the current task.

## Responsibility split

```text
CLAUDE.md
→ the operating contract

specs/
→ feature behavior and acceptance criteria

.claude/skills/**/references/
→ reusable technical guidance

.claude/agents/
→ independent reviewer and verifier roles

.claude/validation.json
→ boundaries and their validation commands

docs/
→ durable knowledge about the harness

evals/
→ observable evaluation of agent behavior under the harness
```

A project that adopts this harness supplies its own durable product, domain and
architecture documents. The harness governs how those documents hold authority;
it does not provide their content.

Draft and Open documents provide refinement context only. They cannot silently
act as normative authority for a Ready specification.
