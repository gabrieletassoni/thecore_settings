class CreateThecoreSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :thecore_settings, if_not_exists: true do |t|
      t.boolean :enabled, default: true
      t.string :kind, null: false, default: 'string'
      t.string :ns, default: 'main'
      t.string :key, null: false
      if Object.const_defined?('Geocoder')
        t.float :latitude
        t.float :longitude
      end
      t.text :raw
      t.string :label
      if defined?(Paperclip)
        t.attachment :file
      elsif defined?(CarrierWave)
        t.string :file
      end
      t.timestamps
    end

    add_index :thecore_settings, :key
    add_index :thecore_settings, [:ns, :key], unique: true
  end
end
