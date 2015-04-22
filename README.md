# The-Sherman-Keyboard

# keyboard.rkt
Running this file will produce the synth's GUI, which is now able to play tones created through portaudio. You can 
use either the mouse or the keyboard to play the synth. Bindings for the keyboard match up to the "default" position 
on the keyboard (a - f keys for the left half of the keyboard, j - ; for the right half). It also now has a volume
slider and an attack slider built in.

# effect-runner.rkt
This file is an example of the how to use the effects in the the effects folder.

# buttons.rkt
This file contains the definitions for the volume slider, the attack slider, and the currently unimplemented decay
slider.

# effects.rkt and note-generator.rkt
These files are used to define how the notes themselves are actually created.

# additivesynth.rkt
This file provides a method for generating audio data for all of the fundamental frequencies in the provided range (one octave) with a single procedure call. This procedure (GenerateAudio) takes as its one argument a hash table that contains all of the properties defining some timbre that will be used to generated audio. 
