class LocalizePosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :locale, :string, limit: 2, null: false, default: :vi
    add_index :posts, ['slug', 'locale'], unique: true

    remove_index :posts, :slug, name: 'index_posts_on_slug', unique: true
  end
end
