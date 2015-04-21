#lang racket 

(require  "keyboard-utilities.rkt"
          "effects/buttons/buttons.rkt"
          "effects/note-generator.rkt"
          racket/gui
          rsound
          ffi/vector
          images/icons/control
          images/icons/style)

; Make a frame by instantiating the frame% class
(define frame (new frame% (label "Keyboard")
                   (width 800) (height 400)
                   (min-width 800) (min-height 400)
                   (stretchable-height #f) (stretchable-width #f)))
 
(define volume-slider (install-vol-slider frame))
(define attack-slider (install-attack-slider frame))

; Make a static text message in the frame
(define msg (new message% (parent frame)
                          (label "Play a note:")))
  
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
