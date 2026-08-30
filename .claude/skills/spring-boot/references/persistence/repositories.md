# Repositories — Spring Boot mechanisms

Stack mechanisms for the `persistence/repositories.md` concern reference. The rule lives in the
concern reference; this file states how Spring Boot expresses it.

## Spring Data Repositories

Use Spring Data repository interfaces inside the persistence implementation
when they reduce boilerplate.

Do not expose a Spring Data repository directly to controllers or unrelated
features.
