#lang racket

;; require libraries
(require  "sound-driver/effects/buttons/buttons.rkt"
          "sound-driver/effects/note-generator.rkt"
          racket/gui
          rsound
          ffi/vector
          images/icons/control
          images/icons/style)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;SOUND CODE;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define pitch  523.253) ;; C5

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;ICONS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define my-play-icon (play-icon #:color run-icon-color #:height 32))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;GUI CODE;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; instantiating a frame class instance.
(define frame (new frame% [label ""]
                   [min-width 300]
                   [min-height 150]))

(define (display-frame frame)
   (send frame show #t))

(define volume-slider (install-vol-slider frame))
(define attack-slider (install-attack-slider frame))
; (define decay-slider (install-decay-slider frame))

(define freqs (list pitch 4324))

(define note-hash (create-note-hash))



(init-hash note-hash
           freqs
           'piano
           (send attack-slider get-value)
           (send volume-slider get-value)
           4)

; Make a button in the frame
(new button% [parent frame]
             [label "click to play sound."]
             ; Callback procedure for a button click:
             [callback (lambda (button event) ;; executed when a botton is clicked!
                         (play-note pitch note-hash))]) ;; prevent multiple presses from overlapping the tones playing.

(new button% [parent frame]
     [label "apply settings."]
     [callback (lambda (button event)
                 (init-hash note-hash
                            freqs
                            'piano
                            (send attack-slider get-value)
                            (send volume-slider get-value)
                            4))])
; Show the frame by calling its show method
;;(send frame show #f)
(display-frame frame)

