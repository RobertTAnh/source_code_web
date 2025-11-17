class LocalizeProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :locale, :string, limit: 2, null: false, default: :vi
    add_index :products, ['sku', 'locale'], unique: true
    add_index :products, ['slug', 'locale'], unique: true

    remove_index :products, :sku, name: 'index_products_on_sku', unique: true
    remove_index :products, :slug, name: 'index_products_on_slug', unique: true
  end
end
