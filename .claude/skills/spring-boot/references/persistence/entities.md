# Entities — Spring Boot and JPA mechanisms

Stack mechanisms for the `persistence/entities.md` concern reference. The rule lives in the
concern reference; this file states how Spring Boot and JPA expresses it.

## Separate Domain and JPA Models When the Boundary Matters

Use separate domain and persistence models when doing so protects:

- business invariants;
- domain behavior;
- persistence independence;
- API independence;
- aggregate boundaries.

Do not duplicate models mechanically for trivial CRUD where the additional
mapping provides no useful boundary.
