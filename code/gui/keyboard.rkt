#lang racket

(require "../sound/note-generator.rkt")
(require "../hash/hash.rkt")
(require  racket/gui)

(provide make-keyboard)

(define (draw-keyboard dc)
  ;; this procedure draws the keys onto the canvas on the frame displayed.
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
  (send dc draw-text "[" 793 135))

(define (determine-note-on-click event note-hash)
  (cond
    ;; White Keys
    ((or (and (< (send event get-x) 80) (< (send event get-y) 160))
         (and (< (send event get-x) 100) (>= (send event get-y) 160)))
     (play-note 523.25 note-hash)) ; play C
    ((or (and (> (send event get-x) 120) (< (send event get-x) 180) (< (send event get-y) 160))
         (and (> (send event get-x) 100) (< (send event get-x) 200) (>= (send event get-y) 160)))
     (play-note 587.33 note-hash)) ; play D
    ((or (and (> (send event get-x) 220) (< (send event get-x) 300) (< (send event get-y) 160))
         (and (> (send event get-x) 200) (< (send event get-x) 300) (>= (send event get-y) 160)))
     (play-note 659.25 note-hash)) ; play E
    ((or (and (> (send event get-x) 300) (< (send event get-x) 380) (< (send event get-y) 160))
         (and (> (send event get-x) 300) (< (send event get-x) 400) (>= (send event get-y) 160)))
     (play-note 698.46 note-hash)) ; play F
    ((or (and (> (send event get-x) 420) (< (send event get-x) 480) (< (send event get-y) 160))
         (and (> (send event get-x) 400) (< (send event get-x) 500) (>= (send event get-y) 160)))
     (play-note 783.99 note-hash)) ; play G
    ((or (and (> (send event get-x) 520) (< (send event get-x) 580) (< (send event get-y) 160))
         (and (> (send event get-x) 500) (< (send event get-x) 600) (>= (send event get-y) 160)))
     (play-note 880.00 note-hash)) ; play A
    ((or (and (> (send event get-x) 620) (< (send event get-x) 700) (< (send event get-y) 160))
         (and (> (send event get-x) 600) (< (send event get-x) 700) (>= (send event get-y) 160)))
     (play-note 987.77 note-hash)) ; play B
    ((or (and (> (send event get-x) 700) (< (send event get-x) 780) (< (send event get-y) 160))
             (and (> (send event get-x) 700) (>= (send event get-y) 160)))
     (play-note 1046.50 note-hash)) ; play C

    ;; Black Keys
    ((and (> (send event get-x) 80) (< (send event get-x) 120) (< (send event get-y) 160))
     (play-note 554.37 note-hash)) ; play C#
    ((and (> (send event get-x) 180) (< (send event get-x) 220) (< (send event get-y) 160))
     (play-note 622.25 note-hash)) ; play D#
    ((and (> (send event get-x) 380) (< (send event get-x) 420) (< (send event get-y) 160))
     (play-note 739.99 note-hash)) ; play F#
    ((and (> (send event get-x) 480) (< (send event get-x) 520) (< (send event get-y) 160))
     (play-note 830.61 note-hash)) ; play G#
    ((and (> (send event get-x) 580) (< (send event get-x) 620) (< (send event get-y) 160))
     (play-note 932.33 note-hash)) ; play A#
    ((and (> (send event get-x) 780) (< (send event get-y) 160))
     (play-note 1108.73 note-hash)) ; play C#
    ))

(define (determine-note-on-keyboard event note-hash)
  (cond ;; White Keys
    ((eqv? (send event get-key-code) #\a)
     (play-note 523.25 note-hash)) ;; Play C
    ((eqv? (send event get-key-code) #\s)
     (play-note 587.33 note-hash)) ;; Play D
    ((eqv? (send event get-key-code) #\d)
     (play-note 659.25 note-hash)) ;; Play E
    ((eqv? (send event get-key-code) #\f)
     (play-note 698.46 note-hash)) ;; Play F
    ((eqv? (send event get-key-code) #\j)
     (play-note 783.99 note-hash)) ;; Play G
    ((eqv? (send event get-key-code) #\k)
     (play-note 880.0 note-hash)) ;; Play A
    ((eqv? (send event get-key-code) #\l)
     (play-note 987.77 note-hash)) ;; Play B
    ((eqv? (send event get-key-code) #\;)
     (play-note 1046.5 note-hash)) ;; Play C
    ;; Black Keys
    ((eqv? (send event get-key-code) #\w)
     (play-note 554.37 note-hash)) ;; Play C#
    ((eqv? (send event get-key-code) #\e)
     (play-note 622.25 note-hash)) ;; Play D#
    ((eqv? (send event get-key-code) #\u)
     (play-note 739.99 note-hash)) ;; Play F#
    ((eqv? (send event get-key-code) #\i)
     (play-note 830.61 note-hash)) ;; Play G#
    ((eqv? (send event get-key-code) #\o)
     (play-note 932.33 note-hash)) ;; Play A#
    ((eqv? (send event get-key-code) #\[)
     (play-note 1108.73 note-hash)) ;; Play C#
    ))

; Derive a new canvas (a drawing window) class to handle events
(define keyboard%
  (class canvas% ; The base class is canvas%
    ; Define overriding method to handle mouse events
    (define/override (on-event event)
      (when (send event button-down? 'left)
        (determine-note-on-click event note-hash)))
    ; Define overriding method to handle keyboard events
    (define/override (on-char event)
      (determine-note-on-keyboard event note-hash))

    ; Call the superclass init, passing on all init args
    (super-new)))

(define (make-keyboard frame)
  (new keyboard% (parent frame)
       (paint-callback
        (lambda (canvas dc)
          (draw-keyboard dc)))
       (style (list 'border))))

