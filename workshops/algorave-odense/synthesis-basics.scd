/*

    SYNTHESIS BASICS

    By Mads Kjeldgaard

    @ Workshop at Algorave Odense, october 2018

*/

// Start the sound server
s.boot;

// Let's live code this
p = ProxySpace.push(s);

// Let's put our signal into this variable
~signal.play;

// If you're only hearing sound in one ear
~signal.mold(2);

/*

SINE WAVE: THE SIMPLEST WAVEFORM, NO HARMONICS

The exclamation mark is a way to create multiple copies of a ~signal (in this
case 2 to make a stereo ~signal)

*/
~signal.play;

~signal = { SinOsc.ar(freq: 200)!2 }; 

/*

SCHWEBUNG / SVÆVNINGER / BEATING

Two sine waves at almost the same frequency. 

The "beating" happens at a frequency of the difference between the two ( 200-199=1hz )

the .sum method mixes the two ~signals together to make the effect more obvious

*/
~signal.play;

~signal = { SinOsc.ar(freq: [200, 199]).sum!2 }; // Try changing the two frequency parameters and hear the change in the beating frequency

/*

FREQUENCY MODULATION

The matryoshka doll of sound synthesis:

A sine wave with a (or several) sine wave(s) manipulating eachother's
frequencies.

*/

~signal.play;

// A sine wave in a sine wave
~signal = { SinOsc.ar(freq: 500 * SinOsc.ar(freq: 149) )!2 }; 

// Let's make this more interactive, let's use the mouse's x position to change
// the frequency of the modulator (from 100 to 2000 hz)
~signal = { SinOsc.ar(freq: 500 * SinOsc.ar(freq: MouseX.kr(100, 2000)) )!2 }; 

// A sine wave in a sine wave in a sine wave 
~signal = { SinOsc.ar(freq: 500 * SinOsc.ar(freq: MouseX.kr(100, 2000) * SinOsc.ar(freq: 118) ) )!2 }; 

// A sine wave in a sine wave in a sine wave in a sine wave
~signal = { SinOsc.ar(freq: 500 * SinOsc.ar(freq: MouseX.kr(100, 2000) * SinOsc.ar(freq: 318 * SinOsc.ar(freq: 46))))!2 }; 

// A sine wave in a sine wave in a sine wave in a sine wave in a sine wave
~signal = { SinOsc.ar(freq: 500 * SinOsc.ar(freq: MouseX.kr(100, 2000) * SinOsc.ar(freq: 118 * SinOsc.ar(freq: 76 * SinOsc.ar(918)))))!2 }; 

// A sine wave in a sine wave in a sine wave in a sine wave in a sine wave in a sine wave
~signal = { SinOsc.ar(freq: 500 * SinOsc.ar(freq: MouseX.kr(100, 2000) * SinOsc.ar(freq: 118 * SinOsc.ar(freq: 76 * SinOsc.ar(918 * SinOsc.ar(5))))))!2 }; 

// Experiment with the different frequency parameters to find fun sweet spots 

/*

AMPLITUDE MODULATION

Modulating the amplitude of sine waves (instead of the frequency)  

Sounds similar to FM 

*/
~signal.play;

// A sine wave against a sine wave
// Let's put the Y position of the mouse to use here as well
~signal = { SinOsc.ar(freq: MouseY.kr(100, 2000) ) * SinOsc.ar(freq: MouseX.kr(100, 2000))!2 }; 

// A sine wave against a sine wave against a sine wave
~signal = { SinOsc.ar(freq: MouseY.kr(100, 2000)) * SinOsc.ar(freq: MouseX.kr(100, 2000)) * SinOsc.ar(freq: 118)!2 }; 

// A sine wave against a sine wave against a sine wave against a sine wave
~signal = { SinOsc.ar(freq: MouseY.kr(100, 2000)) * SinOsc.ar(freq: MouseX.kr(100, 2000)) * SinOsc.ar(freq: 118) * SinOsc.ar(freq: 76)!2 }; 

/*

ENVELOPES

*/

// A simple percussive envelope 
// triggered by the mouse crossing the center of it's Y axis
~envelope = {EnvGen.kr(Env.perc(attackTime: 0.01, releaseTime: 0.5), gate: MouseY.kr > 0.5)};

// If you want to look at the envelope signal
~envelope.scope;

// Let's try using this in one of our FM synths from above
~signal.play;

// Here, the envelope controls the amplitude of the signal. 
~signal = { ~envelope * SinOsc.ar(freq: 500 * SinOsc.ar(freq: MouseX.kr(100, 2000) * SinOsc.ar(freq: 666) ) )!2 }; 

// Why not try it on one of the modulating oscillators as well?
~signal = { ~envelope * SinOsc.ar(freq: 500 * SinOsc.ar(freq: MouseX.kr(100, 2000) * SinOsc.ar(freq: 666 * ~envelope) ) )!2 }; 

// Let's modulate the envelope's release time with the mouse as well
~envelope = {EnvGen.kr(Env.perc(attackTime: 0.01, releaseTime: MouseX.kr(0.1)), gate: MouseY.kr > 0.5)};

/*

SIMPLE DRUM SYNTHESIS USING SINE WAVES

*/

// Let's make a simple 808 kick drum using this method!
~kick.play;

~kick = { ~envelope * SinOsc.ar(freq: 50 + ( 180 * ~envelope ) ) !2 }; 

// Using the mouse to gate the drums becomes tiresome, let's get a uGen to do the work for us: 
// Dust = random triggering, Impulse = non random
~envelope = {EnvGen.kr(Env.perc(attackTime: 0.01, releaseTime: MouseX.kr(0.9)), gate: Dust.kr(1))}; // Try changing Dust.kr to Impulse.kr

// Let's add a gabber cowbell!!! 
~gabbercowbell.play;

// First an envelope
~gabbercowbell = { 0.075 * ~envelope * SinOsc.ar(freq: 4766 * SinOsc.ar(freq: ~envelope * 1122 ) )!2 }; 

// Nice and weird!

// Let's control the trigger rate of the envelope with the mouse
~envelope = {EnvGen.kr(Env.perc(attackTime: 0.01, releaseTime: MouseX.kr(0.9)), gate: Dust.kr(MouseX.kr(10)))} 

/*

OTHER WAVEFORMS

*/

~signal.play;

// Saw wave, both even and odd harmonics / overtones, resulting in a harsh sound
~signal = {Saw.ar(110)*0.1!2};

// Useful for subtractive synthesis (using filters to subtract harmonics)
~signal = {RLPF.ar(in: Saw.ar(110)*0.1, freq: MouseX.kr(100, 2000), rq: MouseY.kr(0.01, 1))!2 };

// The same but with a square wave, a waveform with odd harmonics
~signal = {RLPF.ar(in: Pulse.ar(110)*0.1, freq: MouseX.kr(100, 2000), rq: MouseY.kr(0.01, 1))!2 };


