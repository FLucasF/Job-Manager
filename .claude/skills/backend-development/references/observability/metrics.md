# Metrics

Use metrics to observe aggregate system behavior over time.

Prefer metrics that support concrete operational questions, alerts, capacity
decisions, or service-level objectives.

## Prefer Existing Instrumentation

Use Spring Boot and Micrometer's built-in instrumentation before creating custom
meters.

Do not recreate HTTP, JVM, datasource, or other metrics already provided by the
platform.

## Add Custom Metrics for Operational Questions

Create custom metrics when the application needs to observe domain or
integration behavior not covered by built-in instrumentation.

Examples may include:

```text
vacancy creation outcomes
external provider failures
job processing duration
queue depth
```

Do not turn every method call into a metric.

## Choose the Meter by Meaning

Use counters for monotonically increasing event counts.

Use timers for operation latency and count.

Use gauges only for values that represent meaningful current state and have
stable ownership.

Choose the type according to the question being measured, not convenience.

## Control Tag Cardinality

Keep metric tags low-cardinality and bounded.

Good candidates:

```text
operation
outcome
provider
status category
```

Avoid tags such as:

```text
user id
CPF
email
request id
raw URL containing identifiers
exception message
```

Unbounded tag values can create excessive time series and monitoring cost.

## Measure Outcomes, Not Only Attempts

When useful, distinguish success, expected rejection, and failure.

Do not publish metrics whose interpretation is ambiguous.

## Metrics Are Not Logs

Do not encode high-cardinality diagnostic detail into metric tags.

Use logs or traces for per-request detail.

## Avoid

- duplicating built-in Spring/Micrometer metrics
- metrics for every method
- user IDs or request IDs as tags
- raw exception messages as tags
- gauges without clear lifecycle ownership
- custom metrics with no operational consumer or question
