require 'active_support/concern'

require 'rails_admin_settings'

module TheCoreSettingsAbilitiesConcern
  extend ActiveSupport::Concern
  included do
    def thecore_settings_abilities user
      cannot :manage, [RailsAdminSettings::Setting]
      # Pay attention to this errorTypeError (can't convert Class to Array (Class#to_ary gives String)):
      if user && user.admin?
        can [:index, :update], [RailsAdminSettings::Setting]
        cannot [:show, :destroy, :create], [RailsAdminSettings::Setting]
      end

    end
  end
end

# include the extension
TheCoreAbilities.send(:include, TheCoreSettingsAbilitiesConcern)
