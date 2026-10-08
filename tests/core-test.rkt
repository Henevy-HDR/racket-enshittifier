#lang racket/base

(require rackunit
         racket/file
         racket/runtime-path
         racket/string
         "../enshittifier/core.rkt")

(define-runtime-path example-root "../examples")
(define-runtime-path boundary-fixture "fixtures/reader-boundaries.rkt")

(define (without-whitespace source)
  (list->string
   (filter (lambda (character) (not (char-whitespace? character)))
           (string->list source))))

(define recursion-source
  (file->string (build-path example-root "sum-down.rkt")))
(define airy
  (enshittify-source recursion-source
                     #:seed 20261008
                     #:intensity 100
                     #:text-density 10
                     #:identifier-chaos 85
                     #:helper-proliferation 90))
(define compact
  (enshittify-source recursion-source
                     #:seed 20261008
                     #:intensity 100
                     #:text-density 100
                     #:identifier-chaos 85
                     #:helper-proliferation 90))

(check-true (positive? (transformation-structural-count airy)))
(check-true (positive? (transformation-helper-count airy)))
(check-equal? (without-whitespace (transformation-source airy))
              (without-whitespace (transformation-source compact)))
(check-equal? (read-source-datums (transformation-source airy))
              (read-source-datums (transformation-source compact)))
(check-equal? (transformation-structural-count airy)
              (transformation-structural-count compact))
(check-equal? (transformation-helper-count airy)
              (transformation-helper-count compact))
(check-equal? (transformation-renamed-identifiers airy)
              (transformation-renamed-identifiers compact))
(check-true (> (string-length (transformation-source airy))
               (string-length (transformation-source compact))))

(define reader-source (file->string boundary-fixture))
(define reader-dense
  (enshittify-source reader-source
                     #:seed 31415
                     #:intensity 0
                     #:text-density 100))
(check-equal? (read-source-datums reader-source)
              (read-source-datums (transformation-source reader-dense)))
(check-true (string-contains? (transformation-source reader-dense)
                              "literal   spaces ; stay here"))
(check-true (string-contains? (transformation-source reader-dense)
                              "line one  ; this is string data"))
