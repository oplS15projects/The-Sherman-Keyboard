#lang racket

(require  "../sound/additivesynth.rkt"
          "../sound/note-generator.rkt"
          "../hash/hash.rkt"
          "buttons.rkt"
          "keyboard.rkt"
          racket/gui
          ffi/vector)

(provide ShermanKeyboard)

(define (ShermanKeyboard)

  ;; Make a frame by instantiating the frame% class
  (define frame (new frame% (label "The Sherman Keyboard")
                     (width 810) (height 560)
                     (min-width 810) (min-height 560)
                     (stretchable-height #f) (stretchable-width #f)))

  ;; add elements onto gui that the user can use to adjust tone settings
  (add-gui-elements frame)

  ;; Make a canvas that handles events in the frame.
  (define keyboard (make-keyboard frame))

  ;; Show the frame by calling its show method
  (lambda (cmd)
    (cond ((eq? cmd 'display) (send frame show #t)))))
