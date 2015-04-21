
#lang racket

(require "effects.rkt")
(require portaudio
         ffi/vector)

(provide create-tone)

(define (create-tone fundamentalFreq attack max-volume)


    (set! attack (/ attack 10000.0))
    (set! max-volume (/ max-volume 80))

    (define k1 1)
    (define phase1 0)
    (define sample-rate 44100.0)
    (define tpisr (* 2 pi (/ 1.0 sample-rate)))
    (define (real->s16 x)
      (inexact->exact (round (* 32767 x))))
    (define durationOfNote 2)
    (define vec (make-s16vector (* (* 44100 durationOfNote) 4)))

    (for ([t (in-range 88200)])

      (define a (calculate-amplitude t
                                     attack
                                     sample-rate
                                     max-volume
                                     durationOfNote
                                     fundamentalFreq))

      (define sample1 (real->s16 (* max-volume a (sin (+ (* tpisr t (* fundamentalFreq k1)) phase1)))))

      (s16vector-set! vec (* 4 t) sample1)
      (s16vector-set! vec (+ 1 (* 4 t)) sample1)
      (s16vector-set! vec (+ 2 (* 4 t)) sample1)
      (s16vector-set! vec (+ 3 (* 4 t)) sample1))
     (lambda () (s16vec-play vec 0 88200 sample-rate)))


