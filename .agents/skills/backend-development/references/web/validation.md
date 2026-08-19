# Web Validation

Validate external input at the web boundary and keep business invariants in the
appropriate application or domain boundary.

Use Bean Validation for structural input constraints.

## Validate Request DTOs

Use constraints for requirements such as:

- required values;
- length limits;
- numeric ranges;
- syntactic formats;
- collection size limits.

Example:

```java
public record CreateVacancyRequest(
    @NotBlank
    @Size(max = 120)
    String title
) {}
```

Apply validation at the controller boundary with `@Valid` or the validation
mechanism required by the endpoint.

## Structural Validation vs Business Rules

Web validation answers questions such as:

```text
Is this field present?
Is the value within an allowed structural range?
Is the input syntactically valid?
```

Application or domain validation answers questions such as:

```text
Can this worker apply to this vacancy?
Can a closed vacancy be edited?
Does this transition violate a business invariant?
```

Do not place database-dependent or workflow-dependent business rules in DTO
annotations.

## Do Not Duplicate Rules Without Purpose

If a rule belongs to the domain, do not reproduce it independently in multiple
controllers.

Boundary validation may still enforce transport-specific limits that protect the
API.

## Validation Errors

Expose validation failures through the project's standard API error format.

Do not leak internal exception details or framework stack information.

## Defensive Limits

Apply reasonable limits to externally controlled collections, strings,
pagination sizes, uploads, or other potentially expensive inputs.

Security-specific abuse controls belong to the security references.

## Avoid

- business workflows inside custom Bean Validation annotations
- controller `if` chains duplicating domain rules
- unbounded user-controlled input
- inconsistent validation error formats
- accepting invalid input and relying on persistence errors as validation
