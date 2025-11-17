class AddUniversalSlugToProduct < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :universal_slug, :string
    add_index :products, ['universal_slug', 'locale'], unique: true
  end
end
