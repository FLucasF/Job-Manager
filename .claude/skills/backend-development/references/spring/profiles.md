# Spring Profiles

Use Spring profiles for environment-dependent configuration or bean selection
when a real environment distinction exists.

Do not use profiles as a general-purpose feature flag system.

## Environment Separation

Typical profile concerns include:

```text
local
test
production
```

Use profile-specific configuration only for values or components that actually
vary by environment.

## Prefer Configuration over Code Branches

Avoid business code such as:

```java
if (environment.equals("production")) {
    // ...
}
```

when the difference belongs to configuration or bean selection.

## `@Profile`

Use `@Profile` when different environments genuinely require different bean
implementations or configuration.

Do not annotate large portions of ordinary business code with profiles.

## Active Profiles

Treat active profile selection as deployment/runtime configuration.

Do not hardcode the production profile into application code.

## Profile-Specific Properties

Keep common values in base configuration and override only the values that
differ.

Avoid duplicating entire configuration files when only a few properties
change.

## Profile Groups

Use profile groups only when several lower-level profiles represent one stable
deployment concept.

Do not create complicated profile combinations that are difficult to reason
about.

## Tests

Do not make tests depend unnecessarily on developer-local profile state.

A test that requires a profile should activate it explicitly.

## Profiles Are Not Security Boundaries

Do not rely on a profile alone to protect secrets, permissions, endpoints, or
authorization behavior.

Security controls must remain effective regardless of profile mistakes.

## Avoid

- profiles as business feature flags
- environment `if` statements scattered through application code
- duplicated profile configuration without need
- hidden dependencies on whichever profile happens to be active locally
- hardcoded production profile activation
- treating profiles as access-control mechanisms
