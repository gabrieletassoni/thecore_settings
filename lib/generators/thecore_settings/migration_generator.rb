require 'rails/generators'
require 'rails/generators/active_record'

module ThecoreSettings
  class MigrationGenerator < Rails::Generators::Base
    include ActiveRecord::Generators::Migration
    source_root File.expand_path('../templates', __FILE__)

    desc 'RocketCMS migration generator'
    def install
      migration_template "migration.rb", "db/migrate/create_thecore_settings.rb"
    end
  end
end

