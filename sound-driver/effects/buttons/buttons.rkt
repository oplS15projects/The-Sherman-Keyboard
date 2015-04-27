
#lang racket

(provide install-vol-slider)
(provide install-attack-slider)
(require racket/gui)

(define (install-vol-slider parent-frame)

  (new slider%
       [label "volume"]
       [parent parent-frame]
       [min-value 1]
       [max-value 100]
       [init-value 5]))

(define (install-attack-slider parent-frame)

  (new slider%
       [label "attack"]
       [parent parent-frame]
       [min-value 1]
       [max-value 1000]
       [init-value 232]))

(define (install-decay-slider parent-frame)

  (new slider%
       [label "decay"]
       [parent parent-frame]
       [min-value 1]
       [max-value 500]
       [init-value 232]))


