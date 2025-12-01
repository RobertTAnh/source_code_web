class AddExtraToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :extra, :jsonb
  end
end
