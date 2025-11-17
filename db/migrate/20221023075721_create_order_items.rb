class CreateOrderItems < ActiveRecord::Migration[7.0]
  def change
    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.float :original_price
      t.float :price
      t.integer :quantity
      t.float :discount_percentage
      t.jsonb :variants

      t.timestamps
    end
  end
end
