#lang racket

(require  "effects/buttons/buttons.rkt"
          "effects/note-generator.rkt"
          racket/gui
          rsound
          ffi/vector
          images/icons/control
          images/icons/style)

(define notes (make-hash))
(hash-set! notes "C5" 523.25) 
(hash-set! notes "D5" 587.33)
(hash-set! notes "E5" 659.25)
(hash-set! notes "F5" 698.46)
(hash-set! notes "G5" 783.99)
(hash-set! notes "A5" 880.00)
(hash-set! notes "B5" 987.77)
(hash-set! notes "C6" 1046.50)

(hash-set! notes "C#5" 554.37)
(hash-set! notes "D#5" 622.25)
(hash-set! notes "F#5" 739.99)
(hash-set! notes "G#5" 830.61)
(hash-set! notes "A#5" 932.33)
(hash-set! notes "C#6" 1108.73)

(define (determine-note-on-click event)
  (cond 
    ;; White Keys
    ((or (and (< (send event get-x) 80) (< (send event get-y) 160)) 
         (and (< (send event get-x) 100) (>= (send event get-y) 160))) 
     (begin ((create-tone (hash-ref notes "C5") (send attack-slider get-value) (send volume-slider get-value)))
            (send msg set-label "C"))) ; play C
    ((or (and (> (send event get-x) 120) (< (send event get-x) 180) (< (send event get-y) 160)) 
         (and (> (send event get-x) 100) (< (send event get-x) 200) (>= (send event get-y) 160))) 
     (begin ((create-tone (hash-ref notes "D5") (send attack-slider get-value) (send volume-slider get-value)))
            (send msg set-label "D"))) ; play D
    ((or (and (> (send event get-x) 220) (< (send event get-x) 300) (< (send event get-y) 160)) 
         (and (> (send event get-x) 200) (< (send event get-x) 300) (>= (send event get-y) 160))) 
     (begin ((create-tone (hash-ref notes "E5") (send attack-slider get-value) (send volume-slider get-value)))
            (send msg set-label "E"))) ; play E
    ((or (and (> (send event get-x) 300) (< (send event get-x) 380) (< (send event get-y) 160)) 
         (and (> (send event get-x) 300) (< (send event get-x) 400) (>= (send event get-y) 160))) 
     (begin ((create-tone (hash-ref notes "F5") (send attack-slider get-value) (send volume-slider get-value)))
            (send msg set-label "F"))) ; play F
    ((or (and (> (send event get-x) 420) (< (send event get-x) 480) (< (send event get-y) 160)) 
         (and (> (send event get-x) 400) (< (send event get-x) 500) (>= (send event get-y) 160))) 
     (begin ((create-tone (hash-ref notes "G5") (send attack-slider get-value) (send volume-slider get-value)))
            (send msg set-label "G"))) ; play G
    ((or (and (> (send event get-x) 520) (< (send event get-x) 580) (< (send event get-y) 160)) 
         (and (> (send event get-x) 500) (< (send event get-x) 600) (>= (send event get-y) 160))) 
     (begin ((create-tone (hash-ref notes "A5") (send attack-slider get-value) (send volume-slider get-value)))
            (send msg set-label "A"))) ; play A
    ((or (and (> (send event get-x) 620) (< (send event get-x) 700) (< (send event get-y) 160)) 
         (and (> (send event get-x) 600) (< (send event get-x) 700) (>= (send event get-y) 160))) 
     (begin ((create-tone (hash-ref notes "B5") (send attack-slider get-value) (send volume-slider get-value)))
            (send msg set-label "B"))) ; play B
    ((or (and (> (send event get-x) 700) (< (send event get-x) 780) (< (send event get-y) 160)) 
             (and (> (send event get-x) 700) (>= (send event get-y) 160))) 
     (begin ((create-tone (hash-ref notes "C6") (send attack-slider get-value) (send volume-slider get-value)))
            (send msg set-label "C"))) ; play C
    
    ;; Black Keys
    ((and (> (send event get-x) 80) (< (send event get-x) 120) (< (send event get-y) 160)) 
     (begin ((create-tone (hash-ref notes "C#5") (send attack-slider get-value) (send volume-slider get-value)))
            (send msg set-label "C#"))) ; play C#
    ((and (> (send event get-x) 180) (< (send event get-x) 220) (< (send event get-y) 160)) 
     (begin ((create-tone (hash-ref notes "D#5") (send attack-slider get-value) (send volume-slider get-value)))
            (send msg set-label "D#"))) ; play D#
    ((and (> (send event get-x) 380) (< (send event get-x) 420) (< (send event get-y) 160)) 
     (begin ((create-tone (hash-ref notes "F#5") (send attack-slider get-value) (send volume-slider get-value)))
            (send msg set-label "F#"))) ; play F#
    ((and (> (send event get-x) 480) (< (send event get-x) 520) (< (send event get-y) 160)) 
     (begin ((create-tone (hash-ref notes "G#5") (send attack-slider get-value) (send volume-slider get-value)))
            (send msg set-label "G#"))) ; play G#
    ((and (> (send event get-x) 580) (< (send event get-x) 620) (< (send event get-y) 160)) 
     (begin ((create-tone (hash-ref notes "A#5") (send attack-slider get-value) (send volume-slider get-value)))
            (send msg set-label "A#"))) ; play A#
    ((and (> (send event get-x) 780) (< (send event get-y) 160)) 
     (begin ((create-tone (hash-ref notes "C#6") (send attack-slider get-value) (send volume-slider get-value)))
            (send msg set-label "C#"))) ; play C#
    ))

