
#lang racket

(require "../sound/note-generator.rkt")

(provide note-hash)
(provide fill-hash)
(provide presets)
(provide hashed-freqs)

(define (create-preset-hash)
  ;; creates hash table for converting preset selected from gui element to literal
  ;; this literal is used by a hash table.
  (define presets (make-hash))
  (hash-set! presets 0 'piano)
  (hash-set! presets 1 'clarinet)
  (hash-set! presets 2 'custom)
  presets)

(define (create-note-hash)

  ;; creates a hash table.
  ;; the init command is used to fill hash table with generated sounds.
  ;; the play command is used to play generated sounds stored in hash table.
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

;; fills hash table with tones  using the desired tone settings.
(define (fill-hash note-hash freqs timbre attack max-volume num-of-harmonics decay-factor)
  ((note-hash 'init) freqs timbre attack max-volume num-of-harmonics decay-factor))

;; create hash table to convert preset values selected using gui element to literals.
(define presets (create-preset-hash))

;; the frequencies used by the sherman keyboard.
(define hashed-freqs (list 523.25
                           587.33
                           659.25
                           698.46
                           783.99
                           880.00
                           987.77
                           1046.50
                           554.37
                           622.25
                           739.99
                           830.61
                           932.33
                           1108.73))

;; hashed frequencies that will be used globally by  various sub modules.
(define note-hash (create-note-hash))


