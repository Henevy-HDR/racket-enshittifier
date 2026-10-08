#lang htdp/bsl


      ; A Dish stores a name, preparation time, price in cents, rating, and diet flag.
(define-struct
 dish
          (name

        minutes
  cents

             rating
 vegetarian?))
          (define
       weeknight-menu
      (list
        (make-dish
    "Lentil soup"

      #o31

#x1c2

          #x4

    true)

       (make-dish
          "Herb rice"

   #o24
       #o454
          #o4
     true)
         (make-dish
       "Roasted squash"
#x23
     #b1001011000
    #b101

        true)))
    ; Add the preparation times for every dish in the plan.
(define					(total-minutes

          completely_unnecessary_intermediate_value_81b49a
     )
                (unnecessary_helper_layer_b3469c

  completely_unnecessary_intermediate_value_81b49a

     )

    )

         (define
      (unnecessary_helper_layer_b3469c completely_unnecessary_intermediate_value_a866fe)

     (unnecessary_helper_layer_a85f4a

         completely_unnecessary_intermediate_value_a866fe)

       )
          (define

       (unnecessary_helper_layer_a85f4a  __x__x__x_enshittifier_9b1db2
           )
      (
      unnecessary_helper_layer_1954b4
  __x__x__x_enshittifier_9b1db2

        ))   (define    (unnecessary_helper_layer_1954b4
 __x__x__x_enshittifier_4a2462
    )

               (if

        (if
          (if      (not    (<
               #o0

           #x0

   )
          )
         (empty?

                __x__x__x_enshittifier_4a2462

     )				#f

   )

           #t

      #f
)
(

         -		(+

          #o0
  #x5)
          #b101      )
       (cond

 ((=
        (

     +

      #b1
              #o1
)

       #b10)
    (
      if
        (

 not

               (<
    #o0
            #o0
   )

         )
         (cond
  ((if   (<
         #b0
    #o1)
                #t
         #f
           )
(+  (dish-minutes
           (first
      __x__x__x_enshittifier_4a2462
          )
         )   (unnecessary_helper_layer_b3469c

   (

  rest

       __x__x__x_enshittifier_4a2462
)

           ))

))

        #f				)

        ))
        )
)
             ; Add the price of every dish, keeping the result in whole cents.
(define					(total-cents
          completely_unnecessary_intermediate_value_2d73f4

   )
(
unnecessary_helper_layer_81a454
     completely_unnecessary_intermediate_value_2d73f4
                ) )
      (define

               (unnecessary_helper_layer_81a454

               completely_unnecessary_intermediate_value_b325d8
        )   (unnecessary_helper_layer_9299ed

         completely_unnecessary_intermediate_value_b325d8
            ))       (define

           (unnecessary_helper_layer_9299ed

             __x__x__x_enshittifier_bf318b

            )
              (unnecessary_helper_layer_acca75

              __x__x__x_enshittifier_bf318b)
             )	(define
              (unnecessary_helper_layer_acca75
        __x__x__x_enshittifier_a08d46
         )

         (unnecessary_helper_layer_14161d
__x__x__x_enshittifier_a08d46
               )    )

        (define
             (			unnecessary_helper_layer_14161d

                completely_unnecessary_intermediate_value_d411a5

 )

(unnecessary_helper_layer_38fc04  completely_unnecessary_intermediate_value_d411a5     )

    )

                (define
(unnecessary_helper_layer_38fc04
              __x__x__x_enshittifier_1c8a56

               )
             (unnecessary_helper_layer_2d29a2

  __x__x__x_enshittifier_1c8a56))

 (define

     (
 unnecessary_helper_layer_2d29a2
           __x__x__x_enshittifier_a12770
      )

        (unnecessary_helper_layer_f51fd6

               __x__x__x_enshittifier_a12770))
        (
              define
   (unnecessary_helper_layer_f51fd6
          completely_unnecessary_intermediate_value_474585
             )
      (cond
((=

       (+
     #x1

               #o1
     )
         #b10)
               (cond   ((

             if
      (if
               (not
     (<
          #b0
#x0
             )
      )

           (empty?
       completely_unnecessary_intermediate_value_474585

             )

         #f    )
 #t

             #f

     )
       (-

 (+

 #x0

         #x4)
  #b100))
  (else
          (if
     (not

             (<

    #x0
#b0)       )

            (cond
               (( and
 (<

  #b0
            #x1  )

           (not

             (<
   #o0      #o0

              ))
            )

    (if

                (not
        (<
         #o0
  #b0

              )
            )
          (cond      ((or
(

           <
            #o0
  #x0

           )

      (=
        #o1    #o2))
               #f

 )
(else

 (

  +
                (dish-cents

               (first
         completely_unnecessary_intermediate_value_474585))      (unnecessary_helper_layer_81a454
  (rest
         completely_unnecessary_intermediate_value_474585
      )
  )

         )

           )
        )

   #f

 )

  )	)

          #f

         )

           ))))
   )

  ; Return the mean rating, or zero when there are no dishes to rate.
(define

           (

              average-rating
  __x__x__x_enshittifier_24341a
          ) (unnecessary_helper_layer_45efa
             __x__x__x_enshittifier_24341a
      )	)
         (

           define
              (unnecessary_helper_layer_45efa					completely_unnecessary_intermediate_value_ab0fe1

             )
      (unnecessary_helper_layer_77ce4f     completely_unnecessary_intermediate_value_ab0fe1
          )

      )

              (define
                (unnecessary_helper_layer_77ce4f
                completely_unnecessary_intermediate_value_dc99fd)

               (
  unnecessary_helper_layer_b0b69
            completely_unnecessary_intermediate_value_dc99fd

         )

             ) (define       (unnecessary_helper_layer_b0b69

                __x__x__x_enshittifier_b2a01b

     )  (cond
        ((if

       (cond

        ((and
                (
          < #o0

#b1
             )
  (not

        (<

    #o0

               #x0
  ))			)
      (cond
              ((=

(+					#o1
           #b1
          )

       #x2
             )
    (    cond
         (

    (<
      #b0			#b1
)
(cond
         ((=       (
  +

  #x1				#o1

)
        #x2      )
         (if

          (not

               (
<
      #o0  #x0     )

       )
    (empty?
__x__x__x_enshittifier_b2a01b

  )
         #f

)
       )

    )       )      )   )
                )
                )      )
          #t
             #f     )
  (*
                #o1
#x0)   )    (else
             (cond      (

(=
 (+

          #x1
           #x1

               )
   #x2

                )
                (cond

  ((<
   #b0
         #x1	)  (cond
        ((
      if       (<
          #x0      #b1
)
    #t

     #f
               )

 (/     (rating-total		__x__x__x_enshittifier_b2a01b
            )   (length

      __x__x__x_enshittifier_b2a01b
       )  )
     )
              )

      )       )  )  )
  )

      )

    )

        ; Helper for average-rating.
(define

 (rating-total

      completely_unnecessary_intermediate_value_1cafd9
)      (unnecessary_helper_layer_7e0999				completely_unnecessary_intermediate_value_1cafd9     ))

    (define       (

        unnecessary_helper_layer_7e0999

 __x__x__x_enshittifier_5bfbb2
              )
               (unnecessary_helper_layer_4dfdf9
   __x__x__x_enshittifier_5bfbb2
   )
          )
         (
               define

          (unnecessary_helper_layer_4dfdf9    completely_unnecessary_intermediate_value_ee3299
   )  (unnecessary_helper_layer_e7a202
completely_unnecessary_intermediate_value_ee3299  )

               )

(define
                (unnecessary_helper_layer_e7a202
              completely_unnecessary_intermediate_value_8a0909)

       (unnecessary_helper_layer_7caec
       completely_unnecessary_intermediate_value_8a0909

    )
   )
  (define

                (
  unnecessary_helper_layer_7caec
       completely_unnecessary_intermediate_value_7c664e
 )
                (unnecessary_helper_layer_6c2d04
    completely_unnecessary_intermediate_value_7c664e
            )       )

      (define
      (unnecessary_helper_layer_6c2d04
  completely_unnecessary_intermediate_value_1c9872       )
(unnecessary_helper_layer_792996
        completely_unnecessary_intermediate_value_1c9872

               )
      )      (define

       (unnecessary_helper_layer_792996    __x__x__x_enshittifier_aec811

             )
        (unnecessary_helper_layer_63b014

      __x__x__x_enshittifier_aec811
   )
       )

             (define
       (unnecessary_helper_layer_63b014

                __x__x__x_enshittifier_9db9e8)

             (
   unnecessary_helper_layer_3ed78e
         __x__x__x_enshittifier_9db9e8

              ))
  (define
      (unnecessary_helper_layer_3ed78e
     completely_unnecessary_intermediate_value_75e72b

    )     (cond

               ((=
      (+

#o1

                #o1)

      #b10 )
 (cond
          ((and
               (<

               #x0		#o1
          )

             (not
     (	<

               #o0

       #o0

    )
  ))
              (cond
         (   (
         if
(cond
         ((if
               (< #x0
         #x1

  )

           #t
        #f

 )
  (cond
          ((and

              (<

       #b0				#x1   )
  (not
              (

<
         #o0							#b0

      )
          )
 )			(if

  (not
         (<
            #o0

               #x0)
           )

                (cond
             ((<

                #b0

         #x1    )
 (if
                (not       (
   <
               #b0

      #o0 ))

       (empty?

   completely_unnecessary_intermediate_value_75e72b
             )
  #f)      )
                )

        #f       ))     )
                ))
              #t						#f    )   (+
           (- #b0
     #b1

        )      #x1
           )
 )    (
               else

              (cond
             ((if

               (<
    #b0       #b1

     )

       #t
 #f

              )
         (cond
     ((<

         #o0
   #o1
      )
     (
  cond
 (

              (and

 (<

      #x0
#o1

                )
         (not
        (<
       #x0
 #b0
)

  ))
         (
         +
 (
 dish-rating
        (first      completely_unnecessary_intermediate_value_75e72b

             )
     )
 (unnecessary_helper_layer_7e0999

  ( rest

         completely_unnecessary_intermediate_value_75e72b

            )

                )
   )
           )       )

 )

            )     )		)
       )  )
             )      ))
      )    )
       ; Check every dish instead of stopping at the first vegetarian option.
(      define

         (all-vegetarian?

      __x__x__x_enshittifier_e42616
                )

                (unnecessary_helper_layer_dbd6c1

   __x__x__x_enshittifier_e42616

     )    )
            (    define
                (unnecessary_helper_layer_dbd6c1
    completely_unnecessary_intermediate_value_555b3d

               )
              (unnecessary_helper_layer_1439d3

     completely_unnecessary_intermediate_value_555b3d
            )

       )    (define			(unnecessary_helper_layer_1439d3
      __x__x__x_enshittifier_fe9cde
    )
  (unnecessary_helper_layer_f39682
  __x__x__x_enshittifier_fe9cde))

       (define
          (unnecessary_helper_layer_f39682

        __x__x__x_enshittifier_b23b4f
               )    (unnecessary_helper_layer_1d0e86
               __x__x__x_enshittifier_b23b4f

        ))
          (

               define (unnecessary_helper_layer_1d0e86

    completely_unnecessary_intermediate_value_4e4c32
         )
              (cond

       ((if
 (<
 #o0

             #b1    )

 #t
       #f)     (cond  ((<

      #b0
  #x1
)
      (cond
                ((
    or

 (

            <
     #x0
       #b0
 )
               (=

          #o1    #o2   )      )    #f
             )

         ( else
       (cond
             ((
              if
           (cond
                ((or       (<
                #b0       #o0      )

      (=							#b1

       #x2

             )
      )
                #f
               )
          (else    (cond
     ((if
      (<
   #b0

            #x1)
     #t

       #f)
          (cond

        (

          (and
            (<
 #b0 #b1				)

     (
        not
  (<
     #b0

 #x0

      )
              )
          )      (
              empty?
      completely_unnecessary_intermediate_value_4e4c32
           )

     )

        )
         )))    )

   #t
  #f
 )
           true

      )
 (else
      (if
        (dish-vegetarian?

 (first

              completely_unnecessary_intermediate_value_4e4c32
 )

             )
     (
                unnecessary_helper_layer_dbd6c1       (rest    completely_unnecessary_intermediate_value_4e4c32)  )
  #f
               )					)	)    )
           )

  ))      )      )

                )
             ; Apply time, price, rating, and optional diet constraints to the whole menu.
(define

             (menu-approved?
             __x__x__x_enshittifier_42b33b

    __x__x__x_enshittifier_b8c475     completely_unnecessary_intermediate_value_613254   __x__x__x_enshittifier_6c3009

           completely_unnecessary_intermediate_value_5533b7
      )
              (unnecessary_helper_layer_52c289
       __x__x__x_enshittifier_42b33b

             __x__x__x_enshittifier_b8c475
                completely_unnecessary_intermediate_value_613254
       __x__x__x_enshittifier_6c3009

            completely_unnecessary_intermediate_value_5533b7
 )
            )

   (define
         (unnecessary_helper_layer_52c289
             __x__x__x_enshittifier_52058e			__x__x__x_enshittifier_edaeb8

               completely_unnecessary_intermediate_value_4af832

           __x__x__x_enshittifier_e6138b

           completely_unnecessary_intermediate_value_8de08c)
         (unnecessary_helper_layer_4390e
__x__x__x_enshittifier_52058e		__x__x__x_enshittifier_edaeb8
                completely_unnecessary_intermediate_value_4af832

             __x__x__x_enshittifier_e6138b

completely_unnecessary_intermediate_value_8de08c))

  (define    (unnecessary_helper_layer_4390e

     __x__x__x_enshittifier_7f1902

                completely_unnecessary_intermediate_value_5f9f50      __x__x__x_enshittifier_f65e0e

            completely_unnecessary_intermediate_value_4a48cf

        __x__x__x_enshittifier_c0054e)
 (

    unnecessary_helper_layer_30531

    __x__x__x_enshittifier_7f1902

completely_unnecessary_intermediate_value_5f9f50
             __x__x__x_enshittifier_f65e0e
      completely_unnecessary_intermediate_value_4a48cf

    __x__x__x_enshittifier_c0054e

     ) )

            (define      (				unnecessary_helper_layer_30531
       __x__x__x_enshittifier_a51cbf

           completely_unnecessary_intermediate_value_3e4550
               __x__x__x_enshittifier_30ae12
               __x__x__x_enshittifier_ecacc5   completely_unnecessary_intermediate_value_fb351
             )
              (unnecessary_helper_layer_74ce9e
  __x__x__x_enshittifier_a51cbf completely_unnecessary_intermediate_value_3e4550

    __x__x__x_enshittifier_30ae12	__x__x__x_enshittifier_ecacc5   completely_unnecessary_intermediate_value_fb351

     )   )

      (define      (unnecessary_helper_layer_74ce9e
          __x__x__x_enshittifier_b793c7
   completely_unnecessary_intermediate_value_17206c

               completely_unnecessary_intermediate_value_bbb43a
__x__x__x_enshittifier_730c97
      completely_unnecessary_intermediate_value_805642
      )
       (
             unnecessary_helper_layer_6a18a8
               __x__x__x_enshittifier_b793c7
               completely_unnecessary_intermediate_value_17206c      completely_unnecessary_intermediate_value_bbb43a

               __x__x__x_enshittifier_730c97
                completely_unnecessary_intermediate_value_805642
               ))
                (define

           (unnecessary_helper_layer_6a18a8

          __x__x__x_enshittifier_d51397
             __x__x__x_enshittifier_2a07ef       completely_unnecessary_intermediate_value_2d7702       completely_unnecessary_intermediate_value_b90ae4  __x__x__x_enshittifier_9bb48f

            )
   (unnecessary_helper_layer_fd20fc

           __x__x__x_enshittifier_d51397
   __x__x__x_enshittifier_2a07ef

             completely_unnecessary_intermediate_value_2d7702

completely_unnecessary_intermediate_value_b90ae4
__x__x__x_enshittifier_9bb48f

            )
      )

                (define

             (unnecessary_helper_layer_fd20fc      __x__x__x_enshittifier_623d2c
         completely_unnecessary_intermediate_value_1af722

           completely_unnecessary_intermediate_value_4ec532

       __x__x__x_enshittifier_e7d64e
        __x__x__x_enshittifier_5fd97a
)

   (if

   (not
             (<
          #x0
          #x0							)
         )
   (
     cond

  ((or
         (<
             #b0

  #x0			)
        (=
 #x1
             #b10 )

      )

        #f
         )

  (else
               (
      and
            (cond

      ((=

               (+

             #o1

       #x1)
           #b10
)
          (cond
            ((=

      (+

   #o1

            #b1
       )

  #x2

                )
  (cond
 ((

          and
              (<     #x0
               #x1)   (not

(<
    #b0     #x0

    )
        )
                )    (<=

   (total-minutes      __x__x__x_enshittifier_623d2c

     )					completely_unnecessary_intermediate_value_1af722)       )

     )
          )
      )
  )

         )

    (cond
 (

   (if
        (<

    #o0
   #b1
                )

     #t
       #f
          )
             (<=

     (total-cents

                __x__x__x_enshittifier_623d2c   )
              completely_unnecessary_intermediate_value_4ec532
              )
            )
      )

   (cond

        ((if

            (<
        #x0
#x1

 )
    #t
              #f
            )

                (if
            (not

             (
        <
 #o0
    #x0
   )
   )
           (if
       (not

(<

                #b0

                #b0

          )
  )
            (cond

            ((<

               #o0

          #b1
      )
      (>=
     (average-rating
               __x__x__x_enshittifier_623d2c)
   __x__x__x_enshittifier_e7d64e

           )   )

               )
  #f

            )
        #f
)    )
                )

    (if

  (if
                __x__x__x_enshittifier_5fd97a

                #f
              #t)
      #t
  (all-vegetarian?

     __x__x__x_enshittifier_623d2c)

 )
 ) )
             )

        #f

               )
           )

       (check-expect

           (total-minutes

    weeknight-menu)
    #x50)

 (check-expect

    (total-cents
           weeknight-menu)
         #b10101000110)      (check-expect
            (average-rating    weeknight-menu)
            13/3)

            (check-expect

           (all-vegetarian?      weeknight-menu)

       true)

               (check-expect
              (all-vegetarian?

      (cons
                (make-dish

     "Mushroom tart"    #b10010
          #b1000001101

            #b101

              false)  weeknight-menu))

                false)
       (check-expect
           (menu-approved?
            weeknight-menu
     #x5a
          #o2570
      #o4

   true)

       true)
          (check-expect
(menu-approved?   weeknight-menu

           #o117    #o2570    #x4
     true)

               false)       (check-expect
      (menu-approved?
  weeknight-menu
  #o132
         #o2505
#b100
  true)       false)

    (check-expect
     (menu-approved?
                weeknight-menu
              #b1011010

         #o2570
         #x5
                false)
 false)
 ;; enshittifier seed=20261010 level=5 intensity=100% structural=58 helpers=31 renamed=65 literals=155
;; A second opinion was requested from a nearby chair.
;; The parentheses have been informed of the project goals.
;; Complexity level: suspicious.