(define (determine-note-on-keyboard event)
  (cond ;; White Keys
    ((eqv? (send event get-key-code) #\a) 
     (begin ((create-tone (hash-ref notes "C5") (send attack-slider get-value) (send volume-slider get-value)))
            (send msg set-label "C"))) ;; Play C
    ((eqv? (send event get-key-code) #\s)
     (begin ((create-tone (hash-ref notes "D5") (send attack-slider get-value) (send volume-slider get-value)))
            (send msg set-label "D"))) ;; Play D
    ((eqv? (send event get-key-code) #\d) 
     (begin ((create-tone (hash-ref notes "E5") (send attack-slider get-value) (send volume-slider get-value)))
            (send msg set-label "E"))) ;; Play E
    ((eqv? (send event get-key-code) #\f)
     (begin ((create-tone (hash-ref notes "F5") (send attack-slider get-value) (send volume-slider get-value)))
            (send msg set-label "F"))) ;; Play F
    ((eqv? (send event get-key-code) #\j) 
     (begin ((create-tone (hash-ref notes "G5") (send attack-slider get-value) (send volume-slider get-value)))
            (send msg set-label "G"))) ;; Play G
    ((eqv? (send event get-key-code) #\k) 
     (begin ((create-tone (hash-ref notes "A5") (send attack-slider get-value) (send volume-slider get-value)))
            (send msg set-label "A"))) ;; Play A
    ((eqv? (send event get-key-code) #\l)
     (begin ((create-tone (hash-ref notes "B5") (send attack-slider get-value) (send volume-slider get-value)))
            (send msg set-label "B"))) ;; Play B
    ((eqv? (send event get-key-code) #\;) 
     (begin ((create-tone (hash-ref notes "C6") (send attack-slider get-value) (send volume-slider get-value)))
            (send msg set-label "C"))) ;; Play C
    ;; Black Keys
    ((eqv? (send event get-key-code) #\w) 
     (begin ((create-tone (hash-ref notes "C#5") (send attack-slider get-value) (send volume-slider get-value)))
            (send msg set-label "C#"))) ;; Play C#
    ((eqv? (send event get-key-code) #\e) 
     (begin ((create-tone (hash-ref notes "D#5") (send attack-slider get-value) (send volume-slider get-value)))
            (send msg set-label "D#"))) ;; Play D#
    ((eqv? (send event get-key-code) #\u) 
     (begin ((create-tone (hash-ref notes "F#5") (send attack-slider get-value) (send volume-slider get-value)))
            (send msg set-label "F#"))) ;; Play F#
    ((eqv? (send event get-key-code) #\i) 
     (begin ((create-tone (hash-ref notes "G#5") (send attack-slider get-value) (send volume-slider get-value)))
            (send msg set-label "G#"))) ;; Play G#
    ((eqv? (send event get-key-code) #\o)
     (begin ((create-tone (hash-ref notes "A#5") (send attack-slider get-value) (send volume-slider get-value)))
            (send msg set-label "A#"))) ;; Play A#
    ((eqv? (send event get-key-code) #\[) 
     (begin ((create-tone (hash-ref notes "C#6") (send attack-slider get-value) (send volume-slider get-value)))
            (send msg set-label "C#"))) ;; Play C#
    ))

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
  (send dc draw-rectangle 780 0 40 160))
