# Authorization

Authorize every protected operation according to the caller, resource, and
requested action.

Authentication proves who the caller is. It does not prove what the caller may
do.

## Default Deny

Prefer explicit authorization rules and a deny-by-default posture.

Do not assume an endpoint is safe merely because the caller is authenticated.

## Request-Level Authorization

Use request-level rules for coarse-grained access such as:

```text
public endpoints
authenticated endpoints
administrative route groups
```

Keep the catch-all rule protected.

## Method-Level Authorization

Use method-level authorization when access depends on application-level context,
method parameters, authorities, ownership, or the requested operation.

Prefer focused authorization expressions or reusable authorization components.

Do not hide complex business authorization in large SpEL expressions.

## Object-Level Authorization

Whenever a caller supplies an object identifier, verify that the caller may
access that specific object.

Do not rely on UUIDs, opaque IDs, or difficult-to-guess identifiers as access
control.

Example concern:

```text
GET /workers/{workerId}
```

must authorize access to that worker, not merely authenticate the request.

## Property-Level Authorization

A caller authorized to read an object is not automatically authorized to read
every property.

Control response fields deliberately.

Sensitive fields may require omission or masking according to the API contract.

## Function-Level Authorization

Administrative or privileged operations require explicit authority checks.

Do not rely only on hiding UI controls in the frontend.

## Keep Authorization Server-Side

The backend is the authority for access decisions.

Client-provided roles, flags, ownership markers, or hidden form fields are not
trusted authorization evidence.

## Avoid

- authentication-only protection
- trusting resource IDs as authorization
- frontend-only authorization
- returning every object property after object-level access succeeds
- broad role checks where ownership or permission is required
- complex authorization duplicated across controllers
