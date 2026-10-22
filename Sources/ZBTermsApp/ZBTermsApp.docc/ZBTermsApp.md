# ``ZBTermsApp``

Command-line interface for extracting and reporting on filename terms.

## Overview

`zbterms` is a macOS CLI tool that crawls a directory tree, extracts structured
``ZBTermsKit/Term`` values from file and directory basenames, and produces JSON reports.

```sh
# List unique subjects across a directory (sorted by frequency)
zbterms list-unique --dir ~/Videos --max-depth 2

# Full report with per-file term detail
zbterms report --dir ~/Videos --max-depth 2 | jq '.unique_terms[:5]'
```

For details on how terms are encoded in filenames, see the
[Term Parsing](../ZBTermsKit/TermParsing) article in ZBTermsKit.

## Topics

### Entry Point

- ``ZBTerms``
