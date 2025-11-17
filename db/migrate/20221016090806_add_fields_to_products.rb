class AddFieldsToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :original_price, :float
    add_column :products, :price, :float
    add_column :products, :discount_percentage, :float
  end
end
