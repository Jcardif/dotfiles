# Research Methodology Reference

## Phase 1: Problem Formulation

The foundation of any rigorous paper. A poorly defined problem produces a poorly defined paper.

### The research question

Formulate a single, precise question the paper answers. Test it against these criteria:

| Criterion | Test |
| --------- | ---- |
| **Specific** | Can you explain the question in one sentence without jargon? |
| **Bounded** | Is it clear what is in scope and what is not? |
| **Answerable** | Can the question be resolved with the tools and data available? |
| **Significant** | Does the answer matter to someone? Who? |
| **Novel** | Does answering this contribute something that does not already exist? |

Bad: "How does machine learning work?"
Good: "Under what conditions does gradient descent converge to a global minimum for non-convex loss functions with Lipschitz-continuous gradients?"

### Motivation

Establish why the problem matters before solving it. Structure motivation as:

1. **Context**: What is the setting? Who are the stakeholders?
1. **Pain point**: What specific problem exists today?
1. **Consequence**: What happens if the problem remains unsolved?
1. **Opportunity**: What becomes possible with a solution?

### Scope and assumptions

Explicitly state:

- What the paper **will** address
- What the paper **will not** address (and why)
- What is **assumed** to be true (and under what conditions those assumptions break)

Every assumption should be numbered and referenced when invoked later in the paper.

## Phase 2: Literature and Prior Art

### Purpose

Literature review is not a formality. It serves three functions:

1. **Establish credibility**: Show command of the field
1. **Identify the gap**: Demonstrate that this specific problem is unsolved or inadequately solved
1. **Position the contribution**: Show where this work fits in the landscape

### Process

1. **Survey broadly first**: Identify the major themes, seminal works, and active research directions
1. **Narrow to relevance**: Focus on work directly related to the problem at hand
1. **Critically analyze**: For each relevant work, note:
   - What it accomplishes
   - What it does not address
   - How its approach relates to yours
1. **Synthesize, don't summarize**: Group works by approach or finding, not by author. The review should tell a story that leads logically to the gap your paper fills.

### Writing the literature review

Structure by **theme**, not by paper:

**Bad** (paper-by-paper summary):
> Smith (2020) studied X. Jones (2021) examined Y. Lee (2022) proposed Z.

**Good** (thematic synthesis):
> Three approaches to anomaly detection exist in the literature: statistical methods (Smith, 2020; Chen, 2019), deep learning approaches (Jones, 2021), and hybrid techniques (Lee, 2022). Statistical methods fail to scale when...

### The knowledge gap

The literature review must build to a **knowledge gap** — the specific thing that is not yet known, solved, or adequately addressed. This gap is the pivot point of the entire paper. The introduction narrows from broad context to specific background to the gap, and then your contribution fills it.

Without a clearly articulated gap, the paper has no justification.

### Citation standards

- Cite primary sources, not summaries of primary sources
- Every factual claim about prior work must have a citation
- Use "cf." when drawing a comparison, not when citing a direct source
- Distinguish "X showed that..." (citing a result) from "X argued that..." (citing an opinion)
- **Paraphrase, do not quote.** In scientific writing, direct quotation is rare. Reserve it for exact definitions or specific claims you intend to challenge. Paraphrase and summarize instead.
- Cite works that **both support and contradict** your position. Omitting contradictory evidence undermines credibility.

## Phase 3: Methodology

### Choosing an approach

Justify the methodology by answering:

1. **What alternatives exist?** List them.
1. **Why is this one appropriate?** What properties of the problem make this approach suitable?
1. **What are its limitations?** Be honest.

### Formal setup

- Define the mathematical or analytical framework **completely** before using it
- Introduce notation in a systematic order: sets first, then functions/operators, then variables
- Use a notation table if more than 10 symbols are introduced
- State all definitions formally using `\begin{definition}...\end{definition}`

### Assumptions

For each assumption:

