class MigrateFromRailsAdminSettingsToThecoreSettings < ActiveRecord::Migration[5.2]
  
  module RailsAdminSettings
    class Setting < ActiveRecord::Base
      self.table_name = "rails_admin_settings"
    end
  end
  
  def change
    if RailsAdminSettings::Setting.table_exists?
      puts "Table Exists, trying to migrate older values to new ThecoreSettings::Setting Table"    
      RailsAdminSettings::Setting.all.each do |old_setting|
        new_setting = ThecoreSettings::Setting.find_or_initialize_by old_setting.attributes.except("id", "created_at", "updated_at")
        unless new_setting.save
          puts new_setting.errors.full_messages.join("\n")
        end
      end
    else
      puts "Table Does not Exists, nothing to do! Yay"
    end
  end
end
