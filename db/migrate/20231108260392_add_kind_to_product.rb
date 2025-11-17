class AddKindToProduct < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :kind, :string
  end
end