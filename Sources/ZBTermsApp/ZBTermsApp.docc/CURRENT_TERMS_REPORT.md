# Current Terms Syntax Report

A reference for all known term and marker variants embedded in filenames, as understood by zbterms and the legacy `zbclip.zsh` toolchain.

## Overview

The zbterms system operates on structured markers embedded directly in file and directory basenames. These markers encode metadata — content tags, timestamps, ratings, and clip boundaries — using a delimiter-based syntax that is both human-readable and machine-parseable.

All markers use the underscore character (`_`) as a delimiter. Adjacent terms **share** delimiters; there is no double-underscore between consecutive terms.

---

## Common Terms

### Syntax

```
_<word>_
```

where `<word>` matches `[a-zA-Z0-9-]+` (letters, digits, and hyphens).

### Adjacent Term Sharing

Consecutive terms share a single underscore boundary. Given the string `_shoe_dunk_at30s_`, this tokenizes as three term tokens:

- `shoe`
- `dunk`
- `at30s`

There is never a `__` double-delimiter between two adjacent terms.

### Examples

| Basename fragment | Extracted terms |
| ----------------- | --------------- |
| `_shoe_dunk_`     | `shoe`, `dunk`  |
| `_shoe-ht-red_`   | `shoe-ht-red`   |
| `_youtube_`       | `youtube`       |
| `_f09_`           | `f09`           |

### Extraction Regex

```
_([a-zA-Z0-9-]+)_
```

Non-overlapping forward scan. Consecutive terms are found because the closing `_` of one term doubles as the opening `_` of the next.

---

## Timing Terms

Timing terms drive the `zbclip.zsh` video-clip extraction workflow. They appear as part of the regular underscore-delimited stream and are recognized by their `at` and `for` prefixes.

### At-terms: Clip Start Offset (`_at…_`)

Specifies where in the source video a clip should begin.

| Variant        | Meaning                          | Example      |
| -------------- | -------------------------------- | ------------ |
| `_at<N>_`      | N bare digits → N seconds        | `_at30_`     |
| `_at<N>s_`     | N seconds (explicit unit)        | `_at30s_`    |
| `_at<N>m_`     | N minutes → N×60 seconds         | `_at4m_`     |
| `_at<N>m<N>s_` | N minutes + M seconds            | `_at2m30s_`  |

Parsing priority (highest to lowest): `<N>m<N>s`, `<N>m`, `<N>s`, `<N>`.

#### Find Pattern

`zbclip.zsh` identifies candidate files using the glob:

```
*_at[0-9]*
```

This intentionally excludes false positives such as `created_at.json` because the underscore-prefix is required.

### For-terms: Clip Duration (`_for…_`)

Specifies how long the extracted clip should be. Must appear **immediately after** its paired `_at` token in the underscore-split parts array.

| Variant         | Meaning                          | Example       |
| --------------- | -------------------------------- | ------------- |
| `_for<N>_`      | N bare digits → N seconds        | `_for10_`     |
| `_for<N>s_`     | N seconds (explicit unit)        | `_for10s_`    |
| `_for<N>m_`     | N minutes → N×60 seconds         | `_for1m_`     |
| `_for<N>m<N>s_` | N minutes + M seconds            | `_for1m30s_`  |

If no `_for` token immediately follows an `_at` token, the fallback duration is used (from `--duration` flag, defaulting to `10s`).

### Multiple Clips Per File

A single filename may contain **multiple** `_at` tokens, each producing a separate clip. Example:

```
game_at30s_for10s_at2m15s_for5s_shoe.mp4
```

Produces two clips:
1. Start 30 s, duration 10 s
2. Start 2 m 15 s (= 135 s), duration 5 s

Each output clip retains only its own `_at/_for` pair and discards the others from the output basename.

### Output Path Convention

Clips are written to a sibling subdirectory named `{source-stem} [clips]/`:

```
videos/
├── game_at30s_for10s_shoe.mp4
└── game_at30s_for10s_shoe [clips]/
    └── game_at30s_for10s_shoe.mp4
```

---

## Favorite-Rating Marker

### Current Syntax (Legacy)

Leading underscores at the very start of the basename indicate a "favorite" rating from 1 to 10:

| Leading underscores | Rating |
| ------------------- | ------ |
| `_filename`         | 1      |
| `__filename`        | 2      |
| `___filename`       | 3      |
| … (up to 10)        | ≤ 10   |

This marker is **not** extracted as a common term. `TermExtractor` detects the leading-underscore pattern separately and suppresses it from the `[String]` term list returned for a given path item.

