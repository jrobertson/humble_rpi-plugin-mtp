#!/usr/bin/env ruby

# file: humble_rpi-plugin-mtp.rb

require 'open-uri'
require 'dom_render'
require 'serialport_mtp'



class Html < DomRender

  def p(x, attributes, style)
    render_all x
  end

  def b(x, attributes, style)
    [:bold_on, render_all(x), :bold_off]
  end
  
  alias strong b
  
  def br(x, attributes, style)
    :feed
  end  
  
  def strike(x, attributes, style)
    [:strike_on, render_all(x), :strike_off]
  end  
  
  def u(x, attributes, style)
    [:underline_on, render_all(x), :underline_off]
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
      wordwrap(message).lines {|x| self.print x}
      feed 5 if message.length < 140
    end
    feed 5
    
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
        self.print (x).lines.join
      elsif x.is_a? Array
        scanprint x
      else
        method(x).call
      end
      
    end

  end
  
  def wordwrap(s, cols=32)

    a = s.split(/ /)

    a2 = a.inject(['']) do |r,word|

      word.lines.each.with_index do |x,i|

        if ((r[-1] + x).length < cols) or x[/[=]/] then
          r[-1] << (r[-1].empty? ? x : ' ' + x)
        else
          r +=  [x]
        end
        r[-1] = r[-1].chomp ; r += [''] if x[-1] == "\n"

      end
      r
    end

    a2.join("\n")

  end
  
  
  
end