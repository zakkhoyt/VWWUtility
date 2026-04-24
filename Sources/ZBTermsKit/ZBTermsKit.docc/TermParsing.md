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
subject ends and parameters begin. When no predefined subject prefix matches, the entire
raw token is used as the subject with an empty parameter list.

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

## Mixed Basenames

A single basename may contain both V1 and V2 terms in any order. Each token is parsed
independently using its own heuristic: if the token contains `-` it is V2; otherwise V1.

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
4. **Invalid characters** — a token containing characters outside `[a-zA-Z0-9\-]` is
   silently skipped (e.g. `_ on youtube.com` is not a term)

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
``Term/Parameter`` whose `name` and `definition` are both set to the raw token string.

## See Also

- ``Term``
- ``TermExtractor``
- ``TermManager``
