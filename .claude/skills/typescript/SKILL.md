---
name: typescript
description: TypeScript language idioms: type safety, inference and generics, nullability, modules and imports, and compiler configuration. Use as the language overlay when the affected boundary uses TypeScript. Load together with the concern skill that owns the decision. Do not use for framework component patterns, which belong to the framework overlay.
---

# TypeScript

Language overlay for the `typescript` technology. It carries only idioms and APIs.

The concern skill owns the decision: frontend-development. Load it for the rule and load
this skill for the mechanism. When the two appear to disagree, the rule wins and
the disagreement is reported.

`CLAUDE.md` governs the spec gate, RPI workflow, architecture authority,
security, validation and completion. This skill authorizes no technology,
dependency, requirement or architecture.

## Reference Routing

- Type safety, `any`, assertions, object modeling, `keyof` e dynamic access:
  [type-safety.md](references/language/type-safety.md)

- Inferência, contextual typing, generics e constraints:
  [inference-generics.md](references/language/inference-generics.md)

- `null`, `undefined`, optional chaining e narrowing:
  [nullability.md](references/language/nullability.md)

- Imports, exports, `.d.ts`, typings e module resolution:
  [modules-imports.md](references/language/modules-imports.md)

- `tsconfig.json`, strictness, `target`, `lib`, module options e compiler plugins:
  [compiler-config.md](references/language/compiler-config.md)

- Revisão TypeScript:
  [review-checklist.md](references/language/review-checklist.md)

[HARD RULE] Regras específicas de React pertencem à skill `react`, não a
`references/language/`.
