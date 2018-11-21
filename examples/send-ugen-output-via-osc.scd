/************************************ 

    Sending UGEN output via OSC 

*************************************/

// Boot the server
s.boot;

(
// The destination
n = NetAddr("127.0.0.1", 7891);

// A control bus to hold the value of the lfo
b = Bus.control(s, 1);

// Play a sine wave lfo outputting it's value to the control bus above
play{ 
    Out.kr(b, SinOsc.kr(1)) 
};

// A looping process that gets the current value of the bus and sends it to the
// destination address
fork{
    loop{
        var updateRate = 0.01;
        b.get{|v| n.sendBundle(0, ["/yo", v]) };
        updateRate.wait;
    }
};
)
