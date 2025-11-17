class LocalizePages < ActiveRecord::Migration[7.0]
  def change
    add_column :pages, :locale, :string, limit: 2, null: false, default: :vi
    add_index :pages, ['slug', 'locale'], unique: true

    remove_index :pages, :slug, name: 'index_pages_on_slug', unique: true
  end
end
