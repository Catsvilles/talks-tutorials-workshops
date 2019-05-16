( 
    // Server messages to a VSTPlugin UGen in the format: '/u_cmd', nodeID, index, VSTPlugin cmd ... args
    ~vstMsg = { arg ctl, cmd ... args; ['/u_cmd', ctl.synth.nodeID, ctl.synthIndex, cmd] ++  args };

    ~score = Score.new;

    SynthDef.new(\vstsynth, {|out=0|
        var sig = Dust.ar(10);
        sig = VSTPlugin.ar(sig,  numOut: 1);
        Out.ar(out, sig);
    }).load(s);

    // first create the synth and controller in the language:
    ~fx = VSTPluginController(Synth(\vstsynth));

    // OSC messages:
    ~score.add([0.0, ~fx.synth.newMsg]); // create the synth
    ~score.add([1.0, ~vstMsg.(~fx, '/open', "/Library/Audio/Plug-Ins/VST/FabFilter Pro-R.vst")]); // open a plugin
    ~score.add([2.0, ~vstMsg.(~fx, '/set', 1, 0.5, 2, 0.75)]); // after 1 beat, set param 1 to 0.5 and 2 to 0.75

    ~score.add([16, [0]]);

    ~score.recordNRT("/tmp/trashme", "~/test.aiff".standardizePath, options: ServerOptions.new.numOutputBusChannels_(1));

    // also save the Score to a file
    ~score.saveToFile("~/test.sc".standardizePath);
)
