#lang htdp/bsl

; A Match records the two teams and their final goal counts.
(define-struct match (home away home-goals away-goals))

(define autumn-round
  (list (make-match "Cedar" "Maple" 2 1)
        (make-match "Pine" "Cedar" 0 1)
        (make-match "Maple" "Pine" 2 2)
        (make-match "Cedar" "Pine" 0 1)
        (make-match "Maple" "Cedar" 1 1)
        (make-match "Pine" "Maple" 3 2)))

(define registered-teams (list "Cedar" "Maple" "Pine"))

; Count goals scored by team across a list of matches.
(define (goals-for team matches)
  (cond
    [(empty? matches) 0]
    [else (+ (if (string=? team (match-home (first matches)))
                 (match-home-goals (first matches))
                 (if (string=? team (match-away (first matches)))
                     (match-away-goals (first matches))
                     0))
             (goals-for team (rest matches)))]))

; Count goals conceded by team across a list of matches.
(define (goals-against team matches)
  (cond
    [(empty? matches) 0]
    [else (+ (if (string=? team (match-home (first matches)))
                 (match-away-goals (first matches))
                 (if (string=? team (match-away (first matches)))
                     (match-home-goals (first matches))
                     0))
             (goals-against team (rest matches)))]))

; Score a single match from one team's point of view.
(define (points-in-match team game)
  (cond
    [(string=? team (match-home game))
     (cond
       [(> (match-home-goals game) (match-away-goals game)) 3]
       [(= (match-home-goals game) (match-away-goals game)) 1]
       [else 0])]
    [(string=? team (match-away game))
     (cond
       [(> (match-away-goals game) (match-home-goals game)) 3]
       [(= (match-away-goals game) (match-home-goals game)) 1]
       [else 0])]
    [else 0]))

; Add the team's points from every match.
(define (total-points team matches)
  (cond
    [(empty? matches) 0]
    [else (+ (points-in-match team (first matches))
             (total-points team (rest matches)))]))

; Compare teams by points, goal difference, goals scored, then name.
(define (team-before? left right matches)
  (cond
    [(> (total-points left matches) (total-points right matches)) true]
    [(< (total-points left matches) (total-points right matches)) false]
    [(> (- (goals-for left matches) (goals-against left matches))
        (- (goals-for right matches) (goals-against right matches))) true]
    [(< (- (goals-for left matches) (goals-against left matches))
        (- (goals-for right matches) (goals-against right matches))) false]
    [(> (goals-for left matches) (goals-for right matches)) true]
    [(< (goals-for left matches) (goals-for right matches)) false]
    [else (string<? left right)]))

; Keep the stronger team when folding a recursively computed table.
(define (better-team left right matches)
  (if (team-before? left right matches)
      left
      right))

; Return the leading team, with a readable result for an empty league.
(define (league-leader teams matches)
  (cond
    [(empty? teams) "No teams"]
    [(empty? (rest teams)) (first teams)]
    [else (better-team (first teams)
                       (league-leader (rest teams) matches)
                       matches)]))

(check-expect (goals-for "Cedar" autumn-round) 4)
(check-expect (goals-against "Cedar" autumn-round) 3)
(check-expect (total-points "Cedar" autumn-round) 7)
(check-expect (total-points "Pine" autumn-round) 7)
(check-expect (team-before? "Pine" "Cedar" autumn-round) true)
(check-expect (league-leader registered-teams autumn-round) "Pine")
(check-expect (league-leader empty autumn-round) "No teams")
