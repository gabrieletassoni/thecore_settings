require 'active_support/concern'

module TheCoreSettingsAbilitiesConcern
  extend ActiveSupport::Concern
  included do
    def thecore_settings_abilities user
      # Rails.logger.debug "Cannot Create"
      cannot :create, RailsAdminSettings::Setting
      # Rails.logger.debug "Cannot Delete"
      cannot :destroy, RailsAdminSettings::Setting
      cannot :show, RailsAdminSettings::Setting

      # cannot :manage, [RailsAdminSettings::Setting]
      # cannot :dashboard, [RailsAdminSettings::Setting]
      # # Pay attention to this errorTypeError (can't convert Class to Array (Class#to_ary gives String)):
      # can [:index, :update], [RailsAdminSettings::Setting] if user && user.admin?
    end
  end
end

# include the extension
TheCoreAbilities.send(:include, TheCoreSettingsAbilitiesConcern)
