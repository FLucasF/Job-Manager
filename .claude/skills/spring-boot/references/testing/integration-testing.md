# Integration Testing — Spring Boot mechanisms

Stack mechanisms for the `testing/integration-testing.md` concern reference. The rule lives in the
concern reference; this file states how Spring Boot expresses it.

## Use Spring Test Support Deliberately

Use the Spring TestContext Framework when the test needs managed application
configuration, transactions, security, or framework integration.

Use `@SpringBootTest` only when the full application context is part of what the
test must prove.
