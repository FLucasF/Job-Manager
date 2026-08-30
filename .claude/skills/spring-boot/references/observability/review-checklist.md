# Observability Review — Spring Boot mechanisms

Stack review items for the `observability/review-checklist.md` concern
reference. The generic items live there; these are specific to Spring Boot.

## Actuator Exposure

- [ ] Only required Actuator endpoints are exposed.
- [ ] Sensitive management endpoints have explicit network/security protection.
- [ ] Exposure and authorization are treated as separate controls.
- [ ] Anonymous health output is intentionally minimal.
- [ ] Production metrics use the monitoring system's intended export endpoint.
- [ ] Runtime-mutating management endpoints are not exposed without explicit authorization.