Detection regex (start of basename):

```
^([_]{1,10})(?=[^_])
```

### Planned Syntax (Phase 3)

A future migration will convert the leading-underscore rating to an explicit `_f{NN}_` term:

```
_f09_filename.mp4    # rating 9
_f10_filename.mp4    # rating 10
```

This encodes the same semantic meaning but uses the standard term delimiter syntax, making it extractable by `TermExtractor` alongside other common terms.

> **Note:** The `_f{NN}_` migration is out of scope for the current ZBTermsKit implementation. The extractor intentionally suppresses leading-underscore detection rather than converting it. Phase 3 will add a dedicated migration subcommand.

---

## Source-Metadata Terms

These are commonly used terms found in real-world filenames in the user's media library. They are ordinary common terms (no special parsing), listed here for documentation purposes.

| Term category | Example terms                            |
| ------------- | ---------------------------------------- |
| Content type  | `clip`, `highlight`, `practice`, `game`  |
| Equipment     | `shoe`, `shoe-ht-red`, `boot`, `sneaker` |
| Platform      | `youtube`, `instagram`                   |
| Timing        | `at30s`, `at2m15s`, `for5s`              |
| Rating        | `f09`, `f10`                             |

---

## Variants Requiring New ZBTermsKit Support

The following patterns exist in real filenames but are **not yet handled** by the current `TermExtractor` implementation. They should be addressed in a future ZBTermsKit release.

### 1. Timing Terms (`_at`, `_for`)

`TermExtractor` currently extracts **all** underscore-delimited words matching `[a-zA-Z0-9-]+`, so `at30s` is returned as a raw string rather than a parsed `TimingTerm`. ZBTermsKit needs dedicated model types:

- `AtTerm` — wraps a start-offset in seconds (`Int`)
- `ForTerm` — wraps a duration in seconds (`Int`)

These would be parsed from terms already returned by `TermExtractor` but identified and typed separately. The `TermsReport` could optionally include a `timingSpecs: [ClipSpec]` array on each `PathItem`.

**New parser needed:**

```swift
struct TimingParser {
    static func parseAtSeconds(_ raw: String) -> Int?   // "at30s" → 30
    static func parseForSeconds(_ raw: String) -> Int?  // "for1m10s" → 70
}
```

### 2. Favorite Rating (`_f{NN}_`)

Once Phase 3 migration runs, filenames will carry `_f09_` style terms. `TermExtractor` will extract `f09` as a raw string but there is no typed `FavoriteRating` model. A new type is needed:

```swift
struct FavoriteRating {
    let value: Int  // 1–10
    // init from "f09" etc.
}
```

### 3. Leading-Underscore Rating Detection

The current `TermExtractor` must detect and suppress the legacy leading-underscore pattern so it does not pollute the common-term list. This detection should produce a typed `LegacyFavoriteRating` value rather than silently dropping underscores, enabling the Phase 3 migration tooling to enumerate files that need conversion.

### 4. `ClipSpec` Derivation from `PathItem`

The `FileCrawler` → `TermsReport` pipeline has no concept of clip specs. After timing-term parsing is added, `TermsReportBuilder` should optionally produce `clipSpecs: [ClipSpec]` on each `PathItem` that contains at least one `AtTerm`.

### 5. Multi-Word Basename Text (Non-Term Regions)

Filenames often contain human-readable text outside the underscore-delimited term region, e.g.:

```
march madness_shoe_at14m3s_swish_ on youtube.com - title.mp4
```

The space-separated regions (`march madness`, `on youtube.com - title`) are not extracted as terms. A future `extractablePathText` property could expose these free-text fragments for search and display.

---

## Summary Table

| Marker type           | Syntax              | Extracted? | Typed model needed?   |
| --------------------- | ------------------- | ---------- | --------------------- |
| Common term           | `_word_`            | ✅ Yes      | `String` (current)    |
| Common term w/ hyphen | `_word-sub_`        | ✅ Yes      | `String` (current)    |
| At-term               | `_at30s_`           | ✅ raw str  | ⚠️ `AtTerm` needed     |
| For-term              | `_for10s_`          | ✅ raw str  | ⚠️ `ForTerm` needed    |
| Favorite rating (new) | `_f09_`             | ✅ raw str  | ⚠️ `FavoriteRating`    |
| Favorite rating (old) | `__basename`        | ❌ Suppressed | ⚠️ `LegacyFavoriteRating` |
| Multiple at-terms     | `_at30s_…_at2m15s_` | ✅ raw str  | ⚠️ Multi-`ClipSpec`    |
