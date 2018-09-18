(
// Start proxyspace
p = ProxySpace.push(s);

// Clap your hands and/or whistle
~testsignal = {|amp=2| SoundIn.ar() * amp};

// Trace the amplitude and the RMS value of the signal
~amp = { Amplitude.ar(~testsignal)};
~rms = {|lpf=10| RMS.ar(~testsignal, lpf)};

// Detection - these all return 1 if true and 0 if false
~rmscrossing = {|thresh=0.23| (~rms > thresh)};
~ampcrossing = {|thresh=0.25| (~amp > thresh)};

~silence = { DetectSilence.ar(~testsignal)};

// Pitch
~pitch = {Tartini.kr(~testsignal)[0]};

// Use the machine listening to trigger an envelope
~env = {|a=0.5, r=2, c=10, scale=1| EnvGen.kr(Env.perc(a,r,c), timeScale: scale, gate: ~rmscrossing)};
~env.map(\scale, ~rms);

// An fm synth to test it out with
~fm = {|freq=444, fmi=1.32512, rms, amp, env| 
    SinOsc.ar(freq * SinOsc.ar(freq * rms * 2.1612 * fmi * env.lag(amp)))!2 * 0.1 * env
};

// Map the nodeproxy busses to the synth arguments
~fm.map(\freq, ~pitch);
~fm.map(\fmi, ~rms);
~fm.map(\rms, ~rms);
~fm.map(\amp, ~amp);
~fm.map(\env, ~env);

~fm.play;
)


