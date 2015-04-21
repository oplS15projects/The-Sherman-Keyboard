#lang racket

;; require libraries
(require  "effects/buttons/buttons.rkt"
          "effects/note-generator.rkt"
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

; Make a button in the frame
(new button% [parent frame]
             [label "click to play sound."]
             ; Callback procedure for a button click:
             [callback (lambda (button event) ;; executed when a botton is clicked!
                         (stop) ;; prevent multiple presses from overlapping the tones playing.
                         ((create-tone pitch
                                      (send attack-slider get-value)
                                      (send volume-slider get-value))))])

; Show the frame by calling its show method
;;(send frame show #f)
(display-frame frame)

