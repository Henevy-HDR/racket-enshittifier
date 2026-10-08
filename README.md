# Racket Enshittifier

A DrRacket tool that applies seeded, deliberately excessive rewrites to a
conservative subset of Racket and the teaching languages. It leaves the
original editor buffer alone and opens the result as a separate editable copy.

The project website is the repository's [`index.html`](index.html). It includes
installation instructions, limits, and fresh examples written for this
project. The examples are not based on user-submitted course code.

## Install in DrRacket

1. Download [`racket-enshittifier.zip`](downloads/racket-enshittifier.zip).
2. In DrRacket, choose **File → Install Package…**.
3. Select the downloaded archive as the package source and choose **Install**.
4. Restart DrRacket. Choose **Enshittify source…** from the active language
   menu.

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

These original examples use small, neutral problems:

- [`sum-down.rkt`](examples/sum-down.rkt), with [airy](examples/sum-down-airy.rkt)
  and [compact](examples/sum-down-compact.rkt) outputs made from the same seed.
- [`between-inclusive.rkt`](examples/between-inclusive.rkt) and its
  [transformed version](examples/between-inclusive-enshittified.rkt).

Each source and transformed example has `check-expect` tests. They can be run
from DrRacket or with the development checks below.

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
`.github/workflows/pages.yml`. After creating the GitHub repository, select
**Settings → Pages → GitHub Actions** as the publishing source. A push to
`main` builds the install archive and deploys the static page; the workflow can
also be run manually. The workflow only publishes after it is triggered in the
GitHub repository.

The project is dual-licensed under Apache-2.0 OR MIT; see `LICENSE` and
`LICENSE-MIT`.
