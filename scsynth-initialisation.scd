/*#############################################################################################*/
// INITIALISING SERVER ON BELA
/*
//start scsynth in Bela using terminal (loggin via ssh into the bela)
scsynth -u 57110 -i 6 -o 6 -z 16 -J 4 -K 4 -G 16 -Q -12 -X 5 -Y 5 -s 1 -x 0 -y 0 -g 0 -T 0
scsynth -u 57110 -a 116 -i 6 -o 6 -z 16 -S 44100 -R 1 -l 256 -J 4 -K 4 -G 16 -Q -12 -X 0 -Y 0 -s 1 -x 0 -y 0 -g 0 -T 0
scsynth -u 57110 -a 116 -i 6 -o 6 -b 1026 -z 16 -S 44100 -R 0 -C 0 -l 64 -J 0 -K 0 -G 16 -Q -12 -X 0 -Y 0 -s 1 -x 0 -y 0 -g 0 -T 0
scsynth -u 57110 -a 116 -i 2 -o 2 -b 1024 -z 16 -R 0 -C 0 -l 64 -J 8 -K 8 -G 16 -Q -8 -X 4 -Y 5 -s 0 -x -5 -y -3 -g 0 -T 0
scsynth -u 57110 -a 116 -i 2 -o 2 -b 1026 -z 16 -S 48000 -R 0 -C 0 -l 64 -J 4 -K 4 -G 16 -Q -8 -X 4 -Y 5 -s 1 -x -12 -y -5 -g 0 -T 0
scsynth -u 57110 -i 2 -o 2 -z 16 -S 44100 -J 4 -K 4 -G 8
scsynth -u 57110 -i 2 -o 2 -z 16 -J 4 -K 4 -G 8
scsynth -u 57110 -i 10 -o 10 -z 16 -J 4 -K 4 -G 16 -s 1
scsynth -u 57110 -i 2 -o 2 -z 16 -J 4 -K 4 -G 8  -S 88200
scsynth -u 57110 -i 2 -o 2 -z 16 -J 4 -K 4 -G 16 -Q 0 -X -0 -Y -0 -s 1 -x 0 -y -12 -g 0 -T 0
scsynth -u 57110 -i 2 -o 2
scsynth -u 57110 -i 6 -o 6 -z 16 -J 4 -K 0 -G 16 -Q 0 -X -0 -Y -0 -s 1 -x 0 -y -12 -g 0 -T 0

scsynth -u 57110 -i 2 -o 2 -z 16 -J 4 -K 4 -G 16 -Q 0 -X -0 -Y -0 -s 1 -x 0 -y 0 -g 0 -T 0 //THIS

*/

/*
There must be a -u and/or a -t options, or -N for nonrealtime.
supercollider_synth  options:
   -v print the supercollider version and exit
   -u <udp-port-number>    a port number 0-65535
   -t <tcp-port-number>    a port number 0-65535
   -B <bind-to-address>    an IP address
   -c <number-of-control-bus-channels> (default 4096)
   -a <number-of-audio-bus-channels>   (default 128)
   -i <number-of-input-bus-channels>   (default 8)
   -o <number-of-output-bus-channels>  (default 8)
   -z <block-size>                     (default 64)
   -Z <hardware-buffer-size>           (default 0)
   -S <hardware-sample-rate>           (default 0)
   -b <number-of-sample-buffers>       (default 1024)
   -n <max-number-of-nodes>            (default 1024)
   -d <max-number-of-synth-defs>       (default 1024)
   -m <real-time-memory-size>          (default 8192)
   -w <number-of-wire-buffers>         (default 64)
   -r <number-of-random-seeds>         (default 64)
   -D <load synthdefs? 1 or 0>         (default 1)
   -R <publish to Rendezvous? 1 or 0>  (default 1)
   -l <max-logins>                     (default 64)
          maximum number of named return addresses stored
          also maximum number of tcp connections accepted
   -p <session-password>
          When using TCP, the session password must be the first command sent.
          The default is no password.
          UDP ports never require passwords, so for security use TCP.
   -N <cmd-filename> <input-filename> <output-filename> <sample-rate> <header-format> <sample-format>
   -J <bela-analog-input-channels>
   -K <bela-analog-output-channels>
   -G <bela-digital-channels>
   -Q <bela-headphone-level> (0dB max, -63.5dB min)
   -X <bela-pga-gain-left>
   -Y <bela-pga-gain-right>
   -s <bela-speaker-mute>
   -x <bela-dac-level>
   -y <bela-adc-level>
   -g <bela-multiplexer-channels>
   -T <bela-pru-id>
   -H <hardware-device-name>
   -V <verbosity>
          0 is normal behaviour
          -1 suppresses informational messages
          -2 suppresses informational and many error messages
   -U <ugen-plugins-path>    a colon-separated list of paths
          if -U is specified, the standard paths are NOT searched for plugins.
   -P <restricted-path>
          if specified, prevents file-accessing OSC commands from
          accessing files outside <restricted-path>.
*/
/*
s.options.numAnalogInChannels = 4;
s.options.numAnalogOutChannels = 4;
s.options.numDigitalChannels = 16;
s.options.maxLogins = 64;  	   // set max number of clients
s.options.sampleRate = 48000;

s.options.pgaGainLeft = 5;     // sets the pga gain of the left channel to 4 dB
s.options.pgaGainRight = 5;    // sets the pga gain of the right channel to 5 dB
s.options.headphoneLevel = -8; // sets the headphone level to -8 dB
s.options.speakerMuted = 1;    // the speakers are not muted (so active)
s.options.dacLevel = -5;       // sets the gain of the dac to -5 dB
s.options.adcLevel = -5;       // sets the gain of the adc to -3 dB
s.options.numMultiplexChannels = 0; // do not enable multiplexer channels
s.options.belaPRU = 0;         // select the PRU on which Bela audio will run

s.options.blockSize = 16;
s.options.numInputBusChannels = 2;
s.options.numOutputBusChannels = 2;

s.options.postln;
*/

/*
//Monitoring performance
watch -n 0.5 cat /proc/xenomai/stat
*/