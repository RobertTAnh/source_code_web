class AddVariantOptionToProduct < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :variant_options, :jsonb
  end
end
