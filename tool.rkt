#lang racket/base

(require racket/class
         racket/gui/base
         racket/unit
         racket/string
         "enshittifier/core.rkt"
         drracket/tool)

(provide tool@)

(define maximum-seed 2147483647)

(define (fresh-seed)
  (random (add1 maximum-seed)))

(define (settings-dialog parent initial-seed initial-level
                         initial-text-density initial-identifier-chaos
                         initial-helper-proliferation)
  (define dialog
    (new dialog%
         [label "Racket Enshittifier"]
         [parent parent]
         [width 700]
         [height 690]))
  (define content
    (new vertical-panel%
         [parent dialog]
         [spacing 7]
         [border 14]
         [stretchable-width #t]))
  (new message%
       [parent content]
       [label "Generate a randomized structural copy. The current definitions stay unchanged."])
  (new message%
       [parent content]
       [label "Unknown teaching-language forms are kept intact. A seed can reproduce a variant."])
  (new message%
       [parent content]
       [label "Text density changes whitespace only; the same seed keeps all non-whitespace code characters identical."])
  (new message%
       [parent content]
       [label "Output has no byte-length cap; high intensity can create a much larger buffer."])
  (define seed-field
    (new text-field%
         [parent content]
         [label "Seed (0–2,147,483,647):"]
         [init-value initial-seed]
         [stretchable-width #t]))
  (define level-slider
    (new slider%
         [parent content]
         [label "Intensity level (1 Mild to 5 Apocalypse):"]
         [min-value 1]
         [max-value 5]
         [init-value initial-level]
         [style '(horizontal)]
         [stretchable-width #t]))
  (define density-slider
    (new slider%
         [parent content]
         [label "Text density (0 airy, 100 compact):"]
         [min-value 0]
         [max-value 100]
         [init-value initial-text-density]
         [style '(horizontal)]
         [stretchable-width #t]))
  (define identifier-slider
    (new slider%
         [parent content]
         [label "Identifier chaos (%):"]
         [min-value 0]
         [max-value 100]
         [init-value initial-identifier-chaos]
         [style '(horizontal)]
         [stretchable-width #t]))
  (define helper-slider
    (new slider%
         [parent content]
         [label "Helper-function proliferation (%):"]
         [min-value 0]
         [max-value 100]
         [init-value initial-helper-proliferation]
         [style '(horizontal)]
         [stretchable-width #t]))
  (define buttons (new horizontal-panel% [parent content] [alignment '(right center)]))
  (define result #f)
  (new button%
       [parent buttons]
       [label "Cancel"]
       [callback (lambda (_button _event)
                   (set! result #f)
                   (send dialog show #f))])
  (new button%
       [parent buttons]
       [label "Preview"]
       [callback
        (lambda (_button _event)
          (define typed-seed (string-trim (send seed-field get-value)))
          (define parsed-seed
            (if (string=? typed-seed "")
                (fresh-seed)
                (string->number typed-seed)))
          (cond
            [(not (and (exact-integer? parsed-seed)
                       (<= 0 parsed-seed maximum-seed)))
             (message-box "Invalid seed"
                          "Enter a whole number from 0 to 2,147,483,647, or leave the field blank."
                          dialog)]
            [else
             (set! result
                   (list parsed-seed
                         (send level-slider get-value)
                         (send density-slider get-value)
                         (send identifier-slider get-value)
                         (send helper-slider get-value)))
             (send dialog show #f)]))])
  (send dialog show #t)
  result)

(define (preview-dialog parent result)
  (define dialog
    (new dialog%
         [label "Enshittifier Preview — original unchanged"]
         [parent parent]
         [width 900]
         [height 680]))
  (define content
    (new vertical-panel%
         [parent dialog]
         [spacing 8]
         [border 10]
         [stretchable-width #t]
         [stretchable-height #t]))
  (new message%
       [parent content]
       [label (format "Level ~a · seed ~a · ~a structural complexity point~a · ~a helper~a · ~a renamed name~a · ~a numeric literal change~a"
                      (transformation-level result)
                      (transformation-seed result)
                      (transformation-structural-count result)
                      (if (= (transformation-structural-count result) 1) "" "s")
                      (transformation-helper-count result)
                      (if (= (transformation-helper-count result) 1) "" "s")
                      (transformation-renamed-identifiers result)
                      (if (= (transformation-renamed-identifiers result) 1) "" "s")
                      (transformation-literal-count result)
                      (if (= (transformation-literal-count result) 1) "" "s"))])
  (define preview-text (new text%))
  (send preview-text insert (transformation-source result))
  (send preview-text lock #t)
  (new editor-canvas%
       [parent content]
       [editor preview-text]
       [stretchable-width #t]
       [stretchable-height #t])
  (define buttons (new horizontal-panel% [parent content] [alignment '(right center)]))
  (define outcome 'close)
  (define (finish choice)
    (set! outcome choice)
    (send dialog show #f))
  (new button% [parent buttons] [label "Close"]
       [callback (lambda (_button _event) (finish 'close))])
  (new button% [parent buttons] [label "Change settings"]
       [callback (lambda (_button _event) (finish 'settings))])
  (new button% [parent buttons] [label "Generate another"]
       [callback (lambda (_button _event) (finish 'another))])
  (new button% [parent buttons] [label "Open editable copy"]
       [callback (lambda (_button _event) (finish 'open))])
  (send dialog show #t)
  outcome)

(define-unit tool@
  (import drracket:tool^)
  (export drracket:tool-exports^)

  (define (selected-language-name settings)
    (with-handlers ([exn:fail? (lambda (_error) #f)])
      (define language
        (drracket:language-configuration:language-settings-language settings))
      (send language get-language-name)))

  (define (open-editable-copy source language-settings)
    (define new-frame (drracket:unit:open-drscheme-window #f))
    (define new-definitions (send new-frame get-definitions-text))
    (when language-settings
      (send new-definitions set-next-settings language-settings #f))
    (send new-definitions begin-edit-sequence)
    (send new-definitions insert source)
    (send new-definitions end-edit-sequence)
    (send new-frame show #t))

  (define (transform-or-report parent source seed intensity selected-language
                               text-density identifier-chaos helpers)
    (with-handlers
        ([exn:fail?
          (lambda (error)
            (message-box "Source could not be previewed"
                         (string-append
                          "The current buffer could not be read safely. Fix its reader or syntax and try again.\n\n"
                          (exn-message error))
                         parent)
            #f)])
      (enshittify-source source
                         #:seed seed
                         #:intensity intensity
                         #:selected-language selected-language
                         #:text-density text-density
                         #:identifier-chaos identifier-chaos
                         #:helper-proliferation helpers)))

  (define (run-enshittifier frame definitions)
    (define source (send definitions get-text))
    (define language-settings (send definitions get-next-settings))
    (define selected-language (selected-language-name language-settings))
    (let loop ([seed-text ""] [level 5]
               [text-density 15] [identifier-chaos 100] [helpers 100])
      (define options
        (settings-dialog frame seed-text level text-density
                         identifier-chaos helpers))
      (when options
        (define seed (car options))
        (define selected-level (cadr options))
        (define selected-text-density (caddr options))
        (define selected-identifier-chaos (list-ref options 3))
        (define selected-helpers (list-ref options 4))
        (define selected-intensity (* 20 selected-level))
        (define result
          (transform-or-report frame source seed selected-intensity
                               selected-language
                               selected-text-density selected-identifier-chaos
                               selected-helpers))
        (when result
          (case (preview-dialog frame result)
            [(open)
             (open-editable-copy (transformation-source result) language-settings)]
            [(another)
             (loop "" selected-level selected-text-density
                   selected-identifier-chaos selected-helpers)]
            [(settings)
             (loop (number->string seed) selected-level selected-text-density
                   selected-identifier-chaos
                   selected-helpers)]
            [else (void)])))))

  (define enshittifier-frame-mixin
    (mixin (drracket:unit:frame<%>) ()
      (inherit get-definitions-text get-language-menu)
      (super-new)
      (new menu-item%
           [label "Enshittify source…"]
           [parent (get-language-menu)]
           [callback (lambda (_item _event)
                       (run-enshittifier this (get-definitions-text)))])
      (void)))

  (define (phase1)
    (drracket:get/extend:extend-unit-frame enshittifier-frame-mixin))

  (define (phase2)
    (void)))
