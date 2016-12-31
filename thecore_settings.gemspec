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
  s.add_dependency "rich", "~> 0"
  s.add_dependency "russian_phone", "~> 0"
  s.add_dependency "sanitize", "~> 0"
  s.add_dependency "safe_yaml", "~> 0"
  s.add_dependency "validates_email_format_of", "~> 0"
  s.add_dependency "geocoder", "~> 0"
  s.add_dependency "paperclip", "~> 0"
  s.add_dependency "addressable", "~> 0"
  s.add_dependency "rails_admin_settings", "~> 0"
end
