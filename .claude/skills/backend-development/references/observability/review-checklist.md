# Observability Review Checklist

Use this checklist after reading the observability references relevant to the
change.

Do not use this checklist as a substitute for the detailed references.

## Logging

- [ ] Logs exist at meaningful operational boundaries rather than every method.
- [ ] Log levels match event severity and expectedness.
- [ ] Logs include useful stable context when needed.
- [ ] The same exception is not logged redundantly across layers.
- [ ] Operational logs are not being used as an accidental audit trail.
- [ ] Sensitive-data logging follows the security logging policy.

## Metrics

- [ ] Built-in Spring Boot/Micrometer metrics are reused before custom metrics are added.
- [ ] Each custom metric answers a concrete operational question.
- [ ] Meter type matches the meaning of the measurement.
- [ ] Metric tags are bounded and low-cardinality.
- [ ] Personal identifiers, request IDs, and raw exception messages are not metric tags.
- [ ] Custom metrics distinguish relevant outcomes when needed.

## Tracing

- [ ] Framework instrumentation is preferred before custom spans.
- [ ] Custom spans cover meaningful boundaries rather than every method.
- [ ] Trace context is propagated across supported distributed/asynchronous boundaries.
- [ ] Span attributes are low-cardinality and non-sensitive.
- [ ] Tracing code does not couple the application unnecessarily to a telemetry vendor.
- [ ] Sampling is treated as an operational decision.

## Health Checks

- [ ] Liveness does not depend on shared external systems by default.
- [ ] Readiness includes only dependencies that determine whether the instance should receive traffic.
- [ ] Health checks are fast, bounded, and side-effect free.
- [ ] Built-in health contributors are reused where possible.
- [ ] Health output does not expose sensitive details.
- [ ] Probe location accurately represents the real application traffic path.

## Final Review

- [ ] Observability helps answer operational questions without creating unnecessary telemetry.
- [ ] Telemetry does not leak personal data, credentials, or secrets.
- [ ] Instrumentation is proportional to the application's production needs.
- [ ] New observability abstractions solve a concrete diagnostic or operational problem.
