require_relative "boot"

# Only what thecore_settings needs: Active Record for the settings table, Action Controller for
# the after_action that unloads the memoized namespaces.
require "rails"
require "active_record/railtie"
require "action_controller/railtie"
# thecore_settings picks its HTML scrubber when it is required, as host apps do after rails/all.
require "rails-html-sanitizer"

Bundler.require(*Rails.groups)
require "thecore_settings"

module Dummy
  class Application < Rails::Application
    config.load_defaults Rails::VERSION::STRING.to_f
    config.eager_load = false
  end
end
