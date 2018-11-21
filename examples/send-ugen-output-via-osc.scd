/************************************ 

Sending UGEN output via OSC 

This works by using the SendReply ugen and looping it's output back into an
OSCFunc. Thanks to Eirik for showing me this.

*************************************/

// Boot the server
s.boot;

// The destination
n = NetAddr("127.0.0.1", 7891);

(
var responder, 
    updateFreq=10; // Play with this to adjust the smoothness of the output

// Play a sine wave lfo outputting it's value to the control bus above
play{ 
    var sig = SinOsc.kr(1);
    SendReply.kr(Impulse.kr(updateFreq), '/1lfo/val', sig);
};

// Register a callback function that is called whenever our lfo sends it's
// output to it and then pass on the single value of the lfo to our osc
// destination 
responder = OSCFunc({|msg, time, addr, port|
    var val = msg[3];
    n.sendMsg("/yo", val);
}, '/1lfo/val');
)

/************************************ 

    Output from a multichannel graph 

*************************************/
(
var responder, updateFreq=10, numlfo = 10;

// Play a sine wave lfo outputting it's value to the control bus above
play{ 
    var sig = SinOsc.kr((1..numlfo));
    SendReply.kr(Impulse.kr(updateFreq), '/lfos/val', sig);
};

// Register a callback function that is called whenever our lfos send their 
// output to it and then pass on the array of values our osc destination 
responder = OSCFunc({|msg, time, addr, port|
    var val = msg[3..];
    n.sendMsg("/yo", *val);
}, '/lfos/val');
)
