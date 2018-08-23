/*

LFO TO PBIND

Example: Three ways of controlling Pbind parameters with LFO's 


Be careful when using this on the \dur parameter though. If it crosses or
equals zero, things go apeshit so make sure it doesn't do that.

*/

// 1. 
(

    // Here's one way of controlling patterns using LFO's/synths

    // Make a bus to funnel the lfo's output into the pattern
    var lfo1 = Bus.control(s,1);
    var lfo2 = Bus.control(s,1);

    // Make a sinewave, outputting to lfo1
    {Out.kr(lfo1, SinOsc.kr(0.5) )}.play;

    // Make saw wave, outputting to lfo2
    // Note that all scaling has to happen inside this synth, you can't do it in
    // the pbind, unfortunately
    {Out.kr(lfo2, Saw.kr(5.1, 100, 500) )}.play;

    Pbind(
        \freq, lfo2.asMap,
        \amp, lfo1.asMap, // note you have to use the .asMap method
        \dur, 0.25
    ).play;

)

// 2. ProxySpace example. Pretty flexible 

// This works like plugging a midi controller into each synth, making the lfo
// sound smooth between note events and being able to keep changing once the
// note event has started
(

    // Start ProxySpace to allow live coding
    p = ProxySpace.push(s);

    // This will automatically create a bus and map it accordingly in the Pbind
    // Try changing each node proxy and listen to the pattern change
    // You still have to do all operations to the lfo's data inside of the
    // nodeproxies
    ~lfo1 = {SinOsc.kr(0.1)};
    ~lfo2 = {Saw.kr(11.1, 500, 100)};

    ~pattern = Pbind(
        \freq, ~lfo2,
        \amp, ~lfo1, 
        \dur, 0.25
    ).play;
    
)

// 3. Even more flexible: ProxySpace + BenoitLib

// Using the Pkr pattern from BenoitLib. Download it and install from here: https://github.com/cappelnord/BenoitLib
// This method is great if you want to be able to do binary operations inside of
// the patterns

// This works a bit like a sample and hold, sampling the lfo at each note event 
(

    // Start ProxySpace to allow live coding
    p = ProxySpace.push(s);

    // This will automatically create a bus and map it accordingly in the Pbind
    // Try changing each node proxy and listen to the pattern change
    ~lfo1 = {SinOsc.kr(0.1)};
    ~lfo2 = {Saw.kr(111.1, 100, 100)};

    ~pattern = Pbind(
        \freq, Pkr(~lfo2) * 10, // Now you can do binary operations inside of the Pbind making Pkr quite flexible
        \amp, Pkr(~lfo1), 
        \dur, 0.125 + (Pkr(~lfo1)/10)
    ).play;
)
