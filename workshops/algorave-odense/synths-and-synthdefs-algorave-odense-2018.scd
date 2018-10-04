s.boot;

/*

SYNTH

A synth in SuperCollider is a crossbreed between a note and an instrument and a timebomb.

When it is played, it makes a sound (like a note).

The sound is then created and played according to a sort of sound recipe called the UGEN graph.

Then, more often than not, when the synth is done playing it's note it will self immulate.

Except, when we're done playing the Synth, we destroy it (and don't waste any computer resources on it when we don't need it to play)!

As we will see, this is a really convenient way of organizing sound producing code into a sort of library that we can easily call and make noise.

*/

z = Synth('default'); // Play the default synth (a "piano" sound)

z.free; // Let's destroy this horrible thing

/*

SYNTHDEF (808)

Okay, so let's start making some recipes for some more ravey sounds.

One of the most popular sounds in rave music is the Roland 808 drum synthesizer.

It has a very distinct, deep sound that is actually quite easy to recreate so let's start there.

*/

(
SynthDef('808kick', {

	// ARGUMENTS
	arg dur=1, // How long is this sound supposed to be alive? This sets the default to 1 beat
	freq=40, // What frequency, default is 80 hz
	amp=1, // Sets the volume
	pan=0,
	out=0; // Choose an output (default is directly to your speakers/headphones)

	// A basic percussive envelope
	// If you want to see what this looks like, evaluate the following code: Env.perc.plot
	var env = EnvGen.kr(Env.perc, timeScale: dur, doneAction: 2);

	// Let's use our envelope to create a downwards pitch slide which is what
	// gives the 808 kick it's sound
	var pitchSlide = 2 * freq * env;

	// Create the sound, using a sine wave
	var sig = SinOsc.ar(freq + pitchSlide);

	// Pan the signal. This also converts it from a mono to a stereo signal
	sig = Pan2.ar(sig, pan);

	// Adjust the volume by multiplying with the amp argument and then the contour using the envelope
	sig = sig * amp * env;

	// Output the sound. the !2
	Out.ar(out, sig);

}).add;
)

// Test it out .... Boooooooom
Synth('808kick');

// The same synthdef can be used to make a sort of congas sound by supplying it
// with different argument values for frequency and duration
Synth('808kick', [\freq, 880, \dur, 0.125]); // Hi congas
Synth('808kick', [\freq, 660, \dur, 0.25]); // Mid congas
Synth('808kick', [\freq, 440, \dur, 0.33]); // Lo congas

// By copy-pasting most of our 808 kick drum recipe we can quite easily make a new recipe for a snare drum as well
(
SynthDef('electrosnare', {

	// ARGUMENTS
	arg dur=0.5,
	freq=50,
	amp=1,
	out=0;

	// A basic percussive envelope
	var env = EnvGen.kr(Env.perc, timeScale: dur, doneAction: 2);

	var pitchSlide = 2*freq * env;

	// Here's where it gets different: We add some band pass filtered noise to the signal
	var sig = BPF.ar(WhiteNoise.ar, freq*4, 2);

	sig = amp * sig * env * 0.5;

	Out.ar(out, sig!2);

}).add;
)

// Test out the snare sound
Synth('electrosnare');

(
// Let's make a terrible electro beat out of all of this.
var tempo = 1.25;
var clock = TempoClock.new(tempo);

// Play the snare on every second beat
Pbind(\instrument, 'electrosnare', \freq, 400, \dur, Pseq([Rest(1.0), 1.0],inf)).play(clock, quant: 1/64);

// Reuse the snare to create a kind of hihat
Pbind(\instrument, 'electrosnare', \freq, 1000, \dur, Pseq([Rest(1/4), 1/4],inf) ).play(clock, quant: 1/64);

// Play the kick on every half note beat
Pbind(\instrument, '808kick', \freq, 40, \dur, 1/2, \amp, 1 ).play(clock, quant: 1/64);

// Reuse the kick for a probability based conga rhythm
Pbind(\instrument, '808kick', \freq, Pwrand([200, 300, 400], [0.25, 0.25, 0.5], inf), \dur, Pwrand([1/2, Rest(1), 1/4], [0.25, 0.25, 0.5], inf), \pan, Pwhite(-1.0, 1.0, inf), \amp, 0.1 ).play(clock, quant: 1/64);

)

/*

More drum synthesis inspiration can be found here:

*/

"https://sccode.org/1-54H".openOS;
"https://sccode.org/1-523".openOS;
"https://github.com/supercollider/supercollider/blob/develop/examples/demonstrations/DrumSynths.scd".openOS;