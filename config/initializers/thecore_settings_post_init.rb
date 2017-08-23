Rails.application.configure do
  config.after_initialize do
    # Auto inizializza questa gemma
    require 'rails_admin_settings'
		require 'thecore_settings'
    require 'rails_admin_requirements'
    require 'thecore_settings_abilities'

    SafeYAML::OPTIONS[:default_mode] = :safe # or :unsafe
    SafeYAML::OPTIONS[:deserialize_symbols] = true
  end
end
