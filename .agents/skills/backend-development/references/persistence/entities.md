# Persistence Entities

Treat JPA entities as persistence models whose shape and lifecycle are influenced
by relational storage.

Do not let persistence convenience dictate domain or HTTP contracts.

## Persistence Boundary

Keep persistence concerns inside the infrastructure/persistence boundary when
the project uses a separate domain model.

Typical direction:

```text
Domain / Application
        ↑
Persistence Adapter
        ↓
JPA Entity
```

Do not expose JPA entities directly as REST request or response DTOs.

## Separate Domain and JPA Models When the Boundary Matters

Use separate domain and persistence models when doing so protects:

- business invariants;
- domain behavior;
- persistence independence;
- API independence;
- aggregate boundaries.

Do not duplicate models mechanically for trivial CRUD where the additional
mapping provides no useful boundary.

## Entity Identity

Define entity identity deliberately.

Do not include mutable business fields in equality merely because they exist.

Be especially careful with generated `equals` and `hashCode` on persistence
entities.

## Controlled Mutation

Expose only the mutation required by persistence and domain behavior.

Do not add setters for every field by default.

When Lombok is used, avoid `@Data` as the default for JPA entities.

## Database Constraints

Use database constraints for invariants that must remain true regardless of the
application code path.

Examples include:

- `NOT NULL`;
- unique constraints;
- foreign keys;
- check constraints where supported and appropriate.

Application validation does not replace database integrity constraints.

## Identifiers

Choose identifier strategies intentionally.

Do not expose persistence-generated identifiers as domain meaning unless they
actually represent the business identity.

## Sensitive Fields

Do not assume an entity field may be logged, serialized, or returned merely
because it is persisted.

Sensitive-data storage and encryption policy belongs to the security
references.

## Avoid

- JPA entities as HTTP DTOs
- `@Data` on entities by default
- setters for every field without a mutation need
- equality based casually on mutable associations
- persistence annotations leaking through unrelated application contracts
- duplicate domain/JPA models with no boundary benefit
- relying only on application validation for database integrity
