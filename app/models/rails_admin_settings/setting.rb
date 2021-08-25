if ThecoreSettings.active_record?
  module ThecoreSettings
    class Setting < ActiveRecord::Base
    end
  end
end

module ThecoreSettings
  class Setting
    if ThecoreSettings.mongoid?
      include ThecoreSettings::Mongoid
    end

    if ThecoreSettings.active_record?
      self.table_name = "thecore_settings"
    end

    scope :enabled, -> { where(enabled: true) }
    scope :ns, ->(ns) { where(ns: ns) }

    include ThecoreSettings::RequireHelpers
    include ThecoreSettings::Processing
    include ThecoreSettings::Uploads
    include ThecoreSettings::Validation

    def disabled?
      !enabled
    end

    def enabled?
      enabled
    end

    def name
      label.blank? ? key : label
    end

    def type
      kind
    end

    def to_path
      if value.nil?
        nil
      else
        'public' + URI.parse(value).path
      end
    end

    def as_yaml(options = {})
      v = {type: type, enabled: enabled, label: label}
      if upload_type?
        v[:value] = to_path
      else
        v[:value] = raw
      end
      v.stringify_keys!
      v
    end

    # t = {_all: 'Все'}
    if ::Settings.table_exists?
      ::ThecoreSettings::Setting.pluck(:ns).uniq.each do |c|
         s = "ns_#{c.gsub('-', '_')}".to_sym
         scope s, -> { where(ns: c) }
         # t[s] = c
       end
     end
     # I18n.backend.store_translations(:ru, {admin: {scopes: {'thecore_settings/setting': t}}})

    if Object.const_defined?('RailsAdmin')
      include ThecoreSettings::RailsAdminConfig
    else
      puts "[thecore_settings] Rails Admin not detected -- put this gem after rails_admin in gemfile"
    end
  end
end
