#lang htdp/bsl

; Add every whole number from n down to zero.
(define (sum-down n)
  (if (= n 0)
      0
      (+ n (sum-down (sub1 n)))))

(check-expect (sum-down 0) 0)
(check-expect (sum-down 4) 10)
