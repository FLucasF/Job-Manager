# Java Review Checklist

Use this checklist after reading the Java references relevant to the change.

Do not use this checklist as a substitute for the detailed references.

## Type Safety

- [ ] Raw generic types are not used.
- [ ] Unchecked casts and warning suppressions are narrowly scoped and justified.
- [ ] `Object` is not used as a generic escape hatch.
- [ ] Domain states are represented with explicit types instead of magic strings where appropriate.
- [ ] External untyped data is converted and validated at the boundary.

## Nullability and Optional

- [ ] `Optional` is used only where absence is an intentional contract.
- [ ] Methods returning `Optional` never return `null`.
- [ ] Collection-returning methods return empty collections instead of `null`.
- [ ] `Optional` fields and parameters were not introduced mechanically.
- [ ] Required dependencies and values have clear non-null contracts.
- [ ] `Optional.get()` is not used as routine control flow.

## Immutability and Records

- [ ] State is immutable where practical.
- [ ] Records are used only when data-carrier semantics fit.
- [ ] Mutable record components are defensively copied when required.
- [ ] Stateful domain entities were not converted to records only to reduce boilerplate.
- [ ] Mutable internal collections do not escape unintentionally.

## Lombok

- [ ] Lombok annotations remove boilerplate without hiding important design decisions.
- [ ] `@Data` is not used mechanically.
- [ ] Setters are generated only when mutability is intentional.
- [ ] JPA entity equality, hash code, and string representation are handled deliberately.
- [ ] Builders are used only when they improve construction clarity.
- [ ] Native Java features are preferred when clearer than Lombok.
- [ ] Experimental Lombok features are not introduced by default.

## Exceptions

- [ ] Exceptions are caught only where recovery, translation, context, or cleanup is owned.
- [ ] Translated exceptions preserve their original cause.
- [ ] Broad catch blocks are avoided unless the boundary intentionally owns all failures.
- [ ] Exceptions are not used as normal branching logic.
- [ ] Domain exceptions do not encode HTTP concerns.
- [ ] Sensitive data is not included in exception messages or logs.
- [ ] The same failure is not logged redundantly at multiple layers.

## Collections

- [ ] Collection types match the required semantics.
- [ ] Contracts prefer collection interfaces when implementation details are irrelevant.
- [ ] Empty collections are returned instead of `null`.
- [ ] Mutable internal collections are not exposed unintentionally.
- [ ] Streams improve readability rather than obscure control flow.
- [ ] Parallel streams are not used without measurement and justification.

## Generics

- [ ] Generic parameters preserve useful type relationships.
- [ ] Wildcards and bounds are used only when they improve the contract.
- [ ] Generic abstractions do not erase important domain semantics.
- [ ] Unchecked casts are not hidden inside generic infrastructure.
- [ ] Concrete APIs are preferred when generic reuse is not real.

## Date and Time

- [ ] Temporal types match the business meaning of the data.
- [ ] Globally meaningful timestamps use an unambiguous representation.
- [ ] Server-default timezone behavior is not relied upon implicitly.
- [ ] Time-dependent logic uses an injectable `Clock` when deterministic testing matters.
- [ ] Legacy date APIs are avoided in new code.
- [ ] Formatting and parsing remain near system boundaries.

## Final Review

- [ ] The implementation uses Java features to make contracts clearer and safer.
- [ ] Added abstractions solve current problems rather than hypothetical ones.
- [ ] The resulting code remains simple enough to understand and maintain.
