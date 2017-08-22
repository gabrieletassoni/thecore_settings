Rails.application.configure do
  config.after_initialize do
    # Auto inizializza questa gemma
    require 'rails_admin_settings'
		require 'thecore_settings'
    require 'rails_admin_requirements'
  end
end
