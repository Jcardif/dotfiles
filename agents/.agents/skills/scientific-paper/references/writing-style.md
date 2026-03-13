# Academic Writing Style Guide

## Sentence-level principles

### Clarity over elegance

The goal is to transfer understanding from the author's mind to the reader's. Every sentence should be parseable on first reading.

**Bad**: "The heretofore unaddressed lacuna in the extant body of scholarly discourse pertaining to the optimization of neural architectures necessitates a novel methodological paradigm."

**Good**: "No existing method efficiently searches the space of neural architectures under memory constraints. This paper proposes one."

### Active voice

Active voice is shorter, clearer, and assigns responsibility.

| Passive (avoid) | Active (prefer) |
| ----------------- | ----------------- |
| It was shown that the formula converges | We show that the formula converges |
| The parameters were estimated using MLE | We estimate the parameters using MLE |
| An assumption is made that... | We assume that... |

Exception: Use passive when the actor is irrelevant or unknown ("Data was collected over 20 months" is fine if who collected it does not matter).

### One idea per sentence

If a sentence contains "and" connecting two independent ideas, split it.

**Bad**: "The model receives an input vector and the hidden layer applies a nonlinear activation and the output layer produces a probability distribution."

**Good**: "The model receives an input vector. The hidden layer applies a nonlinear activation. The output layer produces a probability distribution."

### One idea per paragraph

Each paragraph should:

1. Open with a **topic sentence** stating the paragraph's claim
1. Support that claim with evidence, reasoning, or examples
1. Close with a transition or implication

If a paragraph makes two claims, split it into two paragraphs.

## Word choice

### Precision

| Imprecise | Precise |
| ----------- | --------- |
| a lot of | 12 (use the actual number) |
| significantly | statistically significant at $p < 0.05$ (or use a different word if you mean "substantially") |
| various | three (name them) |
| etc. | (list all items, or use "such as" with representative examples) |
| things | (name the specific items) |

### Words and phrases to avoid

| Avoid | Why | Use instead |
| ----- | --- | ----------- |
| "clearly" / "obviously" | If it were clear, you would not need to say so | (delete, or explain why) |
| "it is well known that" | Either cite a source or omit | (cite the source) |
| "very" / "extremely" | Vague intensifiers add no precision | Quantify or remove |
| "trivially" | Dismissive; what is trivial to the author may not be to the reader | (show the step) |
| "simple" / "straightforward" | Same problem as "trivially" | (just present it) |
| "in order to" | Wordy | "to" |
| "it should be noted that" | Throat-clearing | (just state the thing) |
| "the fact that" | Usually deletable | (rephrase) |
| "we believe" | In a proof-based paper, beliefs are irrelevant | "we conjecture" or "we show" |
| "utilize" | Pompous synonym for "use" | "use" |
| "methodology" | Often a pompous synonym for "method" | "method" (unless discussing the study of methods) |
| "prove" | Science does not prove; it supports or refutes | "support", "demonstrate", "provide evidence for" |
| "significant" (non-statistical) | Means something specific in statistics; do not use casually | Quantify, or use "substantial", "notable" |
| "attempts" | Implies uncertainty about your own methodology | "we performed", "we applied" |

### Demonstrative pronouns need nouns

Always follow "this", "that", "these", "those" with a noun. Bare demonstratives create ambiguity.

**Bad**: "This shows that the method works."
**Good**: "This result shows that the method works."

### Prefer repetition over misleading synonyms

Repeating a technical term is clearer than varying it. Using "survey", "questionnaire", and "assessment" interchangeably implies three different instruments. Weak ideas create dullness, not word repetition.

### Failure mode analysis for sentences

For each sentence, ask: could a reader misparse this? Ambiguity in scientific writing is not a style issue — it is an error. Common sources:

- Dangling participles ("Using gradient descent, the loss decreased" — the loss did not use gradient descent)
- Unclear pronoun antecedents (if "it" could refer to two things, use the noun instead)
- Stacked noun phrases ("acoustic noise source location technique" — break up with prepositions)

### Hedging appropriately

Hedge when genuinely uncertain. Do not hedge established facts.

**Over-hedged**: "It seems plausible that 2 + 2 might potentially equal 4."

**Under-hedged**: "This method is optimal for all datasets." (Without proof of optimality)

**Appropriate**: "The results suggest that the proposed regularization improves generalization on small datasets, though this conclusion depends on the assumptions stated in Section 3."

## Structural conventions

### Section introductions

Each major section should begin with 1-2 sentences explaining what the section covers and why:

**Bad** (diving straight in):
> **Section 3: Model**
> Let $M = \{1, 2, \ldots, n\}$ be the set of members...

**Good** (orienting the reader):
> **Section 3: Model**
> This section formalizes the proposed optimization framework. We first define the notation (Section 3.1), then state the assumptions (Section 3.2), and finally derive the convergence bounds (Section 3.3).
>
> Let $\mathcal{D} = \{(x_i, y_i)\}_{i=1}^{n}$ be the training set...

### Transitions

The reader should always know **why** they are reading the current paragraph. Transitions connect the previous idea to the next.

**No transition** (jarring):
> "...the gradient of the loss is thus $\nabla \mathcal{L} = X^T(X\theta - y)$.
>
> Stochastic gradient descent samples a mini-batch."

**With transition** (smooth):
> "...the gradient of the loss is thus $\nabla \mathcal{L} = X^T(X\theta - y)$.
>
> Computing this gradient over the full dataset is expensive for large $n$. Stochastic gradient descent addresses this by sampling a mini-batch at each step, trading exact gradients for computational efficiency."

### Notation introduction

When a section introduces new notation, consider a brief notation summary at the start:

```latex
\paragraph{Notation.}
Throughout this section, $n$ denotes the number of samples, $d$ the
dimensionality, $\theta \in \mathbb{R}^d$ the parameter vector, and
$\mathcal{L}(\theta)$ the loss function.
```

## Numbers and units

- Spell out numbers below 10 in prose ("three funds"), use digits for 10 and above ("12 members")
- Always use digits with units ("5 days", not "five days")
- Use thin spaces in large numbers: `1{,}000{,}000` or `\num{1000000}` with siunitx
- Units: define the notation once (e.g., "ms" for milliseconds) and use consistently
- Percentages: use `\%` in LaTeX, decide between "percent" and "%" and be consistent

## Common structural anti-patterns

### The literature dump

Listing papers without synthesis. Each cited work should serve the narrative.

### The methodology island

Describing methodology disconnected from the problem. The reader should understand *why* each methodological choice is made.

### The results graveyard

Presenting results without interpretation. Every result should be followed by "This means..." or "This implies..."

### The conclusion that is just a summary

The conclusion should state the **contributions** (what is new because of this paper), not re-summarize the paper. It should also state limitations and future work.

### The missing assumptions

Using formulas that only hold under certain conditions without stating those conditions. Always state: "Under Assumptions 1-3, the following holds..."

### The methods without rationale

Describing *what* was done without explaining *why*. For every methodological choice, state the purpose ("To estimate X, we used Y"), explain why this method is appropriate, and briefly justify rejecting alternatives.
