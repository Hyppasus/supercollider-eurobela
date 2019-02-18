/*#############################################################################################*/
// run scsynth on the Bela


"scsynth -u 57110 -i 2 -o 2 -z 16 -J 4 -K 4 -G 16 -Q 0 -X -0 -Y -0 -s 1 -x 0 -y 0 -g 0 -T 0"

/*#############################################################################################*/
// contorl scsynth on the bela from your local machine
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
	s.sampleRate.postln;
	}.fork
}
);

/*#############################################################################################*/
// TESTS

// Audio outputs
{SinOsc.ar(1000,0,-20.dbamp)}.play(s,0);// free the sound with cmd+period
{SinOsc.ar(1000,0,-60.dbamp)}.play(s,0);// low volume? adjust your range
{SinOsc.ar(1000,0,-20.dbamp)}.play(s,1);// right channel
{SinOsc.ar([1200,1000],0,-20.dbamp)}.play(s);
//more audio tests
{SinOsc.ar( 500, 0, Decay.ar(Impulse.ar(1),1))}.play;
{SinOsc.ar(1000, 0, Decay.ar(Impulse.ar(4),1,0.5))}.play;//easy to modify
{Pulse.ar(1000)!2}.play;
{Saw.ar(1000)!2}.play;
{Saw.ar(Line.ar(10000,1,10,1,0,2))}.play;

// Audio Inputs
{SoundIn.ar(0)}.play(s,0);//Connect and audio source to Audio In ch1
{SoundIn.ar(1)}.play(s,1);// Right channel
{SoundIn.ar([0,1])}.play;// Both channels at the same time
{SoundIn.ar(0).wrap}.play;// try an effect

//Analog Ins
{SinOsc.ar(AnalogIn.ar(0).range(200,1000),0,0.5)}.play;//use range to adjust the mapping from the incoming signal
{SinOsc.ar(AnalogIn.ar(1).range(200,2000))}.play;
{SinOsc.ar(AnalogIn.ar(2).range(200,2000))}.play;
{SinOsc.ar(AnalogIn.ar(3).range(200,20000))}.play;

{Out.ar(0,AnalogIn.ar(0,2,-1))}.play;//Audio can pass from the analog ins (not the same quality as the dedicated Audio Outs but worth to explore)

//Analog Outs
{AnalogOut.ar(0,SinOsc.ar(1,0,0.5,0.5));}.play //outs should be unipolar (0-5v); connect analog out 1 to an external oscillator
{AnalogOut.ar(0,LFDNoise0.ar(1,0.5,0.5));}.play;
{AnalogOut.ar(0,LFDNoise0.ar(10,0.5,0.5));}.play;
{AnalogOut.ar(0,SinOsc.ar(10,0,0.5,0.5));}.play;
{AnalogOut.ar(0,SinOsc.ar(1000,0,0.5,0.5);)}.play;
{AnalogOut.ar(0,SinOsc.ar(1));}.play;//compare bipolar
{AnalogOut.ar(0,SinOsc.ar(1,0,0.5,0.5));}.play;//unipolar
{AnalogOut.ar(0,AnalogIn.ar(0));}.play;//passing signals from analog ins through analog outs. Try patching two external oscillators: Oscillator 1 out into bela analog in 1, bela analog out into oscillator 2 cv in, oscillator 2 out into oscillator 1 cv in, monitor in any of the inputs of oscillator 2 or 1 playing with the cv atenuators of each external oscillator










