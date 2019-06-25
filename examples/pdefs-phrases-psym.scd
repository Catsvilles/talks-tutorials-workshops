/*

Segments / phrases using Pdef and Psym

*/

// Phrases
Pdef(\a, Pbind(\degree, Pwhite(0,10), \dur, Pn(0.25, 10)));
Pdef(\b, Pbind(\degree, Pseq([0,3,0,2,5,6],1), \dur, 0.1));
Pdef(\c, Pbind(\degree, Pxrand([0,3,0,2,5,6],10), \dur, 0.125));

// Composition
Pdefn(\segments, Pseq("abcabacab"));
Pdef(\composition, Psym(Pdefn(\segments))).play;
