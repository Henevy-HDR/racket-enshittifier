#lang info

(define collection "racket-enshittifier")
(define pkg-desc "A language-aware DrRacket tool for randomized structural source obfuscation.")
(define version "0.6.0")
(define pkg-authors '("Racket Enshittifier contributors"))
(define license '(Apache-2.0 OR MIT))
(define deps '("base" "drracket-plugin-lib" "gui-lib"))
(define build-deps '("rackunit-lib" "scribble-lib"))
(define compile-omit-paths '("tests" "examples"))
(define drracket-tool-names '("Racket Enshittifier"))
(define drracket-tools '(("tool.rkt")))
(define scribblings
  '(("scribblings/racket-enshittifier.scrbl"
     (multi-page)
     (drracket-plugin))))
