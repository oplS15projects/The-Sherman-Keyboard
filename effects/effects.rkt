
#lang racket

(provide calculate-amplitude)

(define (calc-decay-factor fundamental-freq
                            max-vol
                            sample-rate)

  ;; this procedure is used to calculate how fast a note should die out
  (expt (* .5
           (log (/
                 (* fundamental-freq
                    max-vol)
                 sample-rate)))
        2))

(define (calc-decayed-amplitude vec-index
                        max-vol
                        sample-rate
                        attack-setting
                        duration-of-note
                        decay-factor)

  ;; this procedure is used to calculate the amplitude a wave should be at a given index.
  (expt (- 1
           (/ (- vec-index
                 (* sample-rate
                    attack-setting))
              (* sample-rate
                 (- duration-of-note
                    attack-setting))))
        decay-factor))

(define (calculate-amplitude vec-index
                             attack-setting
                             sample-rate
                             max-vol
                             duration-of-note
                             fundamental-freq)

  (cond ((<= vec-index
             (* attack-setting
                sample-rate)) (/ vec-index
                                 (* sample-rate
                                    attack-setting)))
        (else (calc-decayed-amplitude vec-index
                                      max-vol
                                      sample-rate
                                      attack-setting
                                      duration-of-note
                                      (calc-decay-factor fundamental-freq
                                                          max-vol
                                                          sample-rate)))))


