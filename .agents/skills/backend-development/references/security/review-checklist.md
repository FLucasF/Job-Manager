# Security Review Checklist

Use this checklist after reading the security references relevant to the change.

Do not use this checklist as a substitute for the detailed references.

## Authentication

- [ ] Authentication is handled by Spring Security rather than controllers.
- [ ] Anonymous endpoints are explicit and minimal.
- [ ] Authentication failures do not expose unnecessary account/provider details.
- [ ] Inner application code does not depend unnecessarily on servlet authentication objects.
- [ ] Account state is enforced where the product supports it.

## Authorization

- [ ] Authentication is not treated as authorization.
- [ ] Protected endpoints follow a deny-by-default authorization posture.
- [ ] User-supplied object IDs receive object-level authorization checks.
- [ ] Sensitive properties have explicit disclosure rules.
- [ ] Privileged functions have server-side authorization.
- [ ] Frontend visibility is not relied upon as access control.

## JWT

- [ ] JWT validation is owned by Spring Security or another approved framework boundary.
- [ ] Signature and required issuer/audience/time claims are validated.
- [ ] Tokens contain only necessary claims.
- [ ] Sensitive PII is not embedded without a concrete need.
- [ ] Bearer tokens are not placed in URLs or logs.
- [ ] Token lifetimes and key management are intentional.

## Passwords

- [ ] Passwords use an adaptive one-way `PasswordEncoder`.
- [ ] Passwords are never stored plaintext or reversibly encrypted.
- [ ] Raw fast hashes are not used for password storage.
- [ ] Password comparison uses the encoder/provider rather than string equality.
- [ ] Passwords and hashes are absent from responses and logs.

## Data Protection

- [ ] Personal data collection and disclosure are limited to what the feature needs.
- [ ] Sensitive fields have explicit storage, access, response, and logging policies.
- [ ] Masking is not used as a substitute for authorization.
- [ ] Masking is not incorrectly described as anonymization.
- [ ] New logs, exports, fields, and integrations were reviewed for data exposure.
- [ ] Retention requirements were considered where the feature creates new personal data.

## Response Obfuscation

- [ ] Each masked data type uses a dedicated semantic obfuscator contract.
- [ ] `EmailObfuscator`, `CpfObfuscator`, and similar policies are not combined into a generic type switch.
- [ ] Malformed input cannot cause the full sensitive value to be returned.
- [ ] Response masking occurs at the disclosure/mapping boundary.
- [ ] Persisted source values are not overwritten with masked values.
- [ ] Callers who must not receive a field do not receive it merely in masked form.

## Encryption and Secrets

- [ ] Recoverable sensitive data is encrypted only where the threat model requires it.
- [ ] Established authenticated cryptography is used rather than custom algorithms.
- [ ] Encryption/signing secrets are not committed to source control.
- [ ] Key rotation is possible where long-lived encrypted/signed data requires it.
- [ ] Password hashing, encryption, and masking are not conflated.
- [ ] Critical secrets have no weak fallback defaults.

## Sensitive Logging

- [ ] Credentials, tokens, secret keys, and authorization headers are never logged.
- [ ] Personal data is omitted or minimized in logs.
- [ ] Entire request/response/entity objects are not logged by default.
- [ ] Debug/trace logging does not reveal secrets.
- [ ] Redaction uses a deliberate shared policy rather than ad-hoc string manipulation.

## CORS and CSRF

- [ ] Production CORS allows only required origins/methods/headers.
- [ ] CORS is not treated as authorization.
- [ ] CSRF configuration matches the actual browser credential transport.
- [ ] CSRF was not disabled merely because the application is called a REST API.
- [ ] State-changing GET endpoints were not introduced to bypass CSRF.
- [ ] SPA cookie/session flows integrate with CSRF protection when applicable.

## Final Review

- [ ] Security controls exist at the correct boundary instead of being duplicated ad hoc.
- [ ] Sensitive information is protected in storage, access, responses, and logs according to its use.
- [ ] The implementation follows least privilege and minimizes exposed data.
- [ ] Added security abstractions solve a concrete threat rather than creating ceremonial complexity.
