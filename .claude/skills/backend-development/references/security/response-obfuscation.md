# Response Obfuscation

Mask personal or sensitive response values when the caller may receive the
property but does not need the complete value.

Use type-specific obfuscation policies.

## Contents

- [Strategy Contract](#strategy-contract)
- [One Policy per Data Type](#one-policy-per-data-type)
- [Stable Masking Rules](#stable-masking-rules)
- [Response Mapping](#response-mapping)
- [Authorization First](#authorization-first)
- [Null and Invalid Input](#null-and-invalid-input)
- [Separate Storage Protection](#separate-storage-protection)
- [Avoid](#avoid)

## Strategy Contract

Use a small common strategy contract:

```java
public interface Obfuscator<T> {

    T obfuscate(T value);
}
```

Define semantic contracts for each protected data type.

Example:

```java
public interface EmailObfuscator extends Obfuscator<String> {
}

public interface CpfObfuscator extends Obfuscator<String> {
}
```

Implementations may be Spring-managed components when they are application
services used by response mapping.

## One Policy per Data Type

Prefer dedicated implementations such as:

```text
DefaultEmailObfuscator
DefaultCpfObfuscator
DefaultPhoneObfuscator
```

Do not centralize unrelated masking rules in a generic utility with a large
type switch.

## Stable Masking Rules

Each obfuscator should have a deterministic documented output policy.

Examples of policy decisions include:

```text
email  preserve only enough characters to help the user recognize the address
CPF    preserve only the minimum suffix required by the use case
phone  preserve only a limited suffix when recognition is required
```

The exact visible characters are project policy.

Do not reveal more characters simply because the formatting is convenient.

## Response Mapping

Apply obfuscation while constructing the response representation when the
contract requires a masked value.

Example boundary:

```text
Domain/Application result
        ↓
Response Mapper
        ↓
EmailObfuscator / CpfObfuscator
        ↓
Response DTO
```

Do not mutate the stored value solely to produce a masked response.

## Authorization First

Obfuscation is not an access-control decision.

If the caller must not receive a property, omit it or deny access instead of
returning a masked value automatically.

## Null and Invalid Input

Define predictable behavior for absent or malformed values.

Do not accidentally return the full input when an obfuscator cannot parse it.

Prefer a safe failure policy that does not disclose additional information.

## Separate Storage Protection

Response obfuscators are not encryption services.

Do not reuse `Obfuscator` for database encryption, password hashing,
tokenization, or anonymization.

## Avoid

- one generic switch-based masking utility for every data type
- returning full values when parsing fails
- masking used instead of authorization
- overwriting persisted data with masked values
- treating masked output as anonymized data
- exposing implementation-specific formatting as business logic
