class AddPropertiesToVariant < ActiveRecord::Migration[7.0]
  def change
    add_column :variants, :properties, :jsonb
  end
end
