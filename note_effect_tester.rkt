#lang racket

(require "effects/effects.rkt")
(require portaudio
         ffi/vector)

(define fundametalFreq 200)

(define k1 1)

(define phase1 0)

(define sample-rate 44100.0)
(define tpisr (* 2 pi (/ 1.0 sample-rate)))
(define (real->s16 x)
  (inexact->exact (round (* 32767 x))))

(define durationOfNote 2)

(define vec (make-s16vector (* (* 44100 durationOfNote) 4)))

(define attack .002)
(define max-vol .5)

(for ([t (in-range 88200)])

  (define a (calculate-amplitude t
                                 attack
                                 sample-rate
                                 max-vol
                                 durationOfNote
                                 fundametalFreq))

  (define sample1 (real->s16 (* 1 a (sin (+ (* tpisr t (* fundametalFreq k1)) phase1)))))

  (s16vector-set! vec (* 4 t) sample1)
  (s16vector-set! vec (+ 1 (* 4 t)) sample1)
  (s16vector-set! vec (+ 2 (* 4 t)) sample1)
  (s16vector-set! vec (+ 3 (* 4 t)) sample1))


(s16vec-play vec 0 88200 sample-rate)


