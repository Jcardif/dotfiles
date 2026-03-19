<!-- markdownlint-disable MD013 -->

# UI/UX Foundations

Use these principles to make concrete design decisions. This is the working playbook for screen design, component design, and design-to-code translation.

## 1. Signifiers and affordances

Interfaces should communicate behavior without needing a tutorial.

- Group related items with containers, spacing, and alignment so the relationship is obvious.
- Use selected states to show what is active and what can be toggled.
- Gray out or mute inactive content only when it is truly unavailable.
- Make clickable things look clickable through shape, contrast, cursor behavior, hover states, focus states, or icon treatment.
- Use tooltips, helper text, and affordances to clarify non-obvious controls, not to compensate for bad structure.

Ask yourself: can a user tell what is interactive, selected, unavailable, or dangerous at a glance?

## 2. Hierarchy

Hierarchy is how the interface tells the user where to look first.

- Put the most important content near the top or start of a scan path.
- Create contrast with size, weight, position, color, and spacing.
- Make primary information larger and bolder.
- Push secondary information down the hierarchy with smaller size, lighter weight, reduced contrast, or supporting placement.
- Use images when they materially improve recognition or scanning, not as filler.
- Use icons and directional cues to compress obvious meaning when they genuinely reduce reading effort.

Do not make everything loud. If all elements compete equally, the design is just yelling.

## 3. Layout, whitespace, and grids

Whitespace is a structural tool, not empty space.

- Start by grouping content that belongs together, then create larger gaps between groups.
- Use consistent spacing multiples so the screen feels coherent.
- Favor a 4-point spacing system because it splits cleanly and scales well.
- Grids are useful for repeated or responsive content such as galleries, dashboards, blog cards, and structured layouts.
- Do not force every design into a rigid 12-column religion, especially for custom landing pages or expressive compositions.
- For responsive work, define how layouts simplify on tablet and mobile instead of hoping flexbox has a spiritual experience.

Good spacing makes the grouping legible before the user reads the copy.

## 4. Typography

Most interfaces need discipline more than novelty.

- Default to one strong sans-serif family unless the product has a clear reason to do otherwise.
- Keep the number of font sizes under control. Marketing pages can stretch wider, but most interfaces should feel tight and purposeful.
- Dashboards and dense product UIs usually need a smaller size range than landing pages.
- For large headings, slightly tighter letter spacing and lower line height usually improve polish fast.
- Use typography to support hierarchy, not to show off how many font weights you found.
- Labels, helper text, metadata, and body copy should feel related, not randomly scaled.

If the type system looks improvised, the rest of the UI usually follows it into the ditch.

## 5. Color and semantics

Color should carry meaning before it carries vibes.

- Start with one primary brand or accent color.
- Build lighter and darker steps from it for surfaces, emphasis, and text if needed.
- Use semantic colors intentionally:
- blue often signals trust, action, or focus
- green signals success or completion
- yellow or amber signals caution
- red signals danger, destructive actions, or errors
- Do not use accent colors as decoration when they do not mean anything.
- Preserve contrast and readability over palette cleverness.

If a color choice does not help orientation, feedback, or hierarchy, question why it exists.

## 6. Dark mode and depth

Dark mode is not light mode with the lights turned off.

- Lower border contrast in dark mode. Harsh borders can feel noisy fast.
- Create depth through surface relationships, usually with lighter surfaces on darker backgrounds.
- Reduce saturation and brightness for chips and accents that feel too electric.
- Light mode benefits from subtle shadows. Dark mode often benefits more from tonal layering.
- Shadows should be soft and supportive. Cards need less depth than popovers, menus, or dialogs.
- If the shadow is the first visual feature anyone notices, tone it down.

Depth should clarify stacking and focus, not cosplay as cinematic lighting.

## 7. Icons, buttons, and components

Components should feel like members of the same family.

- Size icons to align with the text system, often close to the line height of the paired text.
- Keep icon usage purposeful and consistent.
- Treat sidebar links, segmented controls, pills, and ghost buttons as stateful interaction patterns, not isolated decoration.
- Good button padding is balanced and deliberate. Horizontal padding is often roughly double the vertical padding.
- When primary and secondary actions sit together, make the priority obvious through fill, contrast, and order.
- Keep repeated component structure stable so users can learn it once and reuse the knowledge.

## 8. States and feedback

Every meaningful interaction needs a response.

- Buttons usually need default, hover, pressed, and disabled states.
- Add loading states when actions take time.
- Inputs need focus states, error states, and supporting messages when validation matters.
- Warning and success states should be explicit when the workflow benefits from them.
- Show loading, success, failure, and empty states across the whole interface, not just inside form controls.
- Users should never wonder whether the interface noticed what they just did.

No feedback means the product feels broken, even when it technically works.

## 9. Micro interactions

Micro interactions are small confirmations that make the system feel responsive.

- Use them to confirm an action, reveal state change, or reduce ambiguity.
- Favor functional motion, such as a copied confirmation, inline success transition, or selection animation.
- Keep them brief and tied to a real event.
- Do not add motion that exists only to look expensive.

Useful motion earns its keep. Decorative motion gets old in about six minutes.

## 10. Overlays, gradients, and readability on images

Text over imagery needs help or it will betray you.

- Use overlays or gradients to preserve text readability while keeping the image visible.
- Prefer directional gradients when they support the composition better than a flat dark wash.
- Progressive blur can work when the visual language calls for it, but it should support readability, not become the main event.
- Verify contrast where text actually sits, not just in the part of the image you wish mattered.

The image is there to support the content. If it murders the text, the image loses.

## 11. Design-tool and implementation translation

The design is not complete until the interaction model survives contact with real constraints.

- In Figma or Penpot, define reusable components, variants, constraints, and responsive intent.
- In code, preserve those decisions with tokens, reusable classes, variant props, and accessible semantics.
- Design for real data lengths, empty states, and error cases.
- Check scanability, hierarchy, and state clarity after the design becomes real code.
- Do not ship a pretty mockup and then implement a cheaper, blander version that drops half the states.

## 12. Default review checklist

Use this when critiquing or refining a screen:

1. What is the primary action?
2. What should the user notice first?
3. Which items are grouped, selected, disabled, or secondary, and is that obvious?
4. Does spacing reinforce grouping and flow?
5. Does typography create order or just occupy pixels?
6. Is color doing semantic work?
7. Are all relevant interaction states represented?
8. Does the design survive responsive compression?
9. Would the interface still make sense without explanatory copy?
