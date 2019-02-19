/*##########################################################################################################*/
// granular live input

Buffer.alloc(s, s.sampleRate * 2, 1, bufnum:10);
(
SynthDef(\grains4,{
		arg out = 0, bufNum = 10, amp = 0.1, interp = 4, wet=1;

		var input, grains, output, trig, pos, bufDur, bufDurSection, posDif;
		var rate, posLo=0, posHi=1, granDur, posRate=0.01, pan =0;

		input=HPF.ar(SoundIn.ar(0), 100);
		bufDur = BufDur.kr(bufNum);
		trig = DigitalIn.ar(0);
		posLo = AnalogIn.ar(0).range(0,1.0);
		posHi = AnalogIn.ar(1).range(0,1.0);
		rate = AnalogIn.ar(2).range(-1,2.0);
		granDur = AnalogIn.ar(3).range(0.001,2.0);
		posDif = posHi - posLo;
		bufDurSection = bufDur * posDif;
		pos = posLo * bufDur + (Phasor.ar(0, BufRateScale.kr(bufNum) * posRate / SampleRate.ir, posLo * bufDur, posHi * bufDur) ).mod(bufDurSection);
		BufWr.ar(input, bufNum, Phasor.ar(0, BufRateScale.kr(bufNum), 0, BufFrames.kr(bufNum)), 1);
		grains = TGrains.ar(2, trig, bufNum, rate, pos, granDur, pan, amp, interp);
		output = (input * (1 - (wet))) + (grains * (wet));

		DigitalOut.ar(2,trig);//First digital output
		AnalogOut.ar(0, rate.range(0,1.0));
		Out.ar(out, output);
}).add
);

s.sendMsg(\s_new, "grains4", 1010);
Buffer.alloc(s, s.sampleRate * 4, 1, bufnum:10);
Buffer.alloc(s, s.sampleRate * 2, 1, bufnum:10);
Buffer.alloc(s, s.sampleRate * 0.5, 1, bufnum:10);