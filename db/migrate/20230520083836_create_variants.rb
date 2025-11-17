class CreateVariants < ActiveRecord::Migration[7.0]
  def change
    create_table :variants do |t|
      t.string :name
      t.string :sku, null: false
      t.jsonb :options
      t.float :price
      t.float :original_price
      t.bigint :owner_id
      t.string :owner_type

      t.timestamps

      t.index [:sku, :owner_type], unique: true
    end
  end
end
