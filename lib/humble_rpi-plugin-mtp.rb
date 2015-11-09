#!/usr/bin/env ruby

# file: humble_rpi-plugin-mtp.rb

require 'open-uri'
require 'dom_render'
require 'serialport_mtp'



class Html < DomRender

  def p(x)
    render_all x
  end

  def b(x)
    [:bold_on, render_all(x), :bold_off]
  end

end

class HumbleRPiPluginMTP < SerialPortMTP

  def initialize(settings: {}, variables: {})
    
    h = {port: "/dev/ttyAMA0", baud_rate: 19200}.merge settings
    @username, @password = settings[:username], settings[:password]
    device_id = variables[:device_id] || 'pi'
    
    super(port: h[:port], baud_rate: h[:baud_rate])

  end

  def on_printer_message(raw_message)

    message = raw_message[/^https?:\/\//] ? fetch(raw_message) : raw_message
    return if message.strip.empty?
    
    wake

    inverse_on
    bold_on
    println Time.now.to_s
    bold_off
    inverse_off
    
    feed

    if message =~ /^</ then
      scanprint Html.new(message).to_a
    else
      message.lines {|x| self.print x}
    end
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
  
  def scanprint(a2)

    a2.each do |x|
      
      if x.is_a? String then
        print x
      elsif x.is_a? Array
        scanprint x
      else
        method(x).call
      end
      
    end

  end
  
  
end