1. **State it formally** (e.g., "Assumption 1: The noise term $\epsilon$ is i.i.d. with zero mean and finite variance.")
1. **Justify it** (why is this reasonable?)
1. **State what happens if it fails** (how sensitive are results to this assumption?)

## Phase 4: Development

### Building mathematical frameworks

- **Start from first principles.** Do not assume the reader shares your intuition.
- **Derive step by step.** Each equation should follow from the previous with clear justification.
- **Name intermediate results.** If a derivation produces a useful formula, give it a label (Lemma, Proposition) and reference it later.
- **Verify with special cases.** Does the formula produce expected results for boundary conditions (e.g., $n = 1$, uniform distribution, zero variance)?

### Proofs and derivations

- State the result first (Theorem/Proposition), then prove it
- Begin proofs with an informal sketch if the proof is longer than half a page
- End proofs with `\qed` or the equivalent
- If a proof is long, break it into lemmas

### Figure-driven narrative

Design the key figures and tables **before** writing prose. Each figure should convey one clear takeaway message supported by evidence. Arrange figures in the logical sequence that tells the story, then write the text around that sequence. This prevents both aimless prose and figures that feel disconnected from the narrative.

Every figure and table must be referenced in the text. If it is not discussed, it does not belong.

### Worked examples

- Include at least one worked example for every non-trivial formula
- Use realistic data (or clearly labeled synthetic data)
- Show intermediate calculations, not just the final answer
- Worked examples serve as implicit correctness checks

## Phase 5: Analysis and Discussion

### Separate reporting from interpretation

Quarantine observations from interpretations. Results describe **what** was found; Discussion explains **what it means**. Mixing them undermines both. When results are entangled with interpretation, future readers cannot re-evaluate your data under different theoretical frameworks.

Use careful phrasing to signal interpretation: "We infer that...", "This suggests...", "One explanation is..."

### Interpreting results

- **State what the results show** in plain language before the technical analysis
- **Compare with expectations**: Do results align with intuition? If not, explain why.
- **Sensitivity analysis**: How do results change under different assumptions or parameters?
- **Limitations**: What does this approach **not** capture? Be specific.

### Counterarguments and alternative hypotheses

Address alternative interpretations explicitly. A paper that ignores obvious counterarguments appears naive or dishonest. For each major claim:

- What is the strongest objection a knowledgeable reader could raise?
- What alternative explanation could account for the same evidence?
- Does the counterargument weaken your claim, or can you show why your interpretation is more compelling?

Present multiple hypotheses with even treatment. Do not dismiss alternatives without justification.

### Negative and null results

Report negative results honestly. Withholding them creates a false impression and biases the literature. If an approach was tried and failed, that is valuable information. State what did not work and why.

### Common pitfalls

- Overclaiming: stating results are "optimal" or "complete" without proof
- Ignoring edge cases: what happens at the boundaries ($n = 0$, empty input, degenerate cases)?
- Conflating precision with accuracy: many decimal places do not mean correctness
- Extrapolation beyond the model's domain of validity
- Assuming significance is self-evident: always explain *why* results matter, not just *what* they are

## Phase 6: Writing and Polish

### Structure for the reader

The reader's experience matters more than the author's process. The order of discovery is rarely the best order of presentation.

- **Tell them what you will tell them** (introduction)
- **Tell them** (body)
- **Tell them what you told them** (conclusion)

### The abstract

Write **last**. It should contain:

1. **Problem** (1-2 sentences): What problem does this paper address?
1. **Approach** (1-2 sentences): What method is used?
1. **Key results** (1-2 sentences): What are the main findings?
1. **Significance** (1 sentence): Why does this matter?

Target 150-300 words. No citations in the abstract. No undefined abbreviations.

### Self-review checklist

Before finalizing any section:

- Read it as if you have never seen the paper before. Does it make sense?
- Is every technical term defined?
- Does each paragraph serve a clear purpose?
- Are transitions between paragraphs logical?
- Could any sentence be deleted without losing meaning? If so, delete it.
- Are there any claims without evidence?
