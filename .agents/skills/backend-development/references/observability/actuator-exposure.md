# Actuator Exposure

Expose only the Spring Boot Actuator endpoints required for operations.

Treat management endpoints as privileged operational interfaces.

## Minimize Exposure

Prefer an allowlist of required endpoints.

Do not expose all Actuator endpoints publicly by default.

Commonly useful endpoints may include:

```text
health
metrics or a metrics-export endpoint
prometheus when Prometheus scraping is used
info when its contents are intentional
```

Expose additional endpoints only for a concrete operational need.

## Secure Sensitive Endpoints

Endpoints such as environment, beans, mappings, configuration properties,
logger management, or HTTP exchanges may reveal internal information or alter
runtime behavior.

Protect them with network controls and/or Spring Security according to the
deployment model.

## Separate Exposure from Access

An endpoint must be both exposed and authorized appropriately.

Do not assume "not linked from the UI" means inaccessible.

## Health Detail

Public health endpoints should reveal minimal detail.

Provide component/detail information only to trusted operational callers when
needed.

## Metrics Export

Use the backend-specific export endpoint intended for the monitoring system.

Do not use the diagnostic `/actuator/metrics` endpoint itself as a production
scraping backend.

## Runtime Mutation

Treat endpoints that change runtime state or configuration as privileged
operations.

Do not expose runtime logger changes, shutdown, or other write operations
without explicit operational authorization.

## Avoid

- `management.endpoints.web.exposure.include=*` on public deployments without a
  deliberate security boundary
- public `env`, `configprops`, `beans`, `mappings`, or logger-management
  endpoints without a concrete need
- detailed health information available to anonymous callers by default
- treating endpoint exposure as equivalent to authorization
- using diagnostic metrics endpoints as the production metrics backend
