#lang scribble/manual

@title[#:tag "top"]{Racket Enshittifier}

Racket Enshittifier is a DrRacket tool that makes a separate, editable copy of
source code with randomized structural rewrites and deliberately awkward
formatting. It is intended for experimentation and demonstrations. It does not
claim to prove arbitrary programs equivalent.

@section{Install and open the tool}

In DrRacket, open @bold{File > Package Manager...}, choose
@onscreen{Available from Catalog}, search for @code{Racket-Enshittifier}, and
install that catalog entry. Restart DrRacket after installation. The command
@onscreen{Enshittify source...} appears in the active language menu.

The package detail page is for information; it is not an installable source.
If entering a source URL manually, use:

@verbatim{
https://github.com/Henevy-HDR/racket-enshittifier.git#main
}

@section{Create a rewritten copy}

Open a program and choose @onscreen{Enshittify source...}. Set the controls and
choose @onscreen{Preview}. The preview reports the seed and counts of structural
rewrites, helpers, renamed identifiers, and numeric literal changes. From the
preview, choose @onscreen{Open editable copy} to put the result in a new
DrRacket window. The original editor buffer is left in place. Choose
@onscreen{Generate another} for a fresh seed, or enter a seed to reproduce a
variant.

@itemlist[
 @item{@bold{Intensity} ranges from 1 (Mild) to 5 (Apocalypse). Higher levels
 add more opportunities for conditional rewrites, redundant branches, helper
 definitions, and identifier changes.}
 @item{@bold{Seed} is an integer from 0 through 2,147,483,647. A fixed seed and
 fixed settings reproduce the same generated text. Leave the field empty for a
 fresh seed.}
 @item{@bold{Text density} ranges from 0 (airy) to 100 (compact). For a fixed
 seed and the same other settings, this changes whitespace while preserving
 the non-whitespace characters of the generated source. Required token
 separators and syntax-sensitive boundaries are retained.}
 @item{@bold{Identifier chaos} controls how often eligible parameters and
 generated helper parameters receive awkward names. Public top-level function
 names are kept so calls elsewhere in the program continue to resolve.}
 @item{@bold{Helper-function proliferation} controls the chance of adding
 forwarding helper definitions. Helpers are skipped for typed and
 mutually-recursive functions.}
]

There is no output-byte-length cap. Helper creation and expression traversal
are bounded per function, but a program with many eligible functions can still
produce a large result.

@section{What can be rewritten}

The engine recognizes standard headers for Beginning Student Language (BSL),
BSL with list abbreviations, Intermediate Student Language (ISL), ISL with
lambda, Advanced Student Language, @code{racket}, and @code{racket/base}. When
there is no @tt{#lang} header, DrRacket's selected language is used. Custom
teaching languages can therefore be recognized by their selected language
name, but their private forms are not assumed to have ordinary Racket
semantics.

Only recognized top-level function definitions whose bodies use the supported
expression subset are candidates for structural rewriting. The current rules
include conditionals, short-circuit Boolean forms, redundant equivalent
wrappers, exact-integer arithmetic rewrites, and forwarding helpers. They avoid
rewriting quoted data. A function can be skipped when a primitive is shadowed,
its bindings cannot be resolved conservatively, it uses an unsupported form,
or its signature or recursion pattern makes helper extraction unsafe.

Other top-level material—including data definitions, structures, signatures,
templates, teachpack forms, and test forms—is retained. Exact integer literals
in eligible teaching-language source may be printed with a different radix;
the numeric value is unchanged. Unknown macros and unfamiliar teaching-language
forms are not expanded or interpreted by the tool.

@section{Correctness and limits}

The transformer is conservative about the syntax it changes, reparses the
generated text, and leaves unsupported function bodies untouched. It does not
evaluate the input, run @code{check-expect} tests, compile the program in its
active teaching language, or formally prove semantic equivalence. Its
equivalence claim is limited to the implemented rewrites and their recognized
preconditions.

The generated text can differ in source locations, stack traces, resource use,
and timing. Rewrites are not intended to preserve such observations, nor
behavior that depends on rebinding or replacing primitive operations. Run the
result with the same language and teachpacks as the original, and run the
program's tests before relying on it.

@section{Examples and source}

The repository contains small and larger examples in its @filepath{examples/}
directory, including recursive list processing, interval checks, meal planning,
and a league table. The source code, test suite, and issue tracker are available
at @url{https://github.com/Henevy-HDR/racket-enshittifier}.
