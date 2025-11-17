class LocalizeCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :locale, :string, limit: 2, null: false, default: :vi
    add_index :categories, ['slug', 'locale'], unique: true

    remove_index :categories, :slug, name: 'index_categories_on_slug', unique: true
  end
end
