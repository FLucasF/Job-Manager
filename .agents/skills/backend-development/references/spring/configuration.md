# Spring Configuration

Keep runtime configuration external, typed, validated, and separate from
business logic.

Prefer project configuration that fails clearly when required values are
missing or invalid.

## Externalize Environment Values

Do not hardcode environment-specific values such as:

```text
database URLs
external service URLs
credentials
timeouts
feature environment settings
```

Use Spring Boot externalized configuration.

## Prefer Typed Configuration

For related application properties, prefer `@ConfigurationProperties` over
scattered `@Value` fields.

```java
@ConfigurationProperties("app.mail")
public record MailProperties(
    URI baseUrl,
    Duration timeout
) {}
```

Use a coherent prefix owned by the component or capability.

## Validate Required Configuration

Validate configuration at startup when invalid values would make the
application unsafe or unusable.

Prefer startup failure over discovering malformed critical configuration on
the first production request.

## Keep Configuration Objects Focused

Configuration property classes should represent environment configuration.

Do not inject application services or business collaborators into
`@ConfigurationProperties` objects.

## Use `@Bean` Deliberately

Use `@Bean` for construction or customization that belongs to framework
configuration, especially third-party objects.

Avoid putting business workflows inside configuration classes.

## Secrets

Treat secrets as external configuration, but do not commit production secrets
to repository configuration files.

Do not assume encoding such as Base64 provides secret protection.

Secret storage policy belongs to the project's security and deployment
configuration.

## Property Names

Use stable, hierarchical, kebab-case property names.

Prefer:

```text
app.mail.base-url
app.mail.timeout
```

over unrelated flat names.

## Defaults

Provide defaults only when they are safe and semantically valid in every
environment where they may apply.

Do not provide fallback credentials, security keys, or production-sensitive
defaults merely to allow startup.

## Avoid

- hardcoded environment values
- scattered `@Value` usage for structured configuration
- business logic inside configuration classes
- configuration objects depending on application services
- committed production secrets
- unsafe fallback values
- strings where Spring can bind a more precise type such as `Duration` or `URI`
