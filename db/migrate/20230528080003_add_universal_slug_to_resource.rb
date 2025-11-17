class AddUniversalSlugToResource < ActiveRecord::Migration[7.0]
  def change
    add_column :resources, :universal_slug, :string
    add_index :resources, ['universal_slug', 'locale'], unique: true
  end
end
