class CreateRichRichImages < ActiveRecord::Migration[5.0]
  def change
    create_table :rich_rich_images do |t|
      t.timestamps

      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at

      t.string :owner_type
      t.integer :owner_id
    end
  end
end
