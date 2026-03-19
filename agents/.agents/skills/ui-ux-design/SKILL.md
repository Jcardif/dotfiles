---
name: ui-ux-design
description: UI/UX design skill for shaping product interfaces, interaction patterns, visual systems, presentation, and prototypes across Figma, Penpot, and frontend code. Use this whenever the task involves designing or refining screens, components, flows, states, layout, hierarchy, spacing, typography, color, icons, overlays, design presentations, mockups, micro interactions, or interaction feedback. Always use this alongside `uncodixfy` for frontend design work so the result is both well-designed and not generic AI sludge.
---

<!-- markdownlint-disable MD013 -->

# UI/UX Design

Use this skill as the positive-side design brain for frontend work. `uncodixfy` tells you what cheap AI patterns to avoid. This skill tells you what to build instead.

If the task touches frontend design in any form, use both skills together:

- Figma or Penpot exploration
- UI critiques and redesigns
- landing pages, dashboards, settings pages, forms, modals, and navigation
- component design systems and state modeling
- presentation decks, portfolio shots, showcase frames, mockups, and prototypes
- frontend implementation where layout, hierarchy, or polish matter

Detailed guidance lives in `references/`. Load the relevant files for the task instead of pretending "make it look better" is a complete plan.

## Operating model

1. Inspect the existing product, codebase, or mockup before making design calls.
2. Identify the job of the screen, the primary action, and the information hierarchy.
3. Load the relevant references for the task:
   - `references/foundations.md` for screen structure, hierarchy, spacing, typography, color, overlays, and state logic
   - `references/presentation.md` for portfolio shots, client-facing presentation, mockups, and multi-screen composition
   - `references/micro-interactions.md` for motion, feedback, state transitions, and prototype behavior
4. Translate design decisions into explicit structure: layout, spacing, type scale, color roles, states, feedback, and presentation context.
5. When implementing in code, preserve semantics and accessibility. Visual polish does not excuse broken interaction logic.
6. When working in Figma or Penpot, think in components, variants, spacing systems, reusable tokens, and prototype flows, not one-off pretty rectangles.
7. Before finishing, audit the work for signifiers, hierarchy, spacing, states, responsiveness, and if applicable, presentation quality and motion quality.

## Skill contract

- Treat signifiers as core product behavior, not decoration. Users should understand what is clickable, selected, disabled, loading, dangerous, or successful without needing instructions.
- Create hierarchy with contrast, not noise. Size, position, weight, spacing, and color should make importance obvious.
- Prefer whitespace and grouping over excessive grid worship. Use grids when the content is structured, not as a religion.
- Keep typography disciplined. Usually one type family is enough.
- Use color with meaning. Accent color should help the user act or orient, not just make the screen louder.
- Every interaction needs feedback. Hover, focus, pressed, disabled, loading, success, and error states are not optional when they apply.
- Depth should be subtle. If the shadow is what people notice first, you messed it up.
- Micro interactions should confirm meaning, not perform jazz hands.
- Presentation matters. A strong design shown badly looks unfinished, and a weak design dressed up too hard looks dishonest.

## Working alongside `uncodixfy`

When both skills are active:

- `uncodixfy` blocks generic AI aesthetics, fake-premium fluff, and templated SaaS sludge.
- `ui-ux-design` supplies the system of hierarchy, states, spacing, semantics, and feedback that makes the interface actually usable.

Do not let one replace the other. A design can be non-generic and still be bad. That is a very real and very annoying failure mode.

## Figma and Penpot expectations

When the task is design-tool work rather than code:

- define components and variants for interactive elements
- specify spacing, sizing, and typography tokens
- show state changes explicitly instead of leaving them implied
- prototype key transitions when motion, hidden behavior, or feedback matter
- preserve hierarchy across desktop, tablet, and mobile
- use frames, auto layout, constraints, and reusable patterns instead of manual pixel shoving

## Code implementation expectations

When the task is frontend code:

- encode the design system in reusable variables, tokens, or shared styles that match the repo's patterns
- implement all required states for interactive controls
- keep icons, labels, spacing, and alignment consistent across related components
- design for real content, empty states, error states, and loading states
- implement motion sparingly, with purpose, and in support of state clarity
- ensure responsive behavior is intentional, not just stacked until it stops screaming

## Presentation expectations

When the task involves presenting or showcasing UI:

- pick the presentation mode that matches the goal: creative showcase, professional review, client confidence, or product storytelling
- make the design the star, not the background gimmick
- use mockups and prototype clips when they help people understand the product in context
- for multi-screen displays, compose the frames intentionally instead of dumping them into a dead grid
- prefer realism and clarity in client work, and controlled drama in portfolio work

## Required pre-finish audit

Before you mark the task complete, check:

- Are the primary actions obvious?
- Are selected, inactive, destructive, and loading states clearly signified?
- Is the visual hierarchy obvious without reading everything?
- Is spacing doing real grouping work?
- Are typography choices disciplined and consistent?
- Is color semantic and restrained?
- Does the design still make sense on smaller screens?
- If the task includes presentation, does the framing support the design instead of overpowering it?
- If the task includes motion, do the transitions communicate state and feedback instead of showing off?
- If code was written, do the implemented states match the intended interaction model?

## Reference map

| Reference | Load when |
| --- | --- |
| [Foundations](references/foundations.md) | Any UI/UX design task involving hierarchy, spacing, typography, color, states, overlays, feedback, component behavior, or translating a design into code |
| [Presentation](references/presentation.md) | The task involves portfolios, Dribbble-style shots, social posts, design reviews, client presentations, mockups, collages, multi-screen layouts, or showing UI in context |
| [Micro Interactions](references/micro-interactions.md) | The task involves hover states, button motion, tooltips, toasts, progress indicators, search expansion, swipe cards, shimmer effects, prototype timing, or interaction polish |
