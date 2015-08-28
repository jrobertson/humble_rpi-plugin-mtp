#!/usr/bin/env ruby

# file: humble_rpi-plugin-mtp.rb


require 'serialport_mtp'


class HumbleRPiPluginMTP < SerialPortMTP

  def initialize(settings: {}, variables: {})

    h = {port: "/dev/ttyAMA0", baud_rate: 19200}.merge settings
    device_id = variables[:device_id] || 'pi'
    
    super(port: h[:port], baud_rate: h[:baud_rate])

  end

  def on_printer_message(message)  
    self.println(Time.now.to_s + "\n" + message)
    self.feed 4
  end
  
  alias on_start start  
  
end
