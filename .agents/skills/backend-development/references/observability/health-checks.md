# Health Checks

Use health checks to answer whether an application instance is alive and
whether it should receive traffic.

Keep health checks fast, bounded, and aligned with orchestration behavior.

## Liveness

Liveness answers whether the process is fundamentally unable to continue.

Do not make liveness depend on shared external systems such as:

```text
database
external HTTP API
cache
message broker
```

A shared dependency outage should not normally cause every application instance
to restart.

## Readiness

Readiness answers whether the instance should currently receive traffic.

Include external dependencies only when their failure truly makes the instance
unable to serve useful traffic.

Do not add every integration to readiness automatically.

## Prefer Built-In Indicators

Use Spring Boot Actuator health contributors before creating custom health
checks.

Create a custom indicator only for an application-specific dependency or state
that materially affects availability.

## Keep Checks Fast

Health endpoints are called repeatedly by monitoring and orchestration systems.

Do not perform expensive queries, large allocations, long remote workflows, or
state-changing operations in health checks.

Apply bounded timeouts to external checks.

## Do Not Leak Details

Expose only the health detail required by the caller.

Do not reveal credentials, internal topology, connection strings, or sensitive
configuration through health responses.

## Main Application Path

When deployment architecture uses a separate management port, consider whether
a successful management-port probe can still miss failure of the main HTTP
server.

Make liveness/readiness available through the main server path when that better
represents actual traffic availability.

## Avoid

- database/external API dependency in liveness by default
- every integration included in readiness
- expensive health queries
- health checks with side effects
- sensitive diagnostic detail in public health responses
- probes that report healthy while the real application traffic path is broken
