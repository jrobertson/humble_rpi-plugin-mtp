Gem::Specification.new do |s|
  s.name = 'humble_rpi-plugin-mtp'
  s.version = '0.3.3'
  s.summary = 'This Humble RPi plugin controls the mini thermal printer.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/humble_rpi-plugin-mtp.rb']
  s.signing_key = '../privatekeys/humble_rpi-plugin-mtp.pem'
  s.add_runtime_dependency('serialport_mtp', '~> 0.1', '>=0.1.1')
  s.add_runtime_dependency('dom_render', '~> 0.1', '>=0.1.0')
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/humble_rpi-plugin-mtp'
end
