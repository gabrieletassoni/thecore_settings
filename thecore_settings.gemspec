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


  s.add_dependency "thecore"
  s.add_dependency "rich"
  s.add_dependency "russian_phone"
  s.add_dependency "sanitize"
  s.add_dependency "safe_yaml"
  s.add_dependency "validates_email_format_of"
  s.add_dependency "geocoder"
  s.add_dependency "paperclip"
  s.add_dependency "addressable"
  s.add_dependency "rails_admin_settings"
end
