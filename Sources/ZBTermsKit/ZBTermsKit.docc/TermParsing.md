# Term Parsing

How terms are encoded in file basenames and how ZBTermsKit extracts them.

## Overview

A *term* is a structured token embedded in a file's basename. Terms encode metadata —
content tags, timestamps, ratings, clip boundaries — directly in the filename so they
travel with the file regardless of filesystem, application, or platform.

``TermExtractor`` scans a basename left-to-right and hands each raw token to
``Term/init(basenameRepresentation:)`` for typed parsing. The result is an array of
``Term`` values ordered as they appear in the basename.

## Delimiters

Three delimiter characters partition a basename into terms and their parts:

| Character | Role | Constant |
| --------- | ---- | -------- |
| `_` | Separates terms from each other and from surrounding text | ``Term/BasenameDelimiters/termDelimiter`` |
| `-` | Separates a term's subject from its parameters (V2 only) | ``Term/BasenameDelimiters/parameterDelimiter`` |
| `=` | Separates a parameter's key from its value in option-style parameters | ``Term/BasenameDelimiters/optionDelimiter`` |

## Syntax Versions

### V1 — Concatenated

The original encoding runs the subject and any parameters together with no separator:

```
_shoehtred_
```

Subject `shoe`, parameters `ht` and `red` are concatenated. Parsing V1 terms requires
the predefined subject registry (``Term/predefinedSubjects``) to identify where the
subject ends and parameters begin. The longest predefined subject that prefixes the token
wins, and only when the rest of the token is empty, starts with a digit (`at30s`, `for8`),
or splits entirely into predefined parameters (`shoehtred` → `ht` + `red`). That keeps
ordinary words that merely start with a short subject (`foo` vs `f`, `attic` vs `at`) from
being misread. When no predefined subject matches this way, the entire raw token is used as
the subject with an empty parameter list.

### V2 — Hyphen-Separated

The current encoding separates subject from parameters with `-`:

```
_shoe-ht-red_
```

The first component is the subject (`shoe`); remaining components are parameters
(`ht`, `red`). No registry lookup is needed for the split.

Parameters may be plain flags or key-value options:

```
_modem-speed=fast_      ← option: key "speed", value "fast"
_bbbat-wood_            ← flag: "wood"
```

### V2 Subject Values (clip terms)

A V2 subject may also carry its own inline value via `=`, written `subject=value`. This is how
*clip terms* are encoded: the subject `at` carries a `<time>` value, and clip parameters hang off it.

```
_at=33s_                        ← subject "at" = "33s" (clip start); no params
_at=33s-for=20_                 ← + option for=20 (clip duration)
_at=2m15s-for=20-zoom=110_      ← + zoom
_at=33s-zoom=110-zx=40-zy=30_   ← zoom with a focal point
_at=33s-for=10-speed=50_        ← half-speed clip
```

The subject's value is reported separately as ``Term/subjectValue`` (`subject_value` in JSON);
the subject itself is still `at`, so every clip groups under one subject. Predefined subjects and
parameters are matched by key (the part before `=`), so `for=20` picks up the `for` definition.

The full V2 term grammar is therefore:

```
‹subject›[=‹value›] ( -‹param› )*        param = ‹key›=‹value›  |  ‹flag›
```

Components are `[a-zA-Z0-9]+`; parameters are **order-independent** (`-zx=40-zoom=110` ≡
`-zoom=110-zx=40`). Exact key matching applies — the duration key is `for`, never `forr`/`forx`.

> Clip values (`at`, `for`, `zoom`, `zx`, `zy`, `speed`) are opaque strings to ZBTermsKit; their
> meaning (durations, percentages) is interpreted by the `zbclip` tool, not by term parsing.

## Mixed Basenames

A single basename may contain both V1 and V2 terms in any order. Each token is parsed
independently using its own heuristic: if the token contains `-` or `=` it is V2; otherwise V1.

```
march madness_shoe_f-09_clip.mp4
                ^    ^--- V2 (subject "f", parameter "09")
                '-------- V1 (subject "shoe")
```

## Term Boundaries

``TermExtractor`` uses a sliding-window scan over `_token_` patterns in the stripped
basename (extension removed). The rules are:

1. **Standard token** — text between two `_` characters, both present: `_shoe_`
2. **Adjacent terms share their delimiter** — `_a_b_c_` yields three terms: `a`, `b`, `c`
3. **Trailing token** — valid characters after the last `_` with no closing `_` are
   captured as a term. For example `_dunk_clip.mp4` (after extension strip: `_dunk_clip`)
   yields `dunk` and `clip`
4. **Allowed characters** — a token may contain `[a-zA-Z0-9\-=]`: letters, digits, the parameter
   delimiter `-`, and the option delimiter `=` (the latter for subject-values and key=value params).
   A token containing any other character is silently skipped (e.g. `_ on youtube.com` is not a term)

### Example Walkthrough

```
game_shoe-ht_dunk_clip.mp4
```

After stripping `.mp4`:

```
game_shoe-ht_dunk_clip
         ^         ^-- trailing term, no closing _: "clip"
    ^----+-- standard: "shoe-ht" (V2)
              ^------- standard: "dunk"   (V1)
```

Parsed result:

| Raw token | Syntax | Subject | Parameters |
| --------- | ------ | ------- | ---------- |
| `shoe-ht` | V2 | `shoe` | `ht` |
| `dunk` | V1 | `dunk` | *(none)* |
| `clip` | V1 | `clip` | *(none)* |

## Predefined Subjects and Parameters

``Term/predefinedSubjects`` and ``Term/predefinedParameters`` are loaded once at first
access from JSON resource files bundled with ZBTermsKit:

- `TermSubjectDefinitions.json5` — maps basename tokens to human-readable subject names
  and definitions (e.g. `"shoe"` → `"Shoe"`, `"Content features a shoe"`)
- `ParameterDefinitions.json5` — maps parameter tokens to names and definitions
  (e.g. `"ht"` → `"High-Top"`, `"A high-top shoe style"`)

When no predefined entry matches, ``Term`` creates a fallback ``Term/Subject`` or
``Term/Parameter`` whose `name` is the raw token string and whose `definition` is empty.

Both files ship inside ZBTermsKit, so a missing or malformed file stops the process with the
decoding error instead of silently loading no definitions.

## Special Promotions & Rejections

Beyond plain tokenization, ``TermExtractor`` applies these rules during extraction, so the returned
``Term`` list can differ from the raw basename tokens:

- **Favorite rating (leading underscores).** A basename starting with 2–10 consecutive `_`
  (followed by a non-`_`) encodes a favorite rating, promoted to a synthetic `f-NN` term
  (`__best.jpg` → `f-02`). A single leading `_` is just the term delimiter, not a rating.
- **Favorite shorthand.** A bare `fNN` or `f=NN` token is normalized to the canonical `f-NN`
  (`f09` → `f-09`, `f=06` → `f-06`), so every favorite form groups under the same expression.
- **Order.** A leading token of purely 1–4 digits is promoted to `ord-NNNN` (`03_clip.mp4` → `ord-03`).
- **UUID rejection.** A V2 token whose subject is exactly 8 uppercase-hex characters
  (`^[A-Z0-9]{8}$`, e.g. `A5722D74-F48D`) is treated as a UUID fragment and **not** emitted as a term.

The `f`, `at`, `for`, and `ord` subjects are registered in `TermSubjectDefinitions.json5`.

## See Also

- ``Term``
- ``TermExtractor``
- ``TermManager``
