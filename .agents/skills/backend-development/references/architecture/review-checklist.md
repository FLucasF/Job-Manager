# Architecture Review Checklist

Use this checklist after reading the architecture references relevant to the
change.

Do not use this checklist as a substitute for the detailed references.

## Project Structure

- [ ] Code is organized under the feature that owns the behavior.
- [ ] Technical folders do not unnecessarily span unrelated features.
- [ ] New `shared`, `common`, `util`, or `helper` code has clear ownership and a justified shared responsibility.
- [ ] Empty architectural layers were not introduced only to match a template.
- [ ] Other features do not access internal implementation packages directly.

## Layer Responsibilities

- [ ] Controllers contain HTTP adaptation rather than business rules.
- [ ] Application services coordinate use cases without absorbing unrelated domain behavior.
- [ ] Domain behavior does not depend unnecessarily on HTTP, persistence, or framework details.
- [ ] Infrastructure contains technical implementations rather than application policy.
- [ ] Pass-through layers without a meaningful responsibility were not added.

## Clean Architecture

- [ ] Important application or domain policy is protected from volatile technical details where a meaningful boundary exists.
- [ ] Inner code does not expose or depend unnecessarily on outer-layer types.
- [ ] Persistence models are not automatically used as API contracts.
- [ ] Interfaces represent real contracts or boundaries rather than ceremony.
- [ ] Clean Architecture concepts were applied proportionally to the problem.

## Dependency Direction

- [ ] Source dependencies point toward the intended inner boundaries.
- [ ] Web code does not bypass the application boundary to access persistence.
- [ ] Domain code does not import infrastructure or web types.
- [ ] Application code does not depend on concrete infrastructure where a meaningful inversion is required.
- [ ] Feature dependencies are explicit and acyclic.
- [ ] Cycles were not hidden through lazy injection, globals, or service location.

## SOLID

- [ ] Classes have cohesive responsibilities.
- [ ] Extension abstractions correspond to actual variation.
- [ ] Implementations honor their contracts.
- [ ] Interfaces do not force consumers to depend on unrelated operations.
- [ ] Dependency inversion is used where it protects a meaningful boundary.
- [ ] Interfaces and implementations were not introduced mechanically.

## Cohesion and Coupling

- [ ] Related behavior remains close to the concept it governs.
- [ ] Dependencies are explicit and necessary.
- [ ] Large dependency sets were reviewed for excessive responsibility.
- [ ] Cross-feature coupling is minimized.
- [ ] Shared abstractions represent genuinely shared concepts.
- [ ] Generic utility or manager classes were not used as dumping grounds.

## Final Review

- [ ] The resulting design is simpler or meaningfully safer than the alternative.
- [ ] Architectural abstractions solve current problems rather than speculative ones.
- [ ] The implementation follows existing project conventions unless changing them is part of the task.
