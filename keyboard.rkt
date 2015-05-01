#lang racket 

(require  "sound-driver/additivesynth.rkt"
          "sound-driver/effects/buttons/buttons.rkt"
          "sound-driver/effects/note-generator.rkt"
          racket/gui
          ffi/vector
          )

(define presets (make-hash))
(hash-set! presets 0 'piano)
(hash-set! presets 1 'clarinet)
(hash-set! presets 2 'custom)

(define current-preset 0)

(define (draw-keyboard dc)
  (send dc draw-line 100 0 100 500)
  (send dc draw-line 200 0 200 500)
  (send dc draw-line 300 0 300 500)
  (send dc draw-line 400 0 400 500)
  (send dc draw-line 500 0 500 500)
  (send dc draw-line 600 0 600 500)
  (send dc draw-line 700 0 700 500)
  
  (send dc set-brush "black" 'solid)
  
  (send dc draw-rectangle 80 0 40 160)
  (send dc draw-rectangle 180 0 40 160)
  (send dc draw-rectangle 380 0 40 160)
  (send dc draw-rectangle 480 0 40 160)
  (send dc draw-rectangle 580 0 40 160)
  (send dc draw-rectangle 780 0 40 160)
  
  (send dc set-text-foreground "black")
  
  (send dc draw-text "A" 50 250)
  (send dc draw-text "S" 150 250)
  (send dc draw-text "D" 250 250)
  (send dc draw-text "F" 350 250)
  (send dc draw-text "J" 450 250)
  (send dc draw-text "K" 550 250)
  (send dc draw-text "L" 650 250)
  (send dc draw-text ";" 750 250)
  
  (send dc set-text-foreground "white")
  
  (send dc draw-text "W" 95 135)
  (send dc draw-text "E" 197 135)
  
  (send dc draw-text "U" 397 135)
  (send dc draw-text "I" 500 135)
  (send dc draw-text "O" 595 135)
  (send dc draw-text "[" 793 135)
  
  )

(define (determine-note-on-click event)
  (cond 
    ;; White Keys
    ((or (and (< (send event get-x) 80) (< (send event get-y) 160)) 
         (and (< (send event get-x) 100) (>= (send event get-y) 160))) 
     (begin (play-note 523.25 note-hash)
            (send msg set-label "C"))) ; play C
    ((or (and (> (send event get-x) 120) (< (send event get-x) 180) (< (send event get-y) 160)) 
         (and (> (send event get-x) 100) (< (send event get-x) 200) (>= (send event get-y) 160))) 
     (begin (play-note 587.33 note-hash)
            (send msg set-label "D"))) ; play D
    ((or (and (> (send event get-x) 220) (< (send event get-x) 300) (< (send event get-y) 160)) 
         (and (> (send event get-x) 200) (< (send event get-x) 300) (>= (send event get-y) 160))) 
     (begin (play-note 659.25 note-hash)
            (send msg set-label "E"))) ; play E
    ((or (and (> (send event get-x) 300) (< (send event get-x) 380) (< (send event get-y) 160)) 
         (and (> (send event get-x) 300) (< (send event get-x) 400) (>= (send event get-y) 160))) 
     (begin (play-note 698.46 note-hash)
            (send msg set-label "F"))) ; play F
    ((or (and (> (send event get-x) 420) (< (send event get-x) 480) (< (send event get-y) 160)) 
         (and (> (send event get-x) 400) (< (send event get-x) 500) (>= (send event get-y) 160))) 
     (begin (play-note 783.99 note-hash)
            (send msg set-label "G"))) ; play G
    ((or (and (> (send event get-x) 520) (< (send event get-x) 580) (< (send event get-y) 160)) 
         (and (> (send event get-x) 500) (< (send event get-x) 600) (>= (send event get-y) 160))) 
     (begin (play-note 880.00 note-hash)
            (send msg set-label "A"))) ; play A
    ((or (and (> (send event get-x) 620) (< (send event get-x) 700) (< (send event get-y) 160)) 
         (and (> (send event get-x) 600) (< (send event get-x) 700) (>= (send event get-y) 160))) 
     (begin (play-note 987.77 note-hash)
            (send msg set-label "B"))) ; play B
    ((or (and (> (send event get-x) 700) (< (send event get-x) 780) (< (send event get-y) 160)) 
             (and (> (send event get-x) 700) (>= (send event get-y) 160))) 
     (begin (play-note 1046.50 note-hash)
            (send msg set-label "C"))) ; play C
    
    ;; Black Keys
    ((and (> (send event get-x) 80) (< (send event get-x) 120) (< (send event get-y) 160)) 
     (begin (play-note 554.37 note-hash)
            (send msg set-label "C#"))) ; play C#
    ((and (> (send event get-x) 180) (< (send event get-x) 220) (< (send event get-y) 160)) 
     (begin (play-note 622.25 note-hash)
            (send msg set-label "D#"))) ; play D#
    ((and (> (send event get-x) 380) (< (send event get-x) 420) (< (send event get-y) 160)) 
     (begin (play-note 739.99 note-hash)
            (send msg set-label "F#"))) ; play F#
    ((and (> (send event get-x) 480) (< (send event get-x) 520) (< (send event get-y) 160)) 
     (begin (play-note 830.61 note-hash)
            (send msg set-label "G#"))) ; play G#
    ((and (> (send event get-x) 580) (< (send event get-x) 620) (< (send event get-y) 160)) 
     (begin (play-note 932.33 note-hash)
            (send msg set-label "A#"))) ; play A#
    ((and (> (send event get-x) 780) (< (send event get-y) 160)) 
     (begin (play-note 1108.73 note-hash)
            (send msg set-label "C#"))) ; play C#
    ))

(define (determine-note-on-keyboard event)
  (cond ;; White Keys
    ((eqv? (send event get-key-code) #\a) 
     (begin (play-note 523.25 note-hash)
            (send msg set-label "C"))) ;; Play C
    ((eqv? (send event get-key-code) #\s)
     (begin (play-note 587.33 note-hash)
            (send msg set-label "D"))) ;; Play D
    ((eqv? (send event get-key-code) #\d) 
     (begin (play-note 659.25 note-hash)
            (send msg set-label "E"))) ;; Play E
    ((eqv? (send event get-key-code) #\f)
     (begin (play-note 698.46 note-hash)
            (send msg set-label "F"))) ;; Play F
    ((eqv? (send event get-key-code) #\j) 
     (begin (play-note 783.99 note-hash)
            (send msg set-label "G"))) ;; Play G
    ((eqv? (send event get-key-code) #\k) 
     (begin (play-note 880.0 note-hash)
            (send msg set-label "A"))) ;; Play A
    ((eqv? (send event get-key-code) #\l)
     (begin (play-note 987.77 note-hash)
            (send msg set-label "B"))) ;; Play B
    ((eqv? (send event get-key-code) #\;) 
     (begin (play-note 1046.5 note-hash)
            (send msg set-label "C"))) ;; Play C
    ;; Black Keys
    ((eqv? (send event get-key-code) #\w) 
     (begin (play-note 554.37 note-hash)
            (send msg set-label "C#"))) ;; Play C#
    ((eqv? (send event get-key-code) #\e) 
     (begin (play-note 622.25 note-hash)
            (send msg set-label "D#"))) ;; Play D#
    ((eqv? (send event get-key-code) #\u) 
     (begin (play-note 739.99 note-hash)
            (send msg set-label "F#"))) ;; Play F#
    ((eqv? (send event get-key-code) #\i) 
     (begin (play-note 830.61 note-hash)
            (send msg set-label "G#"))) ;; Play G#
    ((eqv? (send event get-key-code) #\o)
     (begin (play-note 932.33 note-hash)
            (send msg set-label "A#"))) ;; Play A#
    ((eqv? (send event get-key-code) #\[) 
     (begin (play-note 1108.73 note-hash)
            (send msg set-label "C#"))) ;; Play C#
    ))

; Make a frame by instantiating the frame% class
(define frame (new frame% (label "The Sherman Keyboard")
                   (width 800) (height 500)
                   (min-width 800) (min-height 500)
                   (stretchable-height #f) (stretchable-width #f)))
 
(define volume-slider (install-vol-slider frame))
(define attack-slider (install-attack-slider frame))

(define freqs (list 523.25 587.33 659.25 698.46 783.99 880.00 987.77 1046.50 554.37 622.25 739.99 830.61 932.33 1108.73))

(define note-hash (create-note-hash))

(init-hash note-hash
           freqs
           'piano
           (send attack-slider get-value)
           (send volume-slider get-value)
           4)

; Make a static text message in the frame
(define msg (new message% (parent frame)
                          (label "Play a note:")))

(define panel1 (new horizontal-panel% (parent frame) (stretchable-height #f) (min-height 50)))

(new text-field% (parent panel1) (label "k2") (stretchable-width #f) (min-width 120) (init-value "2")
     (callback 
              (λ (text event) 
                (hash-set! customHT "k2" (string->number (send text get-value)))
                (display (hash-ref customHT "k2"))
                )))

(new text-field% (parent panel1) (label "k3") (stretchable-width #f) (min-width 120) (init-value "3")
     (callback 
              (λ (text event) 
                (hash-set! customHT "k3" (string->number (send text get-value)))
                (display (hash-ref customHT "k3"))
                )))

(new text-field% (parent panel1) (label "k4") (stretchable-width #f) (min-width 120) (init-value "4")
     (callback 
              (λ (text event) 
                (hash-set! customHT "k4" (string->number (send text get-value)))
                (display (hash-ref customHT "k4"))
                )))

(define panel2 (new horizontal-panel% (parent frame) (stretchable-height #f) (min-height 50)))

(new text-field% (parent panel2) (label "a2") (stretchable-width #f) (min-width 120) (init-value ".25")
     (callback 
              (λ (text event) 
                (hash-set! customHT "a2" (string->number (send text get-value)))
                (display (hash-ref customHT "a2"))
                )))
(new text-field% (parent panel2) (label "a3") (stretchable-width #f) (min-width 120) (init-value ".15")
     (callback 
              (λ (text event) 
                (hash-set! customHT "a3" (string->number (send text get-value)))
                (display (hash-ref customHT "a3"))
                )))
(new text-field% (parent panel2) (label "a4") (stretchable-width #f) (min-width 120) (init-value ".1")
     (callback 
              (λ (text event) 
                (hash-set! customHT "a4" (string->number (send text get-value)))
                (display (hash-ref customHT "a4"))
                )))

(new choice% (parent panel1) (label "Presets") (choices (list "Organ" "Bells" "Custom")) 
             (style (list 'vertical-label)) (horiz-margin 150) (vert-margin 10)
             
             (callback 
              (λ (choice event) 
                (set! current-preset (send choice get-selection))
                )))

(new button% [parent panel2]
     [label "Apply Settings"]
     (horiz-margin 140)
     [callback (lambda (button event)
                 (init-hash note-hash
                            freqs
                            (hash-ref presets current-preset)
                            (send attack-slider get-value)
                            (send volume-slider get-value)
                            4))])
                        
; Derive a new canvas (a drawing window) class to handle events
(define keyboard%
  (class canvas% ; The base class is canvas%
    ; Define overriding method to handle mouse events
    (define/override (on-event event)
      (when (send event button-down? 'left)
        (determine-note-on-click event)))
    ; Define overriding method to handle keyboard events
    (define/override (on-char event)
      (determine-note-on-keyboard event))

    ; Call the superclass init, passing on all init args
    (super-new)))
 
; Make a canvas that handles events in the frame
(new keyboard% (parent frame)
     (paint-callback
      (lambda (canvas dc)
        (draw-keyboard dc)))
     (style (list 'border)))

; Show the frame by calling its show method
(send frame show #t)