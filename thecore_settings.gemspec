# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'thecore_settings/version'

Gem::Specification.new do |spec|
  spec.name          = "thecore_settings"
  spec.version       = ThecoreSettings::VERSION
  spec.authors       = ["Gabriele Tassoni", "Gleb Tv"]
  spec.email         = ["gabriele.tassoni@gmail.com", "glebtv@gmail.com"]
  spec.description   = %q{ActiveRecord + RailsAdmin App Settings management}
  spec.summary       = %q{}
  spec.homepage      = "https://github.com/gabrieletassoni/thecore_settings"
  spec.license       = "MIT"

  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "simplecov"
  spec.add_dependency "database_cleaner"
  spec.add_dependency "factory_bot"
  spec.add_dependency "safe_yaml"
  spec.add_dependency "russian_phone"
  spec.add_dependency "sanitize"
  spec.add_dependency "validates_email_format_of"
  spec.add_dependency "geocoder"
  spec.add_dependency "addressable"
  spec.add_dependency "rubocop-rspec"
  spec.add_dependency 'image_processing'
  spec.add_dependency "mini_magick"
  spec.add_dependency "shrine", "~> 3.4"
end
