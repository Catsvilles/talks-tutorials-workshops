/*

record-an-nodeproxy.scd
2019-05-19
By: Mads Kjeldgaard, mail@madskjeldgaard.dk

*/

// Install the JITLibExtensions quark if you haven't already
Quarks.install("JITLibExtensions");

// A node proxy that makes sound
( 
    Ndef(\boringSineWave, {
        SinOsc.ar([110,111])
    }).play;
)

// Make a 2 channel recorder from the Ndef above
r = RecNodeProxy.newFrom(Ndef(\boringSineWave), numChannels: 2);

// Record to your home directory
r.open("~/hello.wav".asAbsolutePath);

// Record
r.record(paused: false);

// Stop recording
r.pause;

// Close the file
r.close;
