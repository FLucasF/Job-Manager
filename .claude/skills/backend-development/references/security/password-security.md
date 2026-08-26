# Password Security

Store user passwords with a one-way adaptive password hash.

Passwords are credentials, not encrypted application data.

## Use PasswordEncoder

Use Spring Security's `PasswordEncoder` abstraction.

Choose an adaptive password hashing algorithm supported by the project, such as
bcrypt, PBKDF2, scrypt, or Argon2 according to deployment constraints.

Do not implement password hashing manually.

## Never Store Recoverable Passwords

Do not store passwords as:

- plaintext;
- reversible encryption;
- Base64 or other encoding;
- fast general-purpose hashes such as raw SHA-256.

The application should verify a password without being able to recover the
original value.

## Work Factor

Configure the adaptive hash cost for the deployment environment.

Review cost over time as hardware and threat assumptions change.

Do not hardcode an unusually weak cost merely to make tests faster.

Tests may use a test-specific encoder configuration when intentionally isolated
from production settings.

## Password Comparison

Use `PasswordEncoder.matches(...)` or the selected authentication provider.

Do not compare encoded strings manually.

Adaptive password encoders may use salts and changing encodings.

## Password Exposure

Never log:

- raw passwords;
- encoded password hashes;
- reset tokens.

Do not return password fields in API responses.

## Credential Change

When passwords change, ensure the new credential follows the same encoding
policy.

Consider invalidating or rotating active authentication state when the security
requirements justify it.

## Avoid

- plaintext passwords
- reversible encryption for user passwords
- manual hashing code
- raw SHA/MD5 password storage
- password hashes in responses or logs
- string equality for password verification
