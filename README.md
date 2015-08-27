# Introducing the Humble RPi Plugin Mini Thermal Printer gem

    require 'humble_rpi-plugin-mtp'

    mtp = HumbleRPiPluginMTP.new
    mtp.start
    mtp.on_printer_message 'The weather today is 17 degrees and cloudy'

The above code is for testing purposes only. This gem is designed to be used as a plugin with the HumbleRPi gem. The sub topic *printer* is used to subscribe to the topic relative to the name associated with the Raspberry Pi. If the Pi was called 'Aida', the full topic to be subscribed to would be 'HumbleRPi/root/aida/printer'. Which in this example would make the fully qualified Simple Pub Sub message appears as follows:

<pre>HumbleRPi/root/aida/printer: The weather today is 17 degrees and cloudy</pre>

Which would send to the printer the datetime stamp followed by the message e.g.

<pre>
2015-08-27 21:46:56 +0000
The weather today is 17 degrees and cloudy



</pre>

## Resources

* Introducing the SerialPort Mini Thermal Printer gem http://www.jamesrobertson.eu/snippets/2015/aug/27/introducing-the-serialport-mini-thermal-printer-gem.html
* humble_rpi-plugin-mtp https://rubygems.org/gems/humble_rpi-plugin-mtp

humblerpi plugin mtp thermalprinter
