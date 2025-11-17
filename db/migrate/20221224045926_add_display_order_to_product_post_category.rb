class AddDisplayOrderToProductPostCategory < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :display_order, :integer
    add_column :products, :display_order, :integer
    add_column :categories, :display_order, :integer
  end
end
