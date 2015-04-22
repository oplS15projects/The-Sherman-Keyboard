#lang racket

(require portaudio
         ffi/vector)

;;; Eamon Lightning
;;; The Sherman Keyboard

;;; This file provides a method for generating audio data for all of the 
;;; fundamental frequencies in the provided range (one octave) with a single
;;; procedure call. This procedure (GenerateAudio) takes as its one argument
;;; a hash table that contains all of the properties defining some timbre
;;; that will be used to generated audio. 
;;; Hash tables are used extensively here. They are implemented to store and
;;; retrieve the following values: fundamental frequencies, generated audio 
;;; vectors, and properties of individual timbres.
;;; See the comments below for more detail. 


;; For now, this is the default number of harmonics used in our additive synthesis process.
(define numberOfHarmonics 4)

;; For now, this is the default duration of each tone played. 
(define durationOfNote 2)

;; Fixed sample rate.
(define sample-rate 44100.0)

;; Fixed constant multiplier.
(define tpisr (* 2 pi (/ 1.0 sample-rate)))


;; Scales the output of the sine function by 32676.
(define (real->s16 x)
  (inexact->exact (round (* 32767 x))))

;; Holds all audio vectors for the complex sounds generated within the
;; GenerateAudio procedure. The keys within this hash table are integers, which
;; represent the order in which the synth-keys appear in the GUI.
(define audioVectors (make-hash))

;; A table of all the fundamental frequencies in the provided range beginning
;; with c4 and working up to B4 chromatically. Key/value pair <0,0> is only
;; added to the table to provide a base case for iteration in the cycle procedure.
;; It does nothing but signal an end of iteration. 
(define fundamentalFrequencies (make-hash))
(hash-set! fundamentalFrequencies 0 0)
(hash-set! fundamentalFrequencies 1 261)
(hash-set! fundamentalFrequencies 2 277)
(hash-set! fundamentalFrequencies 3 293)
(hash-set! fundamentalFrequencies 4 311)
(hash-set! fundamentalFrequencies 5 329)
(hash-set! fundamentalFrequencies 6 349)
(hash-set! fundamentalFrequencies 7 369)
(hash-set! fundamentalFrequencies 8 391)
(hash-set! fundamentalFrequencies 9 415)
(hash-set! fundamentalFrequencies 10 440)
(hash-set! fundamentalFrequencies 11 466)
(hash-set! fundamentalFrequencies 12 493)

;; Holds properties of a (mock) piano timbre.
(define pianoHT (make-hash))
(hash-set! pianoHT "k1" 1)
(hash-set! pianoHT "k2" 2)
(hash-set! pianoHT "k3" 3)
(hash-set! pianoHT "k4" 4)
(hash-set! pianoHT "a1" .5)
(hash-set! pianoHT "a2" .25)
(hash-set! pianoHT "a3" .15)
(hash-set! pianoHT "a4" .1)
(hash-set! pianoHT "phase1" 0)
(hash-set! pianoHT "phase2" .1)
(hash-set! pianoHT "phase3" .2)
(hash-set! pianoHT "phase4" 0)

;; Holds properties of a (mock) clarinet timbre.
(define clarinetHT (make-hash))
(hash-set! clarinetHT "k1" 1)
(hash-set! clarinetHT "k2" 3)
(hash-set! clarinetHT "k3" 5)
(hash-set! clarinetHT "k4" 7)
(hash-set! clarinetHT "a1" .5)
(hash-set! clarinetHT "a2" .25)
(hash-set! clarinetHT "a3" .15)
(hash-set! clarinetHT "a4" .1)
(hash-set! clarinetHT "phase1" 0)
(hash-set! clarinetHT "phase2" .1)
(hash-set! clarinetHT "phase3" .4)
(hash-set! clarinetHT "phase4" 0)

;; Aptly named procedure that generates audio data.
;; It accepts a timbre hash table and defines local variables that assume
;; the values of the data that the table contains. Since this data is used
;; thousands of times, creating local variables that store the data will bypass
;; the need to perform thousands of searches into the hash table (albeit in 
;; constant time), thereby improving upon efficiency. 
;; The cycle procedure, which actually does most of the work, is defined within
;; the GenerateAudio procedure so that it can access its local variables, which
;; are very important in the process of generating audio. With each call to cycle
;; n takes on the value of one integer less than the preceeding call, which is used
;; to retrieve the value associated with the n key in the fundamentalFrequencies
;; hash table. With each retrieval of a fundamental frequency, a complex wave
;; is built in reference to its value, and the values that characterize the 
;; desired timbre. After a complex wave completes construction in the for loop,
;; that generated audio data is stored within the audioVectors hash table at 
;; key n, thereby using the same key to store audio data as the key of the
;; fundamental frequency upon which that audio was built. 
;; GenerateAudio calls cycle providing it an arugment of 12 so that all of the
;; frequencies in the fundamentalFrequencies table are accessed, and their 
;; corresponding complex sounds are generated. 
(define (GenerateAudio timbre)
  (define k1 (hash-ref timbre "k1"))
  (define k2 (hash-ref timbre "k2"))
  (define k3 (hash-ref timbre "k3"))
  (define k4 (hash-ref timbre "k4"))
  (define a1 (hash-ref timbre "a1"))
  (define a2 (hash-ref timbre "a2"))
  (define a3 (hash-ref timbre "a3"))
  (define a4 (hash-ref timbre "a4"))
  (define phase1 (hash-ref timbre "phase1"))
  (define phase2 (hash-ref timbre "phase2"))
  (define phase3 (hash-ref timbre "phase3"))
  (define phase4 (hash-ref timbre "phase4"))
  (define (cycle n) 
    (define fundamentalFreq (hash-ref fundamentalFrequencies n))
    (define vec (make-s16vector (* (* 44100 durationOfNote) numberOfHarmonics)))
    (if (= n 0)
        "Audio Generation Complete"
        (begin 
          (for ([t (in-range 88200)])
             (define sample1 (real->s16 (* a1 (sin (+ (* tpisr t (* fundamentalFreq k1)) phase1)))))
             (define sample2 (real->s16 (* a2 (sin (+ (* tpisr t (* fundamentalFreq k2)) phase2)))))
             (define sample3 (real->s16 (* a3 (sin (+ (* tpisr t (* fundamentalFreq k3)) phase3)))))
             (define sample4 (real->s16 (* a4 (sin (+ (* tpisr t (* fundamentalFreq k4)) phase4)))))
             (s16vector-set! vec (* 4 t) sample1)
             (s16vector-set! vec (+ 1 (* 4 t)) sample2)
             (s16vector-set! vec (+ 2 (* 4 t)) sample3)
             (s16vector-set! vec (+ 3 (* 4 t)) sample4))
             (hash-set! audioVectors n vec)
             (cycle (- n 1)))))
  (cycle 12))
 
;; Below are some sample commands to generate and play audio. After calling GenerateAudio 
;; and providing it with clarinetHT as an argument, the timbre of the clarinet
;; (as characterized by the properties in clarinetHT) should be consistent
;; for all notes. Replace the 1 in the hash-ref procedure by any integer [1,12] 
;; to play any of the twelve notes in our octave. 

;; (GenerateAudio clarinetHT)
;; (s16vec-play (hash-ref audioVectors 1) 0 88200 sample-rate)