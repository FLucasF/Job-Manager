# Domain Documentation

The domain boundary contains project-specific vocabulary, candidate models,
candidate durable rules and discovery history. The current model/rules remain
Draft; they are refinement context, not normative authority for a Ready spec.

## Documents

- [Domain Model](domain-model.md) — Draft conceptual model and ubiquitous
  language;
- [Domain Rules and Invariants](domain-rules-invariants.md) — Draft candidate
  cross-feature rules with stable IDs;
- [Open Domain Decisions](open-decisions.md) — material unresolved questions;
- [Event Storming](event-storming.md) — non-normative discovery artifact.

## Authority

```text
spec.md Ready
→ feature behavior and applicable accepted domain rules

explicit user request
→ directly authorized feature behavior using accepted domain rules

domain model/rules Draft
→ refinement context only

open-decisions.md
→ unresolved questions; dependent work is blocked in either path

event-storming.md
→ discovery context and hotspots
```

A Ready spec must identify applicable rules and cannot cite a Draft rule or Open
decision as normative. Directly authorized work has the same restriction. If a
material rule is needed, resolve it in the correct owner or define legitimate
feature-local behavior explicitly without claiming project-wide authority.

## Change policy

Update domain documents when durable knowledge changes. Do not silently promote
Draft content, invent hotspot resolutions or infer requirements from examples.
