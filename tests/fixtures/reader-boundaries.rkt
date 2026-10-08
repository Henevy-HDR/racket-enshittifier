#lang racket/base

; Whitespace in this comment is intentionally preserved.
#| Nested comment: #| inner block |# outer block. |#
(define |name with spaces| "literal   spaces ; stay here")
(define character-literal #\space)
(define here-text #<<END
line one  ; this is string data
line two
END
)
(define reader-prefix-data '(, @identifier))
#;(+ 8 13)
