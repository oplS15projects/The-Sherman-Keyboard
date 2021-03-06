# The-Sherman-Keyboard

### Website : [The Sherman Keyboard](http://opls15projects.github.io/The-Sherman-Keyboard/)

<img src=https://raw.githubusercontent.com/oplS15projects/The-Sherman-Keyboard/master/screenshot.png>

##Authors
**Stuart Tomkins**

**Kevin Wacome**

**Eamon Lightning**

##Overview
The emulation of instruments via audio signal processing is a challenging task and racket provides the tools for
generating and manipulating simple sine waves through several different libraries. The Sherman Keyboard is a synthesizer that gives the user the ability to program their own complex sounds by adjusting different settings built into the UI as well use pre-configured settings.

##Concepts Demonstrated
 **Object Oriented Programming**: Inheritance is used in creating the different elements of the GUI.
 
 **Data Abstraction**: Abstractions away from the core synth driver (additive-synth.rkt) by the effects processor allows for easy to generate complex sound waves through the GUI.
 
 **Data mutability** and **local state**: Used to store musical notes within hash tables in local frames to keep them persistent in memory.

##External Technology and Libraries

[portaudio](http://pkg-build.racket-lang.org/doc/portaudio/index.html): Used to play stored audio data via the **s16vec-play** procedure. 

[ffi/vector](http://docs.racket-lang.org/foreign/homogeneous-vectors.html): Used to create sound samples by storing audio data into 16 bit integer arrays. **make-s16vector** is used to create the arrays and various provided procedures are used to fill and access their contents.

[racket/gui](http://docs.racket-lang.org/gui/index.html?q=racket%20gui): Used to create the various elements of the GUI.

##Favorite Lines of Code

####Stu:
These lines of code are the event handling when the user left clicks a key. When the determine-note-on-click
procedure is called, it determines what key is pressed on the synth based on the pixel position of the mouse.
```
    (define/override (on-event event)
      (when (send event button-down? 'left)
        (determine-note-on-click event)))
```

####Kevin:
This procedure uses the concepts of **assignment** and **local state** to initialize a hash table with musical tones. The procedure *create-note-hash* creates a computational object with time-varying state. When *create-note-hash* is execute a hash object, provided by racket, is created within a local frame within the global environment. The procedure init is defined and then a lambda procedure is returned. The lambda procedure has access to the the procedure *init* and also access to the hash table that was generated. The procedure *init* uses **tail recursion** to fill a hash table by using a list various musical tones. The user can then send **symbolic data** to execute specific operations on the note-hash created. This allows for **abstraction** away from how the notes in hash are created and played.

```
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
          (init (cdr freqs) timbre
                            attack
                            max-volume
                            num-of-harmonics
                            decay-factor))))

  (lambda (cmd)
    (cond ((eq? cmd 'init) init)
          ((eq? cmd 'play) (lambda (pitch) (hash-ref note-hash pitch))))))
```

####Eamon:

This little snippet of code is the heart of the audio generation process. Individual sine waves with different frequencies, amplitudes, and phase offsets are generated and added to an audio vector. When the audio vector is played, these individual sine waves are played simultaneously creating the effect of additive synthesis. 

```

  (define sample1 (real->s16 (* a1 a (sin (+ (* tpisr t (* fundamentalFreq k1)) phase1)))))
  (define sample2 (real->s16 (* a2 a (sin (+ (* tpisr t (* fundamentalFreq k2)) phase2)))))
  (define sample3 (real->s16 (* a3 a (sin (+ (* tpisr t (* fundamentalFreq k3)) phase3)))))
  (define sample4 (real->s16 (* a4 a (sin (+ (* tpisr t (* fundamentalFreq k4)) phase4)))))
  (s16vector-set! vec (* 4 t) sample1)
  (s16vector-set! vec (+ 1 (* 4 t)) sample2)
  (s16vector-set! vec (+ 2 (* 4 t)) sample3)
  (s16vector-set! vec (+ 3 (* 4 t)) sample4))
     
```

#How to Run

Install [Racket](http://racket-lang.org/)

Download .zip or .tar.gz file for this project from [here](http://opls15projects.github.io/The-Sherman-Keyboard/).

####If .zip was downloaded:
```
unzip <file-name>.zip
```

####If .tar.gz was downloaded:
```
tar -xvzf <file-name>.tar.gz
```

####Enter the newly unpacked directory:
```
cd <unpacked directory>
```

####Load main.rkt with drracket:
```
drracket main.rkt 
```

Once drracket has loaded, select run and the interactive GUI should load. drracket should install any dependencies needed by the project.

#How To Play!

To play tones either click on the keys or press the corresponding key binding on your keyboard. You can even press keys simultaneously to play chords.

The Sherman Keyboard offers the user the ability to adjust several settings.

#####sliders:
    volume: How loud the tone played is. The higher the setting the louder.
  
    attack: How rapidly the tone reaches max volume. High attack will sound more like an organ.
     
    decay: How quickly the note is cutoff. The higher the decay the longer the note persists.

#####presets:
  
    Select from a list of preset tone options. The custom preset allows users to create their own tones using the k2 through k4 and a2 through a4 input fields. 
    
#####harmonic settings:
  
    When custom is selected in the preset box, the user can enter their own custom tones.
    
    The input fields k2 through k4 allow the user to set the frequency of the harmonics relative to the fundamental tone.
    
    The input fields a2 through a4 allow the user to adjust how loud the harmonics are.
    
#Evaluation of Results

"By the end of this project we will have a working synthesizer that produces complex sounds using sine waves. We will implement a number of features available for the user to interact with that will alter the sounds produced by the synthesizer."

We were able to implement several different options that the user can adjust to create interesting complex sine waves. The interface, based on feedback from the demonstration, seemed fairly intuitive to newcomers. We did not get to implement all of things we had hoped to such as additional sound effects and dynamic envelopes.
