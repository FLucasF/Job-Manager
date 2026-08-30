---
name: tailwind
description: Tailwind CSS idioms: layout, spacing and sizing, typography, backgrounds and borders, effects filters and masks, transforms and transitions, interactivity, responsive variants, theme customization and tooling integrations. Use as the styling overlay when the affected boundary uses Tailwind CSS. Load together with the concern skill that owns the decision. Do not use for other styling systems.
---

# Tailwind CSS

Styling overlay for the `tailwind` technology. It carries only idioms and APIs.

The concern skill owns the decision: frontend-development. Load it for the rule and load
this skill for the mechanism. When the two appear to disagree, the rule wins and
the disagreement is reported.

`CLAUDE.md` governs the spec gate, RPI workflow, architecture authority,
security, validation and completion. This skill authorizes no technology,
dependency, requirement or architecture.

## Reference Routing

- Flex, grid, positioning, stacking, overflow e layout:
  [layout.md](references/styling/layout.md)

- Spacing, dimensions, min/max sizing e viewport units:
  [spacing-sizing.md](references/styling/spacing-sizing.md)

- Typography, wrapping, truncation e font features:
  [typography.md](references/styling/typography.md)

- Backgrounds, gradients, borders, radius e outlines:
  [backgrounds-borders.md](references/styling/backgrounds-borders.md)

- Shadows, rings, filters, backdrop effects e masks:
  [effects-filters-masks.md](references/styling/effects-filters-masks.md)

- Transitions, animations, transforms, motion e perspective:
  [transforms-transitions.md](references/styling/transforms-transitions.md)

- Native controls, scrolling, pointer, touch e `will-change`:
  [interactivity.md](references/styling/interactivity.md)

- Breakpoints, container queries, states, ARIA/data variants e dark mode:
  [responsive-variants.md](references/styling/responsive-variants.md)

- `@theme`, tokens, custom utilities, custom variants, prefix e important:
  [theme-customization.md](references/styling/theme-customization.md)

- Vite, PostCSS, CLI, editor tooling e integrations:
  [tooling-integrations.md](references/styling/tooling-integrations.md)

- Revisão Tailwind:
  [review-checklist.md](references/styling/review-checklist.md)
