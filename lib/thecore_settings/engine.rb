module ThecoreSettings
  class Engine < ::Rails::Engine

    initializer 'ThecoreSettings.add_to_migrations' do |app|
      unless app.root.to_s.match root.to_s
        # APPEND TO MAIN APP MIGRATIONS FROM THIS GEM
        config.paths['db/migrate'].expanded.each do |expanded_path|
          app.config.paths['db/migrate'] << expanded_path
        end
      end
    end

    rake_tasks do
      require File.expand_path('../tasks', __FILE__)
    end
    
    initializer 'ThecoreSettings.install_after_action' do |app|
      require File.dirname(__FILE__) + '/../../app/models/thecore_settings/setting.rb'

      if defined?(ActionController) and defined?(ActionController::Base)
        ActionController::Base.class_eval do
          after_action { Settings.unload! }
        end
      end
    end
  end
end
