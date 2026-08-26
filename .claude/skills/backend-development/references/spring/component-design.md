# Spring Component Design

Use Spring stereotypes to mark framework-managed adapters and application
components with clear responsibilities.

Do not turn every Java class into a Spring bean.

## Use the Most Specific Stereotype

Prefer the stereotype that communicates the component role:

```text
@Service       application/service component
@Repository    persistence component
@Controller    MVC controller
@RestController REST controller
@Component     generic managed component
```

Do not use `@Component` when a more specific stereotype communicates the
responsibility better.

## Keep Spring at Appropriate Boundaries

Spring annotations are expected in framework-managed components.

Do not add Spring annotations to pure values, records, domain types, or utility
objects solely to obtain them from the container.

## Singleton State

Spring beans are singleton-scoped by default.

Do not keep request-specific or user-specific mutable state in singleton beans.

Prefer local variables, immutable fields, request data, or explicitly scoped
components when a real scope requirement exists.

## Component Responsibilities

A Spring bean should have a cohesive responsibility.

Avoid generic components such as:

```text
ApplicationManager
CommonService
GlobalHelper
```

that accumulate unrelated behavior.

## Bean Creation

Use component scanning for application-owned components when stereotypes make
their role clear.

Use explicit `@Bean` configuration when:

- integrating a third-party type;
- construction requires deliberate configuration;
- the type cannot or should not carry Spring annotations.

Do not create explicit bean definitions when component scanning already
expresses the ownership clearly.

## Framework Annotations and Clean Architecture

Do not remove Spring annotations mechanically in the name of framework
independence.

Review whether business policy depends on Spring behavior or Spring-specific
types, not merely whether an annotation is present.

## Avoid

- annotating every class as a Spring bean
- mutable request state in singleton beans
- generic catch-all services or managers
- `@Component` when a specific stereotype better expresses the role
- container-managed domain values without a concrete need
- artificial wrapper beans around simple Java objects
