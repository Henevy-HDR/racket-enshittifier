# Racket Enshittifier

A DrRacket tool that applies seeded, deliberately excessive rewrites to a
conservative subset of Racket and the teaching languages. It leaves the
original editor buffer alone and opens the result as a separate editable copy.

The project website is the repository's [`index.html`](index.html). It includes
installation instructions, limits, and fresh examples written for this
project. The examples are not based on user-submitted course code.

## Artist's Statement
*An exercise in computational absurdism.*

Software engineering is traditionally concerned with elegance, efficiency, readability, and the pursuit of simplicity. Generations of programmers have devoted their careers to making code easier to understand, maintain, and reason about.

**Racket-Enshittifier is a deliberate rejection of these aspirations.**

It is an experiment in the unnecessary. A tool designed to take the comprehensible and render it incomprehensible, to transform straightforward expressions into elaborate computational absurdities, and to explore just how far the boundaries of syntactic sanity can be stretched without sacrificing execution.

The underlying proposition is simple: **if a program remains functionally equivalent, how much of its apparent complexity is merely aesthetic?**

By introducing randomized structural transformations, gratuitous abstractions, and deliberate syntactic obscurity, Racket-Enshittifier explores the distinction between what a program *does* and what a program *appears to be*.

Its creations are not necessarily broken. They are, by design, unnecessarily complicated.

This project exists at the intersection of programming-language theory, generative art, and technological satire. It questions the assumption that greater complexity necessarily reflects greater sophistication, while demonstrating the extraordinary capacity of computers to execute constructions that no reasonable human being would willingly maintain.

Racket-Enshittifier does not seek to improve software.

**It seeks to demonstrate that software can be made substantially worse, with considerable engineering effort, for absolutely no practical reason.**

It is a celebration of computational freedom, an exploration of artificial complexity, and a monument to the human capacity to solve problems that never needed to exist.

**The machine does not care whether the code is beautiful.**

**Neither do we.**

*October 2026, Switzerland*

## Install in DrRacket

1. In DrRacket, open **File → Package Manager…** and select **Available from
   Catalog**.
2. Search for `Racket-Enshittifier`, select the catalog entry, and install it.
3. Restart DrRacket. Choose **Enshittify source…** from the active language
   menu.

To install the archive instead, download
[`racket-enshittifier.zip`](downloads/racket-enshittifier.zip), choose
**File → Install Package…**, select the archive as the package source, and
choose **Install**.

The catalog detail page is not a package source. If you install from a URL
instead of selecting the catalog entry, use the GitHub repository URL below.
The package's generated manual is available from the catalog's **Documentation**
link once the package build service has processed the release.

To install directly from GitHub, choose **File → Install Package…**, paste
`https://github.com/Henevy-HDR/racket-enshittifier.git` into the package source
field, and choose **Install**. The ZIP download above is also available.

The tool runs from DrRacket. During use, it does not require a terminal
command, replace the open source buffer, or evaluate the program to make a
preview.

## Controls

- **Intensity** selects one of five rewrite levels.
- **Seed** reproduces a variant. Leave it blank to choose a fresh seed.
- **Text density** ranges from airy at 0 to compact at 100. With a fixed seed
  and other settings, density changes only whitespace; the code characters,
  comments, and transformation counts remain the same.
- **Identifier chaos** and **helper proliferation** tune those transformations.

At compact density, token-separating spaces and line breaks required by
language headers and line comments remain. Strings, comments, escaped
identifiers, reader comments, character literals, and here strings are kept
intact by the whitespace formatter.

## Examples

These original examples use neutral problems at two scales:

- [`sum-down.rkt`](examples/sum-down.rkt), with [airy](examples/sum-down-airy.rkt)
  and [compact](examples/sum-down-compact.rkt) outputs made from the same seed.
- [`between-inclusive.rkt`](examples/between-inclusive.rkt) and its
  [transformed version](examples/between-inclusive-enshittified.rkt).
- [`meal-plan.rkt`](examples/meal-plan.rkt), a recursive menu planner with
  structures, numeric summaries, and combined constraints, plus its
  [level-5 output](examples/meal-plan-enshittified.rkt).
- [`league-table.rkt`](examples/league-table.rkt), a recursive standings
  calculation with nested tie-breakers, plus its
  [level-5 output](examples/league-table-enshittified.rkt).

Each source and transformed example has `check-expect` tests. They can be run
from DrRacket or with the development checks below. The longer examples use
seeds `20261010` and `20261011`, intensity level 5, and show substantial helper
proliferation, identifier renaming, conditional rewriting, and layout changes.

## Language and correctness limits

The engine targets conservative first-order expression forms in BSL and its
variants, with a restricted subset for Standard Racket. Unsupported forms are
preserved or cause the containing function to be skipped. It does not claim to
rewrite every Racket program or prove equivalence for arbitrary programs.
Transformations do not preserve source-location observations, timing, resource
limits, or behavior under replaced primitive bindings. The original program
remains available in its existing editor buffer.

## Development

With Racket installed, run:

```sh
raco make enshittifier/core.rkt tool.rkt
raco test tests/core-test.rkt
raco test examples/*.rkt
```

The test suite checks density invariance, reader-sensitive text, and generated
examples. The package metadata is in `info.rkt`; the DrRacket integration is in
`tool.rkt`.

## GitHub Pages

The repository includes a Pages workflow at
`.github/workflows/pages.yml`. Select **Settings → Pages → GitHub Actions** as
the publishing source. A push to `main` builds the install archive and deploys
the static page; the workflow can also be run manually.

The project is dual-licensed under Apache-2.0 OR MIT; see `LICENSE` and
`LICENSE-MIT`.
