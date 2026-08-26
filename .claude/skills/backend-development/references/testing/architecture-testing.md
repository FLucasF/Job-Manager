# Architecture Testing

Automate stable architectural rules when violating them would create costly or
easy-to-miss coupling.

Do not encode every style preference as an architecture test.

## Good Candidates

Architecture tests are useful for stable rules such as:

```text
domain must not depend on web
domain must not depend on persistence implementation
web must not access JPA repositories directly
feature dependencies must remain acyclic
internal feature packages must not be accessed externally
```

These rules should match the architecture references, not invent a competing
architecture.

## Use a Suitable Tool When Adopted

Use an architecture-testing tool such as ArchUnit, or module verification such
as Spring Modulith, when the project intentionally adopts it.

Do not add a new dependency solely to test a rule that the compiler/package
structure already enforces adequately.

## Keep Rules Structural

Architecture tests should focus on dependency and boundary structure.

Do not use them to enforce arbitrary naming, file length, or subjective code
style better handled by linting/static analysis.

## Fail with Actionable Messages

A failing architecture rule should make the forbidden dependency clear.

Avoid meta-tests whose failure requires understanding a large custom framework.

## Update Deliberately

When architecture changes intentionally, update the reference and architecture
test together.

Do not weaken a rule merely to make a new dependency compile.

## Avoid

- architecture tests for subjective style
- duplicated lint/static-analysis rules
- custom architecture frameworks with high maintenance cost
- rules that contradict actual project boundaries
- silently excluding violating packages to make the suite pass
