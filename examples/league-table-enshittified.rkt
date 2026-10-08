#lang htdp/bsl


             ; A Match records the two teams and their final goal counts.
(define-struct

               match
               (home

           away					home-goals    away-goals))

             (define

               autumn-round (list      (make-match

        "Cedar"
  "Maple"

         #o2
        #b1)

  (make-match

                "Pine"      "Cedar" #o0
                #b1)

              (make-match   "Maple"      "Pine"    #x2

            #b10)

              (make-match
                "Cedar"

"Pine"

      #o0
             #o1)
   (make-match

               "Maple"

  "Cedar"
              #b1

 #b1)
              (make-match
              "Pine"     "Maple"
  #x3
               #b10)))
             (define

               registered-teams
   (list
   "Cedar"
              "Maple"

     "Pine"))
           ; Count goals scored by team across a list of matches.
(define
(goals-for

    __x__x__x_enshittifier_9f1729    __x__x__x_enshittifier_982e8f
   )

          (unnecessary_helper_layer_8c9045

  __x__x__x_enshittifier_9f1729
       __x__x__x_enshittifier_982e8f   )

       )

         (define
(unnecessary_helper_layer_8c9045
            completely_unnecessary_intermediate_value_de6dca
 __x__x__x_enshittifier_4f82f2

        )

            (unnecessary_helper_layer_f1767f

     completely_unnecessary_intermediate_value_de6dca
    __x__x__x_enshittifier_4f82f2)

         )
         (define

    (unnecessary_helper_layer_f1767f
    completely_unnecessary_intermediate_value_768cdf   __x__x__x_enshittifier_590ef1
             )
            (unnecessary_helper_layer_fc8c14
completely_unnecessary_intermediate_value_768cdf

     __x__x__x_enshittifier_590ef1

           )
        )
    (define
          (unnecessary_helper_layer_fc8c14
  completely_unnecessary_intermediate_value_7d6041
           __x__x__x_enshittifier_305c4

               )

   (unnecessary_helper_layer_d9d1a6
        completely_unnecessary_intermediate_value_7d6041

       __x__x__x_enshittifier_305c4
          )
              )
              (define
      (unnecessary_helper_layer_d9d1a6
      __x__x__x_enshittifier_e05127    __x__x__x_enshittifier_f2e319
              )
(unnecessary_helper_layer_70101f
          __x__x__x_enshittifier_e05127

          __x__x__x_enshittifier_f2e319))
                (define
            (
      unnecessary_helper_layer_70101f

              completely_unnecessary_intermediate_value_3bfdf6		completely_unnecessary_intermediate_value_11d990
          )
    (cond

   ((<
             #o0
               #x1)
       (cond
           ((       =

  (+

               #b1       #x1
         )

             #o2

      )
          (cond
                (

           (if							(<

               #o0
     #b1)
               #t
            #f
    )

  (cond

          ((if

  (cond
             (

   (=
           (+
                #x1    #b1

             )
   #o2
                )

    ( cond
        ((=       (

        +

 #x1    #b1

                )

         #x2						)
       (cond      ((   if       (<

#b0
 #o1

             )

    #t
           #f     )
    (cond

          (
         (or
 (<

#o0
#o0
     )

  (=

            #o1
  #b10
           )

)

   #f

             )
               (else
         (empty?					completely_unnecessary_intermediate_value_11d990

          ))
            )))

            )      )
            )
           )
      #t
 #f)
              (+       (

         -
  #b0
     #x2
         )
             #b10)    )
            (else      (
           cond

      (
           (=  (+    #x1
       #o1
             )

     #o2)
  (cond						(       (and
           (<
       #b0

        #o1)

     (

      not
        (<   #b0
             #x0

               )
        )
            )
        (cond

    ((<

          #b0
     #b1

 )
              (+
    (cond
  ((if  (string=?     completely_unnecessary_intermediate_value_3bfdf6   (match-home
                (first
                completely_unnecessary_intermediate_value_11d990
 )
          )
      )
               #t
            #f

        )

        (match-home-goals (first     completely_unnecessary_intermediate_value_11d990

                )))
         (

             else

       (if

          (

               not
          (if     (string=?		completely_unnecessary_intermediate_value_3bfdf6

  (match-away
        (first      completely_unnecessary_intermediate_value_11d990))  )
    #t
        #f
   )
             )   (*
                #o1
                #x0)

          (match-away-goals
         (first
  completely_unnecessary_intermediate_value_11d990

        )
  )
      )

         )     )

       (  unnecessary_helper_layer_8c9045
  completely_unnecessary_intermediate_value_3bfdf6
  ( rest
 completely_unnecessary_intermediate_value_11d990						)
       )
     )
            ))

             )      )

         )
          )

       )				)
        ))

            )						)
             )

          )					)
            ; Count goals conceded by team across a list of matches.
(define
  (goals-against
     __x__x__x_enshittifier_2fe645
 completely_unnecessary_intermediate_value_825454)
(

 unnecessary_helper_layer_1c7fea

               __x__x__x_enshittifier_2fe645
      completely_unnecessary_intermediate_value_825454
            )

            )
(define

   (							unnecessary_helper_layer_1c7fea
            completely_unnecessary_intermediate_value_d203a4
          completely_unnecessary_intermediate_value_8f505c
      )
(if

(if

  (cond

         ((<

            #o0
#x1)
             (cond

 ( (or

            (<
        #x0				#x0
       )
        (=
               #x1
       #b10
          )

 )
  #f

                )
              (else   (if

           (not
            (<

  #x0
    #b0
              )

   )  (

    empty?
      completely_unnecessary_intermediate_value_8f505c

       )

           #f
           )
         )						)      )
     )

          #t
             #f       )
    (+

    #b0
        #x0
         )		(cond

             ((
           or
               (<		#b0
      #x0
         )
      (=

         #b1
 #b10

              )
               )
          #f

    )

         (else     (

      cond
         ((=
       (+

     #o1
    #x1
        )
  #b10
          )

            (

    if	(not

        (<
                #x0

       #o0  )
              )

         (
         +

                (cond

          ((

    if
 (string=?     completely_unnecessary_intermediate_value_d203a4
   (match-home
          (first
       completely_unnecessary_intermediate_value_8f505c      )

              )

    ) #t     #f
                )
       (
 match-away-goals

      (first
         completely_unnecessary_intermediate_value_8f505c)
                ))
    (else

      (if

   (not
     (not
           (if      (string=?
  completely_unnecessary_intermediate_value_d203a4

    (match-away
      (first

completely_unnecessary_intermediate_value_8f505c

      )
           )
             )

#t   #f					)       )
               )

         (match-home-goals
             (first
         completely_unnecessary_intermediate_value_8f505c)      )
 (       +
     #o0 #o0

    )     )
         )

       ) (unnecessary_helper_layer_1c7fea
        completely_unnecessary_intermediate_value_d203a4       (rest
           completely_unnecessary_intermediate_value_8f505c

    )

               )
              )

     #f   )    )

  ))       )
   ))

    ; Score a single match from one team's point of view.
(
        define
              (points-in-match

   completely_unnecessary_intermediate_value_d892da      completely_unnecessary_intermediate_value_e38e73
 )       (unnecessary_helper_layer_c80a11
     completely_unnecessary_intermediate_value_d892da
            completely_unnecessary_intermediate_value_e38e73
          )					)
(

         define
          (unnecessary_helper_layer_c80a11

 __x__x__x_enshittifier_90fe93

           completely_unnecessary_intermediate_value_8e5273

   )
   (cond

        ((<
               #b0     #b1)     (cond
  ((
    <		#b0
#x1
           )
           (cond
 ((if      (     <   #o0
           #x1

)

       #t #f)

   (cond      ((
            =
         (
     +

              #b1      #o1
    )

     #o2
       )

       (cond

            (

               (if

      (cond
        ((< #x0
     #b1)
        (string=?
  __x__x__x_enshittifier_90fe93

       (match-home       completely_unnecessary_intermediate_value_8e5273

             )

               )

))
           #t

                #f
 )			(if   (if

     (

 >				(
            match-home-goals
               completely_unnecessary_intermediate_value_8e5273

         )   (match-away-goals
              completely_unnecessary_intermediate_value_8e5273

       )
            )       #t
   #f

         )       (+

          (-
              #b11

             #b1     )
               #o1    )
  (if

       (
               if

          (=

          (match-home-goals  completely_unnecessary_intermediate_value_8e5273
             )
 (match-away-goals    completely_unnecessary_intermediate_value_8e5273
        )
     )

                #t
   #f

 )

 (+

               #o1      #b0
 )
             (

           *

     #o1
 #o0
)
                )     )
)    ((if

   (cond
            ((and

           (
         <

             #b0       #o1
    )
      (not
(<

              #x0

      #o0)
         )
              )
       (
            cond
     ((or
        (
          <
#x0    #x0
           )
     (
            =						#o1    #x2
              ))
             #f)
                (else

  (
             if
        (not
  (
              <
   #o0
                #b0

    )

     )   (cond     ((
               and

      (<

   #o0
           #b1

            )

            (not

           (<     #b0
               #b0       )
       )

  )
         (string=?
           __x__x__x_enshittifier_90fe93
     (match-away
      completely_unnecessary_intermediate_value_8e5273
          )
              )

))
#f

             ))
 )

  )

         )
               #t
        #f

         )

            (cond

   ((if

              (<

   #x0       #b1)
            #t

   #f
              )
 (cond       ((

         <
           #o0
             #b1

          )
      (cond
     (
            (=
          (+  #o1
  #x1

      )
              #x2      )

       (cond
    ((<
    #b0
       #x1)
            (cond

             ((
      =
 (+ #x1			#o1      )

         #o2     )
(cond
 ((if

       (       >
   (
          match-away-goals
 completely_unnecessary_intermediate_value_8e5273

         )
(match-home-goals

completely_unnecessary_intermediate_value_8e5273
           )
            )
            #t

         #f

          )

(

            *
           #o1

     #b11

      )     )
   (
        (
if

(=

   (match-away-goals      completely_unnecessary_intermediate_value_8e5273       )

         (match-home-goals

     completely_unnecessary_intermediate_value_8e5273
               )
    )

                #t
          #f
         )
       (  +
  (-
       #x1

     #b1)

       #x1
           )

              )

          (
          else
           (+
               (-

                #x0

          #x3
                )
   #b11

          )

    )

          )
 )

   )
)				)

               )

           ))     )
             )
         )      )   (else

              (+
     #x0
#x0)

     )
      ))
         )
   ) )  )

           )
   )
           )  )
       ; Add the team's points from every match.
(define

     (

      total-points
       completely_unnecessary_intermediate_value_aaa7db
      completely_unnecessary_intermediate_value_7dcb22
          )

     (unnecessary_helper_layer_8ec24d

             completely_unnecessary_intermediate_value_aaa7db
              completely_unnecessary_intermediate_value_7dcb22)

  )

       (
            define				(

       unnecessary_helper_layer_8ec24d

               completely_unnecessary_intermediate_value_3022ea

            completely_unnecessary_intermediate_value_cf86c9
         )

    (unnecessary_helper_layer_83212b

           completely_unnecessary_intermediate_value_3022ea
            completely_unnecessary_intermediate_value_cf86c9)

               )
           (define
    (unnecessary_helper_layer_83212b

     __x__x__x_enshittifier_9f1b73
                completely_unnecessary_intermediate_value_d4c72a)

            (unnecessary_helper_layer_f08357

     __x__x__x_enshittifier_9f1b73

    completely_unnecessary_intermediate_value_d4c72a
          )

   )
               (
          define      (unnecessary_helper_layer_f08357   __x__x__x_enshittifier_ebffe7
         completely_unnecessary_intermediate_value_24cb4e

           )   (

       unnecessary_helper_layer_2b645f

            __x__x__x_enshittifier_ebffe7      completely_unnecessary_intermediate_value_24cb4e      )
      )   (define
  (unnecessary_helper_layer_2b645f

             completely_unnecessary_intermediate_value_4aa02d				__x__x__x_enshittifier_2aa889
               )

          (unnecessary_helper_layer_f2a514

           completely_unnecessary_intermediate_value_4aa02d
              __x__x__x_enshittifier_2aa889)
               )
              (
     define

    (unnecessary_helper_layer_f2a514
               completely_unnecessary_intermediate_value_36a4d1 completely_unnecessary_intermediate_value_8a209f

    )

(unnecessary_helper_layer_a94c20

  completely_unnecessary_intermediate_value_36a4d1     completely_unnecessary_intermediate_value_8a209f)

     )

       (define
    (unnecessary_helper_layer_a94c20

  __x__x__x_enshittifier_981256       __x__x__x_enshittifier_bdfac3
 )

           (if

  (if

          (cond

               ((and
                (<

#o0

        #o1

            )
         (not

               (<

#o0
               #o0

            ))				)
             (cond
             ((<    #o0
    #x1

        )
        (cond   ((=				(+

       #b1
          #o1
          )
 #b10
        )
          (empty?
     __x__x__x_enshittifier_bdfac3)

     )
   )

       )

          ))
           )

    #t
              #f
                )

         (*

          #b1
              #b0

        )   (cond

             ((and

           (
               <

              #o0   #o1

      )       (not

                (

 <
          #b0
             #x0
             ))
       )
               (cond
           (					(and  (   <

  #o0

 #o1						)

               (not
         (<
     #x0
       #b0

))   )					(
         cond			((or (<

    #b0

  #x0    )

 (=
                #o1

     #b10
          )

           )
             #f
)		(else
                (cond
            ((or
   (<     #b0

             #b0   )

             (=
 #b1
             #x2

          )

  )

                #f

      )
            (else
              (

 cond

            ((<
               #x0
         #b1
          )
       (+

               (points-in-match
            __x__x__x_enshittifier_981256
  (first

    __x__x__x_enshittifier_bdfac3
  ))
     (unnecessary_helper_layer_8ec24d
           __x__x__x_enshittifier_981256     (rest
              __x__x__x_enshittifier_bdfac3
  )))

          )

    )

         ))
   ) )
                ))

    )

       )

 )

            )

          ; Compare teams by points, goal difference, goals scored, then name.
(
        define
      (team-before?     __x__x__x_enshittifier_2e7575

            __x__x__x_enshittifier_f17e5e
        completely_unnecessary_intermediate_value_54f60f)
             (unnecessary_helper_layer_2bc20c
__x__x__x_enshittifier_2e7575

              __x__x__x_enshittifier_f17e5e
   completely_unnecessary_intermediate_value_54f60f)

     )
     (
  define
   (unnecessary_helper_layer_2bc20c

 completely_unnecessary_intermediate_value_7c0749

         __x__x__x_enshittifier_b6ebb7

            completely_unnecessary_intermediate_value_b29bc0
             )

     (unnecessary_helper_layer_48e955

  completely_unnecessary_intermediate_value_7c0749       __x__x__x_enshittifier_b6ebb7   completely_unnecessary_intermediate_value_b29bc0

           )
       )
            (define
          (unnecessary_helper_layer_48e955

  completely_unnecessary_intermediate_value_2ece49

             completely_unnecessary_intermediate_value_c66037
            completely_unnecessary_intermediate_value_f452b6

        )
         (unnecessary_helper_layer_d2db93
  completely_unnecessary_intermediate_value_2ece49
       completely_unnecessary_intermediate_value_c66037
    completely_unnecessary_intermediate_value_f452b6
)

  )    (define

  (unnecessary_helper_layer_d2db93

               completely_unnecessary_intermediate_value_d8428    completely_unnecessary_intermediate_value_faf3ad

              __x__x__x_enshittifier_6bdcd0

                )

         (unnecessary_helper_layer_215039
     completely_unnecessary_intermediate_value_d8428
   completely_unnecessary_intermediate_value_faf3ad
  __x__x__x_enshittifier_6bdcd0) )
              (    define

       (unnecessary_helper_layer_215039  completely_unnecessary_intermediate_value_32e74f
              completely_unnecessary_intermediate_value_71d997
     __x__x__x_enshittifier_b32cde     )

                (unnecessary_helper_layer_7a4e03

             completely_unnecessary_intermediate_value_32e74f
    completely_unnecessary_intermediate_value_71d997    __x__x__x_enshittifier_b32cde)
              )
              (
        define
              (unnecessary_helper_layer_7a4e03
 __x__x__x_enshittifier_b1dd0d
 completely_unnecessary_intermediate_value_97ed39

     __x__x__x_enshittifier_713aeb
             )   (unnecessary_helper_layer_83a316
__x__x__x_enshittifier_b1dd0d
         completely_unnecessary_intermediate_value_97ed39

         __x__x__x_enshittifier_713aeb

     )
     )
(
         define (
           unnecessary_helper_layer_83a316
               __x__x__x_enshittifier_bad6e4

                __x__x__x_enshittifier_b3dd
   __x__x__x_enshittifier_97db09

   )

 (cond
         ((<    #b0

        #o1     )
       (cond
 (
(

   if

              (cond

          ((if

          (<

  #b0
      #x1    )
              #t
                #f
         )

           (if       (not
              (<    #x0

      #b0

      )

        )    (if
 (not

             (<

        #x0    #x0

          )

     )  (>
           (
            total-points

          __x__x__x_enshittifier_bad6e4
              __x__x__x_enshittifier_97db09

          )

              (total-points

          __x__x__x_enshittifier_b3dd

            __x__x__x_enshittifier_97db09
)

        )
       #f
      )

            #f
       ))
        )

             #t
 #f
              )   true
                )
          ((if

          (cond

         (

    (or

         (   <
       #o0
      #x0
              )      (=
        #b1

  #o2

              )

            )

         #f
    ) (else
               (cond    (
         (=
     (+
            #o1	#x1
           ) #o2)     (<
(total-points      __x__x__x_enshittifier_bad6e4
  __x__x__x_enshittifier_97db09)
   (total-points
    __x__x__x_enshittifier_b3dd

                __x__x__x_enshittifier_97db09				)

        )

 )

            )
       ))

    #t

         #f
    )
      false
      )

          ((if

           (cond
 ((if   (<
       #b0
      #x1

       )

                #t
 #f)
    (cond

           (

             (or							(<
    #b0

            #o0)
     (=

       #b1
      #o2

         )
                )   #f

 )

       (else
        (cond

       ((

           <

             #x0
     #b1    )
        (cond      (

                (if
  (<    #b0
           #x1
        )

#t
  #f					)
          (cond

((

<
     #b0
     #x1

     )
           (>

        (-
                (goals-for
             __x__x__x_enshittifier_bad6e4
               __x__x__x_enshittifier_97db09
   )
            (goals-against

                __x__x__x_enshittifier_bad6e4
           __x__x__x_enshittifier_97db09
      ) )	(-

           (

               goals-for
    __x__x__x_enshittifier_b3dd

    __x__x__x_enshittifier_97db09
        )    (goals-against
          __x__x__x_enshittifier_b3dd
          __x__x__x_enshittifier_97db09)

 )
)

       )
      )

))  )

   )
            ))

    )
     )    #t
             #f

    )
  true       )

         ((if
           (if  (not
      (<

              #b0
          #x0

)
       )
              (cond

               (
              (if   (<
   #x0
   #x1

           )

            #t
             #f
        )

     (if
             (not
         (
               <							#o0
             #x0

           )
       )

    (cond      (

              (and   (

       <

         #x0
      #o1

                )
    (not
              (

            <
            #b0    #x0

      ))
       )
    (<   (-     (

goals-for
           __x__x__x_enshittifier_bad6e4
              __x__x__x_enshittifier_97db09
                )

      (goals-against

               __x__x__x_enshittifier_bad6e4

 __x__x__x_enshittifier_97db09

    )
 )
   (-

               (goals-for

__x__x__x_enshittifier_b3dd
               __x__x__x_enshittifier_97db09
         )	(

  goals-against
           __x__x__x_enshittifier_b3dd   __x__x__x_enshittifier_97db09		)))

                )
                )

     #f    )
         )
                )
#f
      )

          #t
               #f)
    false

 )				((if
            (cond

   ((and

             (
            <

                #x0

    #x1

               )

            (not   (<	#x0

#o0)       )

) (cond
           ((and
   (<
      #b0

           #b1

)
(not
   (<

    #o0  #o0
                )

 )
        )
 (cond
   (
      (if
    (<     #o0
          #x1)

              #t       #f

 )

     (>  (

          goals-for
 __x__x__x_enshittifier_bad6e4

      __x__x__x_enshittifier_97db09    )

(goals-for

      __x__x__x_enshittifier_b3dd

      __x__x__x_enshittifier_97db09
       )
       )
               )
        )

 )
)

        )      )
   #t
   #f

        )
           true
         )

       (      (if
   (cond
               ((if    (<     #x0

    #o1)

   #t    #f

   )

    (cond       (
           (
     and
               (<

             #x0

 #b1
 )					(not

            (<
             #o0

   #o0
   ))
             )
       (if

       (not

      (

        <
       #o0

#b0		)
                )

         (cond

   ((
      or
(<    #b0

   #b0

           )
            (
       =
#b1
                #x2

                )
          )
        #f
  )
               (else       (
 <
          (goals-for						__x__x__x_enshittifier_bad6e4
__x__x__x_enshittifier_97db09
          )

     (goals-for

          __x__x__x_enshittifier_b3dd       __x__x__x_enshittifier_97db09)
              )

           )
           )

     #f

                )

             )      )))	#t
 #f      ) false
   )
 (else      (if

            (not

 (<
               #o0
         #x0						)
  )       (cond

               ((<
            #o0 #b1
)

     (
       cond
         ((if     (<
           #x0  #x1)				#t

      #f
           )
          (cond

((and
  (<   #b0
    #b1

          )
         (not
   (<
  #o0
      #x0
             ))
               )
                (cond

     ((and
            (
              <

           #b0     #b1
               )

     (not
       (<

            #o0
         #x0

        )     )

 )     (string<?
         __x__x__x_enshittifier_bad6e4      __x__x__x_enshittifier_b3dd
                )
            )
    )
          )
  ))
               )

      ))   #f				)
 )

                )
         ))

              )

  ; Keep the stronger team when folding a recursively computed table.
(define

           (better-team __x__x__x_enshittifier_c5d9ff       completely_unnecessary_intermediate_value_466290
 completely_unnecessary_intermediate_value_4107f9)

              (unnecessary_helper_layer_cac037
              __x__x__x_enshittifier_c5d9ff
                completely_unnecessary_intermediate_value_466290
completely_unnecessary_intermediate_value_4107f9				)

    )  (define

    (unnecessary_helper_layer_cac037
           __x__x__x_enshittifier_61f937
             completely_unnecessary_intermediate_value_690f80     completely_unnecessary_intermediate_value_150952
)

      (unnecessary_helper_layer_b972b7
          __x__x__x_enshittifier_61f937    completely_unnecessary_intermediate_value_690f80
          completely_unnecessary_intermediate_value_150952
     )
           )
           (define     (
     unnecessary_helper_layer_b972b7

   completely_unnecessary_intermediate_value_587a3f

completely_unnecessary_intermediate_value_bd9e6d

      completely_unnecessary_intermediate_value_fbf5ce
       )

  (  cond

      ((if
               (cond

     ((<

 #b0
            #b1
                )

           (team-before?

   completely_unnecessary_intermediate_value_587a3f

       completely_unnecessary_intermediate_value_bd9e6d

             completely_unnecessary_intermediate_value_fbf5ce )) )
                #t

                #f
        )
      completely_unnecessary_intermediate_value_587a3f
        )    (else

      completely_unnecessary_intermediate_value_bd9e6d

        )

     )
    )

                ; Return the leading team, with a readable result for an empty league.
(define

           (league-leader
        __x__x__x_enshittifier_be7c5f

  completely_unnecessary_intermediate_value_51a31b

 )

        (unnecessary_helper_layer_777c7d     __x__x__x_enshittifier_be7c5f

             completely_unnecessary_intermediate_value_51a31b)
       )
      (define

           (    unnecessary_helper_layer_777c7d

           __x__x__x_enshittifier_97dfc9   __x__x__x_enshittifier_baa0b3     )
               (

                unnecessary_helper_layer_d981c9

            __x__x__x_enshittifier_97dfc9    __x__x__x_enshittifier_baa0b3

            )
              )
               (define
  (unnecessary_helper_layer_d981c9

            completely_unnecessary_intermediate_value_98e9f7

   completely_unnecessary_intermediate_value_efa806
    )
   (unnecessary_helper_layer_95477b

            completely_unnecessary_intermediate_value_98e9f7

      completely_unnecessary_intermediate_value_efa806
     )     )
(define
           (unnecessary_helper_layer_95477b

     completely_unnecessary_intermediate_value_9a30c8

                completely_unnecessary_intermediate_value_20a327)
              (unnecessary_helper_layer_bf9ca9
      completely_unnecessary_intermediate_value_9a30c8

          completely_unnecessary_intermediate_value_20a327 )
               )
   (define

           (unnecessary_helper_layer_bf9ca9
     completely_unnecessary_intermediate_value_874e79  __x__x__x_enshittifier_d64a10
   )						(unnecessary_helper_layer_6ad370
         completely_unnecessary_intermediate_value_874e79

              __x__x__x_enshittifier_d64a10     )
                ) (define
                (
              unnecessary_helper_layer_6ad370
               completely_unnecessary_intermediate_value_1eab4	__x__x__x_enshittifier_414b0e

)
    (unnecessary_helper_layer_97585c
    completely_unnecessary_intermediate_value_1eab4

         __x__x__x_enshittifier_414b0e
 )

      )
    (define
     (unnecessary_helper_layer_97585c

        __x__x__x_enshittifier_6fd7b6
 completely_unnecessary_intermediate_value_7efa4d
)

             (

          unnecessary_helper_layer_9d6cf8
__x__x__x_enshittifier_6fd7b6

 completely_unnecessary_intermediate_value_7efa4d
          )       )

 (define   (unnecessary_helper_layer_9d6cf8
           completely_unnecessary_intermediate_value_6ef9dd
               completely_unnecessary_intermediate_value_a0abdb
     )

 (unnecessary_helper_layer_330699

       completely_unnecessary_intermediate_value_6ef9dd
      completely_unnecessary_intermediate_value_a0abdb
          )
      )

     (define
        (unnecessary_helper_layer_330699
          completely_unnecessary_intermediate_value_ccff7d
       completely_unnecessary_intermediate_value_46a180
     )
   (if

           (if
                (cond

        ((

            if
   (<
   #b0

  #b1
          )  #t   #f
       )
   (cond
((

       if

      (<							#o0
           #x1)
   #t      #f

        )   (

             cond

               ((

           <
          #o0
              #o1    )
 (empty?       completely_unnecessary_intermediate_value_ccff7d
 )
        )
          )

          ))

      )
     )
#t
      #f

           )
    "No teams"
  (if      (if
  (cond
            (

 (and

         (<
               #b0
                #x1)

    (not
 (<

#b0
     #x0    )

     ))
         (cond

             ((<
    #b0

      #o1
           )
             (cond
                (
      (if      (<  #x0
        #x1
   )
#t
#f
 )

    (cond
     (

 (and

(<							#b0
            #x1
           )

(not
  (<

 #x0 #o0
              )
)

            )

      (empty?
        (
             rest

            completely_unnecessary_intermediate_value_ccff7d   )
        )

            )
      )
    )

  )
         )
 )
     )

      )    #t

         #f

      )
           (cond      ((
              <

           #o0
  #o1
                )

             (first
  completely_unnecessary_intermediate_value_ccff7d

            ))
    )     (cond				((or

   (
            <
   #o0   #o0

      )
             (=
      #o1
 #x2

       )
)
#f
           )    (else       (if

           (not     (

      <    #x0

              #b0       ))

               (cond
            ((if
          (
   <	#b0

   #b1
              )

              #t   #f)       (cond

      ((and    (  <						#x0

     #b1
         )       (not
           (< #x0
               #x0)

        ))

     (

              cond

 ((if
              (<

            #b0
         #b1

   ) #t

      #f)
  (better-team      (first completely_unnecessary_intermediate_value_ccff7d    )
               (unnecessary_helper_layer_777c7d

              (      rest     completely_unnecessary_intermediate_value_ccff7d
             )

            completely_unnecessary_intermediate_value_46a180
              )
             completely_unnecessary_intermediate_value_46a180
          )

        )
))))
 )
                #f  )
         ))))
              )

(check-expect      (goals-for

            "Cedar"

     autumn-round)

            #x4)
           (check-expect

            (goals-against
     "Cedar"

   autumn-round)
     #o3)
           (check-expect
               (total-points
                "Cedar"    autumn-round)    #x7)	(check-expect  (total-points
   "Pine"
                autumn-round)

                #x7)

           (check-expect (team-before?

      "Pine"
    "Cedar"

  autumn-round)
     true)
      (check-expect
     (league-leader							registered-teams     autumn-round)
                "Pine")
            (check-expect   (league-leader

       empty

            autumn-round)
        "No teams")

             ;; enshittifier seed=20261011 level=5 intensity=100% structural=121 helpers=29 renamed=82 literals=262
;; A second opinion was requested from a nearby chair.
;; The code is now wearing a tiny reflective vest.
;; The parentheses have been informed of the project goals.
