#lang racket

(require racket/gui
         "../sound/additivesynth.rkt"
         "../hash/hash.rkt")

(provide add-gui-elements)

(define default-preset 0)
(define current-preset default-preset)

(define num-of-harmonics 4)

;; adjusts loud tone played is
(define (add-vol-slider parent-frame)
  (new slider%
       [label "volume"]
       [parent parent-frame]
       [min-value 1]
       [max-value 100]
       [init-value 5]))

;; adjusts how fast the tone reaches max vol
(define (add-attack-slider parent-frame)
  (new slider%
       [label "attack"]
       [parent parent-frame]
       [min-value 1]
       [max-value 1000]
       [init-value 200]))

;; adjusts how long a tone plays for.
(define (add-decay-slider parent-frame)
  (new slider%
       [label "decay"]
       [parent parent-frame]
       [min-value 1]
       [max-value 100]
       [init-value 70]))

(define (add-panel parent-frame)
  ;; adds a panel to a frame. used for positioning elements of gui.
  (new horizontal-panel% (parent parent-frame) (stretchable-height #f) (min-height 50)))

(define (add-panels parent-frame)
  ;; adds panels to a frame. used for positioning elements of gui.
  (define panel1 (add-panel parent-frame))
  (define panel2 (add-panel parent-frame))

  (lambda (panel)
    (cond ((eq? panel 'panel1) panel1)
          ((eq? panel 'panel2) panel2))))

(define (add-harmonic-fields panels)
  ;; install the fields that the user can use to adjust what multiple of the fundamental note the harmonics are.
  (new text-field% (parent (panels 'panel1)) (label "k2") (stretchable-width #f) (min-width 120) (init-value "2")
       (callback
        (λ (text event)
          (hash-set! customHT "k2" (string->number (send text get-value)))
          (display (hash-ref customHT "k2")))))

  (new text-field% (parent (panels 'panel1)) (label "k3") (stretchable-width #f) (min-width 120) (init-value "3")
       (callback
        (λ (text event)
          (hash-set! customHT "k3" (string->number (send text get-value)))
          (display (hash-ref customHT "k3")))))

  (new text-field% (parent (panels 'panel1)) (label "k4") (stretchable-width #f) (min-width 120) (init-value "4")
       (callback
        (λ (text event)
          (hash-set! customHT "k4" (string->number (send text get-value)))
          (display (hash-ref customHT "k4")))))

  ;; install the fields that the user can use to adjust the amplitudes of each harmonic.
  (new text-field% (parent (panels 'panel2)) (label "a2") (stretchable-width #f) (min-width 120) (init-value ".25")
       (callback
        (λ (text event)
          (hash-set! customHT "a2" (string->number (send text get-value)))
          (display (hash-ref customHT "a2")))))

  (new text-field% (parent (panels 'panel2)) (label "a3") (stretchable-width #f) (min-width 120) (init-value ".15")
       (callback
        (λ (text event)
          (hash-set! customHT "a3" (string->number (send text get-value)))
          (display (hash-ref customHT "a3")))))

  (new text-field% (parent (panels 'panel2)) (label "a4") (stretchable-width #f) (min-width 120) (init-value ".1")
       (callback
        (λ (text event)
          (hash-set! customHT "a4" (string->number (send text get-value)))
          (display (hash-ref customHT "a4"))))))

(define (add-preset-select panels)
  ;; add list of presets available for selection.
  (new choice% (parent (panels 'panel1)) (label "Presets") (choices (list "Organ" "Bells" "Custom"))
       (style (list 'vertical-label)) (horiz-margin 150) (vert-margin 10)
       (callback
        (λ (choice event)
          (set! current-preset (send choice get-selection))))))

(define (add-apply-settings panels volume-slider attack-slider decay-slider)

  ;; set default settings.
  (fill-hash note-hash
             hashed-freqs
             (hash-ref presets current-preset)
             (send attack-slider get-value)
             (send volume-slider get-value)
             num-of-harmonics
             (send decay-slider get-value))

  ;; add button to gui so user can apply settings they configure.
  (new button% [parent (panels 'panel2)]
       [label "Apply Settings"]
       (horiz-margin 140)
       [callback (lambda (button event)
                   (fill-hash note-hash
                              hashed-freqs
                              (hash-ref presets current-preset)
                              (send attack-slider get-value)
                              (send volume-slider get-value)
                              num-of-harmonics
                              (send decay-slider get-value)))]))


(define (add-gui-elements frame)
  ;; this procedure adds all of the elements to the gui that the user can use to modify tone settings

  ;; sliders
  (define volume-slider (add-vol-slider frame))
  (define attack-slider (add-attack-slider frame))
  (define decay-slider  (add-decay-slider frame))

  ;; panels that will have objects added to
  (define panels (add-panels frame))

  ;; add fields to adjust properties of harmonics that are played
  (add-harmonic-fields panels)

  ;; add list of presets user can select.
  (add-preset-select panels)

  ;; add button so user can apply settings.
  (add-apply-settings panels volume-slider attack-slider decay-slider))

