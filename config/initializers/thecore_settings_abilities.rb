require 'active_support/concern'

module TheCoreSettingsAbilitiesConcern
  extend ActiveSupport::Concern
  included do
    def thecore_settings_abilities user
      # Rails.logger.debug "Cannot Create"
      cannot :create, ThecoreSettings::Setting
      # Rails.logger.debug "Cannot Delete"
      cannot :destroy, ThecoreSettings::Setting
      cannot :show, ThecoreSettings::Setting

      # cannot :manage, [ThecoreSettings::Setting]
      # cannot :dashboard, [ThecoreSettings::Setting]
      # # Pay attention to this errorTypeError (can't convert Class to Array (Class#to_ary gives String)):
      # can [:index, :update], [ThecoreSettings::Setting] if user && user.admin?
    end
  end
end

# include the extension
TheCoreAbilities.send(:include, TheCoreSettingsAbilitiesConcern)
