/*##########################################################################################################*/
// granular live input

s = Server.default;

s.options.numAnalogInChannels = 4;
s.options.numAnalogOutChannels = 4;
s.options.numDigitalChannels = 16;
s.options.maxLogins = 64;
s.options.sampleRate = 44100;

s.options.pgaGainLeft = 0;     // sets the pga gain of the left channel to 0 dB
s.options.pgaGainRight = 0;    // sets the pga gain of the right channel to 0 dB
s.options.headphoneLevel = 0; // sets the headphone level to 0 dB
s.options.speakerMuted = 1;    // the speakers are muted
s.options.dacLevel = 0;       // sets the gain of the dac to 0 dB
s.options.adcLevel = 0;       // sets the gain of the adc to 0 dB
s.options.numMultiplexChannels = 0; // do not enable multiplexer channels
s.options.belaPRU = 0;         // select the PRU on which Bela audio will run

s.options.blockSize = 16;
s.options.numInputBusChannels = 2;
s.options.numOutputBusChannels = 2;

(
s.waitForBoot({

Buffer.alloc(s, s.sampleRate * 1, 1, bufnum:10);

	s.sync;

SynthDef(\grains4,{
		arg out = 0, bufNum = 10, amp = 1, interp = 4, wet=1, density=10;

		var input, grains, output, trig, pos, bufDur, bufDurSection, posDif, recLoop=1;
		var rate, posLo=0, posHi=1, granDur, posRate=0.01, pan =0;
		var analog1, analog2, analog3, analog4;

		bufDur = BufDur.kr(bufNum);
		input=HPF.ar(SoundIn.ar(0), 80);

		analog1 = AnalogIn.ar(0).linlin(0.23,0.99,0.0,1.0);
		analog2 = AnalogIn.ar(1).linlin(0.23,0.99,0.0,1.0);
		analog3 = AnalogIn.ar(2).linlin(0.23,0.99,0.0,1.0);
		analog4 = AnalogIn.ar(3).linlin(0.23,0.99,0.001,1.0);

		recLoop = DigitalIn.ar(0);
		//trig = DigitalIn.ar(0);
		trig = Impulse.ar(analog1.linlin(0,1,1,80));
		//posLo = analog2.linlin(0,1,0,0.5);
		//posHi = analog2.linlin(0,1,1,0.5);
		rate = analog3.linlin(0,1,-2,2);
		granDur = analog4;

		//trig = Impulse.ar(density);
		//posLo = 0.17;
		//posHi = 0.27;
		//rate = 1;
		//granDur = 0.1;

		posDif = posHi - posLo;
		bufDurSection = bufDur * posDif;

		pos = posLo * bufDur + (Phasor.ar(0, BufRateScale.kr(bufNum) * posRate / SampleRate.ir, posLo * bufDur, posHi * bufDur) ).mod(bufDurSection);

		BufWr.ar(input, bufNum, Phasor.ar(0, BufRateScale.kr(bufNum)*recLoop, 0, BufFrames.kr(bufNum)), recLoop);
		grains = TGrains.ar(2, trig, bufNum, rate, pos, granDur, pan, amp, interp);
		output = (input * (1 - (wet))) + (grains * (wet));

		//[posLo, posHi].poll;
		DigitalOut.ar(2,trig);//First digital output
		AnalogOut.ar(0, rate.range(0,1.0));
		Out.ar(out, output);

}).play
});
);
/*
s.sendMsg(\s_new, "grains4", 1022, 1, 1);

s.sendMsg(\n_set, 1022, \wet, 1);
s.sendMsg(\n_set, 1022, \density, 100);
s.sendMsg(\n_set, 1022, \recLoop, 0);
s.sendMsg(\n_set, 1022, \recLoop, 1);


Buffer.alloc(s, s.sampleRate * 4, 1, bufnum:10);
Buffer.alloc(s, s.sampleRate * 2, 1, bufnum:10);
Buffer.alloc(s, s.sampleRate * 1, 1, bufnum:10);
Buffer.alloc(s, s.sampleRate * 0.5, 1, bufnum:10);
*/