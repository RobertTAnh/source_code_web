class AddSkuToProduct < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :sku, :string, null: false

    add_index :products, :sku, unique: true
  end
end
