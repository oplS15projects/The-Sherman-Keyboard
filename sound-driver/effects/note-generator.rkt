
#lang racket

(require "effects.rkt")
(require "../additivesynth.rkt")

(require portaudio
         ffi/vector)

(define (create-tone fund-freq timbre attack max-volume num-of-harmonics decay-factor)

    (set! attack (/ attack 20000.0))
    (set! max-volume (/ max-volume 80))
    (set! decay-factor (- 101 decay-factor))

    (define effects (lambda (t sample-rate dur-of-note)
                        (calculate-amplitude t
                                             attack
                                             sample-rate
                                             dur-of-note
                                             decay-factor)))

    (GenerateAudio fund-freq timbre num-of-harmonics max-volume effects))

(provide create-tone)
(provide create-note-hash)
(provide play-note)
(provide init-hash)

(define (create-note-hash)
  (define note-hash (make-hash))

  (define (init freqs timbre attack max-volume num-of-harmonics decay-factor)
    (if (null? freqs)
        note-hash
        (begin
          (hash-set! note-hash (car freqs) (create-tone (car freqs)
                                                        timbre
                                                        attack
                                                        max-volume
                                                        num-of-harmonics
                                                        decay-factor))
          (init (cdr freqs) timbre attack max-volume num-of-harmonics decay-factor))))

  (lambda (cmd)
    (cond ((eq? cmd 'init) init)
          ((eq? cmd 'play) (lambda (pitch) (hash-ref note-hash pitch))))))

(define (init-hash note-hash freqs timbre attack max-volume num-of-harmonics decay-factor)
  ((note-hash 'init) freqs timbre attack max-volume num-of-harmonics decay-factor))

(define (play-note pitch note-hash)
  (((note-hash 'play) pitch)))


