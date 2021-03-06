/*#############################################################################################*/
// run scsynth on the Bela

"scsynth -u 57110 -i 2 -o 2 -z 16 -J 4 -K 4 -G 16 -Q 0 -X -0 -Y -0 -s 1 -x 0 -y 0 -g 0 -T 0"

/*#############################################################################################*/
// contorl scsynth on the bela from your local machine (Supercollider 3.10.2)
(
~startBela = {{
	Server.default = s = Server("belaServer", NetAddr("192.168.7.2", 57110)); //bela over usb
	0.1.wait;
	s.initTree;
	0.1.wait;
	s.startAliveThread;
	0.1.wait;
	CmdPeriod.add({s.freeAll});
	0.1.wait;
	Ndef.defaultServer=s;
	0.1.wait;
	s.defaultGroup.release;
	0.1.wait;
	s.statusWatcher.prFinalizeBoot;
	0.1.wait;
	s.sampleRate.postln;
	}.fork
}
);
~startBela.value;

//Set the output level
Server.default.volume_(-6);
Server.default.volume_(-9);
Server.default.volume_(-12);
Server.default.volume_(0);

/*#############################################################################################*/
// TESTS

//Basic Signal out test
{SinOsc.ar(1000)!2}.play;
{SinOsc.ar(100)!2}.play;
{SinOsc.ar(10000)!2}.play;
{SinOsc.ar(500, 0, Decay.ar(Impulse.ar(1),1))!2}.play;

// Audio outputs
{SinOsc.ar(1000,0,-20.dbamp)}.play(s,0);// free the sound with cmd+period
{SinOsc.ar(1000,0,-60.dbamp)}.play(s,0);// low volume? adjust your range
{SinOsc.ar(1000,0,-20.dbamp)}.play(s,1);// right channel
{SinOsc.ar([1200,1000],0,-20.dbamp)}.play(s);
{SinOsc.ar([1200,1000],0, 0.dbamp)}.play(s);// maximum amplitude
//more audio tests
{SinOsc.ar(1000, 0, Decay.ar(Impulse.ar(4),1,0.5))}.play;//easy to modify
{Pulse.ar(1000)!2}.play;
{Saw.ar(100)!2}.play;
{Saw.ar(Line.ar(10000,1,10,1,0,2))}.play;
{Mix.fill(20, {SinOsc.ar(100 + 1500.0.rand, [pi.rand,pi.rand], mul: 0.05)} ) }.play;// check cpu while adjusting the amount of sine oscillators or excecuting several times the same line

// Audio Inputs
{SoundIn.ar(0)}.play(s,0);//Connect and audio source to Audio In ch1
{SoundIn.ar(1)}.play(s,1);// Right channel
{SoundIn.ar([0,1])}.play;// Both channels at the same time
{SoundIn.ar(0).wrap}.play;// try an effect

/*#############################################################################################*/

//Analog Ins
{SinOsc.ar(AnalogIn.ar(0).range(200,1000),0,0.5)}.play;//use range to adjust the mapping from the incoming signal
{SinOsc.ar(AnalogIn.ar(0).range(100,1000),0,0.99)}.play;
{SinOsc.ar(AnalogIn.ar(0).expexp(0.23,0.99,100,1000),0,0.99)}.play;
{LFPulse.ar(AnalogIn.ar(0).expexp(0.23,0.99,100,1000),0,0.5)}.play;
{LFPulse.ar(AnalogIn.ar(0).expexp(0.23,0.99,100,1000),0,0.5,1,-0.5)}.play;//DC offset?
{LeakDC.ar( LFPulse.ar(AnalogIn.ar(0).expexp(0.23,0.99,100,1000),0,0.5),0.9999999)}.play;
{Saw.ar(AnalogIn.ar(0).expexp(0.23,0.99,100,1000))}.play;
{SinOsc.ar(AnalogIn.ar(1).range(200,2000))}.play;
{SinOsc.ar(AnalogIn.ar(2).range(200,2000))}.play;
{SinOsc.ar(AnalogIn.ar(3).range(200,20000))}.play;
{BlitB3.ar(AnalogIn.ar(0).expexp(0.23,0.99,1,10000))}.play;
{DPW3Tri.ar(AnalogIn.ar(0).expexp(0.23,0.99,1,10000))}.play;

{Out.ar(0,AnalogIn.ar(0,2,-1))}.play;//Audio can pass from the analog ins (not the same quality as the dedicated Audio Outs but worth to explore)
//Monitor the range. Read the values in the terminal when running scsynth from the command line
{AnalogIn.ar(0).poll;DC.ar(0)}.play;
{AnalogIn.ar(1).poll;DC.ar(0)}.play;
{AnalogIn.ar(2).poll;DC.ar(0)}.play;
{AnalogIn.ar(3).poll;DC.ar(0)}.play;


/*#############################################################################################*/

