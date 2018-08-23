(
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
