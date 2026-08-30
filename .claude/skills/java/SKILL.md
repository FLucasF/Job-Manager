---
name: java
description: Java language idioms and APIs: collections, generics, records and immutability, Optional and nullability, exceptions, date and time, type safety and Lombok. Use as the language overlay when the affected boundary uses Java. Load together with the concern skill that owns the decision. Do not use for framework wiring, which belongs to the framework overlay, and do not use for other languages.
---

# Java

Language overlay for the `java` technology. It carries only idioms and APIs.

The concern skill owns the decision: backend-development. Load it for the rule and load
this skill for the mechanism. When the two appear to disagree, the rule wins and
the disagreement is reported.

`CLAUDE.md` governs the spec gate, RPI workflow, architecture authority,
security, validation and completion. This skill authorizes no technology,
dependency, requirement or architecture.

## Reference Routing

Use for language-level safety and design decisions independent of Spring.

- Type safety, raw types, casts, explicit domain types, and enums:
  [type-safety.md](references/language/type-safety.md)
- Nullability and `Optional` contracts:
  [nullability-optional.md](references/language/nullability-optional.md)
- Immutability, defensive copies, and records:
  [immutability-records.md](references/language/immutability-records.md)
- Lombok usage policy:
  [lombok.md](references/language/lombok.md)
- Exception design and handling:
  [exceptions.md](references/language/exceptions.md)
- Collection semantics and ownership:
  [collections.md](references/language/collections.md)
- Generic APIs, bounds, and wildcards:
  [generics.md](references/language/generics.md)
- Date/time types, timezone handling, and testable clocks:
  [date-time.md](references/language/date-time.md)
- Java review:
  [review-checklist.md](references/language/review-checklist.md)

Do not read Java references merely because the project is written in Java.
Load them when the task involves the corresponding design decision.
