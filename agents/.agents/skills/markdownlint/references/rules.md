# Markdownlint Rules Reference

Complete reference for all 47 built-in rules. Rules are listed by ID with aliases, tags, parameters, and fix support.

## Contents

- [Headings](#headings)
- [Lists](#lists)
- [Whitespace and blank lines](#whitespace-and-blank-lines)
- [Code](#code)
- [Links](#links)
- [Emphasis](#emphasis)
- [Tables](#tables)
- [HTML](#html)
- [Other](#other)

---

## Headings

### MD001 — heading-increment

Tags: `headings`

Heading levels must increment by one level at a time (no skipping from `#` to `###`).

Parameters:

- `front_matter_title` (string): Regex for front matter title field. Default: `"^\s*title\s*[:=]"`

### MD003 — heading-style

Tags: `headings`

Enforce consistent heading style throughout the document.

Parameters:

- `style` (string): `"consistent"` | `"atx"` | `"atx_closed"` | `"setext"` | `"setext_with_atx"` | `"setext_with_atx_closed"`. Default: `"consistent"`

### MD018 — no-missing-space-atx

Tags: `headings`, `atx`, `spaces` | Fixable

Require a space after `#` in atx-style headings. `#Heading` is invalid, `# Heading` is valid.

### MD019 — no-multiple-space-atx

Tags: `headings`, `atx`, `spaces` | Fixable

Only one space after `#` in atx-style headings.

### MD020 — no-missing-space-closed-atx

Tags: `headings`, `atx_closed`, `spaces` | Fixable

Require spaces inside hashes in closed atx headings: `# Heading #`.

### MD021 — no-multiple-space-closed-atx

Tags: `headings`, `atx_closed`, `spaces` | Fixable

Only one space inside hashes in closed atx headings.

### MD022 — blanks-around-headings

Tags: `headings`, `blank_lines` | Fixable

Headings must have blank lines above and below.

Parameters:

- `lines_above` (integer): Blank lines above heading. Default: `1`
- `lines_below` (integer): Blank lines below heading. Default: `1`

### MD023 — heading-start-left

Tags: `headings` | Fixable

Headings must start at the beginning of the line (no leading spaces).

### MD024 — no-duplicate-heading

Tags: `headings`

No multiple headings with the same content.

Parameters:

- `siblings_only` (boolean): Only check sibling headings. Default: `false`

### MD025 — single-h1

Tags: `headings`

Only one top-level heading (`#`) per document.

Parameters:

- `front_matter_title` (string): Regex for front matter title. Default: `"^\s*title\s*[:=]"`
- `level` (integer): Heading level. Default: `1`

### MD026 — no-trailing-punctuation

Tags: `headings`

No trailing punctuation in headings (periods, commas, etc.).

Parameters:

- `punctuation` (string): Punctuation characters to check. Default: `".,;:!。，；：！"`

### MD036 — no-emphasis-as-heading

Tags: `headings`, `emphasis`

Don't use emphasis (bold/italic) as a substitute for headings.

Parameters:

- `punctuation` (string): Punctuation that indicates non-heading emphasis. Default: `".,;:!?。，；：！？"`

### MD041 — first-line-heading

Tags: `headings`

First line of the file should be a top-level heading.

Parameters:

- `front_matter_title` (string): Regex for front matter title. Default: `"^\s*title\s*[:=]"`
- `level` (integer): Required heading level. Default: `1`

### MD043 — required-headings

Tags: `headings`

Enforce a specific heading structure.

Parameters:

- `headings` (array of strings): Required heading structure. Use `"*"` as wildcard. Default: `[]` (disabled)
- `match_case` (boolean): Case-sensitive match. Default: `false`

---

## Lists

### MD004 — ul-style

Tags: `bullet`, `ul` | Fixable

Consistent unordered list item markers.

Parameters:

- `style` (string): `"consistent"` | `"asterisk"` | `"dash"` | `"plus"` | `"sublist"`. Default: `"consistent"`

### MD005 — list-indent

Tags: `bullet`, `indentation`, `ul` | Fixable

Items at the same level must have consistent indentation.

### MD007 — ul-indent

Tags: `bullet`, `indentation`, `ul` | Fixable

Unordered list indentation depth.

Parameters:

- `indent` (integer): Spaces per indent level. Default: `2`
- `start_indent` (integer): First-level indent spaces. Default: `2`
- `start_indented` (boolean): Whether first level is indented. Default: `false`

### MD029 — ol-prefix

Tags: `ol` | Fixable

Ordered list item prefix style.

Parameters:

- `style` (string): `"one"` | `"ordered"` | `"one_or_ordered"` | `"zero"`. Default: `"one_or_ordered"`

### MD030 — list-marker-space

Tags: `ol`, `ul`, `spaces`

Spaces after list markers.

Parameters:

- `ol_multi` (integer): Ordered list multi-line spacing. Default: `1`
- `ol_single` (integer): Ordered list single-line spacing. Default: `1`
- `ul_multi` (integer): Unordered list multi-line spacing. Default: `1`
- `ul_single` (integer): Unordered list single-line spacing. Default: `1`

### MD032 — blanks-around-lists

Tags: `blank_lines`, `lists` | Fixable

Lists must be surrounded by blank lines.

---

## Whitespace and blank lines

### MD009 — no-trailing-spaces

Tags: `whitespace` | Fixable

No trailing whitespace on lines.

Parameters:

- `br_spaces` (integer): Spaces for line break (0 = disable). Default: `2`
- `code_blocks` (boolean): Check code blocks. Default: `false`
- `list_item_empty_lines` (boolean): Allow in list empty lines. Default: `false`
- `strict` (boolean): Report unnecessary line breaks. Default: `false`

### MD010 — no-hard-tabs

Tags: `whitespace`, `hard_tab` | Fixable

No hard tab characters.

Parameters:

- `code_blocks` (boolean): Check code blocks. Default: `true`
- `ignore_code_languages` (array of strings): Languages to ignore. Default: `[]`
- `spaces_per_tab` (integer): Spaces per tab for fixing. Default: `1`

### MD012 — no-multiple-blanks

Tags: `whitespace`, `blank_lines` | Fixable

No more than the configured number of consecutive blank lines.

Parameters:

- `maximum` (integer): Maximum consecutive blank lines. Default: `1`

### MD027 — no-multiple-space-blockquote

Tags: `blockquote`, `whitespace`, `spaces` | Fixable

Only one space after blockquote symbol (`>`).

### MD028 — no-blanks-blockquote

Tags: `blockquote`, `blank_lines`

No blank lines inside blockquotes (use `>` on empty lines to continue).

### MD047 — single-trailing-newline

Tags: `blank_lines` | Fixable

Files must end with a single newline character.

---

## Code

### MD014 — commands-show-output

Tags: `code` | Fixable

Dollar signs in commands only when showing output.

### MD031 — blanks-around-fences

Tags: `blank_lines`, `code` | Fixable

Fenced code blocks must be surrounded by blank lines.

Parameters:

- `list_items` (boolean): Check in list items. Default: `true`

### MD038 — no-space-in-code

Tags: `code`, `spaces` | Fixable

No spaces inside code span backticks.

### MD040 — fenced-code-language

Tags: `code`

Fenced code blocks should specify a language.

Parameters:

- `allowed_languages` (array of strings): Allowed languages. Default: `[]` (any)
- `language_only` (boolean): Only language, no extras. Default: `false`

### MD046 — code-block-style

Tags: `code`

Consistent code block style (fenced vs indented).

Parameters:

- `style` (string): `"consistent"` | `"fenced"` | `"indented"`. Default: `"consistent"`

### MD048 — code-fence-style

Tags: `code` | Fixable

Consistent code fence characters.

Parameters:

- `style` (string): `"consistent"` | `"backtick"` | `"tilde"`. Default: `"consistent"`

---

## Links

### MD011 — no-reversed-links

Tags: `links` | Fixable

No reversed link syntax: `(text)[url]` should be `[text](url)`.

### MD034 — no-bare-urls

Tags: `links`

No bare URLs — use `[text](url)` format.

### MD039 — no-space-in-links

Tags: `links`, `spaces` | Fixable

No spaces inside link text brackets: `[ text ](url)` should be `[text](url)`.

### MD042 — no-empty-links

Tags: `links`

No links with empty URLs: `[text]()` or `[text](#)`.

### MD051 — link-fragments

Tags: `links`

Link fragments (`#anchor`) must reference valid headings in the document.

### MD052 — reference-links-images

Tags: `links`, `images`

Reference-style links and images must have matching definitions.

Parameters:

- `shortcut_syntax` (boolean): Include shortcut syntax. Default: `false`

### MD053 — link-image-reference-definitions

Tags: `links`, `images` | Fixable

No unused link or image reference definitions.

Parameters:

- `ignored_definitions` (array of strings): Definitions to ignore. Default: `["//"]`

### MD054 — link-image-style

Tags: `links`, `images`

Consistent link and image style (inline, full, collapsed, shortcut).

Parameters:

- `autolink` (boolean): Allow autolinks. Default: `true`
- `collapsed` (boolean): Allow collapsed references. Default: `true`
- `full` (boolean): Allow full references. Default: `true`
- `inline` (boolean): Allow inline. Default: `true`
- `shortcut` (boolean): Allow shortcut references. Default: `true`
- `url_inline` (boolean): Allow URL-only inline. Default: `true`

### MD059 — link-text-descriptive

Tags: `accessibility`, `links`

Link text should be descriptive (not "click here" or "link").

---

## Emphasis

### MD037 — no-space-in-emphasis

Tags: `emphasis`, `whitespace`, `spaces` | Fixable

No spaces inside emphasis markers: `* text *` should be `*text*`.

### MD049 — emphasis-style

Tags: `emphasis` | Fixable

Consistent emphasis style.

Parameters:

- `style` (string): `"consistent"` | `"asterisk"` | `"underscore"`. Default: `"consistent"`

### MD050 — strong-style

Tags: `emphasis` | Fixable

Consistent strong emphasis style.

Parameters:

- `style` (string): `"consistent"` | `"asterisk"` | `"underscore"`. Default: `"consistent"`

---

## Tables

### MD055 — table-pipe-style

Tags: `tables`

Consistent table pipe style (leading, trailing, both).

Parameters:

- `style` (string): `"consistent"` | `"leading_and_trailing"` | `"leading_only"` | `"trailing_only"` | `"no_leading_or_trailing"`. Default: `"consistent"`

### MD056 — table-column-count

Tags: `tables`

All table rows must have the same number of columns.

### MD058 — blanks-around-tables

Tags: `blank_lines`, `tables` | Fixable

Tables must be surrounded by blank lines.

### MD060 — table-column-alignment

Tags: `tables`

Consistent table column alignment (left, center, right).

---

## HTML

### MD033 — no-inline-html

Tags: `html`

No inline HTML elements.

Parameters:

- `allowed_elements` (array of strings): HTML elements to allow. Default: `[]`

---

## Other

### MD035 — hr-style

Tags: `hr` | Fixable

Consistent horizontal rule style.

Parameters:

- `style` (string): `"consistent"` | specific string like `"---"` or `"***"`. Default: `"consistent"`

### MD044 — proper-names

Tags: `spelling`

Proper names should use correct capitalization.

Parameters:

- `code_blocks` (boolean): Check code blocks. Default: `true`
- `html_elements` (boolean): Check HTML elements. Default: `true`
- `names` (array of strings): List of proper names. Default: `[]`

### MD045 — no-alt-text

Tags: `accessibility`, `images`

Images must have alternative text (alt text).
