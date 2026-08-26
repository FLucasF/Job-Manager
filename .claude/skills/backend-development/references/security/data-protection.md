# Data Protection

Protect personal and sensitive data according to necessity, purpose, access,
storage, and disclosure risk.

Security controls support privacy obligations but do not by themselves prove
legal compliance.

## Minimize Data

Collect, persist, process, return, and log only data required for the intended
purpose.

Do not expose a field merely because it exists in the database.

## Classify Before Protecting

Identify data that requires stronger handling, for example:

```text
CPF
email
phone
credentials
authentication tokens
financial or employment-sensitive information
```

Use the classification to drive authorization, masking, encryption, logging,
retention, and auditing decisions.

## Protect by Boundary

Apply controls according to the boundary:

```text
database       encryption/access controls when required
application    least-privilege access
API response   omission or masking when full disclosure is unnecessary
logs           redaction/omission
exports        explicit authorization and purpose
```

Do not rely on one control to protect every boundary.

## Data Disclosure

Before returning personal data, determine:

1. whether the caller may access the resource;
2. whether the caller may access the property;
3. whether the full value is necessary;
4. whether omission or masking is sufficient.

Masking does not replace authorization.

## Pseudonymization and Anonymization

Do not call simple masking or token replacement "anonymization" without an
appropriate re-identification risk assessment.

Treat anonymization as a separate privacy process.

## Retention

Do not keep personal data indefinitely without a business or legal retention
reason.

Deletion and retention rules should consider backups, audit records, derived
data, and external systems when applicable.

## Security by Design

Review data protection when adding:

- new fields;
- new responses;
- new logs;
- new exports;
- new integrations;
- new database copies.

Do not defer privacy controls until after a feature is complete.

## Avoid

- unnecessary personal data collection
- full sensitive values in generic responses
- assuming masking equals authorization
- calling masking anonymization
- indefinite retention without purpose
- duplicating personal data across logs and audit records
