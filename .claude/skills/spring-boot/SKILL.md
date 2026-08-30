---
name: spring-boot
description: Spring Boot framework idioms and APIs: component model, dependency injection, configuration and profiles, plus the Spring mechanisms for persistence, testing and operational endpoints. Use as the framework overlay when the affected boundary uses Spring Boot. Load together with the concern skill that owns the decision. Do not use for Java language semantics, which belong to the java overlay.
---

# Spring Boot

Framework overlay for the `spring-boot` technology. It carries only idioms and APIs.

The concern skill owns the decision: backend-development. Load it for the rule and load
this skill for the mechanism. When the two appear to disagree, the rule wins and
the disagreement is reported.

`CLAUDE.md` governs the spec gate, RPI workflow, architecture authority,
security, validation and completion. This skill authorizes no technology,
dependency, requirement or architecture.

## Reference Routing

Use for Spring container, component, and runtime-configuration decisions.

- Constructor injection, bean selection, and dependency visibility:
  [dependency-injection.md](references/framework/dependency-injection.md)
- Spring stereotypes, bean responsibilities, scopes, and component ownership:
  [component-design.md](references/framework/component-design.md)
- Externalized and typed Spring Boot configuration:
  [configuration.md](references/framework/configuration.md)
- Environment-specific configuration and profiles:
  [profiles.md](references/framework/profiles.md)
- Spring review:
  [review-checklist.md](references/framework/review-checklist.md)

Do not create a separate configuration abstraction when existing Spring
configuration or security-secret references already cover the concern.

## Concern Overlays

These files carry only the Spring Boot mechanism for a concern whose rule lives in
`backend-development`. Read the concern reference first.

- observability / actuator exposure:
  [actuator-exposure.md](references/observability/actuator-exposure.md)
- observability / review checklist:
  [review-checklist.md](references/observability/review-checklist.md)
- persistence / entities:
  [entities.md](references/persistence/entities.md)
- persistence / repositories:
  [repositories.md](references/persistence/repositories.md)
- testing / integration testing:
  [integration-testing.md](references/testing/integration-testing.md)
- testing / testcontainers:
  [testcontainers.md](references/testing/testcontainers.md)
