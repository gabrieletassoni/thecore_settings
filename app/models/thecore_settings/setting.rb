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

    # A key that names a secret (smtp.password, sql.password, the SMB shares' password,
    # vapid.private_key, ...): the whole key or its last underscore-separated part.
    SECRET_KEY = /(\A|_)(password|passwd|secret|private_key|api_key|token)\z/i

    def self.secret_key?(key)
      SECRET_KEY.match?(key.to_s)
    end

    # A Secret setting is write-only (host ADR 0046 point 10): the code reads raw, nothing
    # serializes it, and a blank save (the masked RailsAdmin field left empty) keeps the stored
    # value. To clear one, destroy the row (the seeds recreate it empty).
    def secret?
      self.class.secret_key?(key)
    end

    before_save :keep_secret_when_blank, if: :secret?

    # No `methods:` for a secret, whose value could come back through any of them (value,
    # attributes, raw_was...), and raw always nil.
    def serializable_hash(options = nil)
      return super unless secret?

      options = (options || {}).to_h.symbolize_keys.except(:methods)
      super(options).tap { |hash| hash["raw"] = nil if hash.key?("raw") }
    end

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

    private def keep_secret_when_blank
      self.raw = raw_in_database if raw.blank? && raw_in_database.present?
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
