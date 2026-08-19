# Encryption

Use encryption when data must remain recoverable but requires confidentiality
against unauthorized storage or infrastructure access.

Encryption is different from password hashing and response masking.

## Encrypt Only When the Threat Model Requires It

Use application- or database-level encryption for fields whose confidentiality
requirements justify the operational cost.

Do not encrypt every column mechanically.

Consider:

- data sensitivity;
- who must decrypt it;
- query requirements;
- key management;
- backup exposure;
- operational recovery.

## Use Established Cryptography

Use vetted platform or infrastructure cryptographic libraries and authenticated
encryption modes.

Do not design custom cryptographic algorithms or protocols.

## Key Separation

Keep encryption keys separate from encrypted data where practical.

Do not hardcode encryption keys in source code or committed configuration.

Key storage and rotation are part of the encryption design.

## Authenticated Encryption

Prefer authenticated encryption when encrypting application data so tampering
can be detected as well as confidentiality protected.

Do not use insecure or unauthenticated legacy cipher modes as new defaults.

## Search and Indexing

Encryption can make filtering, uniqueness checks, and indexing harder.

Design database access before choosing field-level encryption.

Do not decrypt large datasets in application memory merely to perform routine
searching.

## Rotation

Plan how encrypted data can survive key rotation.

Keep enough metadata to determine which key/version protected a value when the
rotation scheme requires it.

## Do Not Confuse Controls

```text
password        one-way adaptive hashing
response value  masking/obfuscation when appropriate
recoverable sensitive storage  encryption when required
```

Do not substitute one control for another.

## Avoid

- custom cryptography
- hardcoded keys
- encryption keys stored beside ciphertext without protection
- encrypting user passwords
- encryption without a key-rotation strategy when long-lived data requires it
- field encryption added without considering query behavior
