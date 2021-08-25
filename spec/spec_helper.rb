$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'

require 'simplecov'
SimpleCov.start

require 'bundler/setup'
require 'active_support'
require 'active_support/core_ext'

unless ENV['ACTIVERECORD']
  require 'mongoid'
end

require 'database_cleaner'
require 'factory_bot'
require 'mongoid-rspec'

if ENV['UPLOADS'] == 'paperclip'
  require "mongoid-paperclip"
end
if ENV['UPLOADS'] == 'carrierwave'
  require "carrierwave/mongoid"
  CarrierWave.configure do |config|
    config.asset_host = proc do |file|
      "http://localhost"
    end
  end
end
if ENV['UPLOADS'] == 'shrine'
  require "shrine"
  require "shrine/storage/file_system"
  Shrine.storages = {
      cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"), # temporary
      store: Shrine::Storage::FileSystem.new("public", prefix: "uploads"),       # permanent
  }

  if ENV['ACTIVERECORD']
    Shrine.plugin :activerecord
  end
  Shrine.plugin :cached_attachment_data # for retaining the cached file across form redisplays
  Shrine.plugin :restore_cached_data # re-extract metadata when attaching a cached file
end



I18n.enforce_available_locales = true
I18n.load_path << File.join(File.dirname(__FILE__), "..", "config", "locales", "en.yml")

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each do |f|
  require f
end

if ENV['RAILS'] == '1'
  require "active_model/railtie"
  require "action_controller/railtie"
  require "action_view/railtie"
  module RAS
    class Application < Rails::Application
    end
  end
  # Initialize the Rails application.
  Rails.application.initialize!
end

require 'thecore_settings'


if ENV['UPLOADS'] == 'paperclip'
  module ThecoreSettings::Uploads
    def self.paperclip_options
      {path: "#{File.dirname(__FILE__)}/../uploads/:filename", url: '/uploads/:filename'}
    end
  end
end


Dir["#{File.dirname(__FILE__)}/factories/**/*.rb"].each do |f|
  require f
end

#RSpec.configure do |config|
  #config.expect_with(:rspec) { |c| c.syntax = :should }
#end
