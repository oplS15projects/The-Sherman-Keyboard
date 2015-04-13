
#lang racket

(provide install-vol-slider)
(require racket/gui)

(define (install-vol-slider parent-frame)

  ;; takes in a frame object and then adds a slider to the frame

  ;; TODO: flip the values around so setting slider up increases volume
  ;; TODO: get a + and - on the top and bottom of slider.

  (new slider%
       [label "volume"]
       [parent parent-frame]
       [min-value 0]
       [max-value 10]
       [init-value 5]
       [style (list 'vertical 'plain)]))
      ; [callback (lambda (control event)
       ;            (play (create-tone (/ (send slider get-value) 80))))]))




