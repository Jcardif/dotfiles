# LaTeX Reference

## Essential packages

### Mathematics

```latex
\usepackage{amsmath}    % Core math environments (align, equation, etc.)
\usepackage{amssymb}    % Extended math symbols (\mathbb, \mathfrak, etc.)
\usepackage{amsthm}     % Theorem environments with proof
\usepackage{mathtools}  % Extensions to amsmath (\coloneqq, \DeclarePairedDelimiter)
```

### Document quality

```latex
\usepackage[a4paper,margin=1in]{geometry}  % Page layout
\usepackage{hyperref}                       % Clickable links
\usepackage{cleveref}                       % Smart refs: \cref{eq:foo} -> "Equation (1)"
\usepackage{booktabs}                       % Professional tables
\usepackage{graphicx}                       % Figures
\usepackage{microtype}                      % Typographic refinement
\usepackage{enumitem}                       % List customization
```

### Citations

```latex
% Option A: BibLaTeX (preferred for new papers)
\usepackage[backend=biber,style=numeric-comp,sorting=nyt]{biblatex}
\addbibresource{references.bib}
% Use: \printbibliography at the end

% Option B: Traditional BibTeX (for journals that require it)
\bibliographystyle{plain}
% Use: \bibliography{references} at the end
```

### Algorithms and code

```latex
\usepackage{algorithm}
\usepackage{algpseudocode}   % For algorithmic pseudocode
\usepackage{listings}         % For source code listings
```

## Mathematical typesetting

### Equation environments

```latex
% Single equation (numbered)
\begin{equation}
  \hat{\theta} = \arg\min_{\theta} \sum_{i=1}^{n} \mathcal{L}(y_i, f(x_i; \theta))
  \label{eq:objective}
\end{equation}

% Multi-line aligned equations
\begin{align}
  \nabla_\theta \mathcal{L} &= \frac{1}{n} \sum_{i=1}^{n} \nabla_\theta \ell_i \label{eq:gradient} \\
  \theta_{t+1} &= \theta_t - \eta \nabla_\theta \mathcal{L} \label{eq:update}
\end{align}

% Unnumbered (use sparingly — prefer numbered)
\begin{equation*}
  x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}
\end{equation*}

% Cases
\begin{equation}
  \sigma(x) = \begin{cases}
    0 & \text{if } x < 0 \\
    x & \text{if } x \geq 0
  \end{cases}
  \label{eq:relu}
\end{equation}
```

### Common mistakes to avoid

```latex
% WRONG: bare text in math mode (renders as multiplication of variables)
$argmax = ...$

% CORRECT: use \text{} or \operatorname{} for multi-letter identifiers
$\operatorname{argmax} = ...$
% or define once:
\DeclareMathOperator*{\argmax}{argmax}

% WRONG: eqnarray (inconsistent spacing, deprecated)
\begin{eqnarray} ... \end{eqnarray}

% CORRECT: align
\begin{align} ... \end{align}

% WRONG: manual sizing
$(\frac{x}{y})$

% CORRECT: auto-sizing
$\left(\frac{x}{y}\right)$
% or with mathtools:
\DeclarePairedDelimiter{\parens}{(}{)}
$\parens*{\frac{x}{y}}$

% WRONG: unformatted numbers
$1000000$

% CORRECT: use thin spaces or siunitx
$1{,}000{,}000$
% or: \usepackage{siunitx} then \num{1000000}
```

### Notation conventions

| Type | Convention | Example |
| ------ | --------- | ------- |
| Scalars | Italic lowercase | $x$, $r$, $t$ |
| Vectors | Bold lowercase | $\mathbf{v}$, $\mathbf{w}$ |
| Matrices | Bold uppercase | $\mathbf{A}$, $\mathbf{M}$ |
| Sets | Blackboard bold or calligraphic | $\mathbb{R}$, $\mathcal{S}$ |
| Functions/operators | Roman (upright) | $\sin$, $\operatorname{argmax}$ |
| Units/text in math | `\text{}` | $E_{\text{total}}$ |
| Definitions | `:=` or `\coloneqq` | $\mathcal{L} \coloneqq -\log p$ |

### Subscript/superscript clarity

