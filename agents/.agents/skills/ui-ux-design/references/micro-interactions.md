<!-- markdownlint-disable MD013 -->

# UI Micro Interactions

Use this guide when the task involves motion, feedback, or interaction polish in Figma, Penpot, or production code.

Micro interactions should make the interface feel more understandable and more satisfying. They should not feel like the UI is desperate for attention.

## 1. Motion principles

- Tie motion to a real event: hover, focus, click, press, drag, load, success, error, or reveal.
- Use motion to confirm state change, explain causality, or reduce ambiguity.
- Keep the transition readable and short.
- Avoid animation that only exists because the static layout felt undercooked.

Good motion clarifies. Bad motion performs.

## 2. Button interactions

Buttons should feel responsive without needing five extra colors and a prayer.

- Hover can move text, icons, or fills in a controlled way instead of just swapping to a random darker tint.
- Pressed states can slightly reduce scale or compress depth to feel tactile.
- Sliding text reveals, masked text swaps, and directional hover motion can add polish when they still preserve readability.
- Keep the button recognizable in all states.

Use animation to reinforce the button's responsiveness, not to turn it into a slot machine.

## 3. Keyboard shortcuts and success confirmation

Shortcut-heavy interfaces need memorable feedback.

- Visually acknowledge the shortcut when the user triggers it.
- Use a compact success confirmation to reinforce the action.
- This is especially useful when the shortcut itself would otherwise disappear into muscle memory.

If the action fires and nothing visibly confirms it, the interface feels uncertain.

## 4. Toast notifications

Toasts are feedback, not decorative confetti cannons.

- A toast should communicate what happened, whether work is loading, and whether the user needs to care.
- Slide, fade, and stagger can help it arrive and leave cleanly.
- Rich toasts can include loading, success, or celebratory states when the product voice supports it.
- Particle effects or overly cute motion should be rare and justified. Most apps are not a birthday party.

## 5. Hover reveals and contextual labels

Hover is a cheap way to expose more meaning without crowding the layout.

- Use hover labels for avatars, dense icon rows, and hidden metadata.
- Name tags, small cards, and image previews can work well when they support discovery.
- Delay tooltips slightly so they feel intentional rather than twitchy.
- Use hover reveals to show more context, not to hide critical information that should have been visible.

If the product breaks on touch because all the meaning lives in hover, you built a trap.

## 6. Tooltips

Tooltips are for explanation, not for making unlabeled chaos acceptable.

- Use delayed appearance when there are many icons or controls in a compact area.
- Keep the content short and specific.
- Make the motion soft and supportive.
- Pair tooltip behavior with accessible alternatives in code.

## 7. Text and media hover pop-outs

Hover-driven previews can make dense content more informative.

- Use image or media pop-outs to preview the thing being referenced.
- Keep the transition light enough that it feels attached to the trigger.
- Use this pattern when it saves space and reduces explanatory copy.

This is one of the few places where playful interaction can still be useful.

## 8. Shimmer and animated strokes

Animated strokes can add a modern feel, but they are easy to overcook.

- Use shimmer effects sparingly around highlighted controls or premium surfaces.
- Keep the motion subtle and clean.
- Make sure the effect supports the component instead of hijacking it.
- If the behavior is visually intense, consider letting users pause it or reducing motion in production.

Shimmer is garnish, not dinner.

## 9. Progress and form feedback

Forms are tedious. Motion can make progress feel more tangible.

- Use progress bars to show movement toward completion, not just current position.
- Animate progress in ways that make the system feel responsive and intentional.
- Combine progress with contextual feedback when the user needs reassurance that work is happening.

## 10. Card swipe and stacked motion

Stacked cards, notifications, and queue-like patterns benefit from spatial logic.

- When the front card leaves, the cards behind it should advance to fill the space.
- Use rotation, fade, and scale together carefully so the stack feels physical but not goofy.
- Movement should reveal order and progression, not just make things fly around.

If the cards move but the stack logic makes no sense, the effect falls apart fast.

## 11. Search expansion and control transformation

Condensed controls can expand elegantly when the action deserves focus.

- Search icons expanding into search fields are a strong pattern when space is tight.
- The transition should explain where the larger control came from.
- Hide and reveal supporting elements in sequence so the expansion feels deliberate.

The interaction should feel like the control unfolded from itself, not teleported in.

## 12. Upgrade, limits, and plan feedback

Hover and reveal patterns can clarify product limits without feeling hostile.

- Use hover or focus details to explain what an upgrade unlocks.
- Prefer additive explanations over hostile crossed-out text theatrics.
- The message should help the user understand value, not just rub their face in the paywall.

## 13. Figma and Penpot implementation notes

When prototyping these patterns in design tools:

- Use components and variants for stateful elements.
- Keep timing, easing, and delay choices consistent across related interactions.
- Smart animate, masks, auto layout, and staged frames can cover most of these patterns.
- Prototype enough to communicate intent, not every pixel of runtime behavior.

## 14. Code implementation notes

When implementing in production code:

- Respect reduced-motion preferences when the platform supports them.
- Keep motion tied to accessible state changes.
- Avoid making essential information visible only on hover.
- Make timing and easing values reusable when a motion language starts repeating.

## 15. Motion review checklist

1. What state change or user action is this interaction explaining?
2. Would the interface still be understandable without the motion?
3. Does the motion improve clarity or only add flair?
4. Are timing and easing consistent with related interactions?
5. Is the effect still usable for touch, keyboard, and reduced-motion contexts?
