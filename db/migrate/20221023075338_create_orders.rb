class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :code, null: false
      t.string :customer_uuid
      t.string :customer_name
      t.string :customer_email
      t.string :customer_phone
      t.string :payment_method
      t.string :shipping_method
      t.jsonb :shipping_address
      t.boolean :invoice_required
      t.jsonb :invoice_data
      t.string :status
      t.float :vat_fee

      t.timestamps
    end

    add_index :orders, :code, unique: true
  end
end
