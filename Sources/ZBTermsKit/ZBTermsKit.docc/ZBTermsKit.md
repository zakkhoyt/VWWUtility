# ``ZBTermsKit``

Parse, report on, and rename files using structured terms embedded in basenames.

## Overview

ZBTermsKit is the core library powering the `zbterms` CLI tool. It provides three main
capabilities:

- **Term parsing** — extract typed ``Term`` values from any filename, supporting both
  V1 (concatenated) and V2 (hyphen-separated) encoding
- **File crawling** — walk a directory tree and collect
  ``TermsReport/PathItem`` entries with ``FileCrawler``
- **Report building** — aggregate extracted terms into a ``TermsReport`` that groups
  per-file usages and cross-file unique-term counts by subject

For a detailed explanation of how terms are encoded in filenames and how the parser works,
see <doc:TermParsing>.

## Topics

### How Term Parsing Works

- <doc:TermParsing>

### Term Model

- ``Term``
- ``BasenameRepresentable``

### Extraction

- ``TermExtractor``
- ``TermManager``

### Reports

- ``TermsReport``
- ``TermsReportBuilder``

### File Crawling

- ``FileCrawler``
- ``TermContainer``
