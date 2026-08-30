# Testcontainers — Spring Boot mechanisms

Stack mechanisms for the `testing/testcontainers.md` concern reference. The rule lives in the
concern reference; this file states how Spring Boot expresses it.

## Spring Boot Integration

Use Spring Boot's Testcontainers integration/service connections when it makes
connection configuration simpler and explicit.

Do not duplicate manual dynamic-property wiring when the framework integration
already expresses the connection correctly.
