# require "thecore_settings/version"

module ThecoreSettings
  if defined?(Rails) && defined?(Rails::Html) && defined?(Rails::Html::WhiteListSanitizer)
    @@scrubber = Rails::Html::WhiteListSanitizer.new
  end
  cattr_accessor :scrubber

  class PersistenceException < Exception
  end

  autoload :Mongoid,           "thecore_settings/mongoid"
  autoload :Fallback,          "thecore_settings/fallback"
  autoload :Namespaced,        "thecore_settings/namespaced"
  autoload :Processing,        "thecore_settings/processing"
  autoload :Validation,        "thecore_settings/validation"
  autoload :RequireHelpers,    "thecore_settings/require_helpers"
  autoload :RailsAdminConfig,  "thecore_settings/rails_admin_config"
  autoload :Uploads,           "thecore_settings/uploads"
  autoload :HexColorValidator, "thecore_settings/hex_color_validator"
  autoload :Dumper,            "thecore_settings/dumper"

  class << self
    def orm
      if defined?(::Mongoid)
        :mongoid
      else
        :active_record
      end
    end

    def mongoid?
      orm == :mongoid
    end

    def active_record?
      orm == :active_record
    end

    def apply_defaults!(file, verbose = false)
      if File.file?(file)
        puts "[settings] Loading from #{file}" if verbose
        if defined?(Psych) && Psych.respond_to?(:safe_load)
          yaml = Psych.safe_load(File.read(file))
        else
          yaml = YAML.load(File.read(file), safe: true)
        end
        yaml.each_pair do |namespace, vals|
          process_defaults(namespace, vals, verbose)
        end
      end
    end

    def process_defaults(namespace, vals, verbose = false)
      vals.symbolize_keys!
      n = Settings.ns(namespace)
      vals.each_pair do |key, val|
        val.symbolize_keys!
        if !val[:kind].nil? && (val[:kind] == 'file' || val[:kind] == 'image')
          unless Settings.file_uploads_supported
            raise PersistenceException, "Fatal: setting #{key} is #{val[:type]} but file upload engine is not detected"
          end
          value = File.open(Settings.root_file_path.join(val.delete(:value)))
        else
          value = val.delete(:value)
        end
        puts "#{key} - default '#{value}' current '#{Settings.get(key).raw}'" if verbose
        n.set(key, value, val.merge(overwrite: false))
      end
      n.unload!
    end

    def migrate!
      if ThecoreSettings.mongoid?
        ThecoreSettings::Setting.where(:ns.exists => false).update_all(ns: 'main')
        ThecoreSettings::Setting.all.each do |s|
          s.kind = s.read_attribute(:type) if !s.read_attribute(:type).blank? && s.kind != s.read_attribute(:type)
          s.save! if s.changed?
          s.unset(:type)
        end
      else
        if Settings.table_exists?
          ThecoreSettings::Setting.where("ns IS NULL").update_all(ns: 'main')
        end
      end
    end

    def track_history!
      return false unless Settings.table_exists?

      if mongoid?
        if ::Mongoid.const_defined?('History')
          ThecoreSettings::Setting.send(:include, ::Mongoid::History::Trackable)
          ThecoreSettings::Setting.send(:track_history, {track_create: true, track_destroy: true})
        else
          puts "[thecore_settings] WARN unable to track_history: Mongoid::History not loaded!"
        end
        if ::Mongoid.const_defined?('Userstamp')
          ThecoreSettings::Setting.send(:include, ::Mongoid::Userstamp)
        else
          puts "[thecore_settings] WARN unable to track_history: Mongoid::Userstamp not loaded!"
        end
      elsif active_record?
        if defined?(PaperTrail) && PaperTrail::Version.table_exists?
          ThecoreSettings::Setting.send(:has_paper_trail)
        end
      end
    end
  end
end

require "thecore_settings/kinds"
require "thecore_settings/settings"

if Object.const_defined?('Rails')
  require "thecore_settings/engine"
else
  require File.dirname(__FILE__) + '/../app/models/thecore_settings/setting.rb'
end
