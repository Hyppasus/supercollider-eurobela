// RECORDING

//On the bela board
Server.default.recHeaderFormat_("wav").recChannels_(2);
s.prepareForRecord("/root/Bela/sounds/test1.wav".standardizePath);//asuming the folder sounds exists under the direcotry Bela
s.record;
s.stopRecording;

//RecordBuf

b = Buffer.alloc(s, s.sampleRate * 4.0, 1); // a four second 1 channel Buffer
// record for four seconds
(
SynthDef(\rec, { arg out = 0, bufnum = 0;
    var source, sig, env;
    env = Line.kr(0.001,1.0, 4);
	//source = AnalogOut.ar(0,DC.ar(0.0)*env);
	sig = SoundIn.ar(0);
	//sig = AnalogIn.ar(0);
	RecordBuf.ar(sig, bufnum, doneAction: 2, loop: 0);
}).play(s,[\out, 0, \bufnum, b]);
);

b.write ("/root/Bela/sounds/test2.wav", headerFormat: "wav", sampleFormat: "int24", numFrames: -1, startFrame: 0, leaveOpen: false);


b = Buffer.alloc(s, s.sampleRate * 10.0, 1); // a four second 1 channel Buffer
// record for four seconds
(
SynthDef(\rec, { arg out = 0, bufnum = 0;
    var source, sig, env;
	    sig = SoundIn.ar(2);
    env = XLine.kr(0,10000, 10);
	RecordBuf.ar(sig, bufnum, doneAction: 2, loop: 0);
}).play(s,[\out, 0, \bufnum, b]);
);

b.write ("/root/Bela/sounds/test3.wav", headerFormat: "wav", sampleFormat: "int24", numFrames: -1, startFrame: 0, leaveOpen: false);