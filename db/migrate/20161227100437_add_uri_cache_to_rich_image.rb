class AddUriCacheToRichImage < ActiveRecord::Migration[5.0]
  def change
    add_column :rich_rich_images, :uri_cache, :text
  end
end