```latex
% Ambiguous: what does subscript i mean?
$L_i$

% Clear: descriptive subscripts
$L_{\text{train}}$   % training loss
$w_{i,j}$            % weight from neuron i to neuron j
$\theta_{t}^{(k)}$   % parameter at step t for layer k
```

## Tables

### Standard format

```latex
\begin{table}[htbp]
  \centering
  \caption{Classification accuracy by model architecture.}
  \label{tab:results}
  \begin{tabular}{@{}lrr@{}}
    \toprule
    Model & Accuracy (\%) & Parameters \\
    \midrule
    Baseline  & 87.3 & 1{,}200 \\
    Proposed  & 92.1 & 1{,}450 \\
    Ensemble  & 93.8 & 4{,}350 \\
    \bottomrule
  \end{tabular}
\end{table}
```

Rules:

- `\toprule`, `\midrule`, `\bottomrule` only. No `\hline`. No vertical lines.
- `@{}` removes outer padding for clean alignment
- Caption goes **above** the table
- Every table must have a `\label` and be referenced in text

### Long tables

For tables that span multiple pages:

```latex
\usepackage{longtable}
\usepackage{booktabs}

\begin{longtable}{llr}
  \caption{Complete experimental results.} \label{tab:experiments} \\
  \toprule
  Dataset & Method & F1 Score \\
  \midrule
  \endfirsthead
  \multicolumn{3}{c}{\textit{Continued from previous page}} \\
  \toprule
  Dataset & Method & F1 Score \\
  \midrule
  \endhead
  \midrule
  \multicolumn{3}{r}{\textit{Continued on next page}} \\
  \endfoot
  \bottomrule
  \endlastfoot
  % data rows here
\end{longtable}
```

## Figures

```latex
\begin{figure}[htbp]
  \centering
  \includegraphics[width=0.8\textwidth]{figures/convergence.pdf}
  \caption{Convergence of training loss across learning rates for the proposed architecture.}
  \label{fig:convergence}
\end{figure}
```

Rules:

- Caption goes **below** the figure
- Use PDF or vector formats when possible; PNG/JPG for photographs only
- Every figure must be referenced in the text
- Use `\textwidth` fractions for sizing, not absolute dimensions

## Cross-referencing

```latex
% With cleveref (preferred — automatically adds "Equation", "Table", etc.):
As shown in \cref{eq:objective}...
\Cref{tab:results} summarizes...     % Start of sentence (capitalized)

% Without cleveref:
As shown in Equation~\eqref{eq:objective}...
Table~\ref{tab:results} summarizes...
```

Use `~` (non-breaking space) before `\ref` to prevent line breaks.

## BibTeX entry formats

```bibtex
@article{smith2020convergence,
  author  = {Smith, John A. and Doe, Jane B.},
  title   = {On the Convergence of Adaptive Gradient Methods},
  journal = {Journal of Machine Learning Research},
  year    = {2020},
  volume  = {21},
  number  = {48},
  pages   = {1--34}
}

@book{bishop2006pattern,
  author    = {Bishop, Christopher M.},
  title     = {Pattern Recognition and Machine Learning},
  publisher = {Springer},
  year      = {2006}
}

@inproceedings{lee2022hybrid,
  author    = {Lee, Wei and Chen, Xiao},
  title     = {A Hybrid Approach to Robust Optimization Under Uncertainty},
  booktitle = {Proceedings of the International Conference on Machine Learning},
  year      = {2022},
  pages     = {12045--12058}
}

@misc{pytorch2024docs,
  author       = {{PyTorch Contributors}},
  title        = {PyTorch Documentation},
  year         = {2024},
  howpublished = {\url{https://pytorch.org/docs/stable/}},
  note         = {Accessed: 2024-11-15}
}
```

## Document compilation

```bash
# Full build with BibLaTeX/Biber
pdflatex paper.tex
biber paper
pdflatex paper.tex
pdflatex paper.tex

# Full build with traditional BibTeX
pdflatex paper.tex
bibtex paper
pdflatex paper.tex
pdflatex paper.tex

# Quick single pass (no bibliography updates)
pdflatex paper.tex
```

The double `pdflatex` after bibliography processing resolves cross-references and citation numbers.
