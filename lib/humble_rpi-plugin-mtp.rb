#!/usr/bin/env ruby

# file: humble_rpi-plugin-mtp.rb

require 'open-uri'
require 'serialport_mtp'


class HumbleRPiPluginMTP < SerialPortMTP

  def initialize(settings: {}, variables: {})
    
    h = {port: "/dev/ttyAMA0", baud_rate: 19200}.merge settings
    @username, @password = settings[:username], settings[:password]
    device_id = variables[:device_id] || 'pi'
    
    super(port: h[:port], baud_rate: h[:baud_rate])

  end

  def on_printer_message(raw_message)

    wake

    inverse_on
    bold_on
    println Time.now.to_s
    bold_off
    inverse_off
    
    feed

    message = raw_message[/^https?:\/\//] ? fetch(raw_message) : raw_message
    message.lines {|x| self.print x}
    feed 4
    
    sleep_after 10 # seconds
  end
  
  def start()
    
    super
    sleep_after 1 # second
    
  end
  
  alias on_start start

  private
  
  def fetch(url)
    
    open(url, http_basic_authentication: [@username, @password]).read
    
  end
  
end