//Analog Outs - connect to the CV inputs of an analog oscillator
{AnalogOut.ar(0,DC.ar(1));}.play;
{AnalogOut.ar(0,DC.ar(0));}.play;// DC.ar(1) -> 4.766V (4.08V); DC.ar(0) -> -3.51V (-3.84V); //values on parenthesis after calibrating 0V

{AnalogOut.ar(0,DC.ar(1));}.play;
{AnalogOut.ar(0,DC.ar(0));}.play;
{AnalogOut.ar(0,DC.ar(0.03));}.play;
{AnalogOut.ar(0,DC.ar(0.8));}.play;
{AnalogOut.ar(0,DC.ar(1)*AnalogIn.ar(0));}.play;
//Controlling the pitch of an analog oscillator
//half tone is (2**(1/96))-1 = 0.0072464122237039
{AnalogOut.ar(0,DC.ar(0.0072464122237039*60));}.play;
{AnalogOut.ar(0,DC.ar(0.0072464122237039*61));}.play;
{AnalogOut.ar(0,DC.ar(0.0072464122237039*62));}.play;

{var octave=4,note=8;AnalogOut.ar(0,DC.ar((2**(((12*octave)+note)/96))-1));}.play;

//Chromatic scales
{AnalogOut.ar(0,DC.ar(0.0072464122237039)*(60+PulseCount.ar(Impulse.ar(1),Impulse.ar(1/12))));}.play;
{var speed=0.5, root=72;AnalogOut.ar(0,DC.ar(0.0072464122237039)*(root+PulseCount.ar(Impulse.ar(speed),Impulse.ar(speed/12))));}.play;
{var speed=8, root=72;AnalogOut.ar(0,DC.ar(0.0072464122237039)*(root+PulseCount.ar(Impulse.ar(speed),Impulse.ar(speed/24))));}.play;
//Arpegios
{var speed=8.reciprocal, root=72;AnalogOut.ar(0,DC.ar(0.0072464122237039)*(Duty.ar(Dseq([speed],inf),0,Dseq([1,3,5,7]+root,inf))));}.play;
{var speed=8.reciprocal, root=62;AnalogOut.ar(0,DC.ar(0.0072464122237039)*(Duty.ar(Dseq([speed],inf),0,Drand([0,2,3,7,8]+root,inf))));}.play;

//Envelopes, Connect the analog out to the CV in of a filter for example.
{AnalogOut.ar(0,EnvGen.ar(Env([0,1,0],[0,1],[1,1]),Impulse.ar(1)));}.play;//Attack-decay envelop with time and curve type control. Cycling with an impulse.
{AnalogOut.ar(0,EnvGen.ar(Env([0,1,0],[0,4],[1,-1]),Impulse.ar(1)));}.play;//Attack-decay envelop with time and curve type control.

//CV out for pitch on analog out 1, envelop 1 for filter cutoff on analog 2, envelop 2 for dynamics on analog 3
(
{var speed=8, root=62;
	AnalogOut.ar(0,DC.ar(0.0072464122237039)*(Duty.ar(Dseq([speed.reciprocal],inf),0,Drand([0,2,3,7,8]+root,inf))));
	AnalogOut.ar(1,EnvGen.ar(Env([0,1,0],[0,1],[1,-1]),Impulse.ar(speed)));
	AnalogOut.ar(2,EnvGen.ar(Env([0,1,0],[0,0.5],[1,-5]),Impulse.ar(speed)));
}.play;
);
//same than previous but using analog ins for controlling decay times and transposition
(
{var speed=8, root=AnalogIn.ar(2).range(60,72);
	AnalogOut.ar(0,DC.ar(0.0072464122237039)*(Duty.ar(Dseq([speed.reciprocal],inf),0,Drand([0,2,3,7,8]+root,inf))));
	AnalogOut.ar(1,EnvGen.ar(Env([0,1,0],[0,AnalogIn.ar(0).range(0,1.0)],[1,-1]),Impulse.ar(speed)));
	AnalogOut.ar(2,EnvGen.ar(Env([0,1,0],[0,AnalogIn.ar(1).range(0,1.0)],[1,-5]),Impulse.ar(speed)));
}.play;
);

//LFO and Audio Rate
{AnalogOut.ar(0,SinOsc.ar(1,0,0.5,0.5));}.play //Audio rate outs should be unipolar (0-5v); connect analog out 1 to an external oscillator
{AnalogOut.ar(0,SinOsc.ar(100,0,0.5,0.5));}.play
{AnalogOut.ar(0,LFDNoise0.ar(1,0.5,0.5));}.play;
{AnalogOut.ar(0,LFDNoise0.ar(10,0.5,0.5));}.play;
{AnalogOut.ar(0,SinOsc.ar(10,0,0.5,0.5));}.play;
{AnalogOut.ar(0,SinOsc.ar(1000,0,0.5,0.5);)}.play;
{AnalogOut.ar(0,SinOsc.ar(1));}.play;//compare a bipolar output (halfwave rectified) with the unipolar:
{AnalogOut.ar(0,SinOsc.ar(1,0,0.5,0.5));}.play;//unipolar

