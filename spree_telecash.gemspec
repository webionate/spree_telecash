# encoding: UTF-8
lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'spree_telecash/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_telecash'
  s.version     = SpreeTelecash.version
  s.summary     = 'Spree Telecash'
  s.description = 'Telecash extension for Spree Commerce'
  s.required_ruby_version = '>= 2.0.0'

  s.author    = 'webionate GmbH'
  s.email     = 'info@webionate.de'
  s.homepage  = 'https://www.webionate.de'

  # s.files       = `git ls-files`.split("\n")
  # s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  spree_version = '>= 3.1.0', '< 4.0'
  s.add_dependency "activemerchant"
  s.add_dependency 'spree_core', spree_version
  s.add_dependency 'spree_backend', spree_version
  s.add_dependency 'spree_frontend', spree_version
  s.add_dependency 'spree_extension'
  s.add_dependency "coffee-script"
end
