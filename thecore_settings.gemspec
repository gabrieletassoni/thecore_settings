<<<<<<< HEAD
# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'thecore_settings/version'

Gem::Specification.new do |spec|
  spec.name          = "thecore_settings"
  spec.version       = ThecoreSettings::VERSION
  spec.authors       = ["Gabriele Tassoni", "Gleb Tv"]
  spec.email         = ["gabriele.tassoni@gmail.com", "glebtv@gmail.com"]
  spec.description   = %q{Mongoid / ActiveRecord + RailsAdmin App Settings management}
  spec.summary       = %q{}
  spec.homepage      = "https://github.com/gabrieletassoni/thecore_settings"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]


  spec.add_development_dependency "mongoid", '~> 6.3'
  spec.add_development_dependency "rails"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "mongoid-rspec"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "database_cleaner"
  spec.add_development_dependency "factory_bot"
  spec.add_development_dependency "safe_yaml"
  spec.add_development_dependency "russian_phone"
  spec.add_development_dependency "sanitize"
  spec.add_development_dependency "validates_email_format_of"
  spec.add_development_dependency "geocoder"
  spec.add_development_dependency "addressable"
  spec.add_development_dependency "carrierwave-mongoid"
  spec.add_development_dependency "mongoid-paperclip"
  spec.add_development_dependency "rubocop-rspec"
  spec.add_development_dependency 'image_processing'
  spec.add_development_dependency "mini_magick"
  spec.add_development_dependency "shrine", "~> 3.0"
  spec.add_development_dependency "shrine-mongoid", "~> 1.0"
=======
$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "thecore_settings/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "thecore_settings"
  s.version     = ThecoreSettings::VERSION
  s.authors     = ["Gabriele Tassoni"]
  s.email       = ["gabrieletassoni@taris.it"]
  s.homepage    = "https://taris.it"
  s.summary     = "Adds settings section."
  s.description = "Automagically manage settings."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "thecore", "~> 1.0"
  #s.add_dependency "rich", "~> 1.4"
  s.add_dependency "russian_phone", "~> 0.6"
  s.add_dependency "sanitize", "~> 4.5"
  s.add_dependency "safe_yaml", "~> 1.0"
  s.add_dependency "validates_email_format_of", "~> 1.6"
  s.add_dependency "geocoder", "~> 1.4"
  s.add_dependency "paperclip", "~> 5.1"
  s.add_dependency "addressable", "~> 2.5"
  s.add_dependency "rails_admin_settings", "~> 1.3"
>>>>>>> 3678524292fde93db61ea7faea1e85d249b629de
end