//Four outputs phase-shifted (quadrature)
(
{
	var freq = AnalogIn.ar(0).range(1,20);
	AnalogOut.ar(0,SinOsc.ar(freq,0.degrad,0.5,0.5));
	AnalogOut.ar(1,SinOsc.ar(freq,90.degrad,0.5,0.5));
	AnalogOut.ar(2,SinOsc.ar(freq,180.degrad,0.5,0.5));
	AnalogOut.ar(3,SinOsc.ar(freq,270.degrad,0.5,0.5));

}.play;
);

{var freq = AnalogIn.ar(0).range(1,20);4.do{|i|AnalogOut.ar(i,SinOsc.ar(freq,[0,90,180,270].degrad.at(i),0.5,0.5));};DC.ar(0)}.play

/*#############################################################################################*/


//Analog in and out as Audio
{AnalogOut.ar(0,AnalogIn.ar(0));}.play;//passing signals from analog ins through analog outs. Try patching two external oscillators: Oscillator 1 out into bela analog in 1, bela analog out into oscillator 2 cv in, oscillator 2 out into oscillator 1 cv in, monitor in any of the inputs of oscillator 2 or 1 playing with the cv atenuators of each external oscillator

//Analog-Digital FEEDBACK (Cross modulating oscillators)
{AnalogOut.ar(0,SinOsc.ar(AnalogIn.ar(0).range(1,5000),0,0.5,0.5));}.play;//Connect an analog oscillator output to the Analog In 1 on the bela. Connect the Analog Out 1 on the bela to the cv in of the analog oscillator play with the cv attenuation.

{AnalogOut.ar(0,SinOsc.ar(AnalogIn.ar(0).range(1,10000),0,0.5,0.5));}.play;

/*#############################################################################################*/

//Using AnalogIn and AnalogOut
{Out.ar(0,SoundIn.ar(0));AnalogOut.ar(0,SinOsc.ar(AnalogIn.ar(0).range(1,1000.0),0,0.5,0.5)*0.99)}.play;//Connect a sound source and a voltage control into the Bela, then use the voltage out from the analog out 1 in the bela to drive a cv input in the sound source and monitor the bela audio outs.

{Out.ar(0,RLPF.ar(SoundIn.ar(0),AnalogIn.ar(0).range(1,10000),0.01));AnalogOut.ar(0,SinOsc.ar(AnalogIn.ar(0).range(1,1000.0),0,0.5,0.5)*0.99)}.play;

{Out.ar(0,CombC.ar(SoundIn.ar(0),1,AnalogIn.ar(0).range(0.0001,1).lag(4),[4,10]))}.play;

{[CombC.ar(SoundIn.ar(0),1,AnalogIn.ar(0).range(0.5,0.51),1),AnalogOut.ar(0,AnalogIn.ar(0,0.5,0.5))]}.play;

/*#############################################################################################*/

//Digital Inputs. Use a trigger
{DigitalIn.ar(0)}.play;//listen to the triggers on the Audio outputs
{SinOsc.ar( 440, 0, DigitalIn.ar(0))}.play;// controlling the amplitude of a sine
{SinOsc.ar( 440, 0, Decay.ar(DigitalIn.ar(0),0.1))}.play;
{SinOsc.ar( 440, 0, (Decay.ar(PulseDivider.ar(DigitalIn.ar(0),2),1)))}.play;//cleaner

{Klank.ar(`[[800, 1071, 1153, 1723], nil, 0.125!4], DigitalIn.ar(0), 1, 0, 1)}.play;
{Klank.ar(`[[800, 1071, 1153, 1723], nil, 0.125!4], (Decay.ar(PulseDivider.ar(DigitalIn.ar(0),2),1)), 1, 0, 1)}.play;

/*#############################################################################################*/

//Digital outs. Monitor through an oscillator or directly from the digital outs
{DigitalOut.ar(2,Impulse.ar(1),0)}.play;//First digital output.
{DigitalOut.ar(2, SinOsc.ar( 100 ) )}.play; //Bit Reduction, sine to square
{DigitalOut.ar(2, LFPulse.ar( 2,0,0.5 )) }.play;
{DigitalOut.ar(2, LFPulse.ar( AnalogIn.ar(0).range(1,1000),0,0.5 )) }.play;
{DigitalOut.ar(2, LFPulse.ar( LFDNoise0.ar(4,200,300),0,0.5 )) }.play;
{DigitalOut.ar(2, LFPulse.ar( LFDNoise0.ar(4,200,300),0,LFTri.ar(0.1) )) }.play;

//Audio through the digital outs
{DigitalOut.ar(2,SoundIn.ar(0))}.play;//Bit reduction
{DigitalOut.ar(2,DigitalIn.ar(0))}.play;//Try sending the signal from an oscillator back to its CV in

/*#############################################################################################*/
