( 
    SynthDef(\insert, { arg bus;
    ReplaceOut.ar(bus, VSTPlugin.ar(In.ar(bus, 2), 2));  
}).add;
)

// Search system for vsts
VSTPlugin.search();

VSTPlugins.plugins();

// Make a synth which will be used to hold a vst
~synth = Synth.after(1, \insert, [\bus, 0]);

s.plotTree

// get a handle to the VSTPlugin:
~fx = VSTPluginController(~synth);

// open a plugin:
~fx.open("FabFilter Pro-R", info: true);

// show the GUI:
~fx.gui;

// Play a sound
( 
Ndef(\soundsource,{
    var sig = VarSaw.ar(MouseX.kr(45,800), 0, SinOsc.kr(0.01).abs + 0.5, 0.125);

    Pan2.ar(sig, LFNoise2.kr(1));
}).play;

)



// ------------ ------- ------- ------- -------







// Set first parameter to something else
~fx.set(1, 0.15)

// Make some lfos to modulate some parameters
Ndef(\lfo1, {LFSaw.kr(0.1*SinOsc.kr(0.15))});
Ndef(\lfo2, {LFCub.kr(0.31)});
Ndef(\lfo3, {LFPar.kr(Ndef(\lfo1))});
Ndef(\lfo4, {LFPar.kr(Ndef(\lfo3) + Ndef(\lfo1))});

Ndef(\mousey, {MouseY.kr});

// Add lfos some of the parameters
~fx.map(0, Ndef(\lfo1));
~fx.map(5, Ndef(\lfo2));
~fx.map(4, Ndef(\lfo3));
~fx.map(7, Ndef(\lfo4));
~fx.map(2, Ndef(\mousey));

~fx.set(0, 0.15)
