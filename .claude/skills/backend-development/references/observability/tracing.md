# Tracing

Use distributed tracing to follow request and dependency flow across meaningful
boundaries.

Prefer framework-provided instrumentation before adding custom spans.

## Use Micrometer Tracing Integration

Use Spring Boot's Micrometer tracing integration when distributed tracing is
required.

Do not couple application code directly to a vendor-specific tracing backend
without a concrete need.

## Add Custom Spans Sparingly

Create custom observations/spans around operations that are important and not
already instrumented.

Good candidates include:

- meaningful external integrations;
- background processing stages;
- expensive application operations;
- asynchronous boundaries that need causal visibility.

Do not create a span for every service method.

## Propagate Context

Preserve tracing context across supported HTTP, messaging, and asynchronous
boundaries.

Do not invent separate request-correlation mechanisms when tracing already
provides the required identifiers, unless the application has a distinct
business correlation ID.

## Span Attributes

Use low-cardinality, non-sensitive attributes.

Do not attach:

- CPF;
- email;
- passwords;
- bearer tokens;
- full request bodies;
- unbounded user-generated values.

## Errors

Record span failure according to the tracing integration.

Do not duplicate full error payloads in span attributes when logs already hold
the safe diagnostic detail.

## Sampling

Treat sampling as an operational configuration decision.

Do not assume every trace must be exported in production.

Choose sampling according to traffic, cost, and diagnostic needs.

## Avoid

- vendor-specific tracing APIs spread through application code
- spans around every method
- sensitive or high-cardinality span attributes
- custom correlation systems duplicating trace IDs without need
- production sampling chosen without traffic/cost consideration
