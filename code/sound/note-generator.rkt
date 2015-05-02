#lang racket

;; The create-tone procedure is used to generate tones
;; based on settings configured by user by making a call
;; to the additive synth module.

;; The play-note procedure is used to make playing the notes stored
;; a little easier!

(require "effects.rkt")
(require "additivesynth.rkt")

(require portaudio
         ffi/vector)

(provide create-tone)
(provide play-note)

(define (create-tone fund-freq timbre attack max-volume num-of-harmonics decay-factor)
    ;; creates a tone by executing the GenerateAudio procedure

    ;; this is done mainly because the values stored within gui elements have limited range.
    (set! attack (/ attack 20000.0))
    (set! max-volume (/ max-volume 80))

    ;; this is done so a higher value stored has the opposite effect.
    (set! decay-factor (- 101 decay-factor))

    ;; used to calculate amplitude at a specific moment in time.
    (define effects (lambda (t sample-rate dur-of-note)
                        (calculate-amplitude t
                                             attack
                                             sample-rate
                                             dur-of-note
                                             decay-factor)))

    ;; create the tone.
    (GenerateAudio fund-freq timbre num-of-harmonics max-volume effects))

;; play the tone stored in the hash table.
(define (play-note pitch note-hash)
  (((note-hash 'play) pitch)))


