#lang htdp/bsl

; A Dish stores a name, preparation time, price in cents, rating, and diet flag.
(define-struct dish (name minutes cents rating vegetarian?))

(define weeknight-menu
  (list (make-dish "Lentil soup" 25 450 4 true)
        (make-dish "Herb rice" 20 300 4 true)
        (make-dish "Roasted squash" 35 600 5 true)))

; Add the preparation times for every dish in the plan.
(define (total-minutes dishes)
  (cond
    [(empty? dishes) 0]
    [else (+ (dish-minutes (first dishes))
             (total-minutes (rest dishes)))]))

; Add the price of every dish, keeping the result in whole cents.
(define (total-cents dishes)
  (cond
    [(empty? dishes) 0]
    [else (+ (dish-cents (first dishes))
             (total-cents (rest dishes)))]))

; Return the mean rating, or zero when there are no dishes to rate.
(define (average-rating dishes)
  (if (empty? dishes)
      0
      (/ (rating-total dishes) (length dishes))))

; Helper for average-rating.
(define (rating-total dishes)
  (cond
    [(empty? dishes) 0]
    [else (+ (dish-rating (first dishes))
             (rating-total (rest dishes)))]))

; Check every dish instead of stopping at the first vegetarian option.
(define (all-vegetarian? dishes)
  (cond
    [(empty? dishes) true]
    [else (and (dish-vegetarian? (first dishes))
               (all-vegetarian? (rest dishes)))]))

; Apply time, price, rating, and optional diet constraints to the whole menu.
(define (menu-approved? dishes time-limit cents-limit rating-floor vegetarian-only?)
  (and (<= (total-minutes dishes) time-limit)
       (<= (total-cents dishes) cents-limit)
       (>= (average-rating dishes) rating-floor)
       (or (not vegetarian-only?)
           (all-vegetarian? dishes))))

(check-expect (total-minutes weeknight-menu) 80)
(check-expect (total-cents weeknight-menu) 1350)
(check-expect (average-rating weeknight-menu) 13/3)
(check-expect (all-vegetarian? weeknight-menu) true)
(check-expect (all-vegetarian?
               (cons (make-dish "Mushroom tart" 18 525 5 false)
                     weeknight-menu))
              false)
(check-expect (menu-approved? weeknight-menu 90 1400 4 true) true)
(check-expect (menu-approved? weeknight-menu 79 1400 4 true) false)
(check-expect (menu-approved? weeknight-menu 90 1349 4 true) false)
(check-expect (menu-approved? weeknight-menu 90 1400 5 false) false)
