
/*#############################################################################################*/
// BELA StartUp function

//Once connected to the belaboard with an USB cable set the local IP to "192.168.7.1" and Subnet Mask to "255.255.255.0" in network preferences. Then test your connection in the terminal with "ping 192.168.7.2"
//Details and debugging instructions at https://github.com/BelaPlatform/Bela/wiki/Getting-started-with-Bela
// This function will allow you to control scsynth in the belaboard from your local machine
(
~startBela = {{
	Server.default = s = Server("belaServer", NetAddr("192.168.7.2", 57110)); //bela over usb
	//Server.default = s = Server("belaServer", NetAddr("192.168.105.110", 57110)); //bela over ethernet
	//Server.default = s = Server("belaServerEth0",NetAddr("192.168.105.110",57110));// wolfson
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