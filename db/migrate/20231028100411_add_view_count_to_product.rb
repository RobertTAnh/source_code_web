class AddViewCountToProduct < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :view_count, :integer, default: 0
  end
end