# Open Domain Decisions

Every entry is non-normative while `Status: Open`. Product decisions require
human authority and must be resolved before a dependent spec reaches Ready or
before directly authorized dependent implementation begins.

## DOMAIN-OPEN-001 — CPF mutability and uniqueness

**Status:** Open

Question: Is CPF editable, required and/or unique?

Boundaries: profile, validation, persistence, security and contracts.

## DOMAIN-OPEN-002 — Self-application and authorization roles

**Status:** Open

Question: May a user apply to a vacancy they published, and are candidate and
publisher distinct roles?

Boundaries: job-applications, vacancy-management and authorization.

## DOMAIN-OPEN-003 — Vacancy discovery behavior

**Status:** Open

Question: Which filters, search, ordering and pagination semantics are required?

Boundaries: vacancy-discovery, frontend and HTTP contract.

## DOMAIN-OPEN-004 — Vacancy drafts

**Status:** Open

Question: What minimum data permits saving, where are drafts recovered and what
is their final lifecycle?

Boundaries: vacancy-management, persistence, frontend and contracts.

## DOMAIN-OPEN-005 — Remuneration semantics

**Status:** Open

Question: May remuneration be zero, omitted or represented as “to be agreed”,
and which currency rules apply?

Boundaries: vacancy-management, domain model and contracts.

## DOMAIN-OPEN-006 — Vacancy and JobApplication workflows

**Status:** Open

Question: Which final states/transitions exist for vacancies and job
applications, including closing or modifying a published vacancy?

Boundaries: vacancy-management, job-applications, persistence and contracts.

## DOMAIN-OPEN-007 — Company

**Status:** Open

Question: Does `Company` exist, and what are its ownership responsibilities?

Boundaries: identity-access, vacancy-management, domain model and contracts.

## DOMAIN-OPEN-008 — Reference-data catalogs

**Status:** Open

Question: What are the authoritative values and sources for states, cities,
interests, education levels and employment types?

Boundaries: reference-data, persistence and contracts.

## DOMAIN-OPEN-009 — Profile save interaction

**Status:** Open

Question: Is profile persistence explicit-save or autosave?

Boundaries: user-profile, frontend and API behavior.
