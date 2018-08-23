/*

EXAMPLE: SEND OSC FROM SUPERCOLLIDER PATTERNS

Here's a way to send all of the data from a Pbind to some external source via
OSC (other software within your computer – like Unity, Processing, Max/MSP, 
PureData or whatever – or somewhere on the network)

*/
(
    // The OSC data is sent to this address and port. 127.0.0.1 is your
    // computer's internal address
    var osc = NetAddr("127.0.0.1", 7000);

    // This is the base of the message sent elsewhere. It's used to filter the
    // osc packets from other osc packets in the receiving program 
    var baseMessage = "/supercollider/";

    // Function to be used within Pbind. 
    // Pfunc gets all of the patterns event data as it's argument
    // We iterate over all that data and gather it in one array
    // Then send that array to the osc address on every event/note
    var oscTransmitter = 
        Pfunc({|ev| 

            // First part of our osc array has to be the basemessage
            // And if the pattern has been supplied with an id key, it will be used
            // as well
            var oscArray = [baseMessage ++ (ev.id ?? '') ];

            // Now put all of the data from the enclosing Pbind's event into the
            // oscArray
            ev.keysValuesDo{|k,v| 
                // Filter out the 'destination' and 'id' keys
                (k != 'destination' and: {k != 'id'}).if{
                    oscArray = oscArray ++ k ++ [v]; // Brackets necessary in case value is a string
                }
            };
                
            // And send
            osc.sendBundle(~latency, oscArray)
            }
        );

    // This is the boring pattern being played
    
    // When the oscTransmitter function is in the \send key, you will be able to
    // hear sound from the pattern

    // NO SOUND
    // Overwriting the \play key with our oscTransmitter will disable the pattern's sound functionality     
    // This may be useful in some cases
    Pbind(
        \text, Pseq(["hey", "ho", "lets", "go"],inf),
        \dur, 0.5, 
        \destination, osc,
        \id, 'silentPattern',
        \play, oscTransmitter 
    ).play;

    // SOUND
    // Putting the oscTransmitter in a custom key won't mess with the patterns
    // sound functionality
    Pbind(
        \degree, Pseq((1..7),inf),
        \dur, Pseq((1..4)/3,inf),
        \destination, osc,
        \id, 'boringPiano',
        \send, oscTransmitter 
    ).play;
)
