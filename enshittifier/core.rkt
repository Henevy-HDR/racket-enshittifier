#lang racket/base

(require racket/list
         racket/match
         racket/port
         racket/pretty
         racket/set
         racket/string)

(provide (struct-out transformation)
         (struct-out language-profile)
         (struct-out transformation-rule)
         enshittify-source
         registered-transformations
         read-source-datums
         language-profile-for
         htdp-student-source?)

(struct transformation
  (source seed intensity level literal-count comment-count student-language?
          structural-count helper-count renamed-identifiers capabilities
          skipped-function-count)
  #:transparent)

(struct language-profile (name capabilities student?) #:transparent)

;; Rules are data so the scheduler can apply one safety policy to every rewrite.
(struct transformation-rule
  (id categories requires safety weight complexity apply)
  #:transparent)

(struct counters (structural helpers renamed literals comments skipped)
  #:mutable
  #:transparent)

(struct engine-state
  (level intensity capabilities safe-functions text-density
         identifier-chaos helper-proliferation counters)
  #:transparent)

(struct function-info (name params body syntax start end) #:transparent)
(struct source-edit (start end replacement) #:transparent)

(define maximum-seed 2147483647)
(define maximum-ast-depth 96)

(define (make-seeded-generator seed)
  (define generator (make-pseudo-random-generator))
  (parameterize ([current-pseudo-random-generator generator])
    (random-seed seed))
  generator)

(define bsl-capabilities
  '(student-language if cond top-level-define top-level-helper
    exact-integer-arithmetic radix-literals direct-recursion
    alpha-renaming safe-expression-reconstruction
    boolean-only-short-circuit logical-connectives))

(define bsl-plus-capabilities (append bsl-capabilities '(list-abbreviations)))
(define isl-capabilities (append bsl-plus-capabilities '(local-binding)))
(define isl-plus-capabilities (append isl-capabilities '(lambda)))
(define asl-capabilities (append isl-capabilities '(lambda)))
(define racket-capabilities
  '(if cond top-level-define top-level-helper exact-integer-arithmetic
    direct-recursion alpha-renaming safe-expression-reconstruction
    logical-connectives))

(define bsl-profile (language-profile 'bsl bsl-capabilities #t))
(define bsl-plus-profile (language-profile 'bsl+ bsl-plus-capabilities #t))
(define isl-profile (language-profile 'isl isl-capabilities #t))
(define isl-plus-profile (language-profile 'isl+ isl-plus-capabilities #t))
(define asl-profile (language-profile 'asl asl-capabilities #t))
(define racket-profile (language-profile 'racket racket-capabilities #f))
(define unknown-profile (language-profile 'unknown '() #f))

(define language-header-map
  (hash "htdp/bsl" bsl-profile
        "htdp/bsl+" bsl-plus-profile
        "htdp/isl" isl-profile
        "htdp/isl+" isl-plus-profile
        "htdp/asl" asl-profile
        "racket" racket-profile
        "racket/base" racket-profile))

(define (language-profile-for source-or-name)
  (cond
    [(symbol? source-or-name)
     (case source-or-name
       [(bsl) bsl-profile]
       [(bsl+) bsl-plus-profile]
       [(isl) isl-profile]
       [(isl+) isl-plus-profile]
       [(asl) asl-profile]
       [(racket racket/base) racket-profile]
       [else #f])]
    [(string? source-or-name)
     (define header
       (regexp-match #px"(?m:^#lang[ \t]+([^ \t\r\n]+))" source-or-name))
     (cond
      [header
        (hash-ref language-header-map (cadr header) unknown-profile)]
       [else
        (define name (string-downcase source-or-name))
        (cond
          [(regexp-match? #px"advanced student" name) asl-profile]
          [(and (regexp-match? #px"intermediate student" name)
                (or (regexp-match? #px"lambda" name)
                    (regexp-match? #px"list abbreviations" name)))
           isl-plus-profile]
          [(regexp-match? #px"intermediate student" name) isl-profile]
          [(and (regexp-match? #px"beginning student" name)
                (regexp-match? #px"list abbreviations" name))
           bsl-plus-profile]
          [(regexp-match? #px"beginning student" name) bsl-profile]
          [(regexp-match? #px"racket" name) racket-profile]
          [else #f])])]
    [else #f]))

(define (source-has-language-header? source)
  (regexp-match? #px"(?m:^#lang[ \t]+[^ \t\r\n]+)" source))

(define (htdp-student-source? source)
  (and (let ([profile (language-profile-for source)])
         (and profile (language-profile-student? profile)))
       #t))

(define (read-source-syntax source)
  (call-with-input-string
   source
   (lambda (in)
     (port-count-lines! in)
     (parameterize ([read-accept-reader #t])
       (let loop ([forms '()])
         (define next (read-syntax 'enshittifier in))
         (if (eof-object? next)
             (reverse forms)
             (loop (cons next forms))))))))

(define (read-source-datums source)
  (map syntax->datum (read-source-syntax source)))

(define (reader-module-forms forms)
  (cond
    [(and (= (length forms) 1)
          (let ([parts (syntax->list (car forms))])
            (and parts
                 (>= (length parts) 4)
                 (eq? (syntax-e (car parts)) 'module))))
     (define module-parts (syntax->list (car forms)))
     (define body (list-ref module-parts 3))
     (define body-parts (and (syntax? body) (syntax->list body)))
     (if (and body-parts
              (pair? body-parts)
              (eq? (syntax-e (car body-parts)) '#%module-begin))
         (cdr body-parts)
         '())]
    [else forms]))

(define safe-primitive-calls
  (set '+ '- '* '/ '< '<= '= '> '>= 'add1 'sub1 'zero? 'positive?
       'negative? 'even? 'odd? 'abs 'sqr 'expt 'remainder 'modulo
       'quotient 'max 'min 'number? 'integer? 'real? 'rational? 'exact?
       'inexact? 'not 'cons 'first 'rest 'empty? 'list 'length 'append
       'reverse 'member? 'list? 'string-append 'string=? 'string<?
       'string-length 'string? 'symbol? 'boolean? 'char? 'equal?
       'eq? 'eqv? 'and 'or))

;; These names are provided by the HtDP student languages, but not by every
;; `racket/base` environment. Keep them in a separate set so the conservative
;; Racket profile does not assume that a teachpack or collection is installed.
(define student-core-primitive-calls
  (set 'make-posn 'posn-x 'posn-y 'number->string 'string->number
       'string-upcase 'string-downcase 'substring 'make-string))
(define student-list-primitive-calls (set 'list-ref 'remove))
(define student-higher-order-primitive-calls
  (set 'build-list 'filter 'map 'foldr 'foldl))

(define (primitive-calls-for profile)
  (define capabilities (language-profile-capabilities profile))
  (set-union
   safe-primitive-calls
   (if (language-profile-student? profile)
       student-core-primitive-calls
       (set))
   (if (memq 'list-abbreviations capabilities)
       student-list-primitive-calls
       (set))
   (if (or (memq 'local-binding capabilities)
           (memq 'lambda capabilities))
       student-higher-order-primitive-calls
       (set))))

(define (student-struct-function-names forms)
  (for/fold ([names (set)]) ([stx (in-list forms)])
    (define form (syntax->datum stx))
    (if (and (list? form)
             (>= (length form) 3)
             (memq (car form) '(define-struct define-struct/typed))
             (symbol? (cadr form)))
        (let* ([struct-name (cadr form)]
               [field-specs (caddr form)]
               [fields
                (if (list? field-specs)
                    (filter
                     values
                     (for/list ([field (in-list field-specs)])
                       (cond
                         [(symbol? field) field]
                         [(and (list? field) (pair? field)
                               (symbol? (car field)))
                          (car field)]
                         [else #f])))
                    '())]
               [struct-text (symbol->string struct-name)]
               [generated
                (append
                 (list (string->symbol (string-append "make-" struct-text))
                       (string->symbol (string-append struct-text "?")))
                 (for/list ([field (in-list fields)])
                   (string->symbol
                    (string-append struct-text "-" (symbol->string field)))))])
          (set-union names (list->set generated)))
        names)))

(define (known-primitive-name? name state)
  (or (set-member? safe-primitive-calls name)
      (and (memq 'student-language (engine-state-capabilities state))
           (or (set-member? student-core-primitive-calls name)
               (and (memq 'list-abbreviations
                          (engine-state-capabilities state))
                    (set-member? student-list-primitive-calls name))
               (and (or (memq 'local-binding
                              (engine-state-capabilities state))
                        (memq 'lambda (engine-state-capabilities state)))
                    (set-member? student-higher-order-primitive-calls
                                 name))))))

(define safe-constant-identifiers
  (set 'true 'false 'empty 'empty-image 'pi 'e))

(define special-expression-heads '(if cond and or quote quasiquote syntax quote-syntax))
(define quoted-heads '(quote quasiquote syntax quote-syntax))

(define (head-symbol expression)
  (and (pair? expression) (symbol? (car expression)) (car expression)))

(define (quoted-expression? expression)
  (and (pair? expression)
       (memq (head-symbol expression) quoted-heads)
       #t))

(define (safe-cond-clauses? clauses safe-functions depth)
  (and (pair? clauses)
       (let loop ([rest clauses] [remaining-depth depth])
         (cond
           [(or (null? rest) (negative? remaining-depth)) (null? rest)]
           [else
            (define clause (car rest))
            (and (list? clause)
                 (= (length clause) 2)
                 (let ([test (car clause)] [body (cadr clause)])
                   (if (eq? test 'else)
                       (and (null? (cdr rest))
                            (safe-expression? body safe-functions
                                              (sub1 remaining-depth)))
                       (and (safe-expression? test safe-functions
                                              (sub1 remaining-depth))
                            (safe-expression? body safe-functions
                                              (sub1 remaining-depth))
                            (loop (cdr rest) (sub1 remaining-depth))))))]))))

(define (safe-expression? expression safe-functions [depth maximum-ast-depth])
  (cond
    [(negative? depth) #f]
    [(or (number? expression)
         (string? expression)
         (boolean? expression)
         (char? expression)
         (symbol? expression))
     #t]
    [(not (and (pair? expression) (list? expression))) #f]
    [else
     (define head (head-symbol expression))
     (case head
       [(quote quasiquote syntax quote-syntax)
        (= (length expression) 2)]
       [(if)
        (and (= (length expression) 4)
             (andmap (lambda (part)
                       (safe-expression? part safe-functions (sub1 depth)))
                     (cdr expression)))]
       [(cond)
        (safe-cond-clauses? (cdr expression) safe-functions (sub1 depth))]
       [(and or)
        (andmap (lambda (part)
                  (safe-expression? part safe-functions (sub1 depth)))
                (cdr expression))]
       [else
        (and head
             (or (set-member? safe-primitive-calls head)
                 (set-member? safe-functions head))
             (andmap (lambda (part)
                       (safe-expression? part safe-functions (sub1 depth)))
                     (cdr expression)))])]))

(define (definition-name form)
  (match form
    [(list 'define (? symbol? name) _rhs) name]
    [(list 'define (list* (? symbol? name) _params) _body ...) name]
    [_ #f]))

(define (parse-function-form stx)
  (define form (syntax->datum stx))
  (define position (syntax-position stx))
  (define span (syntax-span stx))
  (and (list? form)
       (= (length form) 3)
       (eq? (car form) 'define)
       (list? (cadr form))
       (pair? (cadr form))
       (symbol? (caadr form))
       (andmap symbol? (cdadr form))
       (exact-positive-integer? position)
       (exact-positive-integer? span)
       (function-info (caadr form)
                      (cdadr form)
                      (caddr form)
                      stx
                      (sub1 position)
                      (+ (sub1 position) span))))

(define (type-signature-names forms)
  (for/set ([stx (in-list forms)]
            #:do [(define form (syntax->datum stx))]
            #:when (and (list? form)
                        (>= (length form) 3)
                        (eq? (car form) ':)
                        (symbol? (cadr form))) )
    (cadr (syntax->datum stx))))

(define (all-defined-names forms)
  (for/set ([stx (in-list forms)]
            #:do [(define name (definition-name (syntax->datum stx)))]
            #:when name)
    name))

(define (racket-unresolved-binding-forms? forms)
  (for/or ([stx (in-list forms)])
    (define form (syntax->datum stx))
    (and (list? form)
         (pair? form)
         (memq (car form)
               '(require require-for-syntax require-for-meta
                 define-syntax define-syntax-rule define-syntaxes
                 let-syntax letrec-syntax)))))

(define (function-call-targets expression names [depth maximum-ast-depth])
  (cond
    [(or (negative? depth) (not (pair? expression))) (set)]
    [(quoted-expression? expression) (set)]
    [(not (list? expression)) (set)]
    [else
     (define head (head-symbol expression))
     (define own
       (if (and head (set-member? names head)
                (not (memq head '(if cond and or))))
           (set head)
           (set)))
     (for/fold ([found own]) ([part (in-list (if head (cdr expression) expression))])
       (set-union found (function-call-targets part names (sub1 depth))))]))

(define (function-call-graph functions names)
  (for/hash ([info (in-list functions)])
    (values (function-info-name info)
            (function-call-targets (function-info-body info) names))))

(define (reaches? graph from target [seen (set)])
  (cond
    [(eq? from target) #t]
    [(set-member? seen from) #f]
    [else
     (for/or ([next (in-set (hash-ref graph from (set)))])
       (reaches? graph next target (set-add seen from)))]))

(define (mutually-recursive? graph name)
  (for/or ([next (in-set (hash-ref graph name (set)))]
           #:unless (eq? next name))
    (reaches? graph next name)))

(define (identifier-in-call-position? name expression [depth maximum-ast-depth])
  (cond
    [(or (negative? depth) (not (pair? expression))) #f]
    [(quoted-expression? expression) #f]
    [(not (list? expression)) #f]
    [else
     (define head (head-symbol expression))
     (or (and head (eq? head name) (not (memq head special-expression-heads)))
         (for/or ([part (in-list (if head (cdr expression) expression))])
           (identifier-in-call-position? name part (sub1 depth))))]))

(define (block-comment-end source start end)
  (let loop ([index (+ start 2)] [depth 1])
    (cond
      [(>= index end) #f]
      [(and (< (add1 index) end)
            (char=? (string-ref source index) #\#)
            (char=? (string-ref source (add1 index)) #\|))
       (loop (+ index 2) (add1 depth))]
      [(and (< (add1 index) end)
            (char=? (string-ref source index) #\|)
            (char=? (string-ref source (add1 index)) #\#))
       (if (= depth 1)
           (+ index 2)
           (loop (+ index 2) (sub1 depth)))]
      [else (loop (add1 index) depth)])))

(define (datum-comment-end source after-marker end)
  ;; #; is a reader comment that consumes one complete datum. Keep that datum
  ;; with the marker when moving the comment out of a rewritten definition.
  (with-handlers ([exn:fail? (lambda (_error) #f)])
    (define input (open-input-string (substring source after-marker end)))
    (port-count-lines! input)
    (define datum (read-syntax 'enshittifier-comment input))
    (define position (and (syntax? datum) (syntax-position datum)))
    (define span (and (syntax? datum) (syntax-span datum)))
    (and (exact-positive-integer? position)
         (exact-positive-integer? span)
         (let ([datum-end (+ after-marker (sub1 position) span)])
           (and (<= datum-end end) datum-end)))))

(define (comments-in-source-range source start end)
  ;; Structural rewrites pretty-print the parsed expression, which discards
  ;; reader trivia. Extract comments while ignoring strings, escaped
  ;; identifiers, and character literals; reattach them at the start of the
  ;; generated body so they stay with the implementation without affecting it.
  (define source-length (string-length source))
  (define (at? index character)
    (and (< index source-length) (char=? (string-ref source index) character)))
  (define (line-comment-end index)
    (let loop ([cursor index])
      (cond
        [(>= cursor end) end]
        [(or (at? cursor #\newline) (at? cursor #\return)) cursor]
        [else (loop (add1 cursor))])))
  (let loop ([index start] [mode 'normal] [comments '()])
    (cond
      [(>= index end) (if (eq? mode 'normal) (reverse comments) #f)]
      [(eq? mode 'string)
       (cond [(at? index #\\) (loop (+ index 2) mode comments)]
             [(at? index #\") (loop (add1 index) 'normal comments)]
             [else (loop (add1 index) mode comments)])]
      [(eq? mode 'bar-symbol)
       (cond [(at? index #\\) (loop (+ index 2) mode comments)]
             [(at? index #\|) (loop (add1 index) 'normal comments)]
             [else (loop (add1 index) mode comments)])]
      [else
       (cond
         [(at? index #\") (loop (add1 index) 'string comments)]
         [(at? index #\|) (loop (add1 index) 'bar-symbol comments)]
         [(at? index #\;)
          (define comment-end (line-comment-end index))
          (loop comment-end 'normal
                (cons (substring source index comment-end) comments))]
         [(and (at? index #\#) (< (add1 index) end)
               (char=? (string-ref source (add1 index)) #\|))
          (define comment-end (block-comment-end source index end))
          (if comment-end
              (loop comment-end 'normal
                    (cons (substring source index comment-end) comments))
              #f)]
         [(and (at? index #\#) (< (add1 index) end)
               (char=? (string-ref source (add1 index)) #\;))
          (define comment-end (datum-comment-end source (+ index 2) end))
          (if comment-end
              (loop comment-end 'normal
                    (cons (substring source index comment-end) comments))
              #f)]
         [(and (at? index #\#) (< (+ index 2) end)
               (char=? (string-ref source (add1 index)) #\\))
          (loop (+ index 3) 'normal comments)]
         [else (loop (add1 index) 'normal comments)])])))

(define (collect-symbols value [seen (make-hasheq)])
  (cond
    [(symbol? value) (set value)]
    [(pair? value)
     (if (hash-ref seen value #f)
         (set)
         (begin
           (hash-set! seen value #t)
           (set-union (collect-symbols (car value) seen)
                      (collect-symbols (cdr value) seen))))]
    [(vector? value)
     (for/fold ([found (set)]) ([part (in-vector value)])
       (set-union found (collect-symbols part seen)))]
    [else (set)]))

(define (fresh-identifier used identifier-chaos level)
  (let loop ()
    (define salt (number->string (random #x1000000) 16))
    (define name
      (cond
        [(and (>= level 4) (>= identifier-chaos 60) (zero? (random 2)))
         (format "completely_unnecessary_intermediate_value_~a" salt)]
        [(>= identifier-chaos 35)
         (format "__x__x__x_enshittifier_~a" salt)]
        [else
         (format "enshittifier_value_~a" salt)]))
    (define candidate (string->symbol name))
    (if (set-member? used candidate)
        (loop)
        (values candidate (set-add used candidate)))))

(define (fresh-helper-identifier used)
  (let loop ()
    (define candidate
      (string->symbol
       (format "unnecessary_helper_layer_~a" (number->string (random #x1000000) 16))))
    (if (set-member? used candidate)
        (loop)
        (values candidate (set-add used candidate)))))

(define (rename-expression expression mapping [depth maximum-ast-depth])
  (cond
    [(negative? depth) expression]
    [(symbol? expression) (hash-ref mapping expression expression)]
    [(not (and (pair? expression) (list? expression))) expression]
    [(quoted-expression? expression) expression]
    [else
     (define head (head-symbol expression))
     (case head
       [(if)
        (if (= (length expression) 4)
            (list 'if
                  (rename-expression (cadr expression) mapping (sub1 depth))
                  (rename-expression (caddr expression) mapping (sub1 depth))
                  (rename-expression (cadddr expression) mapping (sub1 depth)))
            expression)]
       [(cond)
        (cons 'cond
              (for/list ([clause (in-list (cdr expression))])
                (if (and (list? clause) (= (length clause) 2))
                    (list (if (eq? (car clause) 'else)
                              'else
                              (rename-expression (car clause) mapping (sub1 depth)))
                          (rename-expression (cadr clause) mapping (sub1 depth)))
                    clause)))]
       [(and or)
        (cons head
              (map (lambda (part)
                     (rename-expression part mapping (sub1 depth)))
                   (cdr expression)))]
       [else
        ;; Student languages have no first-class functions in the BSL subset.
        ;; Function-head shadowing is rejected before this walk.
        (cons head
              (map (lambda (part)
                     (rename-expression part mapping (sub1 depth)))
                   (cdr expression)))])]))

(define (rename-self-calls expression old-name new-name [depth maximum-ast-depth])
  (cond
    [(negative? depth) expression]
    [(or (not (pair? expression)) (quoted-expression? expression)) expression]
    [(not (list? expression)) expression]
    [else
     (define head (head-symbol expression))
     (cond
       [(eq? head 'if)
        (if (= (length expression) 4)
            (list 'if
                  (rename-self-calls (cadr expression) old-name new-name (sub1 depth))
                  (rename-self-calls (caddr expression) old-name new-name (sub1 depth))
                  (rename-self-calls (cadddr expression) old-name new-name (sub1 depth)))
            expression)]
       [(eq? head 'cond)
        (cons 'cond
              (for/list ([clause (in-list (cdr expression))])
                (if (and (list? clause) (= (length clause) 2))
                    (list (if (eq? (car clause) 'else)
                              'else
                              (rename-self-calls (car clause) old-name new-name (sub1 depth)))
                          (rename-self-calls (cadr clause) old-name new-name (sub1 depth)))
                    clause)))]
       [(memq head '(and or))
        (cons head
              (map (lambda (part)
                     (rename-self-calls part old-name new-name (sub1 depth)))
                   (cdr expression)))]
       [else
        (cons (if (eq? head old-name) new-name head)
              (map (lambda (part)
                     (rename-self-calls part old-name new-name (sub1 depth)))
                   (cdr expression)))])]))

(define (cond-expression? expression)
  (and (list? expression)
       (>= (length expression) 2)
       (eq? (car expression) 'cond)
       (let ([clauses (cdr expression)])
         (and (pair? clauses)
              (eq? (car (last clauses)) 'else)
              (for/and ([clause (in-list clauses)] [index (in-naturals)])
                (and (list? clause)
                     (= (length clause) 2)
                     (or (not (eq? (car clause) 'else))
                         (= index (sub1 (length clauses))))))))))

(define (cond->if expression)
  (define clauses (cdr expression))
  (let loop ([remaining clauses])
    (define clause (car remaining))
    (define test (car clause))
    (define body (cadr clause))
    (if (eq? test 'else)
        body
        (list 'if test body
              (if (null? (cdr remaining))
                  '(error "cond has no matching clause")
                  (loop (cdr remaining)))))))

(define (exact-arithmetic-expression? expression)
  (and (list? expression)
       (pair? expression)
       (memq (car expression) '(+ - *))
       (>= (length expression) 3)
       (andmap exact-integer? (cdr expression))))

(define (evaluate-exact-arithmetic expression)
  (define operator (car expression))
  (define arguments (cdr expression))
  (case operator
    [(+) (apply + arguments)]
    [(-) (apply - arguments)]
    [(*) (apply * arguments)]))

(define (exact-integer-tangle value)
  (define offset (add1 (random 9)))
  (case (random 4)
    [(0) (list '+ value 0)]
    [(1) (list '* 1 value)]
    [(2) (list '- (list '+ value offset) offset)]
    [else (list '+ (list '- value offset) offset)]))

(define (redundant-wrapper expression)
  (case (random 6)
    [(0) (list 'cond (list (list '< 0 1) expression))]
    [(1) (list 'cond
               (list (list '= (list '+ 1 1) 2) expression))]
    [(2) (list 'cond
               (list (list 'and (list '< 0 1) (list 'not (list '< 0 0)))
                     expression))]
    [(3) (list 'cond
               (list (list 'if (list '< 0 1) #true #false) expression))]
    [(4) (list 'cond
               (list (list 'or (list '< 0 0) (list '= 1 2)) #false)
               (list 'else expression))]
    [else (list 'if (list 'not (list '< 0 0)) expression #false)]))

(define (logical-negation-expression? expression)
  (and (list? expression)
       (= (length expression) 2)
       (eq? (car expression) 'not)
       (let ([inner (cadr expression)])
         (and (list? inner)
              (pair? inner)
              (memq (car inner) '(and or))))))

(define (logical-if-test-category expression)
  (and (list? expression)
       (= (length expression) 4)
       (eq? (car expression) 'if)
       (let ([test (cadr expression)])
         (and (list? test)
              (pair? test)
              (case (car test)
                [(and) 'if-and-test]
                [(or) 'if-or-test]
                [else #f])))))

(define (if-negated-test? expression)
  (and (list? expression)
       (= (length expression) 4)
       (eq? (car expression) 'if)
       (let ([test (cadr expression)])
         (and (list? test)
              (= (length test) 2)
              (eq? (car test) 'not)))))

(define (demorgan-negation expression)
  (define connective (car (cadr expression)))
  (define replacement (if (eq? connective 'and) 'or 'and))
  (cons replacement
        (for/list ([operand (in-list (cdr (cadr expression)))])
          (list 'not operand))))

(define (conditionalize-logical-test expression)
  (define connective (car (cadr expression)))
  (define operands (cdr (cadr expression)))
  (define then-branch (caddr expression))
  (define else-branch (cadddr expression))
  (case connective
    [(and)
     (let lower ([remaining operands])
       (if (null? remaining)
           then-branch
           (list 'if (car remaining)
                 (lower (cdr remaining))
                 else-branch)))]
    [(or)
     (let lower ([remaining operands])
       (if (null? remaining)
           else-branch
           (list 'if (car remaining)
                 then-branch
                 (lower (cdr remaining)))))]))

(define transformation-registry
  (list
   (transformation-rule
    'exact-integer-tangle '(literal) '(exact-integer-arithmetic)
    (lambda (expression _state) (exact-integer? expression)) 4 1
    (lambda (expression _state) (exact-integer-tangle expression)))
   (transformation-rule
    'fold-exact-arithmetic '(exact-arithmetic) '(exact-integer-arithmetic)
    (lambda (expression _state) (exact-arithmetic-expression? expression))
    2 2
    (lambda (expression _state)
      (exact-integer-tangle (evaluate-exact-arithmetic expression))))
   (transformation-rule
    'if-to-cond '(if) '(if cond)
    (lambda (expression _state)
      (and (list? expression) (= (length expression) 4)
           (eq? (car expression) 'if)))
    3 2
    (lambda (expression _state)
      (list 'cond
            (list (cadr expression) (caddr expression))
            (list 'else (cadddr expression)))))
   (transformation-rule
    'cond-to-if '(cond) '(if cond)
    (lambda (expression _state) (cond-expression? expression))
    3 2
    (lambda (expression _state) (cond->if expression)))
   (transformation-rule
    'double-negation-test '(if) '(if)
    (lambda (expression _state)
      (and (list? expression) (= (length expression) 4)
           (eq? (car expression) 'if)))
    2 1
    (lambda (expression _state)
      (list 'if (list 'not (list 'not (cadr expression)))
            (caddr expression) (cadddr expression))))
   (transformation-rule
    'and-to-nested-if '(and) '(if boolean-only-short-circuit)
    (lambda (expression _state)
      (and (list? expression) (pair? expression) (eq? (car expression) 'and)))
    5 3
    (lambda (expression _state)
      (let lower ([operands (cdr expression)])
        (cond
          [(null? operands) #true]
          [(null? (cdr operands)) (car operands)]
          [else (list 'if (car operands) (lower (cdr operands)) #false)]))))
   (transformation-rule
    'or-to-nested-if '(or) '(if boolean-only-short-circuit)
    (lambda (expression _state)
      (and (list? expression) (pair? expression) (eq? (car expression) 'or)))
    5 3
    (lambda (expression _state)
      (let lower ([operands (cdr expression)])
        (cond
          [(null? operands) #false]
          [(null? (cdr operands)) (car operands)]
          [else (list 'if (car operands) #true (lower (cdr operands)))]))))
   (transformation-rule
    'demorgan-negation '(logical-negation) '(if logical-connectives)
    (lambda (expression _state) (logical-negation-expression? expression))
    6 3
    (lambda (expression _state) (demorgan-negation expression)))
   (transformation-rule
    'not-to-conditional '(application logical-negation) '(if)
    (lambda (expression _state)
      (and (list? expression) (= (length expression) 2)
           (eq? (car expression) 'not)))
    4 2
    (lambda (expression _state)
      (list 'if (cadr expression) #false #true)))
   (transformation-rule
    'if-not-test-to-swapped-branches '(if-not-test) '(if)
    (lambda (expression _state) (if-negated-test? expression))
    5 2
    (lambda (expression _state)
      (list 'if (cadr (cadr expression))
            (cadddr expression) (caddr expression))))
   (transformation-rule
    'if-and-test-to-nested-if '(if-and-test) '(if logical-connectives)
    (lambda (expression _state)
      (and (eq? (logical-if-test-category expression) 'if-and-test)
           (>= (length (cadr expression)) 3)))
    7 4
    (lambda (expression _state) (conditionalize-logical-test expression)))
   (transformation-rule
    'if-or-test-to-nested-if '(if-or-test) '(if logical-connectives)
    (lambda (expression _state)
      (and (eq? (logical-if-test-category expression) 'if-or-test)
           (>= (length (cadr expression)) 3)))
    7 4
    (lambda (expression _state) (conditionalize-logical-test expression)))
   (transformation-rule
    'invert-conditional '(if) '(if)
    (lambda (expression _state)
      (and (list? expression) (= (length expression) 4)
           (eq? (car expression) 'if)))
    3 2
    (lambda (expression _state)
      (list 'if (list 'not (cadr expression))
            (cadddr expression) (caddr expression))))
   (transformation-rule
    'make-predicate-explicit '(predicate) '(if)
    (lambda (expression _state) #t)
    4 2
    (lambda (expression _state)
      (list 'if expression #true #false)))
   (transformation-rule
    'redundant-branch-wrapping
    '(application if cond and or)
    '(if cond)
    (lambda (expression state)
      (and (not (quoted-expression? expression))
           (safe-expression? expression (engine-state-safe-functions state))))
    5 2
    (lambda (expression state)
      (define layers
        (if (zero? (engine-state-level state))
            0
            (add1 (random (engine-state-level state)))))
      (for/fold ([current expression]) ([index (in-range layers)])
        (redundant-wrapper current))))))

(define (registered-transformations)
  transformation-registry)

(define (expression-category expression)
  (cond
    [(exact-integer? expression) 'literal]
    [(number? expression) 'literal]
    [(symbol? expression) 'identifier]
    [(quoted-expression? expression) 'quoted]
    [(and (list? expression) (pair? expression))
     (case (car expression)
       [(if) 'if]
       [(cond) 'cond]
       [(and) 'and]
       [(or) 'or]
       [(not) (if (logical-negation-expression? expression)
                  'logical-negation
                  'application)]
       [else (if (exact-arithmetic-expression? expression)
                 'exact-arithmetic
                 'application)])]
    [else 'other]))

(define (rule-capable? rule state)
  (andmap (lambda (capability)
            (memq capability (engine-state-capabilities state)))
          (transformation-rule-requires rule)))

(define (weighted-rule-choice rules)
  (define total (for/sum ([rule (in-list rules)]) (transformation-rule-weight rule)))
  (and (positive? total)
       (let ([selected (random total)])
         (let loop ([remaining rules] [cursor selected])
           (define weight (transformation-rule-weight (car remaining)))
           (if (< cursor weight)
               (car remaining)
               (loop (cdr remaining) (- cursor weight)))))))

(define (eligible-rules expression category state [exclude-fold? #f] [depth 0])
  (for/list ([rule (in-list transformation-registry)]
             #:when
             (and (member category (transformation-rule-categories rule))
                  (or (not exclude-fold?)
                      (not (eq? (transformation-rule-id rule) 'fold-exact-arithmetic)))
                  (or (<= depth 1)
                      (not (eq? (transformation-rule-id rule)
                                'redundant-branch-wrapping)))
                  (rule-capable? rule state)
                  ((transformation-rule-safety rule) expression state)))
    rule))

(define (apply-rule-if-selected expression category state
                                [exclude-fold? #f] [depth 0])
  (define rules (eligible-rules expression category state exclude-fold? depth))
  (cond
    [(or (null? rules)
         (>= (random 100) (* 20 (engine-state-level state))))
     expression]
    [else
     (define rule (weighted-rule-choice rules))
     (define candidate ((transformation-rule-apply rule) expression state))
     (set-counters-structural!
      (engine-state-counters state)
      (+ (counters-structural (engine-state-counters state))
         (transformation-rule-complexity rule)))
     candidate]))

(define (rewrite-expression expression state [depth 0] [allow-fold? #t])
  (cond
    [(>= depth maximum-ast-depth) expression]
    [(quoted-expression? expression) expression]
    [(logical-negation-expression? expression)
     (define rewritten
       (apply-rule-if-selected expression 'logical-negation state #t depth))
     (if (equal? rewritten expression)
         (rewrite-children-and-rule expression state depth allow-fold?)
         (rewrite-expression rewritten state (add1 depth) allow-fold?))]
    [(logical-if-test-category expression)
     (define category (logical-if-test-category expression))
     (define rewritten
       (apply-rule-if-selected expression category state #t depth))
     (if (equal? rewritten expression)
         (rewrite-children-and-rule expression state depth allow-fold?)
         (rewrite-expression rewritten state (add1 depth) allow-fold?))]
    [(if-negated-test? expression)
     (define rewritten
       (apply-rule-if-selected expression 'if-not-test state #t depth))
     (if (equal? rewritten expression)
         (rewrite-children-and-rule expression state depth allow-fold?)
         (rewrite-expression rewritten state (add1 depth) allow-fold?))]
    [(and allow-fold? (exact-arithmetic-expression? expression))
     (define folded
       (apply-rule-if-selected expression 'exact-arithmetic state #f depth))
     (if (equal? folded expression)
         (rewrite-children-and-rule expression state depth allow-fold?)
         (rewrite-expression folded state (add1 depth) #f))]
    [else (rewrite-children-and-rule expression state depth allow-fold?)]))

(define (rewrite-predicate expression state depth allow-fold?)
  (apply-rule-if-selected
   (rewrite-expression expression state depth allow-fold?)
   'predicate state #t depth))

(define (rewrite-children-and-rule expression state depth allow-fold?)
  (define rewritten
    (cond
      [(and (list? expression) (pair? expression))
       (define head (car expression))
       (case head
         [(if)
          (if (= (length expression) 4)
              (list 'if
                    (rewrite-predicate (cadr expression) state (add1 depth) allow-fold?)
                    (rewrite-expression (caddr expression) state (add1 depth) allow-fold?)
                    (rewrite-expression (cadddr expression) state (add1 depth) allow-fold?))
              expression)]
         [(cond)
          (cons 'cond
                (for/list ([clause (in-list (cdr expression))])
                  (if (and (list? clause) (= (length clause) 2))
                      (list (if (eq? (car clause) 'else)
                                'else
                                (rewrite-predicate (car clause) state (add1 depth) allow-fold?))
                            (rewrite-expression (cadr clause) state (add1 depth) allow-fold?))
                      clause)))]
         [(and or)
          (cons head
                (map (lambda (part)
                       (rewrite-expression part state (add1 depth) allow-fold?))
                     (cdr expression)))]
         [else
          (cons head
                (map (lambda (part)
                       (rewrite-expression part state (add1 depth) allow-fold?))
                     (cdr expression)))])]
      [else expression]))
  (apply-rule-if-selected rewritten (expression-category rewritten) state #t depth))

(define (written-atom datum)
  (call-with-output-string (lambda (out) (write datum out))))

(define (chaos-indent depth text-density)
  (define spaciousness (- 100 text-density))
  (define base
    (min 28 (+ (* depth (max 1 (quotient spaciousness 14)))
               (random (add1 (max 1 (quotient spaciousness 10)))))))
  (make-string base (if (and (> depth 1) (zero? (random 5))) #\tab #\space)))

(define (compact-items items)
  (let loop ([remaining items] [previous #f] [reversed '()])
    (cond
      [(null? remaining) (string-join (reverse reversed) "")]
      [else
       (define item (car remaining))
       (define separator
         (if (or (not previous)
                 (zero? (string-length previous))
                 (zero? (string-length item))
                 (memv (string-ref previous (sub1 (string-length previous)))
                       '(#\( #\[ #\{ #\) #\] #\}))
                 (memv (string-ref item 0) '(#\( #\[ #\{ #\) #\] #\})))
             ""
             " "))
       (loop (cdr remaining) item (cons (string-append separator item) reversed))])))

(define (compact-datum datum)
  (cond
    [(or (not (list? datum)) (null? datum) (quoted-expression? datum))
     (written-atom datum)]
    [else
     (string-append
      "(" (compact-items (map compact-datum datum)) ")")]))

(define (chaotic-datum datum text-density [depth 0])
  (cond
    [(or (not (list? datum))
         (null? datum)
         (quoted-expression? datum))
     (written-atom datum)]
    [else
     (define items (map (lambda (item)
                          (chaotic-datum item text-density (add1 depth)))
                        datum))
     (if (= text-density 100)
         (string-append "(" (compact-items items) ")")
         (let* ([spaciousness (- 100 text-density)]
                [style
                 (cond
                   [(< (random 100) text-density) 'flat]
                   [(< (random 4) 1) 'head-tail]
                   [(< (random 3) 1) 'vertical]
                   [else 'staircase])])
           (case style
             [(flat)
              (string-append "(" (string-join items " ") ")")]
             [(head-tail)
              (if (= (length items) 1)
                  (string-append "(" (car items) ")")
                  (string-append
                   "(" (car items) "\n"
                   (chaos-indent (add1 depth) text-density)
                   (string-join (cdr items)
                                (if (and (> spaciousness 45)
                                         (zero? (random 3)))
                                    "\n\n"
                                    "\n"))
                   "\n" (chaos-indent depth text-density) ")"))]
             [(vertical)
              (string-append
               "(\n"
               (chaos-indent (add1 depth) text-density)
               (string-join items
                            (if (and (> spaciousness 35)
                                     (zero? (random 4)))
                                "\n\n"
                                "\n"))
               "\n" (chaos-indent depth text-density) ")")]
             [else
              (string-append
               "(" (car items)
               (apply string-append
                      (for/list ([item (in-list (cdr items))]
                                 [index (in-naturals)])
                        (string-append
                         (if (and (> spaciousness 50)
                                  (zero? (random 5)))
                             "\n\n"
                             "\n")
                         (chaos-indent (+ depth 1 index) text-density)
                         item)))
               "\n" (chaos-indent depth text-density) ")")]))) ]))

(define (pretty-datum datum text-density _level)
  (chaotic-datum datum text-density))

(define (safe-function-info info safe-functions)
  (and (not (memq (function-info-name info) (function-info-params info)))
       ;; A parameter can shadow a primitive or another known function. The
       ;; restricted reader cannot establish first-class function bindings,
       ;; so leave such bodies untouched instead of guessing at call targets.
       (not (for/or ([parameter (in-list (function-info-params info))])
              (or (set-member? safe-primitive-calls parameter)
                  (set-member? safe-functions parameter))))
       (safe-expression? (function-info-body info) safe-functions)))

(define (function-edit-for info source state used-names typed-names graph
                           format-generator)
  (define name (function-info-name info))
  (define typed? (set-member? typed-names name))
  (define original-body (function-info-body info))
  (define preserved-comments
    (comments-in-source-range source (function-info-start info)
                              (function-info-end info)))
  (define safe-functions (engine-state-safe-functions state))
  (cond
    [(or (known-primitive-name? name state)
         (not preserved-comments)
         (not (safe-function-info info safe-functions)))
     (set-counters-skipped! (engine-state-counters state)
                            (add1 (counters-skipped (engine-state-counters state))))
    #f]
    [else
     (define stats (engine-state-counters state))
     (define initial-structural (counters-structural stats))
     (define initial-renamed (counters-renamed stats))
     (define initial-helpers (counters-helpers stats))
     (define used used-names)
     (define public-params '())
     (define used-after-public used)
     (for ([parameter (in-list (function-info-params info))])
       (define can-rename?
         (and (positive? (engine-state-level state))
              (>= (engine-state-identifier-chaos state) 15)
              (< (random 100) (engine-state-identifier-chaos state))
              (not (identifier-in-call-position? parameter original-body))))
       (if can-rename?
           (let-values ([(fresh next-used)
                         (fresh-identifier used-after-public
                                           (engine-state-identifier-chaos state)
                                           (engine-state-level state))])
             (set! public-params (append public-params (list fresh)))
             (set! used-after-public next-used)
             (set-counters-renamed!
              (engine-state-counters state)
              (add1 (counters-renamed (engine-state-counters state)))))
           (set! public-params (append public-params (list parameter)))))
     (define public-map
       (for/hash ([old (in-list (function-info-params info))]
                  [new (in-list public-params)]
                  #:unless (eq? old new))
         (values old new)))
     (define renamed-after-public (counters-renamed stats))
     (define renamed-body (rename-expression original-body public-map))
     (define recursive? (set-member? (hash-ref graph name (set)) name))
     (define mutual? (mutually-recursive? graph name))
     (define max-helpers
       (case (engine-state-level state)
         [(0 1) 0]
         [(2) 1]
         [(3) 3]
         [(4) 5]
         [else 8]))
     (define helper-count
       (if (or typed?
               mutual?
               (zero? max-helpers)
               (< (random 100) (- 100 (engine-state-helper-proliferation state))))
           0
           (add1 (random max-helpers))))
     (define helper-names '())
     (define helper-params '())
     (define used-final used-after-public)
     (for ([index (in-range helper-count)])
       (define-values (fresh-name next-used)
         (fresh-helper-identifier used-final))
       (set! used-final next-used)
       (set! helper-names (append helper-names (list fresh-name)))
       (define fresh-params '())
       (for ([parameter (in-list (function-info-params info))])
         (define-values (fresh-param next-param-used)
           (fresh-identifier used-final
                             (engine-state-identifier-chaos state)
                             (engine-state-level state)))
         (set! used-final next-param-used)
         (set! fresh-params (append fresh-params (list fresh-param)))
         (set-counters-renamed!
          (engine-state-counters state)
          (add1 (counters-renamed (engine-state-counters state)))))
       (set! helper-params (append helper-params (list fresh-params))))
     (define body-for-helpers
       (if (null? helper-names)
           renamed-body
           (let* ([final-params (last helper-params)]
                  [mapping (for/hash ([old (in-list (function-info-params info))]
                                      [new (in-list final-params)])
                             (values old new))]
                  [mapped (rename-expression original-body mapping)])
             (if recursive?
                 (rename-self-calls mapped name (car helper-names))
                 mapped))))
     (define expression-state
       (struct-copy engine-state state
                    [safe-functions
                     (for/fold ([functions safe-functions])
                               ([helper (in-list helper-names)])
                       (set-add functions helper))]))
     (define rewritten-body
       (rewrite-expression body-for-helpers expression-state))
     (define (forms-for helper-list body-expression)
       (if (null? helper-list)
           (list (list 'define
                       (cons name public-params)
                       body-expression))
           (let* ([entry (car helper-list)]
                  [wrapper (list 'define (cons name public-params)
                                 (cons entry public-params))]
                  [helpers
                   (for/list ([helper (in-list helper-list)]
                              [params (in-list helper-params)]
                              [index (in-naturals)])
                     (define next-name
                       (and (< index (sub1 (length helper-list)))
                            (list-ref helper-list (add1 index))))
                     (define body
                       (if next-name
                           (cons next-name params)
                           body-expression))
                     (list 'define (cons helper params) body))])
             (cons wrapper helpers))))
     (define (indent-lines text prefix)
       (string-append
        prefix
        (string-join (string-split text "\n" #:trim? #f)
                     (string-append "\n" prefix))))
     (define (render-form form comments chaos)
       (cond
         [(and (pair? comments)
               (list? form)
               (= (length form) 3)
               (eq? (car form) 'define)
               (list? (cadr form)))
          (define signature (cadr form))
          (define header
            (pretty-datum (list 'define signature)
                          chaos
                          (engine-state-level state)))
          (define body
            (pretty-datum (caddr form)
                          chaos
                          (engine-state-level state)))
          (string-append
           (substring header 0 (sub1 (string-length header)))
           "\n"
           (string-join comments "\n")
           "\n"
           (indent-lines body "  ")
           ")")]
         [else
          (pretty-datum form chaos
                        (engine-state-level state))]))
     (define (render-forms forms text-density)
       (parameterize ([current-pseudo-random-generator format-generator])
         (string-join
          (for/list ([form (in-list forms)]
                     [index (in-naturals)])
            (render-form
             form
             (if (= index (sub1 (length forms)))
                 preserved-comments
                 '())
             text-density))
          "\n")))
     (define rendered
       (render-forms (forms-for helper-names rewritten-body)
                     (engine-state-text-density state)))
     (cond
       [(or (pair? helper-names)
           (> (counters-structural stats) initial-structural))
        (set-counters-helpers! stats (+ initial-helpers (length helper-names)))
        (source-edit (function-info-start info)
                     (function-info-end info)
                     rendered)]
       [(null? helper-names)
        (set-counters-structural! stats initial-structural)
        (set-counters-renamed! stats initial-renamed)
        (set-counters-helpers! stats initial-helpers)
        ;; Even when no probabilistic rule selected a rewrite, make an
        ;; eligible function structurally different at nonzero intensity.
        (if (positive? (engine-state-level state))
            (let* ([fallback-body (redundant-wrapper original-body)]
                   [fallback-form
                   (list 'define
                          (cons name (function-info-params info))
                          fallback-body)]
                   [fallback-rendered
                    (render-forms (list fallback-form)
                                  (engine-state-text-density state))])
              (set-counters-structural! stats (add1 initial-structural))
              (source-edit (function-info-start info)
                           (function-info-end info)
                           fallback-rendered))
            #f)]
       [else
       ;; Intensity zero leaves an eligible definition unchanged.
       (set-counters-structural! stats initial-structural)
       (set-counters-renamed! stats renamed-after-public)
       (set-counters-helpers! stats initial-helpers)
       #f])]))

(define (apply-source-edits source edits)
  (for/fold ([current source])
            ([change (in-list (sort edits > #:key source-edit-start))])
    (string-append
     (substring current 0 (source-edit-start change))
     (source-edit-replacement change)
     (substring current (source-edit-end change)))))

(define (reader-token-character? character)
  (and (not (char-whitespace? character))
       (not (memv character '(#\( #\) #\[ #\] #\{ #\} #\" #\;
                              #\' #\` #\,)))))

(define (density-gap source start end density)
  (define spaciousness (- 100 density))
  (define before (and (positive? start) (string-ref source (sub1 start))))
  (define after (and (< end (string-length source)) (string-ref source end)))
  (define required-separator?
    (and before after
         (or (and (char=? before #\,) (char=? after #\@))
             (and (reader-token-character? before)
                  (reader-token-character? after)))))
  (define (spaces)
    (if (zero? spaciousness)
        " "
        (make-string
         (add1 (random (add1 (max 1 (quotient spaciousness 12)))))
         (if (and (> spaciousness 55) (zero? (random 7))) #\tab #\space))))
  (cond
    [(and (positive? spaciousness)
          (< (random 100) spaciousness))
     (define line-count
       (if (and (> spaciousness 35)
                (< (random 100) (quotient spaciousness 2)))
           2
           1))
     (string-append
      (make-string line-count #\newline)
      (make-string (random (add1 (min 24 (quotient spaciousness 5)))) #\space))]
    [(and (not required-separator?)
          (>= density 55)
          (< (random 100) density))
     ""]
    [else (spaces)]))

(define (line-comment-lexeme-end source start end)
  (let loop ([index start])
    (cond
      [(>= index end) end]
      [(char=? (string-ref source index) #\newline) (add1 index)]
      [(char=? (string-ref source index) #\return)
       (if (and (< (add1 index) end)
                (char=? (string-ref source (add1 index)) #\newline))
           (+ index 2)
           (add1 index))]
      [else (loop (add1 index))])))

(define (quoted-lexeme-end source start end terminator)
  (let loop ([index (add1 start)])
    (cond
      [(>= index end) end]
      [(char=? (string-ref source index) #\\)
       (loop (min end (+ index 2)))]
      [(char=? (string-ref source index) terminator) (add1 index)]
      [else (loop (add1 index))])))

(define (character-lexeme-end source start end)
  ;; Preserve #\space, #\newline, Unicode names, and punctuation characters
  ;; as one opaque reader token while formatting the surrounding whitespace.
  (define first-index (+ start 2))
  (if (>= first-index end)
      end
      (let ([first (string-ref source first-index)])
        (if (or (char-whitespace? first)
                (memv first '(#\( #\) #\[ #\] #\{ #\} #\" #\; #\'
                              #\` #\,)))
            (add1 first-index)
            (let loop ([index (add1 first-index)])
              (if (or (>= index end)
                      (char-whitespace? (string-ref source index))
                      (memv (string-ref source index)
                            '(#\( #\) #\[ #\] #\{ #\} #\" #\; #\'
                              #\` #\,)))
                  index
                  (loop (add1 index))))))))

(define (here-string-lexeme-end source start end)
  (define marker-start (+ start 3))
  (define header-end
    (let loop ([index marker-start])
      (cond
        [(>= index end) end]
        [(char=? (string-ref source index) #\newline) index]
        [(char=? (string-ref source index) #\return) index]
        [else (loop (add1 index))])))
  (if (>= header-end end)
      end
      (let ([marker (substring source marker-start header-end)])
        (let search-line ([line-start (add1 header-end)])
          (cond
            [(> line-start end) end]
            [else
             (define line-end
               (let find-end ([index line-start])
                 (cond
                   [(>= index end) end]
                   [(or (char=? (string-ref source index) #\newline)
                        (char=? (string-ref source index) #\return)) index]
                   [else (find-end (add1 index))])))
             (define line
               (let ([raw (substring source line-start line-end)])
                 (if (and (positive? (string-length raw))
                          (char=? (string-ref raw (sub1 (string-length raw))) #\return))
                     (substring raw 0 (sub1 (string-length raw)))
                     raw)))
             (define after-line
               (cond
                 [(>= line-end end) end]
                 [(and (char=? (string-ref source line-end) #\return)
                       (< (add1 line-end) end)
                       (char=? (string-ref source (add1 line-end)) #\newline))
                  (+ line-end 2)]
                 [else (add1 line-end)]))
             (if (string=? line marker)
                 after-line
                 (if (>= after-line end)
                     end
                     (search-line after-line)))])))))

(define (source-format-start source)
  (define size (string-length source))
  (if (or (string-prefix? source "#lang")
          (string-prefix? source "#reader"))
      (let loop ([index 0])
        (cond
          [(>= index size) size]
          [(char=? (string-ref source index) #\newline) (add1 index)]
          [else (loop (add1 index))]))
      0))

(define (format-source-whitespace source density)
  ;; Reformat only whitespace runs. Strings, bar-escaped identifiers,
  ;; character literals, here strings, and all three reader-comment forms are
  ;; copied as opaque text. #lang/#reader directives retain their first line.
  (define size (string-length source))
  (define format-start (source-format-start source))
  (define output (open-output-string))
  (display (substring source 0 format-start) output)
  (define (at? index character)
    (and (< (add1 index) size)
         (char=? (string-ref source index) #\#)
         (char=? (string-ref source (add1 index)) character)))
  (let loop ([index format-start])
    (cond
      [(>= index size) (get-output-string output)]
      [(char-whitespace? (string-ref source index))
       (define end
         (let skip ([cursor index])
           (if (and (< cursor size) (char-whitespace? (string-ref source cursor)))
               (skip (add1 cursor))
               cursor)))
       (display (density-gap source index end density) output)
       (loop end)]
      [(char=? (string-ref source index) #\")
       (define end (quoted-lexeme-end source index size #\"))
       (display (substring source index end) output)
       (loop end)]
      [(char=? (string-ref source index) #\|)
       (define end (quoted-lexeme-end source index size #\|))
       (display (substring source index end) output)
       (loop end)]
      [(char=? (string-ref source index) #\;)
       (define end (line-comment-lexeme-end source index size))
       (display (substring source index end) output)
       (loop end)]
      [(at? index #\|)
       (define end (or (block-comment-end source index size) size))
       (display (substring source index end) output)
       (loop end)]
      [(at? index #\;)
       (define end (or (datum-comment-end source (+ index 2) size)
                       (+ index 2)))
       (display (substring source index end) output)
       (loop end)]
      [(and (at? index #\<)
            (< (+ index 2) size)
            (char=? (string-ref source (+ index 2)) #\<))
       (define end (here-string-lexeme-end source index size))
       (display (substring source index end) output)
       (loop end)]
      [(at? index #\\)
       (define end (character-lexeme-end source index size))
       (display (substring source index end) output)
       (loop end)]
      [else
       (write-char (string-ref source index) output)
       (loop (add1 index))])))

(struct literal-candidate (start end value original) #:transparent)
(struct literal-edit (start end replacement) #:transparent)

(define (integer-candidates forms source)
  (define visited (make-hasheq))
  (define ranges (make-hash))
  (define found '())
  (define (record! stx value original)
    (define position (syntax-position stx))
    (define span (syntax-span stx))
    (when (and (exact-positive-integer? position)
               (exact-positive-integer? span))
      (define start (sub1 position))
      (define end (+ start span))
      (define key (cons start end))
      (when (and (<= 0 start end (string-length source))
                 (< start end)
                 (not (hash-ref ranges key #f)))
        (hash-set! ranges key #t)
        (set! found (cons (literal-candidate start end value original) found)))))
  (define (walk value)
    (cond
      [(syntax? value)
       (unless (hash-ref visited value #f)
         (hash-set! visited value #t)
         (define datum (syntax-e value))
         (cond
           [(and (exact-integer? datum) (>= datum 0))
            (record! value datum
                     (substring source
                                (sub1 (syntax-position value))
                                (+ (sub1 (syntax-position value))
                                   (syntax-span value))))]
           [(and (pair? datum)
                 (syntax? (car datum))
                 (memq (syntax-e (car datum)) quoted-heads))
            (void)]
           [else (walk datum)]))]
      [(pair? value)
       (unless (hash-ref visited value #f)
         (hash-set! visited value #t)
         (walk (car value))
         (walk (cdr value)))]
      [(vector? value)
       (unless (hash-ref visited value #f)
         (hash-set! visited value #t)
         (for ([part (in-vector value)]) (walk part)))]
      [else (void)]))
  (for ([form (in-list forms)]) (walk form))
  (sort found < #:key literal-candidate-start))

(define (encode-radix value original)
  (define options
    (filter
     (lambda (text) (not (string=? text original)))
     (for/list ([base (in-list '(2 8 16))])
       (string-append
        (case base [(2) "#b"] [(8) "#o"] [else "#x"])
        (number->string value base)))))
  (if (null? options) original (list-ref options (random (length options)))))

(define comment-fragments
  '#(";; The parentheses have been informed of the project goals."
     ";; This line exists so the other line feels supported."
     ";; The indentation has been peer-reviewed by a semi-conscious stapler."
     ";; Complexity level: suspicious."
     ";; A second opinion was requested from a nearby chair."
     ";; The code is now wearing a tiny reflective vest."))

(define (append-provenance source seed intensity level state literal-count)
  (define count
    (if (zero? level) 0 (min 3 (add1 (quotient level 2)))))
  (define separator
    (cond
      [(zero? (string-length source)) ""]
      [(char=? (string-ref source (sub1 (string-length source))) #\newline) ""]
      [(char=? (string-ref source (sub1 (string-length source))) #\return) "\n"]
      [else "\n"]))
  (define marker
    (format ";; enshittifier seed=~a level=~a intensity=~a% structural=~a helpers=~a renamed=~a literals=~a"
            seed level intensity
            (counters-structural (engine-state-counters state))
            (counters-helpers (engine-state-counters state))
            (counters-renamed (engine-state-counters state))
            literal-count))
  (define lines
    (append (list marker)
            (for/list ([index (in-range count)])
              (vector-ref comment-fragments
                          (random (vector-length comment-fragments))))))
  (set-counters-comments! (engine-state-counters state) (length lines))
  (string-append source separator (string-join lines "\n") "\n"))

(define (intensity->level intensity)
  (if (zero? intensity)
      0
      (min 5 (add1 (quotient (sub1 intensity) 20)))))

(define (apply-literal-edits source forms intensity counters)
  (define candidates (integer-candidates forms source))
  (define edits
    (filter
     values
     (for/list ([candidate (in-list candidates)]
                #:when (and (positive? intensity) (< (random 100) intensity)))
       (define replacement
         (encode-radix (literal-candidate-value candidate)
                       (literal-candidate-original candidate)))
       (and (not (string=? replacement (literal-candidate-original candidate)))
            (literal-edit (literal-candidate-start candidate)
                          (literal-candidate-end candidate)
                          replacement)))))
  (define rewritten
    (for/fold ([current source])
              ([change (in-list (sort edits > #:key literal-edit-start))])
      (string-append (substring current 0 (literal-edit-start change))
                     (literal-edit-replacement change)
                     (substring current (literal-edit-end change)))))
  (set-counters-literals! counters (length edits))
  rewritten)

(define (selected-profile source selected-language student-language?)
  (define header-present? (source-has-language-header? source))
  (define by-source (and header-present? (language-profile-for source)))
  (or by-source
      (and selected-language (language-profile-for selected-language))
      (and student-language? bsl-profile)
      (if header-present? unknown-profile racket-profile)))

(define (enshittify-source source
                           #:seed seed
                           #:intensity intensity
                           #:student-language? [selected-student-language? #f]
                           #:selected-language [selected-language #f]
                           ;; Accepted for callers from 0.3.x; source length is
                           ;; no longer capped, so this legacy value is ignored.
                           #:max-growth-factor [_legacy-growth-factor #f]
                           #:text-density [requested-text-density #f]
                           ;; Compatibility for existing callers: old format
                           ;; chaos 100 meant spacious, so invert it here.
                           #:format-chaos [legacy-format-chaos #f]
                           #:identifier-chaos [identifier-chaos intensity]
                           #:helper-proliferation [helper-proliferation intensity])
  (unless (string? source)
    (raise-argument-error 'enshittify-source "string?" source))
  (unless (and (exact-integer? seed) (<= 0 seed maximum-seed))
    (raise-argument-error 'enshittify-source
                          (format "exact integer in [0, ~a]" maximum-seed)
                          seed))
  (unless (and (exact-integer? intensity) (<= 0 intensity 100))
    (raise-argument-error 'enshittify-source "exact integer in [0, 100]" intensity))
  (when (and requested-text-density legacy-format-chaos)
    (raise-arguments-error 'enshittify-source
                           "provide either #:text-density or the legacy #:format-chaos, not both"
                           "text density" requested-text-density
                           "legacy format chaos" legacy-format-chaos))
  (when requested-text-density
    (unless (and (exact-integer? requested-text-density)
                 (<= 0 requested-text-density 100))
      (raise-argument-error 'enshittify-source
                            "exact integer text density in [0, 100]"
                            requested-text-density)))
  (when legacy-format-chaos
    (unless (and (exact-integer? legacy-format-chaos)
                 (<= 0 legacy-format-chaos 100))
      (raise-argument-error 'enshittify-source
                            "exact integer legacy format chaos in [0, 100]"
                            legacy-format-chaos)))
  (define text-density
    (cond [requested-text-density requested-text-density]
          [legacy-format-chaos (- 100 legacy-format-chaos)]
          [else 20]))
  (for ([option (in-list (list identifier-chaos helper-proliferation))])
    (unless (and (exact-integer? option) (<= 0 option 100))
      (raise-argument-error 'enshittify-source "exact integer in [0, 100]" option)))

  (define profile
    (selected-profile source selected-language selected-student-language?))
  (define original-syntax (read-source-syntax source))
  (define top-forms (reader-module-forms original-syntax))
  (define functions (filter values (map parse-function-form top-forms)))
  (define function-names
    (for/set ([info (in-list functions)]) (function-info-name info)))
  (define primitive-names (primitive-calls-for profile))
  (define struct-function-names (student-struct-function-names top-forms))
  (define shadowed-primitives?
    (not (set-empty? (set-intersect (all-defined-names top-forms)
                                    primitive-names))))
  (define unresolved-racket-bindings?
    (and (eq? (language-profile-name profile) 'racket)
         (racket-unresolved-binding-forms? top-forms)))
  (define graph (function-call-graph functions function-names))
  (define typed-names (type-signature-names top-forms))
  (define all-symbol-names
    (for/fold ([used (set-union function-names
                                struct-function-names
                                (collect-symbols (map syntax->datum top-forms)))])
              ([info (in-list functions)])
      (set-union used (list->set (function-info-params info)))))
  (define generator (make-seeded-generator seed))
  (define formatting-generator
    (make-seeded-generator (modulo (+ seed 104729) (add1 maximum-seed))))
  (define provenance-generator
    (make-seeded-generator (modulo (+ seed 130363) (add1 maximum-seed))))
  (define stats (counters 0 0 0 0 0 0))
  (define level (intensity->level intensity))
  (define capabilities
    (if (language-profile-student? profile)
        (language-profile-capabilities profile)
        (if (eq? (language-profile-name profile) 'racket)
            (language-profile-capabilities profile)
            '())))
  (define base-state
    (engine-state level intensity capabilities
                  (set-union function-names struct-function-names primitive-names)
                  text-density identifier-chaos helper-proliferation stats))

  (define structural-source
    (parameterize ([current-pseudo-random-generator generator])
      (if (and (or (language-profile-student? profile)
                   (eq? (language-profile-name profile) 'racket))
               (not shadowed-primitives?)
               (not unresolved-racket-bindings?))
          (let ([edits '()]
                [used all-symbol-names])
            (for ([info (in-list functions)])
              (define edit
                (function-edit-for info source base-state used typed-names graph
                                   formatting-generator))
              (when edit
                (set! edits (cons edit edits))
                (set! used
                      (set-union used
                                 (collect-symbols
                                  (syntax->datum (function-info-syntax info)))))))
            (apply-source-edits source edits))
          (begin
            (when (or shadowed-primitives? unresolved-racket-bindings?)
              (set-counters-skipped! stats (length functions)))
            source))))

  (define after-structure-forms (read-source-syntax structural-source))
  (define literal-source
    (parameterize ([current-pseudo-random-generator generator])
      (apply-literal-edits structural-source after-structure-forms
                           (if (and (language-profile-student? profile)
                                    (memq 'radix-literals capabilities))
                               intensity
                               0)
                           stats)))
  (define provenance-source
    (parameterize ([current-pseudo-random-generator provenance-generator])
      (append-provenance literal-source seed intensity level base-state
                         (counters-literals stats))))
  (define output
    (parameterize ([current-pseudo-random-generator formatting-generator])
      (format-source-whitespace provenance-source text-density)))
  (with-handlers ([exn:fail?
                   (lambda (error)
                     (error 'enshittify-source
                            "generated text was rejected by the active reader: ~a"
                            (exn-message error)))])
    (read-source-syntax output))
  (transformation output seed intensity level
                  (counters-literals stats)
                  (counters-comments stats)
                  (language-profile-student? profile)
                  (counters-structural stats)
                  (counters-helpers stats)
                  (counters-renamed stats)
                  capabilities
                  (counters-skipped stats)))
