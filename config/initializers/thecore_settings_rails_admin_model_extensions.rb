require 'rails_admin_settings'

module RailsAdminSettings
  module RailsAdminExtensionConfig
    def self.included(base)
      # IMPORTANT: To extend rails admin section in model, directly, instead of using concerns, I can
      # extend the included method. Be sure to use a different module name, otherwis it will be overwritten
      # See thecore_settings_rails_admin_model_extensions.rb initializer for a reference
      # on how to extend rails_admin section of a model previously defined (say it's defined in another gem) 
      if base.respond_to?(:rails_admin)
        base.rails_admin do
          navigation_icon 'fa fa-cogs'
        end
      end
    end
  end
end

# include the extension
RailsAdminSettings::Setting.send(:include, RailsAdminSettings::RailsAdminExtensionConfig)
