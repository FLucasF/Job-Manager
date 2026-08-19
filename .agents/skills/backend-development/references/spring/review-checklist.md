# Spring Review Checklist

Use this checklist after reading the Spring references relevant to the change.

Do not use this checklist as a substitute for the detailed references.

## Dependency Injection

- [ ] Required dependencies use constructor injection.
- [ ] Required collaborators are explicit and normally held in `final` fields.
- [ ] Field injection was not introduced.
- [ ] Multiple implementations are selected explicitly when necessary.
- [ ] Container lookup is not used as a service locator for normal application code.
- [ ] Large constructor dependency sets were reviewed for excessive responsibility.
- [ ] Dependency injection respects architectural dependency direction.

## Component Design

- [ ] Only objects that need container management are Spring beans.
- [ ] The most appropriate stereotype communicates each component's role.
- [ ] Singleton beans do not hold request-specific or user-specific mutable state.
- [ ] Components have cohesive responsibilities.
- [ ] Generic managers, helpers, or catch-all services were not introduced.
- [ ] Explicit `@Bean` definitions are used only where construction/configuration justifies them.
- [ ] Framework independence was evaluated by coupling, not annotation purity.

## Configuration

- [ ] Environment-specific values are externalized.
- [ ] Related custom properties use typed configuration where appropriate.
- [ ] Critical configuration is validated early.
- [ ] Configuration property objects do not contain business dependencies.
- [ ] Configuration classes do not contain business workflows.
- [ ] Production secrets are not committed to repository configuration.
- [ ] Defaults are safe and intentional.
- [ ] Configuration types are more precise than raw strings where practical.

## Profiles

- [ ] Profiles represent genuine environment-dependent configuration or bean selection.
- [ ] Profiles are not being used as general business feature flags.
- [ ] Environment branching is not scattered through business code.
- [ ] Active profiles are selected externally rather than hardcoded.
- [ ] Profile-specific configuration overrides only what needs to differ.
- [ ] Tests explicitly activate required profiles.
- [ ] Security does not depend on profile correctness alone.

## Final Review

- [ ] Spring is being used as infrastructure/container support rather than as a substitute for application design.
- [ ] Framework conveniences did not weaken explicit dependencies or architectural boundaries.
- [ ] Added Spring configuration is simpler than the problem it solves.
