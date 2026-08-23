# Security Architecture

**Status:** Draft

## Purpose

This document defines project-wide security constraints that apply regardless
of the eventual authentication technology.

Capability-specific security behavior belongs in the applicable specification.
Detailed implementation guidance belongs in security references.

## Current security status

Authentication mechanism, project-wide authorization model and browser session
strategy remain in [Open Architecture Decisions](open-decisions.md). References
to JWT, sessions or OAuth/OIDC do not authorize adoption. A dependent feature
must resolve the applicable decisions before Ready.

## Authentication and authorization

Authentication and authorization are different responsibilities.

```text
authentication
→ who is the caller?

authorization
→ may this caller perform this action or access this resource/property?
```

Frontend route protection is a usability/navigation boundary and never replaces
backend authorization.

## Secrets and credentials

Never commit:

- passwords;
- access tokens;
- private keys;
- real service credentials;
- database credentials;
- personal OAuth state;
- environment-specific secrets.

Runtime secrets remain externalized from versioned source and harness files.

The backend already reads database connection values from environment
variables.

## Personal and sensitive data

Collect, persist, process, return, and log only data needed for the intended
purpose.

Classify data before deciding controls. Relevant categories may include:

- CPF;
- email;
- phone;
- credentials;
- authentication tokens;
- employment-sensitive information;
- financial information if introduced.

Controls are selected by boundary and risk.

```text
database
→ storage/access protection when required

application
→ least-privilege access and policy

API response
→ omission, full disclosure, or masking according to need

logs
→ omission/redaction

exports/integrations
→ explicit purpose and authorization
```

Masking does not replace authorization. Masking is not automatically
anonymization. Encryption is not a substitute for access control.

## Disclosure rules

Before returning personal or sensitive data, determine:

1. whether the caller can access the resource;
2. whether the caller can access the property;
3. whether the complete value is necessary;
4. whether omission or masking is sufficient.

Do not expose a field merely because it exists in persistence.

## Logging

Do not log:

- passwords;
- bearer tokens;
- authorization headers;
- secret keys;
- sensitive request/response payloads without an explicit safe policy.

Operational usefulness does not justify uncontrolled sensitive-data disclosure.

## Browser security

The frontend treats external and user-controlled content as untrusted.

Do not weaken browser security merely to make integration easier.

Authentication/session behavior in the browser must match the accepted backend
authentication architecture once that architecture is defined.

## CORS and CSRF

CORS and CSRF policy depends on the selected authentication and deployment
architecture.

Do not choose permissive CORS or disable CSRF protection by default.

These controls must be configured from actual browser/backend topology and
authentication semantics.

## Data retention

Do not keep personal data indefinitely without business or legal purpose.

Retention requirements should be specified when capabilities introduce data for
which lifecycle matters.

## Security change policy

A feature spec may define capability-specific security behavior, such as who can
perform an action or which data may be disclosed.

If satisfying that behavior requires a project-wide security mechanism not yet
accepted, Research must stop before Plan until the architecture is explicitly
updated.

## Related implementation references

Backend security guidance includes:

- [authentication](../../.agents/skills/backend-development/references/security/authentication.md)
- [authorization](../../.agents/skills/backend-development/references/security/authorization.md)
- [JWT](../../.agents/skills/backend-development/references/security/jwt.md)
- [password security](../../.agents/skills/backend-development/references/security/password-security.md)
- [data protection](../../.agents/skills/backend-development/references/security/data-protection.md)
- [response obfuscation](../../.agents/skills/backend-development/references/security/response-obfuscation.md)
- [encryption](../../.agents/skills/backend-development/references/security/encryption.md)
- [secrets](../../.agents/skills/backend-development/references/security/secrets.md)
- [CORS and CSRF](../../.agents/skills/backend-development/references/security/cors-csrf.md)

Frontend security guidance lives under:

- `../../.agents/skills/frontend-development/references/security/`

Load only security references relevant to the capability and accepted mechanism.
