require_relative "lib/thecore_settings/version"

Gem::Specification.new do |spec|
  spec.name        = "thecore_settings"
  spec.version     = ThecoreSettings::VERSION
  spec.authors     = ["Gabriele Tassoni", "Gleb Tv"]
  spec.email       = ["g.tassoni@bancolini.com", "glebtv@gmail.com"]
  spec.homepage    = "https://github.com/gabrieletassoni/thecore_settings"
  spec.summary     = "Settings Management"
  spec.description = "ActiveRecord + RailsAdmin App Settings management"
  
  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/gabrieletassoni/thecore_settings"
  spec.metadata["changelog_uri"] = "https://github.com/gabrieletassoni/thecore_settings/blob/master/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  # https://github.com/dtao/safe_yaml
  spec.add_dependency "safe_yaml", "~> 1.0"
  # https://gitlab.com/rocket-science/russian_phone
  spec.add_dependency "russian_phone", "~> 0.8"
  # https://github.com/rgrove/sanitize
  spec.add_dependency "sanitize", "~> 7.0"
  # https://github.com/validates-email-format-of/validates_email_format_of
  spec.add_dependency "validates_email_format_of", "~> 1.8"
  # https://github.com/alexreisner/geocoder
  spec.add_dependency "geocoder", "~> 1.8"
  # https://github.com/sporkmonger/addressable
  spec.add_dependency "addressable", "~> 2.8"
  # https://github.com/minimagick/minimagick
  spec.add_dependency "mini_magick", "~> 5.1"
  # https://github.com/shrinerb/shrine
  spec.add_dependency "shrine", "~> 3.6"
end
