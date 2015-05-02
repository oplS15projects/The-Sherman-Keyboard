#lang racket

;; this module contains the procedures
;; for calculating amplitude of tones
;; based on attack and decay settings.

(provide calculate-amplitude)

(define (peak-amplitude-pos sample-rate attack)
  ;; determines where the amplitude should start decreasing
  (* sample-rate attack))

(define (attack-factor sample-rate attack)
  ;; used to determine how fast a note's volume should increase by
  ;; at a certain index in a vector. this index essentially represents time.
  (/ 1 (* attack sample-rate)))

(define (amplitude t sample-rate attack)
  ;; this procedure calculates amplitude based on the index
  ;; into the vector of integers representing the audio data.
  ;; the sample-rate is used because it is the rate in which
  ;; audio data is read and affects how fast the amplitude should
  ;; rise to avoid clipping or other abnormalities. attack
  ;; is a setting that is adjusted to give the effect of a
  ;; slowly or quickly rising amplitude.
  (* t (attack-factor sample-rate attack)))

(define (num-of-samples sample-rate dur-of-note)
  ;; how many samples there are for this tone
  (* sample-rate dur-of-note))

(define (calc-decayed-amplitude vec-index
                                sample-rate
                                attack-setting
                                duration-of-note
                                decay-factor)

  ;; this procedure is used to calculate the amplitude a wave should be at a given index.
  ;; vec-index approaches the value returned by num-of-samples resulting in the base of the
  ;; exponent to be 0. The decay factor that is set causes the resulting value to approach 0
  ;; more quickly!
  (expt (- 1
           (/ vec-index
             (num-of-samples sample-rate
                             duration-of-note)))
        decay-factor))

(define (calculate-amplitude vec-index
                             attack-setting
                             sample-rate
                             duration-of-note
                             decay-factor)

  ;; note will raise amplitude to a certain point and then tone's amplitude gradually lowers.
  (cond ((<= vec-index (peak-amplitude-pos attack-setting sample-rate)) (amplitude vec-index
                                                                                   sample-rate
                                                                                   attack-setting))
        (else (calc-decayed-amplitude vec-index
                                      sample-rate
                                      attack-setting
                                      duration-of-note
                                      decay-factor))))


