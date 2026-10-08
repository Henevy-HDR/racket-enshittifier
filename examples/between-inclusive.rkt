#lang htdp/bsl

; Report whether value lies between the two endpoints, including both.
(define (between-inclusive? value low high)
  (and (<= low value) (<= value high)))

(check-expect (between-inclusive? 5 2 8) true)
(check-expect (between-inclusive? 2 2 8) true)
(check-expect (between-inclusive? 9 2 8) false)
